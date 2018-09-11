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
# MLab username: z5147810, password: COMP9321, please login if necessary
# Database parameters, can be changed for judging
DB_NAME = 'comp9321'
DB_HOST = 'ds149960.mlab.com'
DB_PORT = 49960
DB_USER = 'admin'
DB_PASS = 'admin1'

# Build connection to the database 
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
class ClassName(Resource):
	
	@api.response(200, 'Collection Already Has Been Imported')	
	@api.response(201, 'Collection Created Successfully')
	@api.response(400, 'Indicator Error')
	@api.doc(description = "Import a new collection from the data service (Question 1)")
	@api.expect(indicator_model, validate = True)
	def post(self):
		indicator = request.json
		indicator_id = indicator['indicator_id']
		# If user didn't print an indicator id, then return 400
		if 'indicator_id' not in indicator:
			return {"message": "Missing Indicator_id"}, 400

		url = "http://api.worldbank.org/v2/countries/all/indicators/"+indicator_id+"?date=2012:2017&format=json"
		# Transform content from the url to json format
		r = requests.get(url)
		t = r.text
		j = json.loads(t)
		# If the url is not valiable or the indicator is not valiable, then return 400
		if r.status_code != 200 or len(j) < 2:
			return {"message": "Indicator_id {} is not available".format(indicator_id)}, 400
		# Set system timezone and time format
		os.environ['TZ'] = 'AEST-10AEDT-11,M10.5.0,M3.5.0'
		creation_time = time.strftime("%Y-%m-%dT%H:%M:%SZ")
		# Initialise api return info
		post_info = { 
						"location" : "/<collections>/"+indicator_id, 
    					"collection_id" : indicator_id,  
    					"creation_time": creation_time,
    					"indicator" : indicator_id
					}
		post_info = json.dumps(post_info)
		post_info = json.loads(post_info)
		# If the indicator id is already in the database, just return 200 and collection info
		if indicator_id in db.collection_names():
			return post_info, 200
		# Initialise the collection
		collection = {  
  						"collection_id" : indicator_id,
  						"indicator": indicator_id,
  						"indicator_value": "GDP (current US$)",
  						"creation_time" : creation_time,
  						"entries" : {}
		 		  	 }
		page_number = r.json()[0]["pages"]
		# Traverse all pages and all item of the indicator
		entries = []
		for i in range(1, page_number + 1):
			r = requests.get(url+"&page="+str(i))
			entries_in_one_page = len(r.json()[1])
			content = r.json()
			for j in range(entries_in_one_page):
				entry = {"country": "", "date": "", "value": ""}
				entry["country"] = content[1][j]["country"]["value"]
				entry["date"] = content[1][j]["date"]
				entry["value"] = content[1][j]["value"]
				entries.append(entry)
		
		collection["entries"] = entries
		collection = json.dumps(collection)
		collection = json.loads(collection)
		# Use bracket can name a collection using variable, db.* can not
		new_collection = db[indicator_id]
		new_collection.insert_one(collection)
		return post_info, 201


	@api.response(200, 'Retrieve Collections Successfully')
	@api.doc(description = "Retrieve the list of available collections (Question 3)")
	def get(self):
		get_info = []
		collections = list(db.collection_names())
		collections.remove("system.indexes")
		for collection_id in collections:
			collection = db[collection_id]
			collection_info = {}
			for document in collection.find():
				collection_info["location"] = "/<collections>/"+collection_id
				collection_info["collection_id"] = collection_id
				collection_info["creation_time"] = document["creation_time"]
				collection_info["indicator"] = collection_id
			get_info.append(collection_info)

		return get_info, 200


@api.route('/collection/<string:collection_id>')
@api.param('collection_id', 'The Collection identifier')
class ClassName(Resource):
	
	@api.response(200, 'Collection Removed Successfully')
	@api.response(404, 'Cannot Find Collection in Database')
	@api.doc(description = "Deleting a collection with the data service (Question 2)")
	def delete(self, collection_id):
		if collection_id not in db.collection_names():
			return {"message": "Collection {} doesn't exist".format(collection_id)}, 404
		db.drop_collection(collection_id)
		return {"message": "Collection = {} is removed from the database!".format(collection_id)}, 200


	@api.response(200, 'Collection Retrived Successfully')
	@api.response(404, 'Cannot Find Collection in Database')
	@api.doc(description = "Retrieve a collection (Question 4)")
	def get(self, collection_id):
		if collection_id not in db.collection_names():
			return {"message": "Collection {} doesn't exist".format(collection_id)}, 404
		collection = db[collection_id]
		get_info = {}
		for document in collection.find():
			get_info["collection_id"] = document["collection_id"]
			get_info["indicator"] = document["indicator"]
			get_info["indicator_value"] = document["indicator_value"]
			get_info["creation_time"] = document["creation_time"]
			get_info["entries"] = document["entries"]

		get_info = json.dumps(get_info)
		get_info = json.loads(get_info)
		return get_info, 200

@api.route('/collection/<string:collection_id>/<string:year>/<string:country>')
@api.param('collection_id', 'The Collection identifier')
@api.param('year', 'The year')
@api.param('country', 'The country')
class ClassName(Resource):

	@api.response(200, 'Indicator Value Found Successfully')
	@api.response(404, 'Parameters Not Available')
	@api.doc(description = "Retrieve economic indicator value for given country and a year (Question 5)")
	def get(self, collection_id, year, country):
		pass


if __name__ == '__main__':
	app.run(debug = True)