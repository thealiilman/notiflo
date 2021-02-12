# notiflo
This is used at [Suria Labs](https://surialabs.com) for Lunch & Learn reminders. I didn't find Google Calendar and Trello effective, so I created this project.
A Lunch & Learn reminder consist of the date of the next Lunch & Learn event and a list of speakers. Every Monday at 12pm, the Lambda function is triggered via CloudWatch, sending a notification to our team channel on Slack via Slack's Incoming Webhooks.

## Tech Stack
- Ruby
- RSpec
- AWS Lambda
- AWS CloudWatch
