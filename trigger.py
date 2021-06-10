import requests
url = "https://www.bridgecrew.cloud/api/v1/scans/integrations"
headers = {"authorization": "07958f89-31b6-591f-9677-e8b92a448e9f"}
response = requests.request("POST", url, headers=headers)
print(response.text)