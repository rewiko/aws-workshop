# Load test

### Usage

```bash
# import data into database
curl http://workshop-app-lb-1024672469.eu-west-1.elb.amazonaws.com/import-data | jq .

export BASE_URL="http://workshop-app-lb-1024672469.eu-west-1.elb.amazonaws.com"
docker run -t -v $(pwd):/scripts -e BASE_URL=${BASE_URL} -e RAMP_TIME="1s" -e RUN_TIME="2s" -e USER_COUNT=50 --net=host grafana/k6:0.34.0 run /scripts/load-get-users.js
```
