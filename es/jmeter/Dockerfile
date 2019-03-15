FROM java:8
RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.0.tgz
RUN tar xzvf apache-jmeter-5.0.tgz
COPY TestPlan.jmx /
RUN echo "jmeter.save.saveservice.assertion_results_failure_message=false" >> /apache-jmeter-5.0/bin/jmeter.properties
RUN rm apache-jmeter-5.0.tgz
