"""
    Interacts with the database
"""

from config import Config
from const import Const
from models import Vehicle

from astrapy.rest import create_client, http_methods, AstraClient


class DBInterface:
    """
        Interface to interact with astra db
    """
    

    def __init__(self, config: Config):
        self.config = config
        
        self.client: AstraClient = create_client(astra_database_id=config.ASTRA_DB_ID,
                         astra_database_region=config.ASTRA_DB_REGION,
                         astra_application_token=config.ASTRA_DB_APPLICATION_TOKEN)

        self.tables_path = f"/api/rest/v2/schemas/keyspaces/{config.ASTRA_DB_KEYSPACE}/tables"
        self.vehicles_by_color_type_path = f"/api/rest/v2/keyspaces/{config.ASTRA_DB_KEYSPACE}/vbct"
        self.vehicles_by_color_path = f"/api/rest/v2/keyspaces/{config.ASTRA_DB_KEYSPACE}/vbc"

    def __get_vehicles_by_color_type_schema(self) -> dict:
        """
            Get the schema for the vehicle_by_color_type table
        """
        return {
            "name": "vbct",
            "columnDefinitions": [
                {
                    "name": Const.COL_COLOR,
                    "typeDefinition": "text"
                },
                {
                    "name": Const.COL_TYPE,
                    "typeDefinition": "text"
                },
                {
                    "name": Const.COL_LATITUDE,
                    "typeDefinition": "decimal"
                },
                {
                    "name": Const.COL_LONGITUDE,
                    "typeDefinition": "decimal"
                },
                {
                    "name": Const.COL_DATE,
                    "typeDefinition": "date"
                },
                {
                    "name": Const.COL_TIME,
                    "typeDefinition": "time"
                },
                {
                    "name": Const.COL_IMAGE_URL,
                    "typeDefinition": "text"
                },
                {
                    "name": Const.COL_FEATURE_VECTOR_PATH,
                    "typeDefinition": "text"
                },
                {
                    "name": Const.COL_VEHICLE_ID, # for uniqueness
                    "typeDefinition": "text"
                }
            ],
            "primaryKey": {
                "partitionKey": [Const.COL_DATE, Const.COL_COLOR, Const.COL_TYPE],
                "clusteringKey": [Const.COL_TIME, Const.COL_VEHICLE_ID]
            }
            
        }

    def __get_vehicles_by_color_schema(self) -> dict:
        """
            Get the schema for the vehicle_by_color table
        """
        return {
            "name": "vbc",
            "columnDefinitions": [
                {
                    "name": Const.COL_COLOR,
                    "typeDefinition": "text"
                },
                {
                    "name": Const.COL_LATITUDE,
                    "typeDefinition": "decimal"
                },
                {
                    "name": Const.COL_LONGITUDE,
                    "typeDefinition": "decimal"
                },
                {
                    "name": Const.COL_DATE,
                    "typeDefinition": "date"
                },
                {
                    "name": Const.COL_TIME,
                    "typeDefinition": "time"
                },
                {
                    "name": Const.COL_IMAGE_URL,
                    "typeDefinition": "text"
                },
                {
                    "name": Const.COL_FEATURE_VECTOR_PATH,
                    "typeDefinition": "text"
                },
                {
                    "name": Const.COL_VEHICLE_ID, # for uniqueness
                    "typeDefinition": "text"
                }
            ],
            "primaryKey": {
                "partitionKey": [Const.COL_DATE, Const.COL_COLOR],
                "clusteringKey": [Const.COL_TIME, Const.COL_VEHICLE_ID]
            }
            
        }

    def create_tables(self):
        """
            Create the required tables
        """
        resp = self.client.request(
            http_methods.POST,
            path=self.tables_path,
            json_data=self.__get_vehicles_by_color_type_schema()
        )

        print(resp)

        resp = self.client.request(
            http_methods.POST,
            path=self.tables_path,
            json_data=self.__get_vehicles_by_color_schema()
        )

        print(resp)

    def add_vehicle(self, vehicle: Vehicle):
        """
            Add a vehicle to the database
        """
        resp = self.client.request(
            http_methods.POST,
            path=self.vehicles_by_color_path,
            json_data=vehicle.to_json()
        )

        print(resp)

        resp = self.client.request(
            http_methods.POST,
            path=self.vehicles_by_color_type_path,
            json_data=vehicle.to_json(include_type=True)
        )

        print(resp)



if __name__ == "__main__":
    db = DBInterface(Config())
    # Vehicle(vehicle_id='1', date='2021-09-03', time='17:20:00', longitude=18.53, latitude=19.52, color='Grey', type='SUV', image_url='url', feature_vector_path='fvp')
    

    