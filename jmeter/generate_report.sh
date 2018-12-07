#!/usr/bin/env bash
#cat  /temp.jtl  | awk -F',' 'NF == 17' > /temp2.jtl
head -n 1 /output/result.jtl > /output/temp.jtl

cat /output/result.jtl | awk -F',' '$16~/^[0-9]+$/' | awk -F',' 'NF==16' | sed "s/\"//g" >> /output/temp.jtl
rm -rf /output/dashboard
echo "Generating dashboard..."
/apache-jmeter-5.0/bin/jmeter -g /output/temp.jtl -o /output/dashboard
rm /output/temp.jtl 