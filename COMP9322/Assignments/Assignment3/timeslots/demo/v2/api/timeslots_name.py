# -*- coding: utf-8 -*-
from __future__ import absolute_import, print_function

from flask import request, g
import pymongo

from . import Resource
from .. import schemas


# Build connection to the database
client = pymongo.MongoClient("mongodb+srv://user:COMP9322@cluster0-89ls6.mongodb.net/test?retryWrites=true&w=majority")
db = client["Dentists"]


class TimeslotsName(Resource):

    def get(self, name):
        t = db["dentist"]
        if t.find_one({'name': name}):
            dentist = t.find_one({'name': name})
            get_info = dict()
            get_info['available09'] = dentist['available09']
            get_info['available10'] = dentist['available10']
            get_info['available11'] = dentist['available11']
            get_info['available12'] = dentist['available12']
            get_info['available13'] = dentist['available13']
            get_info['available14'] = dentist['available14']
            get_info['available15'] = dentist['available15']
            get_info['available16'] = dentist['available16']
            get_info['available17'] = dentist['available17']
            return get_info, 200
        return {"message": "Dentist {} doesn't exist".format(name)}, 404

