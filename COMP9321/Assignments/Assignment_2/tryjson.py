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
		

#for i in range(len(long_data[1])):
#	result['entries']['country'] = long_data[1][i]["country"]["value"]
#	result['entries']['date'] = long_data[1][i]["date"],
#	result['entries']["value"] = long_data[1][i]["value"]
result["entries"] = entries
result = json.dumps(result)
result = json.loads(result)
print(result)
#print(entries)