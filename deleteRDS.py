import sys
import time
import boto3
import datetime

def lambda_handler(event, context):
    # TODO implement
        date = time.strftime("-%d-%m-%Y")
        print date
        global db_inst
        snapshot_name = 'apexdev'+date
        db = boto3.client('rds', 'ap-south-1' )
        db.delete_db_instance(DBInstanceIdentifier='apexdev', SkipFinalSnapshot=False, FinalDBSnapshotIdentifier=snapshot_name)
   
   
