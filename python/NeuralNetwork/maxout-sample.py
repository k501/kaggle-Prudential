#!/usr/bin/env python
# -*- coding: utf-8 -*-
# https://www.kaggle.com/c/otto-group-product-classification-challenge/forums/t/13632/achieve-0-48-in-5-min-with-a-deep-net-feat-batchnorm-prelu?limit=all
from __future__ import unicode_literals
import logging
import numpy
import keras.models
import keras.layers.core
import keras.regularizers
import sklearn.metrics
import sklearn.base
import keras.constraints
import keras.layers.noise
import keras.optimizers
import keras.callbacks

class NnWrapper(sklearn.base.BaseEstimator):
    """Wrapper for Keras feed-forward neural network for classification to enable scikit-learn grid search"""
    def __init__(self, hidden_layer_sizes=(100,), dropout=0.5, show_accuracy=True, batch_spec=((400, 1024), (100, -1)), activation="relu", input_noise=0., use_maxout=False, use_maxnorm=False, learning_rate=0.001, stop_early=False):
        self.hidden_layer_sizes = hidden_layer_sizes
        self.dropout = dropout
        self.show_accuracy = show_accuracy
        self.batch_spec = batch_spec
        self.activation = activation
        self.input_noise = input_noise
        self.use_maxout = use_maxout
        self.use_maxnorm = use_maxnorm
        self.learning_rate = learning_rate
        self.stop_early = stop_early

        if self.use_maxout:
            self.use_maxnorm = True

        self.model_ = None

    def fit(self, X, y, **kwargs):
        self.set_params(**kwargs)

        model = keras.models.Sequential()

        first = True

        if self.input_noise > 0:
            model.add(keras.layers.noise.GaussianNoise(self.input_noise, input_shape=X.shape[1:]))

        num_maxout_features = 2

        dense_kwargs = {"init": "glorot_uniform"}
        if self.use_maxnorm:
            dense_kwargs["W_constraint"] = keras.constraints.maxnorm(2)

        # hidden layers
        for layer_size in self.hidden_layer_sizes:
            if first:
                if self.use_maxout:
                    model.add(keras.layers.core.MaxoutDense(output_dim=layer_size / num_maxout_features, input_dim=X.shape[1], init="glorot_uniform", nb_feature=num_maxout_features))
                else:
                    model.add(keras.layers.core.Dense(output_dim=layer_size, input_dim=X.shape[1], **dense_kwargs))
                    model.add(keras.layers.core.Activation(self.activation))
                first = False
            else:
                if self.use_maxout:
                    model.add(keras.layers.core.MaxoutDense(output_dim=layer_size / num_maxout_features, init="glorot_uniform", nb_feature=num_maxout_features))
                else:
                    model.add(keras.layers.core.Dense(output_dim=layer_size, **dense_kwargs))
                    model.add(keras.layers.core.Activation(self.activation))
            model.add(keras.layers.core.Dropout(self.dropout))

        if first:
            model.add(keras.layers.core.Dense(output_dim=1, input_dim=X.shape[1], **dense_kwargs))
        else:
            model.add(keras.layers.core.Dense(output_dim=1, **dense_kwargs))
        model.add(keras.layers.core.Activation(self.activation))

        optimizer = keras.optimizers.Adam(lr=self.learning_rate, beta_1=0.9, beta_2=0.999, epsilon=1e-8)
        model.compile(loss="mse", optimizer=optimizer, class_mode="binary")

        # batches as per configuration
        for num_iterations, batch_size in self.batch_spec:
            fit_kwargs = {}
            if self.stop_early and batch_size > 0:
                fit_kwargs["callbacks"] = [EarlyStopping(monitor='val_loss', patience=20, verbose=1)]
                fit_kwargs["validation_split"] = 0.2

            if batch_size < 0:
                batch_size = X.shape[0]
            if num_iterations > 0:
                model.fit(X, y, nb_epoch=num_iterations, batch_size=batch_size, show_accuracy=self.show_accuracy, **fit_kwargs)

        if self.stop_early:
            # final refit with full data
            model.fit(X, y, nb_epoch=5, batch_size=X.shape[0], show_accuracy=self.show_accuracy)

        self.model_ = model

    def predict(self, X):
        return self.model_.predict_classes(X)

    def predict_proba(self, X):
        return self.model_.predict(X)

    def score(self, X, y):
        return sklearn.metrics.accuracy_score(y, self.predict(X))
