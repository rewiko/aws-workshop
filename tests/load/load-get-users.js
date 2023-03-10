import http from "k6/http";
import exec from "k6/execution";
import { check, sleep } from "k6";
import { Rate } from "k6/metrics";

const failureRate = new Rate("check_failure_rate");

const BASE_URL = __ENV.BASE_URL || "http://localhost:8080";
const RAMP_TIME = __ENV.RAMP_TIME || "10s";
const RUN_TIME = __ENV.RUN_TIME || "30s";
const USER_COUNT = __ENV.USER_COUNT || 30;
const SLEEP = __ENV.SLEEP || 1;

export const options = {
  insecureSkipTLSVerify: true,
  // userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 Safari/537.36',
  userAgent: "MyK6UserAgentString/1.0",
  stages: [
    { target: USER_COUNT, duration: RAMP_TIME }, // ramp-up
    { target: USER_COUNT, duration: RUN_TIME }, // steady
    { target: 0, duration: RAMP_TIME }, // ramp-down
  ],
  summaryTrendStats: [
    "min",
    "avg",
    "med",
    "p(95)",
    "p(99)",
    "p(99.9)",
    "p(99.99)",
    "max",
    "count",
  ],
};

// url
const url = `${BASE_URL}/intensive-cpu`;

export default function (data) {
  const responses = http.batch([
    {
      method: "GET",
      url: url,
      params: { timeout: "5s", tags: { name: "get-users" } },
    },
  ]);

  for (const response of responses) {
    // console.log(`status: ${response.status}`)
    // console.log(`response: ${response.body}`)
    let checkRes = check(response, {
      "status is 200": (r) => r.status === 200,
      "payload contains word provided_by": (r) =>
        r.body.includes("provided_by"),
    });
    failureRate.add(!checkRes);
    if (response.status >= 400) {
      console.log(`error on current vues: ${exec.instance.vusActive}`);
    }
  }

  sleep(SLEEP);
}
