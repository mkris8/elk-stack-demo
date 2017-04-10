
elk
----
1) Install elasticsearch
download elastic search tar from elastic.co
copy the tar to home
install using tar tar -xvzf <.tar>
navigate into the bin folder
./elasticsearch will start the elasticsearch node

open a new terminal
curl -XGET http://localhost:9200 should give the rest response
krishnm:~ manojkrishnamurthy$ curl -XGET http://localhost:9200
{
  "name" : "sB9eP1d",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "j7NHLDsVTDWxgBUeS2zr3A",
  "version" : {
    "number" : "5.3.0",
    "build_hash" : "3adb13b",
    "build_date" : "2017-03-23T03:31:50.652Z",
    "build_snapshot" : false,
    "lucene_version" : "6.4.1"
  },
  "tagline" : "You Know, for Search"
}

2) install logstash

download logstash tar from elastic.co
same process as above

create the logstash config file

logstash agent -f /Users/mkrishnamurthy/logstash/logstash.conf

input { stdin { } }
output {
  elasticsearch { hosts => ["localhost:9200"] }
  stdout { codec => rubydebug }
}

To run:
./bin/logstash -f logstash.conf

3) Install Kibana

download tar
unzip
edit the kibana.yml in the config folder

to start

./bin/kibana

server runs at http://localhost:5601/

The messages from the logstash will be output into the kibana 

To read the log (refer apach_logs)

83.149.9.216 - - [17/May/2015:10:05:03 +0000] "GET /presentations/logstash-monitorama-2013/images/kibana-search.png HTTP/1.1" 200 203023 "http://semicomplete.com/presentations/logstash-monitorama-2013/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
83.149.9.216 - - [17/May/2015:10:05:43 +0000] "GET /presentations/logstash-monitorama-2013/images/kibana-dashboard3.png HTTP/1.1" 200 171717 "http://semicomplete.com/presentations/logstash-monitorama-2013/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
83.149.9.216 - - [17/May/2015:10:05:47 +0000] "GET /presentations/logstash-monitorama-2013/plugin/highlight/highlight.js HTTP/1.1" 200 26185 "http://semicomplete.com/presentations/logstash-monitorama-2013/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
83.149.9.216 - - [17/May/2015:10:05:12 +0000] "GET /presentations/logstash-monitorama-2013/plugin/zoom-js/zoom.js HTTP/1.1" 200 7697 "http://semicomplete.com/presentations/logstash-monitorama-2013/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"

start with one line on the log
keep adding lines one by one
the output will get appended on the console.


----- logstash config file -------- (refer : apache_logstash.conf)


input {
file {
 path => "/Users/manojkrishnamurthy/apache_logs"
 type => "apache_error_log"
start_position => beginning
}
}

filter {

grok {
        match => {
        "message" => '%{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{HTTPDATE:timestamp}\] "%{WORD:verb} %{DATA:request} HTTP/%{NUMBER:httpversion}" %{NUMBER:response:int} (?:-|%{NUMBER:bytes:int}) %{QS:referrer} %{QS:agent}'
        }
     }

date {
    match => [ "timestamp", "dd/MMM/YYYY:HH:mm:ss Z" ]
    locale => en
}

}

output {
  elasticsearch { hosts => ["http://127.0.0.1:9200"] }
  stdout { codec => rubydebug }
}
------------------------------------------------
Java client to create logs

1) Add maven dependency

		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-api</artifactId>
			<version>1.6.6</version>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
			<version>1.7.21</version>
		</dependency>

		<dependency>
			<groupId>log4j</groupId>
			<artifactId>log4j</artifactId>
			<version>1.2.16</version>
		</dependency>


3) Create log4j.properties under resources and configure to write to a log file.

4) Add log statements in the Java class

5) configure  logstash config file to read from the new log file (java_logstash.conf)

6) execute the java client

7) logstash console will update and so will the kibana board.

7) To delete all the entries from kibana

in the kibana console

DELETE /_all

-----------------------------------------------------------------------------

To import data sets directly and visualise in kibana.

https://www.elastic.co/guide/en/elasticsearch/reference/current/_exploring_your_data.html
https://www.elastic.co/guide/en/kibana/3.0/import-some-data.html

use the sample json files eg : accounts.json
Extract it to our current directory and let’s load it into cluster as follows:
curl -H "Content-Type: application/json" -XPOST 'localhost:9200/bank/account/_bulk?pretty&refresh' --data-binary "@accounts.json"

The below
curl 'localhost:9200/_cat/indices?v'

should give response:
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   bank  l7sSYV2cQXmu6_4rJWVIww   5   1       1000            0    128.6kb        128.6kb

means that we just successfully bulk indexed 1000 documents into the bank index

Now, in kibana, Dev tools > console

run
GET bank/_search
{
  "query": { "match_all": {} }
}

should output all the bank json output.

Now , to visualise in kibana, 

Management > Index pattern > Add New >

create a new index pattern by inputting "bank" into the text field.

Make it default by clicking on the star.

refresh the kibana dash board to see the bank index.

------------

load shakepeare.json
curl -XPUT localhost:9200/_bulk --data-binary @shakespeare.json
same steps as above.












