import json
import pymongo
import requests
import os
import time

from time import strftime
from flask import Flask
from flask import request
from flask_restplus import Resource, Api
from flask_restplus import fields
from flask_restplus import inputs
from flask_restplus import reqparse

DB_NAME = 'comp9321'
DB_HOST = 'ds149960.mlab.com'
DB_PORT = 49960
DB_USER = 'admin'
DB_PASS = 'admin1'

connection = pymongo.MongoClient(DB_HOST, DB_PORT)
db = connection[DB_NAME]
db.authenticate(DB_USER, DB_PASS)

app = Flask(__name__)
api = Api(app,
		  default = "Collections",
		  title = "World Bank Economic Indicators API",
		  description = "Data Service for World Bank Economic Indicators.\
		  				 Assignment writen by Lingxu Meng (z5147810)")

indicator_model = api.model('Indicator', { 
	'indicator_id' : fields.String })

@api.route('/collections')
class Collections(Resource):
	
	@api.response(201, 'Collection Created Successfully')
	@api.response(200, 'Collection Already Has Been Imported')	
	@api.response(400, 'Indicator Error')
	@api.doc(description = "Import a new collection from the data service (Question 1)")
	@api.expect(indicator_model, validate = True)
	def post(self):
		indicator = request.json
		indicator_id = indicator['indicator_id']
		if 'indicator_id' not in indicator:
			return {"message": "Missing Indicator_id"}, 400

		url = "http://api.worldbank.org/v2/countries/all/indicators/"+indicator_id+"?date=2012:2017&format=json"
		r = requests.get(url)
		t = r.text
		j = json.loads(t)
		if r.status_code != 200 or len(j) < 2:
			return {"message": "Indicator_id {} is not available".format(indicator_id)}, 400

		os.environ['TZ'] = 'AEST-10AEDT-11,M10.5.0,M3.5.0'
		creation_time = time.strftime("%Y-%m-%dT%H:%M:%SZ")
		#page_number = 
		post_info = { 
						"location" : "/<collections>/"+indicator_id, 
    					"collection_id" : indicator_id,  
    					"creation_time": creation_time,
    					"indicator" : indicator_id
					}

		return post_info, 201

	def get(self):
		pass


@api.route('/collection/<string:collection_id>')
@api.param('collection_id', 'The Collection identifier')
class ClassName(Resource):
	@api.response(404, 'Collection id was not found')
	@api.response(200, 'Collection Removed Successfully')
	@api.doc(description = "Deleting a collection with the data service (Question 2)")
	def delete(self, collection_id):
		if collection_id not in db.collection_names():
			return {"message": "Collection {} doesn't exist".format(collection_id)}, 404
		db.drop_collection(collection_id)
		return {"message": "Collection = {} is removed from the database!".format(collection_id)}, 200

	def get(self, collection_id):
		pass



if __name__ == '__main__':

	app.run(debug = True)