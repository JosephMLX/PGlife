import json
import requests

indicator_id = "NY.GDP.MKTP.CD"
url = "http://api.worldbank.org/v2/countries/all/indicators/"+indicator_id+"?date=2012:2017&format=json"
r = requests.get(url)
page_number = r.json()[0]["pages"]

result = {  
  			"collection_id" : "<collection_id>",
  			"indicator": "NY.GDP.MKTP.CD",
  			"indicator_value": "GDP (current US$)",
  			"creation_time" : "<creation_time>",
  			"entries" : {}
		 }

for i in range(1, page_number + 1):
	r = requests.get(url+"&page="+str(i))
	item_in_one_page = r.json()	
	print(len(item_in_one_page[1]))

#for i in range(len(long_data[1])):
#	result['entries']['country'] = long_data[1][i]["country"]["value"]
#	result['entries']['date'] = long_data[1][i]["date"],
#	result['entries']["value"] = long_data[1][i]["value"]

result = json.dumps(result)

#print(result)
print(page_number)