"""
    Simulates reading on video stream
    and saves the vehicles
"""

from scipy.spatial import distance as dist
from collections import OrderedDict    
import numpy as np
from scipy.stats import itemfreq
import cv2
import warnings
from model.car_type_detector import CarTypeDetector
warnings.filterwarnings("ignore")

from data_saver import DataSaver

class VideoReader:
    """
        Simulates reading on video stream
    """
    

    def __init__(self, path):
        self.path = path
        self.data_saver = DataSaver()
        self.background=cv2.createBackgroundSubtractorMOG2()
        self.carTypeDetector = CarTypeDetector()

        colors = OrderedDict({"red": (255, 0, 0),"green": (0, 255, 0),"blue": (0,0, 255),"white":(255,255,255),"black":(100,100,100)})
        lab = np.zeros((len(colors), 1, 3), dtype="uint8")
        self.colorNames = []

        incre=1
        for (i, (name, rgb)) in enumerate(colors.items()):
                    # update the L*a*b* array and the color names list
                    lab[i] = rgb
                    self.colorNames.append(name)
        self.lab = cv2.cvtColor(lab, cv2.COLOR_RGB2LAB)


    def read(self):
        """
            Reads a video stream and saves vehicles info
        """
        cap=cv2.VideoCapture(self.path)
        count_frame=0
        while(cap.isOpened()):
#while(True):
            _,frame=cap.read()
            #resizing the frame 
            try:
                frame=cv2.resize(frame,(640,480))
            except Exception as ex:
                print(ex)
                break
            #creating a copy of the frame
            frame_copy=frame
            frame_copy_copy=copy =frame[:,:]
            
            #applying background elemination
            bg=self.background.apply(frame)
            
            #additional image processing
            
            kernel=cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (2, 2))
            bg= cv2.erode(bg,kernel,iterations = 1)
            
            # Fill any small holes
            closing=cv2.morphologyEx(bg,cv2.MORPH_CLOSE,kernel)
            cv2.imshow("closing",closing)
            
            # Remove noise
            opening=cv2.morphologyEx(closing, cv2.MORPH_OPEN, kernel)
            cv2.imshow("removing_noise",opening)
            
            # Dilate to merge adjacent blobs
            dilation=cv2.dilate(opening, kernel, iterations=2)

            # threshold to remove furthur noise 
            dilation[dilation < 240] = 0
            bg=dilation
            
            #initialising output color list
            output_color=[]
            
            #detecting contour and calculating the co-ordinates of the contours
            contour_list=self.detect_vehicles(bg)
            
            #traversing through each detected contour 
            for ele in contour_list:
                x1=ele[0][0]
                y1=ele[0][1]
                x2=x1+ele[0][2]
                y2=y1+ele[0][3]
                #extracting the regions that contains car features
                
                slice_bg=frame_copy[y1:y2,x1:x2]
                
                #normalising the image so that there is uniform color throughout
                slice_bg=self.normalized(slice_bg)
                
                arr=np.float32(slice_bg)
                #reshaping the image to a linear form with 3-channels
                pixels=arr.reshape((-1,3))
                
                #number of clusters
                n_colors=2
                
                #number of iterations
                criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 200, .1)
                
                #initialising centroid
                flags = cv2.KMEANS_RANDOM_CENTERS
                
                #applying k-means to detect prominant color in the image
                _, labels, centroids = cv2.kmeans(pixels, n_colors, None, criteria, 10, flags)
                
                
                palette = np.uint8(centroids)
                quantized = palette[labels.flatten()]
                
                #detecting the centroid with densest cluster  
                dominant_color = palette[np.argmax(itemfreq(labels)[:, -1])]
                


                r=int(dominant_color[0])
                g=int(dominant_color[1])
                b=int(dominant_color[2])

                
                rgb=np.zeros((1,1,3),dtype='uint8')
                rgb[0]=(r,g,b)
                
                
                
                #getting the  label of the car color
                color=self.label(rgb,self.lab,self.colorNames)
                
                
                output_color.append(color)

                # Cropped Vehicle
                cropped_vehicle = frame_copy[y1:y2, x1:x2]

                detectedCars, feature_vector = self.carTypeDetector.detection([frame_copy])

                # Save vehicle
                self.data_saver.save_vehicle(color, detectedCars[0].carType, cropped_vehicle, feature_vector[0])
                

                if(cv2.waitKey(30)==27 & 0xff):
                    break

        cap.release()
        cv2.destroyAllWindows()


    #function to label car lab color to a perticular color class
    def label(self, image,lab,colorNames):

        # initialize the minimum distance found thus far
        minDist = (np.inf, None)
 
        # loop over the known L*a*b* color values
        for (i, row) in enumerate(lab):
            # compute the distance between the current L*a*b*
            # color value and the mean of the image
            
            d = dist.euclidean(row[0],image)
 
            # if the distance is smaller than the current distance,
            # then update the bookkeeping variable
            if d < minDist[0]:
                minDist = (d, i)
 
        # return the name of the color with the smallest distance
        return colorNames[minDist[1]]


    #function to normalize the image so that the entire blob has the same rgb value
    def normalized(self, down):
            s=down.shape
            x=s[1]
            y=s[0]
            norm=np.zeros((y,x,3),np.float32)
            norm_rgb=np.zeros((y,x,3),np.uint8)

            b=down[:,:,0]
            g=down[:,:,1]
            r=down[:,:,2]

            sum=b+g+r

            norm[:,:,0]=b/sum*255.0
            norm[:,:,1]=g/sum*255.0
            norm[:,:,2]=r/sum*255.0

            norm_rgb=cv2.convertScaleAbs(norm)
            return norm_rgb   

    #function to detect vehical/moving object 
    def detect_vehicles(self, fg_mask, min_contour_width=35, min_contour_height=35):

        matches = []
        frame_copy=fg_mask
        # finding external contours
        
        contours, hierarchy = cv2.findContours(fg_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_TC89_L1)

        
        for (i, contour) in enumerate(contours):
            (x, y, w, h) = cv2.boundingRect(contour)
            contour_valid = (w >= min_contour_width) and (
                h >= min_contour_height)

            if not contour_valid:
                continue
            
            # getting center of the bounding box
            centroid = self.get_centroid(x, y, w, h)

            matches.append(((x, y, w, h), centroid))

        return matches

    #Function to get the centroid of the Object.
    def get_centroid(self, x, y, w, h):
        x1 = int(w / 2)
        y1 = int(h / 2)

        cx = x + x1
        cy = y + y1

        return (cx, cy)

if __name__ == "__main__":
    data_reader = VideoReader("pos_a.mp4")
