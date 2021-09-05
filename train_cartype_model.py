# Import necessary libraries
import keras
import numpy as np
from keras.applications import MobileNetV2
from keras.layers import Dense, Flatten,Dropout
from keras.models import Sequential, Model
from keras.preprocessing.image import ImageDataGenerator
import numpy as np

base_model = MobileNetV2(weights='imagenet',include_top=False,input_shape=(180, 180, 3))  # imports the mobilenet model and discards the last 1000 neuron layer.
# Freeze the base model
base_model.trainable = False
model = Sequential([
        base_model,
        Dense(512, activation='relu'), 
        Dropout(0.2),
        Dense(512, activation='relu'),
        Dropout(0.2),
        Dense(256, activation='relu'),
        Flatten(),
        Dense(1, activation='sigmoid')
])

train_datagen = ImageDataGenerator(preprocessing_function=keras.applications.mobilenet.preprocess_input,validation_split=0.2)

train_data_dir = 'path/to/data/dir'

train_generator = train_datagen.flow_from_directory(
        train_data_dir,
        target_size=(180,180),
        batch_size=64,
        class_mode='binary',
        subset='training',
        shuffle=True)

validation_generator = train_datagen.flow_from_directory(
        train_data_dir,
        target_size=(180, 180),
        batch_size=64,
        class_mode='binary',
        subset='validation',
        shuffle=True) 
print(model.summary())

algo = "Adam"
model.compile(optimizer = keras.optimizers.Adam(lr=0.0001), loss='binary_crossentropy', metrics=['accuracy'])
step_size_train=train_generator.n//train_generator.batch_size
step_size_val=validation_generator.n//validation_generator.batch_size
ep = 20

history = model.fit_generator(generator=train_generator,
                   steps_per_epoch=step_size_train,
                   validation_data=validation_generator,
                   validation_steps=step_size_val,
                   epochs=ep) 

# Saving the model 
model.save("path/to/file")

# Saving the Feature Extractor
fe_model = Model(model.input, model.layers[-8].output)
fe_model.save("path/to/file")