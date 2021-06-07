FROM ubuntu

RUN apt-get update && apt-get install -y jq curl

ADD coronatest-checker.sh /
RUN chmod +x /coronatest-checker.sh

CMD ./coronatest-checker.sh
