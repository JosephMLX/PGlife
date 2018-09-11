import pymongo
import requests
import json
DB_NAME = 'comp9321'
DB_HOST = 'ds149960.mlab.com'
DB_PORT = 49960
DB_USER = 'admin'
DB_PASS = 'admin1'

connection = pymongo.MongoClient(DB_HOST, DB_PORT)
db = connection[DB_NAME]
db.authenticate(DB_USER, DB_PASS)

#print(db.collection_names())

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

a = "NY.GDP.MKTP.CD"
b = "20112"
c = "Australia"
v = -1
col = db[a]
for d in col.find():
	for e in d["entries"]:
		if e["date"] == b and e["country"] == c:
			v = e["value"]
if v == -1:
	print('FUCK')
else:
	print(v)