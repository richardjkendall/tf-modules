#!/usr/bin/python3

from argparse import ArgumentParser
from os import environ
import json
import subprocess

def main():
    parser = ArgumentParser(add_help=False)
    parser.add_argument("--list", action="store_true", required=True)
    args = parser.parse_args()
    if args.list:
        public_ip = environ.get('PUBLIC_IP') or resource_attribute(tfstate(), "aws_instance", "ec2", "public_ip")
        print(json.dumps(inventory(public_ip), indent=2))

def inventory(ip):
    return {
        "_meta" : {
            "hostvars" : {
                "ec2": {
                    "ansible_host": ip
                }
            }
        },
        "all" : {
            "hosts" : [
                 "ec2"
            ],
            "children": []
        }
   }

def tfstate():
    return json.loads(subprocess.check_output(["terraform", "state", "pull"]).decode())

def resource_attribute(tfstate, type, name, attr):
    resource = [x for x in tfstate["resources"] if x["type"] == type and x["name"] == name][0]
    return resource["instances"][0]["attributes"][attr]

if __name__ == '__main__':
    main()