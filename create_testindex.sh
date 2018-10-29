set -x
#addr=`echo |  kubectl describe svc resthead-service | grep Endpoints | grep 9098 | awk '{print $2}'`
addr="localhost:9098/testindex"
curl -XPUT ${addr} -H 'Content-Type: application/json' -d'
{  
   "settings":{  
      "index":{  
         "number_of_shards":1
      }
   },
   "mappings":{  
      "default":{  
         "properties":{  
            "annotation":{  
               "type":"text",
               "fields":{  
                  "keyword":{  
                     "type":"keyword",
                     "ignore_above":256
                  }
               }
            },
            "stream":{  
               "type":"text",
               "fields":{  
                  "keyword":{  
                     "type":"keyword",
                     "ignore_above":256
                  }
               }
            },
            "speed":{  
               "type":"float"
            },
            "throttlePosition":{  
               "type":"float"
            },
            "steeringAngle":{  
               "type":"float"
            },
            "location":{  
               "type":"geo_point"
            },
            "carId":{  
               "type":"text",
               "fields":{  
                  "keyword":{  
                     "type":"keyword",
                     "ignore_above":256
                  }
               }
            },
            "emitTimestamp":{  
               "type":"date",
               "index":false
            },
            "payload":{  
               "type":"text",
               "index":false,
               "fields":{  
                  "keyword":{  
                     "type":"keyword",
                     "ignore_above":256
                  }
               }
            },
            "timestamp":{  
               "type":"date"
            }
         }
      }
   }
}'