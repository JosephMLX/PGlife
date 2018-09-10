import pymongo
import requests
DB_NAME = 'comp9321'
DB_HOST = 'ds149960.mlab.com'
DB_PORT = 49960
DB_USER = 'admin'
DB_PASS = 'admin1'

connection = pymongo.MongoClient(DB_HOST, DB_PORT)
db = connection[DB_NAME]
db.authenticate(DB_USER, DB_PASS)


post = {"author": "Mike",
		"text": "My first blog post!",
		"tags": ["mongodb", "python", "pymongo"]
		}
posts = db.posts
post_id = posts.insert_one(post).inserted_id
print(post_id)

cid = 'posts'

if cid in db.collection_names():
	db.drop_collection(cid)
	
else:
	print("Fuck me")