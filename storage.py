"""
    Interacts with the File Storage
"""

from config import Config
import cv2
import urllib
import uuid
import pickle

import boto3

class StorageInterface:
    """
        Interacts with S3
    """

    def __init__(self, config: Config):
        self.config = config
        self.client = boto3.client("s3", region_name=config.AWS_REGION)

    def upload_vehicle_image(self, img, date: str, vehicle_id: str) -> str:
        """
            Uploads an image to S3
        Args:
            img (numpy array): the image to upload
            date (str): The date of the image (yyyy-mm-dd)
            vehicle_id (str): The vehicle id
        Returns:
            The URL of the image
        """
        path = f"images/{date.replace('-', '/')}/{vehicle_id}.jpg"
        image_string = cv2.imencode('.jpg', img)[1].tostring()
        self.client.put_object(Bucket="datafarmers", Key = path, Body=image_string)
        url = f'''https://datafarmers.s3.amazonaws.com/{urllib.parse.quote(path, safe="~()*!.'")}'''
        return url

    def upload_feature_vector(self, feature_vector, date: str, vehicle_id: str) -> str:
        """
            Uploads a feature vector to S3 as a pickle file
        Args:
            feature_vector (numpy array): the feature vector to upload
            date (str): The date of the image (yyyy-mm-dd)
            vehicle_id (str): The vehicle id
        Returns:
            The Path of feature vector (including bucket name)
        """
        path = f"feature_vectors/{date.replace('-', '/')}/{vehicle_id}.pickle"
        feature_string = pickle.dumps(feature_vector)
        self.client.put_object(Bucket="datafarmers", Key = path, Body=feature_string)
        return "datafarmers/" + path

if __name__ == "__main__":
    storage = StorageInterface(Config())

        