# -*- coding: utf-8 -*-
from __future__ import absolute_import, print_function

from flask import request, g
import pymongo

from . import Resource
from .. import schemas


# Build connection to the database
client = pymongo.MongoClient("mongodb+srv://user:COMP9322@cluster0-89ls6.mongodb.net/test?retryWrites=true&w=majority")
db = client["Dentists"]


class TimeslotsCancle(Resource):

    def post(self):
        userData = request.json[0]
        dentistName = userData['name']
        dentistTime = int(userData['time'])
        t = db["dentist"]
        if t.find_one({'name': dentistName}):
            dentistFormer = t.find_one({'name': dentistName})
            dentistUpdate = t.find_one({'name': dentistName})
            timeStr = "available" + "%02d" % dentistTime
            dentistUpdate[timeStr] = True
            dentistUpdate = {"$set": dentistUpdate}
            update = t.update_one(dentistFormer, dentistUpdate)
            post_info = dict()
            post_info['ModifiedCount'] = update.modified_count
            return post_info, 200
        return {"message": "Dentist {} doesn't exist".format(dentistName)}, 404
