import sys, json, re;
test = "\{\'ok\': True}"
parsed = json.dumps(test);
# print(parsed)
print(json.loads(parsed));