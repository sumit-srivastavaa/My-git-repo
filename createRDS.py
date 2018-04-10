import boto3  
import botocore  
import datetime  
import re  
import logging
def byDatestamp(snap):  
  if 'SnapshotCreateTime' in snap:
    return datetime.datetime.isoformat(snap['SnapshotCreateTime'])
  else:
    return datetime.datetime.isoformat(datetime.datetime.now())
def lambda_handler(event, context):
    # TODO implement
    db = boto3.client('rds', 'ap-south-1')
    db_snaps = db.describe_db_snapshots(DBInstanceIdentifier = 'apexdev')['DBSnapshots']
    print "DB_Snapshots:", db_snaps
    db_snap = sorted(db_snaps, key=byDatestamp, reverse=True)[0]['DBSnapshotIdentifier']
    print "Latest DB snapshot is:", db_snap
    response = db.restore_db_instance_from_db_snapshot(DBInstanceIdentifier='apexdev',DBSnapshotIdentifier=db_snap,DBInstanceClass='db.t2.medium',AvailabilityZone='ap-south-1a',DBSubnetGroupName='devdb',DBName='APEXDEV',MultiAZ=False,PubliclyAccessible=False)
    print(response)
