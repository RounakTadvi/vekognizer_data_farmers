import numpy as np
import pickle
from io import BytesIO
import boto3
import json

s3 = boto3.resource("s3")

def lambda_handler(event, context):
    # TODO implement
    print(event)
    event = json.loads(event["body"])
    
    selected = event["selected_vehicle"]
    queried = event["queried_vehicles"]
    selected_fv = get_feature_vector(selected["feature_vector_path"])

    threshold = 0.7
    similar_vehicles = []

    for vehicle in queried:
        vehicle_fv = get_feature_vector(vehicle["feature_vector_path"])
        similarity = get_cosine_similarity(vehicle_fv, selected_fv)
        if similarity > threshold:
            similar_vehicles.append({"id": vehicle["id"], "similarity": similarity})

    similar_vehicles = list(
        sorted(similar_vehicles, key=lambda v: v["similarity"], reverse=True)
    )
    
    result = {"vehicle_result_instances_ids": [selected["id"]] + [v["id"] for v in similar_vehicles]}
    
    return {
        'statusCode': 200,
         'headers': {
            "Access-Control-Allow-Origin": "*", 
            "Access-Control-Allow-Credentials": True, 
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
        'isBase64Encoded': False,
        'body': json.dumps(result)
    }

def get_feature_vector(path):
    """ Function to get feature vector from S3 Bucket. """
    bucket_name, key_name = split_s3_bucket_key(path)
    print(bucket_name)
    print(key_name)
    with BytesIO() as data:
        s3.Bucket(bucket_name).download_fileobj(key_name, data)
        data.seek(0)    # move back to the beginning after writing
        return pickle.load(data)


def get_cosine_similarity(v1, v2):
    """ Get cosine similarity between two vectors. """
    return np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2))


def find_bucket_key(s3_path):
    """
    This is a helper function that given an s3 path such that the path is of
    the form: bucket/key
    It will return the bucket and the key represented by the s3 path
    """
    s3_components = s3_path.split("/")
    bucket = s3_components[0]
    s3_key = ""
    if len(s3_components) > 1:
        s3_key = "/".join(s3_components[1:])
    return bucket, s3_key


def split_s3_bucket_key(s3_path):
    """Split s3 path into bucket and key prefix.
    This will also handle the s3:// prefix.
    :return: Tuple of ('bucketname', 'keyname')
    """
    if s3_path.startswith("s3://"):
        s3_path = s3_path[5:]
    return find_bucket_key(s3_path)



