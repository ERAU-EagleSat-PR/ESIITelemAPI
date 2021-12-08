import datetime
import json
import random
from random import randrange

import requests

class ConfigAPI:
    HOSTNAME = "https://317finalprojtelemapi.azurewebsites.net"
    EPS_ENPOINT = "/Eps"
    TELEM_ENDPOINT = "/Telemetry"


def get_timestamp(year: int, month: int, day: int, hour: int, minute: int, second: int) -> str:
    date = str(datetime.datetime(year=year, month=month, day=day, hour=hour, minute=minute, second=second, microsecond=123124).isoformat())[:-3]
    return date


def put_telemetry(pass_num: int, timestamp: str) -> int:
    headers = {"Content-Type": "application/json", "Accept": "application/json"}
    body = {
        "DownlinkTimestamp": timestamp,
        "PassNumber": pass_num
    }
    url = ConfigAPI.HOSTNAME + ConfigAPI.TELEM_ENDPOINT
    r = requests.put(url, headers=headers, json=body)

    if r.status_code == 200:
        response = json.loads(json.dumps(r.json()))
        id = response[0]["DownlinkId"]
        return id
    else:
        print("Put failed with response code " + str(r.status_code))
    return -1


def put_eps(downlinkID: int):
    headers = {"Content-Type": "application/json", "Accept": "application/json"}
    body = {
        "DownlinkId": downlinkID,
        "AvgBatVoltage": round(random.uniform(10.5, 12.6), 2),
        "Brownouts": randrange(0, 4),
        "ChargeTimeMin": round(random.uniform(15.5, 40), 2),
        "PeakChargePower": round(random.uniform(7.5, 8.2), 2),
    }
    url = ConfigAPI.HOSTNAME + ConfigAPI.EPS_ENPOINT
    r = requests.put(url, headers=headers, json=body)
    if r.status_code == 200:
        response = json.loads(json.dumps(r.json()))
        id = response[0]["DownlinkId"]
        return id
    else:
        print("Put failed with response code " + str(r.status_code))
    return -1


def main():
    pass_num = 0
    year = 2021
    month = 12
    day = 7
    hour = 19
    minute = 1
    second = 1

    for i in range(10000):
        timestamp = get_timestamp(year=year, month=month, day=day, hour=hour, minute=minute, second=second)
        id = put_telemetry(pass_num, timestamp)
        if id > 0:
            put_eps(id)
        print("Created downlink ID " + str(id))
        pass_num += 1
        minute += 92
        if minute > 59:
            minute %= 59
            hour += 1
        if hour > 23:
            hour %= 23
            day += 1
        if day > 30:
            day %= 30
            month += 1
        if month > 11:
            month %= 11
            year += 1


main()