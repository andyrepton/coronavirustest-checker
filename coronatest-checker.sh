#!/bin/sh

# As this is a super simple thing we're going to use the filesystem as a data store right now

mkdir -p /tmp/years-checked

for YEAR in $(seq 65 99); do
  if [ -f /tmp/years-checked/$YEAR ]; then
    echo "Already checked the year $YEAR"
  else
    # Sometimes we get hit by a rate limit. The sed is required because the rate limit message is invalid json (single instead of double quotes)
    if curl -s "https://user-api.coronatest.nl/vaccinatie/programma/booster/1965/NEE" | sed 's/'\''/"/g' | jq -e 'select(.msg != null)'; then
      # Rate limit exceeded. Sleep 30 seconds before continuing
      sleep 30
    fi
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
  # Let's sleep for 3 seconds anyway just to give the poor API some love
  sleep 3
done
