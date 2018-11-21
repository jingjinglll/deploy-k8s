#!/usr/bin/env bash
head -n -1 /output/log.csv > /temp.csv
/apache-jmeter-5.0/bin/jmeter -g /temp.csv -o /output/dashboard
rm /temp.csv