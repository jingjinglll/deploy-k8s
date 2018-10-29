import random
import time
import json
import uuid
import datetime
import subprocess

while True:
    my_dict = {}
    my_dict["carId"] = "000001"
    timestamp = datetime.datetime.fromtimestamp(int(time.time())).isoformat()
    my_dict["emitTimestamp"] = timestamp
    my_dict["timestamp"] = timestamp
    speed = round(random.uniform(0, 200), 2)
    my_dict["speed"] = speed
    steeringAngle = round(random.uniform(0, 360), 2)
    my_dict["steeringAngle"] = steeringAngle
    throttlePosition = round(random.uniform(0, 360), 2)
    my_dict["throttlePosition"] = throttlePosition
    lat = str(round(random.uniform(35, 50), 2))
    lon = str(round(random.uniform(-120, -80), 2))
    my_dict["location"] = {}
    my_dict["location"]["lat"] = lat
    my_dict["location"]["lon"] = lon
    input = json.dumps(my_dict)
    input = "'%s'" % input
    print "Sending " + input + " to pravega"
    list = []
    bash_command = "./bin/cli --service PRAVEGA --operation WRITE --scope psearch --stream TestStream --data " + input
    #list.append(bash_command)
    #list.append(input)
    #bash_command = ''.join(list)
    print bash_command
    #with open('/tmp/car_info', 'a') as f:
    #    json.dump(my_dict, f)
    #    f.write("\n")
    subprocess.call(bash_command, shell=True)
    time.sleep(random.random() )
