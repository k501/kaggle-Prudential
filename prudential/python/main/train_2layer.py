"""
This module tests stacked_autoencoders.ipynb
"""
import os

from pylearn2.testing import skip
from pylearn2.testing import no_debug_mode
from pylearn2.config import yaml_parse


@no_debug_mode
def train_yaml(yaml_file):

    train = yaml_parse.load(yaml_file)
    train.main_loop()

def train_layer1(yaml_file_path, save_path, train_data):

    yaml = open("{0}/dae_l1.yaml".format(yaml_file_path), 'r').read()
    hyper_params = {'train_stop'          : 47500,
                    'batch_size'          : 1000,
                    'monitoring_batches'  : 1,
                    'nvis'                : 952,
                    'nhid'                : 50,
                    'max_epochs'          : 20,
                    'train_data'          : train_data,
                    'act_enc'             : 'tanh',
                    'save_path'           : save_path}
    yaml = yaml % (hyper_params)
    train_yaml(yaml)

def train_layer2(yaml_file_path, save_path, train_data):

    yaml = open("{0}/dae_l2.yaml".format(yaml_file_path), 'r').read()
    hyper_params = {'train_stop'          : 47500,
                    'batch_size'          : 1000,
                    'monitoring_batches'  : 1,
                    'nvis'                : 50,
                    'nhid'                : 50,
                    'max_epochs'          : 3,
                    'train_data'          : train_data,
                    'act_enc'             : 'tanh',
                    'save_path'           : save_path}
    yaml = yaml % (hyper_params)
    train_yaml(yaml)

def train_mlp(yaml_file_path, save_path, train_data, model_name):

    yaml = open("{0}/dae_mlp_2layer.yaml".format(yaml_file_path), 'r').read()
    hyper_params = {'train_stop'    : 47500,
                    'valid_stop'    : 47500,
                    'batch_size'    : 1000,
                    'max_epochs'    : 3,
                    'nvis'          : 952,
                    'train_data'    : train_data,
                    'n_class'       : 8,
                    'save_path'     : save_path,
                    'model_name'    : model_name  }
    yaml = yaml % (hyper_params)
    train_yaml(yaml)

def test_sda():

    skip.skip_if_no_data()

    # set common parameter
    yaml_file_path = '..';
    save_path = '.';
    train_data = '../data/train_mini.pkl';
    model_name = 'model.pkl';

    print '=== train_layer1 =========================================================='
    train_layer1(yaml_file_path, save_path, train_data)
    print '=== train_layer2 =========================================================='
    train_layer2(yaml_file_path, save_path, train_data)
    print '=== fine tuning ==========================================================='
    train_mlp(   yaml_file_path, save_path, train_data, model_name)

    try:
        os.remove("{}/dae_l1.pkl".format(save_path))
        os.remove("{}/dae_l2.pkl".format(save_path))
    except OSError:
        pass

if __name__ == '__main__':
    test_sda()
