# -*- coding: utf-8 -*-
import pymongo

from flask import Flask, request, g

from . import Resource
from .. import schemas

# Build connection to the database
client = pymongo.MongoClient("mongodb+srv://user:COMP9322@cluster0-89ls6.mongodb.net/test?retryWrites=true&w=majority")
db = client["Dentists"]


class Dentist(Resource):

    def get(self):
        t = db["dentist"]
        names = []
        for i in range(t.count()):
            dentist = t.find_one({'id': i+1})
            names.append(dentist['name'])
        info = {'dentists': names}
        return info, 200
