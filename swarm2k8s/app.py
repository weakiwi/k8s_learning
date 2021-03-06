from flask import Flask,render_template,request
import yaml
import re

app = Flask(__name__)
app.jinja_env.trim_blocks = True  
app.jinja_env.lstrip_blocks = True  
def array2string(l):
	tmpStr=""
        tmplen = len(l)
	for i in l:
            if tmplen != 1:
		tmpStr = tmpStr + i
		tmpStr = tmpStr + '", "'
            else:
                tmpStr = tmpStr + i
            tmplen = tmplen - 1
	return tmpStr
def del_bracket(l):
	return l[0]
def env_deal(l):
	if type(l) == list:
		return l.split("=",1)[0]
	if type(l) == dict:
		return l.keys()
def env_deal_1(l):
	if type(l) == list:
		return l.split("=",1)[1]
	if type(l) == dict:
		return l.values()
def convert_command(l):
    l = l.replace("{{ ", "{{")
    l = l.replace(" }}", "}}")
    l = l.split()
    tmplen = len(l)
    tmp = ""
    for i in l:
        if tmplen != 1:
            tmp = tmp + i + '", "'
        else:
            tmp = tmp + i
        tmplen = tmplen - 1
    return tmp
app.add_template_filter(del_bracket, 'del_bracket')
app.add_template_filter(env_deal, 'env_deal')
app.add_template_filter(env_deal_1, 'env_deal_1')
app.add_template_filter(array2string, 'array2string')
app.add_template_filter(convert_command, 'convert_command')
 
@app.route('/')
def hello():
	namespace = "tmpns"
        namespace = request.args.get("namespace")
        applabel = request.args.get("applabel")
        args_volume = request.args.get("isvolume")
        if args_volume != "false":
            args_volume = "true"
        if namespace == None:
            namespace = "tmpns"
	f = open('docker-compose.yaml')
	dataMap = yaml.load(f)
	f.close()
	services = dataMap['services']
	ports=[value["ports"] if "ports" in value else None for value in dataMap["services"].values()]
	images=[value["image"] for value in dataMap["services"].values()]
	depends=[value["depends_on"] if "depends_on" in value else None for value in dataMap["services"].values()]
#	if "commands" in services:
#		commands=[value["command"] for value in dataMap["services"].values()]
#	else:
#		commands=[]
	commands=[]
	for i in services.values():
		if "command" in i:
			commands.append(i["command"])
		else:
			commands.append(None)
	environment = [value["environment"] for value in dataMap["services"].values() if "environment" in value]  if "services" in dataMap else []
	tmp_env = []
	tmp_dict = {}
	for i in environment:
		if type(i) == dict:
			tmp_env.append(i)
		elif type(i) == list:
			for j in i:
				tmp_dict[j.split("=",1)[0]]=j.split("=",1)[1]
			tmp_env.append(tmp_dict)
			tmp_dict = {}
	labels=[map(lambda x:x.split('=', 1) ,map(lambda x:x.replace('"',''), value["labels"])) for value in dataMap["services"].values() if "labels" in value]  if "services" in dataMap else []
	mountpaths=[value["volumes"] if "volumes" in value and args_volume == "true" else None for value in dataMap["services"].values()]  if "services" in dataMap else []
	volumes = []
	storages = []
	counters = 0
	for i in services:
		if (dataMap["services"][i].has_key("volumes")) and args_volume == "true":
			volumes.append("volumes" + str(counters))
			storages.append("100Mi")
			counters = counters + 1
                else:
			volumes.append(None)
			storages.append(None)
			counters = counters + 1
	return render_template('hello.html', namespace=namespace, services=zip(services, ports), volumes=zip(volumes, storages), statefulsets=zip(services,images,commands,tmp_env,labels,zip(volumes,mountpaths), depends), applabel=applabel)
 
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
