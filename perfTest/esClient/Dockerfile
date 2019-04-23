FROM java:8
COPY rallyClient-0.0.1-SNAPSHOT.jar /
COPY testStart.sh /
RUN mkdir /home/data
COPY data/esSoIndex.json /home/data/
COPY data/psSoIndex.json /home/data/
COPY data/esTaxisIndex.json /home/data/
COPY data/psTaxisIndex.json /home/data/