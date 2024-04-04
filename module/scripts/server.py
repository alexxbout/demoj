from flask import Flask, jsonify
from flask_cors import CORS

APP_FOLDER = "../app"
APP_URL = "/app/"
HTTP_SERVER_PORT = 5000
CURRENT_MODULE = "server"

app = Flask(__name__, template_folder=APP_FOLDER, static_folder=APP_FOLDER, static_url_path=APP_URL)
CORS(app)

#################################################################
# API
#################################################################

@app.route("/api")
def api():
    return jsonify({"message": "Server API is running"})
    
#################################################################
# Scenarios
#################################################################
    
# TODO: Calculator (fibonacci, factorial, prime number)
    
# TODO: Streaming video
    
# TODO: Image processing

#################################################################
# Main
#################################################################

def server_routine():
    print("Starting server...")
    app.run(debug=True, host="0.0.0.0", port=HTTP_SERVER_PORT)