# -*- coding: utf-8 -*-
from __future__ import absolute_import, print_function

import pymongo

from flask import Flask, request, g

from . import Resource
from .. import schemas

# from flask_restplus import Resource, Api, fields, inputs, reqparse

# Build connection to the database
client = pymongo.MongoClient("mongodb+srv://user:COMP9322@cluster0-89ls6.mongodb.net/test?retryWrites=true&w=majority")
db = client["Dentists"]


class DentistName(Resource):

    def get(self, name):
        t = db["dentist"]
        if t.find_one({'name': name}):
            dentist = t.find_one({'name': name})
            get_info = dict()
            get_info['id'] = dentist['id']
            get_info['name'] = dentist['name']
            get_info['location'] = dentist['location']
            get_info['specification'] = dentist['specification']
            get_info['phone'] = dentist['phone']
            get_info['description'] = dentist['description']
            return get_info, 200
        return {"message": "Dentist {} doesn't exist".format(name)}, 404
