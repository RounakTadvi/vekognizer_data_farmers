from dataclasses import dataclass
from const import Const

@dataclass
class Vehicle:
    vehicle_id: str

    date: str # yyyy-mm-dd
    time: str # hh:mm:ss

    longitude: float
    latitude: float

    color: str
    type: str

    image_url: str = ""
    feature_vector_path: str = ""

    def to_json(self, include_type=False):

        json =  {
            Const.COL_VEHICLE_ID: self.vehicle_id,
            Const.COL_DATE: self.date,
            Const.COL_TIME: self.time,
            Const.COL_LATITUDE: self.longitude,
            Const.COL_LONGITUDE: self.latitude,
            Const.COL_COLOR: self.color,
            Const.COL_IMAGE_URL: self.image_url,
            Const.COL_FEATURE_VECTOR_PATH: self.feature_vector_path
        }

        if include_type:
            json[Const.COL_TYPE] = self.type

        return json






