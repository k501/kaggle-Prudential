import csv
import numpy as np
import pickle
import theano

# function for classifying a input vector
def classify(inp,model,input_size):
    inp = np.asarray(inp)
    inp.shape = (1, input_size)
    return np.argmax(model.fprop(theano.shared(inp, name='inputs')).eval())

# function for calculating and printing the models accuracy on a given dataset
def score(dataset, model, input_size):
    step = 0
    rowList = []
    for features in zip(dataset.X):

        step += 1
        rowList.append([])
        
        predict = classify(features, model, input_size)
        rowList[step-1].append(predict)
ty
        if step % 100 == 0:
            print 'step %6d / %6d completed' % (step, len(dataset.X))

    return rowList

model = pickle.load(open('models/model_2.pkl'))
test_data = pickle.load(open('../data/test.pkl'))
outList = score(test_data, model, 966)

with open('test.csv', 'w') as f:
	csvWriter = csv.writer(f, lineterminator='\n')
	csvWriter.writerows(outList)
