#!/usr/bin/env bash
head -n -1 /output/log.csv > /temp.csv
cat  /output/log.csv  | awk 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while((gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' | head -n -1 >> /temp.csv
cat  /temp.csv  | awk -F',' 'NF == 17' > /temp2.csv
/apache-jmeter-5.0/bin/jmeter -g /temp2.csv -o /output/dashboard
rm /temp.csv /temp2.csv