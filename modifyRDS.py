import boto3  
import botocore  
import datetime  
import re  
import logging
import boto3
def lambda_handler(event, context):
    # TODO implement
    db = boto3.client('rds', 'ap-south-1')
    change=db.modify_db_instance(DBInstanceIdentifier='apexdev', VpcSecurityGroupIds=[
        'sg-4dd13a24'])
