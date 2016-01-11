#referrence : http://qiita.com/moshisora/items/4f8892158eb21c4c6ade
import numpy as np
import pickle
import theano

# function for classifying a input vector
def classify(inp,model,input_size):
    inp = np.asarray(inp, dtype=np.float32)
    inp.shape = (1, input_size)
    return np.argmax(model.fprop(theano.shared(inp, name='inputs')).eval())

# function for calculating and printing the models accuracy on a given dataset
def score(dataset, model, input_size):
    nr_correct = 0
    step = 0

    for features, label in zip(dataset.X,dataset.y):
        step += 1

        if classify(features,model, input_size) == label:
            nr_correct += 1

        if step % 100 == 0:
            print '%5d/%5d correct' % (nr_correct, step)

    print 'validation process end: {}/{} correct'.format(nr_correct, len(dataset.X))
    return nr_correct, len(dataset.X)

model = pickle.load(open('best.pkl'))
test_data = pickle.load(open('../data/valid_1000.pkl'))
score(test_data, model, 1077)
