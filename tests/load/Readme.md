# Load test

### Usage

```bash

export BASE_URL="http://workshop-app-lb-372977466.eu-west-1.elb.amazonaws.com"

# import data into database
curl ${BASE_URL}/import-data | jq .

docker run -t -v $(pwd):/scripts -e BASE_URL=${BASE_URL} -e RAMP_TIME="1s" -e RUN_TIME="2s" -e USER_COUNT=50 --net=host grafana/k6:0.34.0 run /scripts/load-get-users.js
```
