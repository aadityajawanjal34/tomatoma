import numpy as np
import tensorflow as tf
from PIL import Image
from io import BytesIO
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the TFLite model
tflite_model_path = 'tflite_model.tflite'
interpreter = tf.lite.Interpreter(model_path=tflite_model_path)
interpreter.allocate_tensors()

# Get input and output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Get the class names
class_names = ['Tomato___Bacterial_spot', 'Tomato___Early_blight', 'Tomato___Late_blight',
               'Tomato___Leaf_Mold', 'Tomato___Septoria_leaf_spot', 'Tomato___Spider_mites Two-spotted_spider_mite',
               'Tomato___Target_Spot', 'Tomato___Tomato_Yellow_Leaf_Curl_Virus', 'Tomato___Tomato_mosaic_virus',
               'Tomato___healthy']

@app.route('/api/v1/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'})

    file = request.files['image']
    img = Image.open(file)
    img = img.resize((input_details[0]['shape'][1], input_details[0]['shape'][2]))
    img = np.array(img, dtype=np.float32) / 255.0
    img = np.expand_dims(img, axis=0)

    # Perform inference
    interpreter.set_tensor(input_details[0]['index'], img)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])
    class_index = np.argmax(output_data, axis=1)[0]
    predicted_class = class_names[class_index]
    confidence_score = np.max(output_data)  # Calculate confidence score
    # Round the confidence score to four decimal places
    confidence_score_rounded = round(confidence_score, 4)


    return jsonify({'class': predicted_class, 'confidence': float(confidence_score_rounded)})

if __name__ == '__main__':
    app.run(debug=True)
