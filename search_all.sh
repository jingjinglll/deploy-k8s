set -x
#addr=`echo |  kubectl describe svc resthead-service | grep Endpoints | grep 9098 | awk '{print $2}'`
addr="localhost:9098"
curl -XGET $addr/_search -H 'Content-Type: application/json' -d' 
{
  "query": {
    "match_all" : {
      
    }
  }
}'
