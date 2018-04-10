#root/.local/lib/python2.7/site-packages


#AMIID: ami-97785bed

#instanceid: i-0bc5fa76433103b4b



#!/usr/bin/env python
import boto3
ec2 = boto3.resource('ec2')
instance = ec2.create_instances(
    ImageId='ami-97785bed',
    MinCount=1,
    MaxCount=1,
    InstanceType='t2.micro')
print instance[0].id

