#!/usr/bin/env bash
#cat  /temp.jtl  | awk -F',' 'NF == 17' > /temp2.jtl
nlines=`wc -l /output/result.jtl | awk '{print $1}'`
head -n 1 /output/result.jtl > /output/temp.jtl

cat /output/result.jtl | awk -v nl=${nlines} 'FPAT="([^,]+)|(\"[^\"]+\")"{x=$0;while((x~ /^[0-9]/)&&(NR!=nl)&&(gsub(/\"/,"\"",x)%2)!=0){getline;x=x " ";x=x $0};$0=x;print}' | awk -F',' '$17~/^[0-9]+$/' | awk -F',' 'NF==17' | sed "s/\"//g" >> /output/temp.jtl
/apache-jmeter-5.0/bin/jmeter -g /output/temp.jtl -o /output/dashboard
rm /output/temp.jtl 