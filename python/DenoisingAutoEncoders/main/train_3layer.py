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
    hyper_params = {'train_stop'          : 44500,
                    'batch_size'          : 2000,
                    'monitoring_batches'  : 1,
                    'nvis'                : 900,
                    'nhid'                : 100,
                    'max_epochs'          : 400,
                    'train_data'          : train_data,
                    'act_enc'             : 'tanh',
                    'save_path'           : save_path}
    yaml = yaml % (hyper_params)
    train_yaml(yaml)

def train_layer2(yaml_file_path, save_path, train_data):

    yaml = open("{0}/dae_l2.yaml".format(yaml_file_path), 'r').read()
    hyper_params = {'train_stop'          : 44500,
                    'batch_size'          : 2000,
                    'monitoring_batches'  : 1,
                    'nvis'                : 100,
                    'nhid'                : 100,
                    'max_epochs'          : 400, 
                    'train_data'          : train_data,
                    'act_enc'             : 'tanh',                    
                    'save_path'           : save_path}
    yaml = yaml % (hyper_params)
    train_yaml(yaml)

def train_layer3(yaml_file_path, save_path, train_data):

    yaml = open("{0}/dae_l3.yaml".format(yaml_file_path), 'r').read()
    hyper_params = {'train_stop'          : 44500,
                    'batch_size'          : 2000,
                    'monitoring_batches'  : 1,
                    'nvis'                : 100,
                    'nhid'                : 100,
                    'max_epochs'          : 400,
                    'train_data'          : train_data,
                    'act_enc'             : 'tanh',                    
                    'save_path'           : save_path}
    yaml = yaml % (hyper_params)
    train_yaml(yaml)

def train_mlp(yaml_file_path, save_path, train_data, model_name):

    yaml = open("{0}/dae_mlp_3layer.yaml".format(yaml_file_path), 'r').read()
    hyper_params = {'train_stop'  : 44500,
                    'valid_stop'  : 44500,
                    'batch_size'  : 2000,
                    'max_epochs'  : 400,
                    'nvis'        : 900,
                    'train_data'  : train_data,
                    'n_class'     : 8,
                    'save_path'   : save_path,
                    'model_name'  : model_name  }
    yaml = yaml % (hyper_params)
    train_yaml(yaml)

def test_sda():

    skip.skip_if_no_data()

    # set common parameter 
    yaml_file_path = '..';
    save_path = '.';
    train_data = '../data/train.pkl';
    model_name = 'model.pkl';

    print '=== train_layer1 =========================================================='
    train_layer1(yaml_file_path, save_path, train_data)
    print '=== train_layer2 =========================================================='
    train_layer2(yaml_file_path, save_path, train_data)
    print '=== train_layer3 =========================================================='
    train_layer3(yaml_file_path, save_path, train_data)
    print '=== fine tuning ==========================================================='
    train_mlp(   yaml_file_path, save_path, train_data, model_name)

    try:
        os.remove("{}/dae_l1.pkl".format(save_path))
        os.remove("{}/dae_l2.pkl".format(save_path))
        os.remove("{}/dae_l3.pkl".format(save_path))
    except OSError:
        pass

if __name__ == '__main__':
    test_sda()
