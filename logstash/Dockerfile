FROM logstash:2
COPY pipeline/logstash.conf /logstash/config/
CMD ["-f", "/logstash/config/logstash.conf", "--allow-env"]