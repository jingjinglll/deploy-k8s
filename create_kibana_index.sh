set -x
#addr=`echo |  kubectl describe svc resthead-service | grep Endpoints | grep 9098 | awk '{print $2}'`
addr="localhost:9098/.kibana"
curl -XPUT ${addr} -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index.number_of_shards": 1,
    "index.mapper.dynamic": false,
    "index.mapping.single_type": false
  },
  "mappings": {
    "_default_": {
      "dynamic": "strict"
    },
    "config": {
      "dynamic": true,
      "properties": {
        "buildNum": {
          "type": "keyword"
        },
        "defaultIndex" : {
          "type": "text",
          "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
          }
        }
      }
    },
    "index-pattern": {
      "properties": {
        "fieldFormatMap": {
          "type": "text"
        },
        "fields": {
          "type": "text"
        },
        "intervalName": {
          "type": "keyword"
        },
        "notExpandable": {
          "type": "boolean"
        },
        "sourceFilters": {
          "type": "text"
        },
        "timeFieldName": {
          "type": "keyword"
        },
        "title": {
          "type": "text"
        }
      }
    },
    "visualization": {
      "properties": {
        "description": {
          "type": "text"
        },
        "kibanaSavedObjectMeta": {
          "properties": {
            "searchSourceJSON": {
              "type": "text"
            }
          }
        },
        "savedSearchId": {
          "type": "keyword"
        },
        "title": {
          "type": "text"
        },
        "uiStateJSON": {
          "type": "text"
        },
        "version": {
          "type": "integer"
        },
        "visState": {
          "type": "text"
        }
      }
    },
    "search": {
      "properties": {
        "columns": {
          "type": "keyword"
        },
        "description": {
          "type": "text"
        },
        "hits": {
          "type": "integer"
        },
        "kibanaSavedObjectMeta": {
          "properties": {
            "searchSourceJSON": {
              "type": "text"
            }
          }
        },
        "sort": {
          "type": "keyword"
        },
        "title": {
          "type": "text"
        },
        "version": {
          "type": "integer"
        }
      }
    },
    "dashboard": {
      "properties": {
        "description": {
          "type": "text"
        },
        "hits": {
          "type": "integer"
        },
        "kibanaSavedObjectMeta": {
          "properties": {
            "searchSourceJSON": {
              "type": "text"
            }
          }
        },
        "optionsJSON": {
          "type": "text"
        },
        "panelsJSON": {
          "type": "text"
        },
        "refreshInterval": {
          "properties": {
            "display": {
              "type": "keyword"
            },
            "pause": {
              "type": "boolean"
            },
            "section": {
              "type": "integer"
            },
            "value": {
              "type": "integer"
            }
          }
        },
        "timeFrom": {
          "type": "keyword"
        },
        "timeRestore": {
          "type": "boolean"
        },
        "timeTo": {
          "type": "keyword"
        },
        "title": {
          "type": "text"
        },
        "uiStateJSON": {
          "type": "text"
        },
        "version": {
          "type": "integer"
        }
      }
    },
    "url": {
      "properties": {
        "accessCount": {
          "type": "long"
        },
        "accessDate": {
          "type": "date"
        },
        "createDate": {
          "type": "date"
        },
        "url": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 2048
            }
          }
        }
      }
    },
    "server": {
      "properties": {
        "uuid": {
          "type": "keyword"
        }
      }
    },
    "timelion-sheet": {
      "properties": {
        "description": {
          "type": "text"
        },
        "hits": {
          "type": "integer"
        },
        "kibanaSavedObjectMeta": {
          "properties": {
            "searchSourceJSON": {
              "type": "text"
            }
          }
        },
        "timelion_chart_height": {
          "type": "integer"
        },
        "timelion_columns": {
          "type": "integer"
        },
        "timelion_interval": {
          "type": "keyword"
        },
        "timelion_other_interval": {
          "type": "keyword"
        },
        "timelion_rows": {
          "type": "integer"
        },
        "timelion_sheet": {
          "type": "text"
        },
        "title": {
          "type": "text"
        },
        "version": {
          "type": "integer"
        }
      }
    }
  }
}'

