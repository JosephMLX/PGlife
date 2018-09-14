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
# In this assignment, collection_id = indicator_id
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

# expected model for Question 1
indicator_model = api.model('Indicator', { 
	'indicator_id' : fields.String })

@api.route('/collections')
class Class1(Resource):
	# QUESTION 1
	@api.response(200, 'Collection Already Has Been Imported')	
	@api.response(201, 'Collection Created Successfully')
	@api.response(400, 'Bad Request')
	@api.response(404, 'Indicator Not Found')
	@api.doc(description = "Import a new collection from the data service (Question 1)")
	@api.expect(indicator_model, validate = True)
	def post(self):
		indicator = request.json
		indicator_id = indicator['indicator_id']
		# If user didn't print an indicator id, then return 400
		if not indicator["indicator_id"]:
			return {"message": "Missing Indicator_id"}, 400

		url = "http://api.worldbank.org/v2/countries/all/indicators/"+indicator_id+"?date=2012:2017&format=json"
		r = requests.get(url)
		# Transform content from the url to json format for analysing data
		j = r.json()
		# If cannot find available data with indicator_id, return 404
		if r.status_code != 200 or len(j) < 2:
			return {"message": "Indicator_id {} is not available".format(indicator_id)}, 404
		# Set system timezone ro AEST and time format
		os.environ['TZ'] = 'AEST-10AEDT-11,M10.5.0,M3.5.0'
		creation_time = time.strftime("%Y-%m-%dT%H:%M:%SZ")
		# Initialise api return info
		post_info = { 
						"location" : "/collections/"+indicator_id, 
    					"collection_id" : indicator_id,  
    					"creation_time": creation_time,
    					"indicator" : indicator_id
					}
		# If the indicator id is already in the database, return 200
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
		# Traverse first two pages and items of the indicator
		entries = []
		for i in range(1, 3):
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
		# Create new collection in database
		# db[*] can name a collection using variable, db.* can not
		new_collection = db[indicator_id]
		# Insert collection json as document
		new_collection.insert_one(collection)
		return post_info, 201

	# QUESTION 3
	@api.response(200, 'Retrieve Collections Successfully')
	@api.doc(description = "Retrieve the list of available collections (Question 3)")
	def get(self):
		get_info = []
		collections = list(db.collection_names())
		# Retrieve all collections in database, except for system indexes
		collections.remove("system.indexes")
		for collection_id in collections:
			collection = db[collection_id]
			collection_info = {}
			for document in collection.find():
				collection_info["location"] = "/collections/"+collection_id
				collection_info["collection_id"] = collection_id
				collection_info["creation_time"] = document["creation_time"]
				collection_info["indicator"] = collection_id
			get_info.append(collection_info)

		return get_info, 200


@api.route('/collections/<string:collection_id>')
@api.param('collection_id', 'The Collection identifier')
class Class2(Resource):
	# QUESTION 2
	@api.response(200, 'Collection Removed Successfully')
	@api.response(404, 'Collection Not Found')
	@api.doc(description = "Deleting a collection with the data service (Question 2)")
	def delete(self, collection_id):
		if collection_id not in db.collection_names():
			return {"message": "Collection {} doesn't exist".format(collection_id)}, 404
		# Drop collection from database
		db.drop_collection(collection_id)
		return {"message": "Collection = {} is removed from the database!".format(collection_id)}, 200

	# QUESTION 4
	@api.response(200, 'Collection Retrived Successfully')
	@api.response(404, 'Collection Not Found')
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

		return get_info, 200

@api.route('/collections/<string:collection_id>/<string:year>/<string:country>')
@api.param('collection_id', 'The Collection identifier')
@api.param('year', 'The year')
@api.param('country', 'The country')
class Class3(Resource):
	# QUESTION 5
	@api.response(200, 'Indicator Value Found Successfully')
	@api.response(404, 'Parameters Not Available')
	@api.doc(description = "Retrieve economic indicator value for given country and a year (Question 5)")
	def get(self, collection_id, year, country):
		if collection_id not in db.collection_names():
			return {"message": "Collection {} doesn't exist".format(collection_id)}, 404
		collection = db[collection_id]
		get_info = {}
		# Initialize value as -1, change it if can find a value with parameters above. Otherwise, return 404
		value = -1
		for document in collection.find():
			for entry in document["entries"]:
				if entry["date"] == year and entry["country"] == country:
					value = entry["value"]
		if value == -1:
			return {"message": "Parameters are not available"}, 404
		get_info["collection_id"] = collection_id
		get_info["indicator"] = collection_id
		get_info["country"] = country
		get_info["year"] = year
		get_info["value"] = value
		return get_info, 200

# Use parser.add_argument to get user's query input
parser = api.parser()
parser.add_argument('q', type=str, help='top<N> or bottom<N>', location='args')
@api.route('/collections/<string:collection_id>/<string:year>')
class Class4(Resource):
	# QUESTION 6
	@api.response(200, "Retrieve Indicator Values Successfully")
	@api.response(400, "Bad Request")
	@api.response(404, "Parameters Not Available")
	@api.expect(parser, validate = True)
	@api.doc(description = "Retrieve top/bottom economic indicator values for a given year (Question 6)")
	def get(self, collection_id, year):
		if collection_id not in db.collection_names():
			return {"message": "Collection {} doesn't exist".format(collection_id)}, 404

		entries = []
		collection = db[collection_id]
		for document in collection.find():
			indicator_value = document["indicator_value"]
			for entry in document["entries"]:
				if entry["date"] == year:
					entries.append(entry)
		get_info = {
   					"indicator": collection_id,
   					"indicator_value": indicator_value,
   					"entries": []
					}

		q = parser.parse_args()
		# If query is not given, return all data in the given year
		if not q["q"]:
			get_info["entries"] = entries
			return get_info, 200
		# Check whether query is "top[0-9]+" or "bottom[0-9]+", regex could be better...
		query = q["q"]
		if query[0:3] != "top" and query[0:6] != "bottom":
			return {"message": "Query {} not available".format(query)}, 400
		if query[0:3] == "top":
			order = 1
			if not isinstance(query[3:], int):
				return {"message": "Query {} not available".format(query)}, 400
			num = int(query[3:])
		if query[0:6] == "bottom":
			order = 0
			if not isinstance(query[6:], int):
				return {"message": "Query {} not available".format(query)}, 400
			num = int(query[6:])

		if num > 100 or num < 1:
			return {"message": "<N> {} out of range".format(num)}, 400
		# Set None value to an integer for sorting
		for entry in entries:
			if entry["value"] is None:
				entry["value"] = 0
		# Sort the entries in collection by value
		entries = sorted(entries, key=lambda entry: (entry["value"]), reverse = True)
		# Set edited values back to None
		for entry in entries:
			if entry["value"] == 0:
				entry["value"] = None
		if order == 1:
			get_info["entries"] = entries[0:num]
		if order == 0:
			entries = entries[::-1]
			get_info["entries"] = entries[0:num]
		return get_info, 200



if __name__ == '__main__':
	app.run(debug = True)