from flask import Flask,render_template
import yaml

app = Flask(__name__)
 
@app.route('/hello')
@app.route('/hello/<name>')
def hello(name=None):
	f = open('mongo-swarm.yaml')
	dataMap = yaml.load(f)
	f.close()
	services = dataMap['services']
	ports=[value["ports"] for value in dataMap["services"].values()]
	images=[value["image"] for value in dataMap["services"].values()]
	commands=[value["image"] for value in dataMap["services"].values()]
	environment=[map(lambda x:x.split("="), value["environment"]) for value in dataMap["services"].values() if "environment" in value]  if "services" in dataMap else []
	labels=[map(lambda x:x.split("=",1), value["labels"]) for value in dataMap["services"].values() if "labels" in value]  if "services" in dataMap else []
	mountpaths=[value["volumes"] for value in dataMap["services"].values() if "volumes" in value]  if "services" in dataMap else []
	volumes = []
	storages = []
	counters = 0
	for i in services:
		if (dataMap["services"][i].has_key("volumes")):
			volumes.append("volumes" + str(counters))
			storages.append("100Mi")
			counters = counters + 1
	namespace = "tmpns"
	return render_template('hello.html', namespace=namespace, services=zip(services, ports), volumes=zip(volumes, storages), statefulsets=zip(services,images,commands,environment,labels,zip(volumes,mountpaths)))
 
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
