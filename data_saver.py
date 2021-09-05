from config import Config

from models import Vehicle
from storage import StorageInterface
from db import DBInterface
from datetime import datetime
import uuid

class DataSaver:
    def __init__(self):
        self.config = Config()
        self.storage = StorageInterface(self.config)
        self.db = DBInterface(self.config)

    def save_vehicle(self, color: str, type: str, img, feature_vector):
        """
        Save vehicle to storage and database

        Args:
            color (str): [Color of vehicle]
            type (str): [Type of vehicle]
            img (numpy array): [Image of vehicle]
            feature_vector (numpy array): [Feature vector of vehicle image]
        """

        # now = datetime.now()
        # date = now.strftime("%Y-%m-%d")
        # time = now.strftime("%H:%M:%S")

        # Assuming signal is at Lal Baugcha Raja 
        lat = 18.990909
        lon = 72.828125

        # vehicle_id = str(uuid.uuid4()).replace("-","_")

        # image_url = self.storage.save_image(vehicle_id, img)
        # feature_vector_path = self.storage.save_feature_vector(vehicle_id, feature_vector)

        # vehicle = Vehicle(
        #     vehicle_id=vehicle_id,
        #     date=date,
        #     time=time,
        #     latitude=lat,
        #     longitude=lon,
        #     color=color,
        #     type=type,
        #     image_url=image_url,
        #     feature_vector_path=feature_vector_path
        # )

        # self.db.save_vehicle(vehicle)

        
