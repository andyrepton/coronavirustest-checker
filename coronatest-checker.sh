#!/bin/sh

# As this is a super simple thing we're going to use the filesystem as a data store right now

mkdir -p /tmp/years-checked

for YEAR in $(seq 65 70); do
  if [ -f /tmp/years-checked/$YEAR ]; then
    echo "Already checked the year $YEAR"
  else
    # Sometimes we get hit by a rate limit
    if curl -s "https://user-api.coronatest.nl/vaccinatie/programma/booster/19${YEAR}/NEE" | jq -e 'select(.success==true)'; then
      MESSAGE="19${YEAR} is now available for vaccination"
      if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST -H 'Content-type: application/json' --data "{\"text\": \"${MESSAGE}\" }" ${SLACK_WEBHOOK}
      else
        echo "${MESSAGE}"
      fi
      touch /tmp/years-checked/${YEAR}
    fi
  fi
done
