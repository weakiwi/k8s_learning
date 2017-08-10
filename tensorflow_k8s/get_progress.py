#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import tensorflow as tf
import math
import os.path
import os


import numpy as np
train_data_pos = os.environ.get("TRAIN_DATA_POS")
test_data_pos = os.environ.get("TEST_DATA_POS")
checkpoint_data_pos = os.environ.get("CHECKPOINT_DATA_POS")
from flask import Flask

app = Flask(__name__)

@app.route('/getprogress')
def getprogress():
	batch_size = request.args.get("batch_size")
	epoch_num = request.args.get("epoch_num")
        if os.path.isfile(train_data_pos) and os.path.isfile(test_data_pos) and os.path.isfile(checkpoint_data_pos):
	    validate_interval = request.args.get("validate_interval")
	    ckpt = tf.train.get_checkpoint_state(checkpoint_data_pos)
	    global_step = ckpt.model_checkpoint_path.split('/')[-1].split('-')[-1]
	    train_data_row = sum(1 for _ in tf.python_io.tf_record_iterator(train_data_pos))
	    test_data_row = sum(1 for _ in tf.python_io.tf_record_iterator(test_data_pos))
	    full_step = train_data_row*epoch_num/batch_size
	    validate_step = full_step/validate_interval
	    return global_step/(full_step - validate_step)
        else:
            return "not file exists"
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)

