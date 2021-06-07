# Coronavirus Test Checker

A simple bash script that will check if your birth year is available for a vaccination in the Netherlands. Run as a cron job every 5 minutes, optionally provide the SLACK_WEBHOOK variable to have the script post to a Slack channel.

By default it'll currently only check the next 5 years, so as to avoid a rate limit error from the API. You can manually change the year yourself in the script.

## Example usage

```
$ while true; do sleep 300; bash coronatest-checker.sh ;
done
Already checked the year 84
{
  "success": true
}
ok
```
