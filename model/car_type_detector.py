# Import necessary libraries
from yolo import YOLO
from model.car_classifier import CarClassifier

class Car:
    def __init__(self,position=None,carType=None):
        self.position = position
        self.carType = carType
        
    def get_position(self):
        return self.position
    
    def get_carType(self):
        return self.carType
        
    def __str__(self):
        print("Position : ",self.position," CarType : ",self.carType,"\n")

class CarTypeDetector:
    def __init__(self):
        self.yolo = YOLO()
        self.carClassifier = CarClassifier()
        self.detectedCars = dict()
        self.fv_array = list()

    def detection(self,queue):
        # Object Detection is done using YOLO or TinyYOLO with is trained on COCO Dataset which has 80 classes 
        # can find list of classes from the file model_data/coco_classes
        for frame_no,frame in enumerate(queue):
            image,position_list = self.yolo.detect_image(frame) # detect the objects using already trained YOLO 
            q,i = list(),0 
            for position in position_list:
                if position["class"] == "car": # Only useful classes for our case is Car
                    prediction = self.carClassifier.classify_car(image,position,frame_no,i) # use car classifier which contained our ML Model 
                    feature_array = self.carClassifier.extract_features(image,position,frame_no,i)
                    i=i+1
                    position = (position["left"] + 10,position["top"] + 10)
                    car = Car(position,prediction)
                    q.append(car)
                    self.fv_array.append(feature_array)
            self.detectedCars[frame_no] = (q,image)
            
        return self.detectedCars, self.fv_array
