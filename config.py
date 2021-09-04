import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """
    Config class for the application.
    """
    # get Astra connection information from environment variables
    ASTRA_DB_ID = os.environ.get('ASTRA_DB_ID')
    ASTRA_DB_REGION = os.environ.get('ASTRA_DB_REGION')
    ASTRA_DB_APPLICATION_TOKEN = os.environ.get('ASTRA_DB_APPLICATION_TOKEN')
    ASTRA_DB_KEYSPACE = os.environ.get('ASTRA_DB_KEYSPACE')
    ASTRA_DB_COLLECTION = "test"

    # get AWS connection information from environment variables
    AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')
    AWS_REGION = os.environ.get('AWS_REGION')

    
    