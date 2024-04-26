from flask import Flask, jsonify, request, render_template, redirect, url_for, make_response, send_from_directory
from flask_cors import CORS
from demojcompute import compute

VIDEOS_FOLDER = "../../videos"
HTTP_SERVER_PORT = 5000
CURRENT_MODULE = "server"

app = Flask(__name__, template_folder="dist", static_folder="dist/static", static_url_path="/static")
CORS(app)

#################################################################
# API
#################################################################

@app.route("/api")
def api():
    return make_response(jsonify({"message": "Server API is running"}), 200)

#################################################################
# Scenarios app
#################################################################

@app.route('/videos/<path:filename>')
def serve_video(filename):
    return send_from_directory(app.static_folder + "/videos", filename)

@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def index(path):
    return render_template("index.html")
    
#################################################################
# Scenarios endoints
#################################################################

@app.route("/api/scenarios/calculator/<string:value>")
def calculator(value):
    return make_response(jsonify({"result": compute(value)}), 200)

#################################################################
# Main
#################################################################

def server_routine():
    print("Starting server...")
    app.run(debug=True, host="0.0.0.0", port=HTTP_SERVER_PORT)