Make sure gcloud sdk, kubernetes, and helm are installed on your environment
1. Open a shell, and copy the command-line access from google, generate kubeconfig entry for the cluster
2. Run create_cluster_gke.sh, when it prompts for email address, input your email address. 
The script will create operators(zookeeper, pravega, psearch operator), clusters(zookeeper cluster, pravega cluster, psearch cluster), verify service and create kibana index.
You can customize you yaml files in example folder.
3. After a while, you can see the kibana service and resthead service are exposed, you can access the url directly.
4. To test the cluster, call run_test.sh, which will create a testindex and a test stream,  and feed the stream with generated data.


Launch a Longevity test
1. Run "./start_longevity.sh" to start a longevity test
2. Run "./export_longevity.sh" to export a report
