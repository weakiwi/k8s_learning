#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import tensorflow as tf
import math
import os.path
import os

import json

import numpy as np
train_data_pos = os.environ.get("TRAIN_DATA_POS")
test_data_pos = os.environ.get("TEST_DATA_POS")
checkpoint_data_pos = os.environ.get("CHECKPOINT_DATA_POS")
from flask import Flask
from flask import request

app = Flask(__name__)

@app.route('/checkall')
def checkall():
    return train_data_pos +"\n"+ test_data_pos+"\n" + checkpoint_data_pos+"\n"

@app.route('/')
def hello_world():
	json_data = {}
	batch_size = float(request.args.get("batch_size"))
	epoch_num = float(request.args.get("epoch_num"))
	validate_interval = float(request.args.get("validate_interval"))
        if os.path.isfile(train_data_pos) and os.path.isfile(test_data_pos) and os.path.isfile(checkpoint_data_pos):
	    return "file no exsist"
        else:
	    json_data["batch_size"] = batch_size
	    json_data["epoch_num"] = epoch_num
	    json_data["validate_interval"] = validate_interval
	    ckpt = tf.train.get_checkpoint_state(checkpoint_data_pos)
	    global_step = float(ckpt.model_checkpoint_path.split('/')[-1].split('-')[-1])
	    print(global_step)
	    train_data_row = sum(1 for _ in tf.python_io.tf_record_iterator(train_data_pos))
	    test_data_row = sum(1 for _ in tf.python_io.tf_record_iterator(test_data_pos))
	    full_step = train_data_row*epoch_num/batch_size
	    json_data["current_step"] = global_step
	    validate_step = full_step/validate_interval
	    json_data["progress"] = global_step/(full_step - validate_step)
	    return json.dumps(json_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)

