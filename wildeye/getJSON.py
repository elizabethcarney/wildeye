'''
Elizabeth Carney
May 23, 2020
WildEye: An interactive scavenger hunt app that encourages users to engage with local wildlife.
Created for BackyardHacks 2020

getJSON.py
Calls USDA PLANTS Database API to create JSON files containing local wildlife data.
'''

import requests
import json

def main():
    # call USDA PLANTS Search API (returns page IDs)
    # for some reason, first and last fields are ignored, so need commas before and after list of fields
    response = requests.get("https://plantsdb.xyz/search?limit=1000&offset=1000&fields=',Symbol,Common_Name,State_and_Province,Category,Active_Growth_Period,'")
    raw_json = response.text

    # write response to json file
    file = open("response_text2.json", "w")
    file.write(response.text)
    file.close()

    parseJSON(raw_json)

# parse json into dictionary, filter and clean
def parseJSON(raw_json):
    # convert json to python object
    raw_dict = json.loads(raw_json)
    data_dict_list = raw_dict.get("data")
    # filter to only entries with symbol, common name, and location
    filtered_dict_list = list(filter(lambda x: (x['Common_Name'] != "") & (x['Symbol'] != "") & (x['State_and_Province'] != ""), data_dict_list))

    cleaned_dict_list = cleanDicts(filtered_dict_list)
    
    output_json = json.dumps(cleaned_dict_list)
    filter_file = open("filter_text.json", "a")
    filter_file.write(output_json)
    filter_file.close()

# clean up states attribute, filter out ones with no image
def cleanDicts(dict_list):
    for i in range(len(dict_list)):
        # clean up states attribute
        og_str = dict_list[i]['State_and_Province']
        if og_str[:5] == "USA (":
            cut_str = og_str[5:]
            iparen = cut_str.find(")")
            doublecut_str = cut_str[:iparen]
            dict_list[i]['State_and_Province'] = doublecut_str

            # make sure has image and create attribute for its url
            photo_url = checkPhotoURL(dict_list[i]['Symbol'])
            if photo_url:
                dict_list[i]['Photo_URL'] = photo_url
            else:
                dict_list[i]['Pop'] = "pop" # if no photo found
        else:
            dict_list[i]['Pop'] = "pop" # if not located in USA 
    
    # create new list of cleaned up items that have photos
    new_dict_list = []
    for i in range(len(dict_list)):
        if 'Pop' not in dict_list[i]:
            new_dict_list.append(dict_list[i])

    return new_dict_list

# try to find url of accompanying photo
def checkPhotoURL(symbol):

    guess_urls = ["_001_svp.jpg", "_001_shp.jpg", "_002_svp.jpg", "_002_shp.jpg"]

    for guess in guess_urls:
        url = "https://plants.sc.egov.usda.gov/gallery/standard/" + symbol + guess
        res = requests.get(url)
        if res.status_code == requests.codes.ok:
            return url
    
    return False # not found

main()