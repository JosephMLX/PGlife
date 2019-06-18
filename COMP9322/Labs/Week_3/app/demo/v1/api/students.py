# -*- coding: utf-8 -*-
from __future__ import absolute_import, print_function

from flask import request, g, jsonify
import json

from . import Resource
from .. import schemas


class Students(Resource):
    def get(self):
        print(g.headers)
        print(g.args)
        path = "/Users/mlx/Desktop/PGlife/COMP9322/labs/week_3/app/demo/v1/api/students.json"
        with open(path) as f:
            students = json.load(f)
        return jsonify(students)

    def post(self):
        print(g.json)
        student = json.dumps(g.json)
        path = "/Users/mlx/Desktop/PGlife/COMP9322/labs/week_3/app/demo/v1/api/students.json"
        fileObject = open(path, 'w+')
        fileObject.write(student)
        return None, 200, None