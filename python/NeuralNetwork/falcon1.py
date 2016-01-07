#!/usr/bin/env python
# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd

from keras.models import Sequential
from keras.layers.core import Dense, Dropout, Activation, MaxoutDense
from keras.optimizers import Adadelta
from keras.layers.normalization import BatchNormalization

class NN:
    #I made a small wrapper for the Keras model to make it more scikit-learn like
    #I think they have something like this built in already, oh well
    #See http://keras.io/ for parameter options
    def __init__(self, inputShape, layers, dropout = [], activation = 'relu', init = 'uniform', loss = 'rmse', optimizer = 'adadelta', nb_epochs = 50, batch_size = 32, verbose = 1):
        model = Sequential()
        model.add(MaxoutDense(
            input_dim = inputShape,
            output_dim = 100 / 10,
            nb_feature = 10,
            init='glorot_uniform'))
        model.add(Dropout(0.5))
        model.add(Dense(8, init=init))
        model.add(Activation('softmax'))
        model.compile(loss=loss, optimizer=optimizer)

        '''for i in range(len(layers)):
            if i == 0:
                # Maxout -----------------------------------------------
                print ('MaxoutDense1')
                model.add(MaxoutDense(
                    input_dim = inputShape,
                    output_dim = layers[i],
                    nb_feature = 4,
                    init='glorot_uniform'))

                print model
            else:
                print ('MaxoutDense2')
                model.add(MaxoutDense(
                    output_dim = layers[i] / 4,
                    nb_feature = 4,
                    init='glorot_uniform'))
            print ('Dropout')
            model.add(Dropout(dropout[i]))
            #if len(dropout) > i:
            #    print ('Dropout')
            #    model.add(Dropout(dropout[i]))
        print ('Dense')
        model.add(Dense(output_dim=8)) #End in a single output node for regression style output
        print ('Activation')
        model.add(Activation('softmax'))
        print ('compile')
        model.compile(loss=loss, optimizer=optimizer)
        '''

        self.model = model
        self.nb_epochs = nb_epochs
        self.batch_size = batch_size
        self.verbose = verbose

    def fit(self, X, y):
        self.model.fit(X.values, y.values, nb_epoch=self.nb_epochs, batch_size=self.batch_size, verbose = self.verbose)

    def predict(self, X, batch_size = 128, verbose = 1):
        return self.model.predict(X.values, batch_size = batch_size, verbose = verbose)

class pdStandardScaler:
    #Applies the sklearn StandardScaler to pandas dataframes
    def __init__(self):
        from sklearn.preprocessing import StandardScaler
        self.StandardScaler = StandardScaler()
    def fit(self, df):
        self.StandardScaler.fit(df)
    def transform(self, df):
        df = pd.DataFrame(self.StandardScaler.transform(df), columns=df.columns)
        return df
    def fit_transform(self, df):
        df = pd.DataFrame(self.StandardScaler.fit_transform(df), columns=df.columns)
        return df

def getDummiesInplace(columnList, train, test = None):
    #Takes in a list of column names and one or two pandas dataframes
    #One-hot encodes all indicated columns inplace
    columns = []

    if test is not None:
        df = pd.concat([train,test], axis= 0)
    else:
        df = train

    for columnName in df.columns:
        index = df.columns.get_loc(columnName)
        if columnName in columnList:
            dummies = pd.get_dummies(df.ix[:,index], prefix = columnName, prefix_sep = ".")
            columns.append(dummies)
        else:
            columns.append(df.ix[:,index])
    df = pd.concat(columns, axis = 1)

    if test is not None:
        train = df[:train.shape[0]]
        test = df[train.shape[0]:]
        return train, test
    else:
        train = df
        return train

def pdFillNAN(df, strategy = "mean"):
    #Fills empty values with either the mean value of each feature, or an indicated number
    if strategy == "mean":
        return df.fillna(df.mean())
    elif type(strategy) == int:
        return df.fillna(strategy)

def make_dataset(useDummies = True, fillNANStrategy = "mean", useNormalization = True):
    data_dir = "../../data/"
    train = pd.read_csv(data_dir + 'train_mini.csv')
    test = pd.read_csv(data_dir + 'test_mini.csv')

    labels = train["Response"]
    train.drop(labels = "Id", axis = 1, inplace = True)
    train.drop(labels = "Response", axis = 1, inplace = True)
    test.drop(labels = "Id", axis = 1, inplace = True)

    categoricalVariables = ["Product_Info_1", "Product_Info_2", "Product_Info_3", "Product_Info_5", "Product_Info_6", "Product_Info_7", "Employment_Info_2", "Employment_Info_3", "Employment_Info_5", "InsuredInfo_1", "InsuredInfo_2", "InsuredInfo_3", "InsuredInfo_4", "InsuredInfo_5", "InsuredInfo_6", "InsuredInfo_7", "Insurance_History_1", "Insurance_History_2", "Insurance_History_3", "Insurance_History_4", "Insurance_History_7", "Insurance_History_8", "Insurance_History_9", "Family_Hist_1", "Medical_History_2", "Medical_History_3", "Medical_History_4", "Medical_History_5", "Medical_History_6", "Medical_History_7", "Medical_History_8", "Medical_History_9", "Medical_History_10", "Medical_History_11", "Medical_History_12", "Medical_History_13", "Medical_History_14", "Medical_History_16", "Medical_History_17", "Medical_History_18", "Medical_History_19", "Medical_History_20", "Medical_History_21", "Medical_History_22", "Medical_History_23", "Medical_History_25", "Medical_History_26", "Medical_History_27", "Medical_History_28", "Medical_History_29", "Medical_History_30", "Medical_History_31", "Medical_History_33", "Medical_History_34", "Medical_History_35", "Medical_History_36", "Medical_History_37", "Medical_History_38", "Medical_History_39", "Medical_History_40", "Medical_History_41"]

    if useDummies == True:
        print ("Generating dummies...")
        train, test = getDummiesInplace(categoricalVariables, train, test)

    if fillNANStrategy is not None:
        print ("Filling in missing values...")
        train = pdFillNAN(train, fillNANStrategy)
        test = pdFillNAN(test, fillNANStrategy)

    if useNormalization == True:
        print ("Scaling...")
        scaler = pdStandardScaler()
        train = scaler.fit_transform(train)
        test = scaler.transform(test)

    return train, test, labels

# GET STARTED
print ("Creating dataset...")
train, test, labels = make_dataset(useDummies = True, fillNANStrategy = "mean", useNormalization = True)

model = Sequential()
model.add(MaxoutDense(output_dim = 100, input_dim = train.shape[1], nb_feature=4, init='glorot_uniform'))
model.add(Dropout(0.2))
model.add(Dense(output_dim = 8))
model.add(Activation('softmax'))
model.compile(loss='categorical_crossentropy', optimizer='adadelta')

print 'ji'
