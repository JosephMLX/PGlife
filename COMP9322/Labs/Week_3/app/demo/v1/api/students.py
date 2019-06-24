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
        # path = "/Users/mlx/Desktop/PGlife/COMP9322/labs/week_3/app/demo/v1/api/students.json"
        path = "/app/demo/v1/api/students.json"
        with open(path) as f:
            students = json.load(f)
        return jsonify(students)

    def post(self):
        print(g.json)
        student = g.json
        # path = "/Users/mlx/Desktop/PGlife/COMP9322/labs/week_3/app/demo/v1/api/students.json"
        path = "/app/demo/v1/api/students.json"
        print(type(student))
        with open(path) as f:
            students = json.load(f)
        print(students)
        print(type(students))
        students.append(student)
        fileObject = open(path, 'w+')
        fileObject.write(json.dumps(students))
        return None, 201, None
