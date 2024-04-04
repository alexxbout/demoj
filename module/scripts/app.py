from flask import Flask, jsonify
from flask_cors import CORS

APP_FOLDER = "../app"
SERVER_PORT = 5000

app = Flask(__name__, template_folder=APP_FOLDER, static_folder=APP_FOLDER, static_url_path="/app/")
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

if __name__ == "__main__":
    print("Starting server...")
    app.run(debug=True, host="0.0.0.0", port=5000)