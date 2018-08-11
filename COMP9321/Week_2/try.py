import pymongo
import pandas as pd
from pymongo import MongoClient
client = MongoClient()
db = client.database_name
collection = db.collection_name
data = pd.DataFrame(list(collection.find()))