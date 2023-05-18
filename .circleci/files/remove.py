import boto3

# Create an S3 client
s3 = boto3.client('s3')

# List all buckets
response = s3.list_buckets()

# Iterate through the buckets and delete them
for bucket in response['Buckets']:
    bucket_name = bucket['Name']

    # Delete all objects within the bucket
    objects = s3.list_objects_v2(Bucket=bucket_name)['Contents']
    for obj in objects:
        s3.delete_object(Bucket=bucket_name, Key=obj['Key'])
        print(f"Deleted object: s3://{bucket_name}/{obj['Key']}")

    # Delete the bucket itself
    s3.delete_bucket(Bucket=bucket_name)
    print(f"Deleted bucket: {bucket_name}")
