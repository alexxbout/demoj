from flask import Flask, jsonify, request, render_template, redirect, url_for, make_response
from flask_cors import CORS
from demojcompute import compute

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
    return make_response(jsonify({"message": "Server API is running"}), 200)

#################################################################
# Scenarios app
#################################################################

@app.errorhandler(404)
def not_found():
    if request.path.startswith("/app"):
        return redirect(url_for("index"))
    return jsonify({"error": "Not found"}), 404

@app.route("/")
@app.route("/app")
def index():
    return render_template("index.html")
    
#################################################################
# Scenarios endoints
#################################################################
    
# TODO: Calculator (standard, fibonacci, factorial, prime)
@app.route("/api/scenarios/calculator/<string:mode>/<string:value>")
def calculator(mode, value):
    if mode == "standard":
        pass
    elif mode == "fibonacci":
        value = "fib(" + value + ")"
    elif mode == "factorial":
        value = "fact(" + value + ")"
    elif mode == "prime":
        value = "prime(" + value + ")"
    else:
        return make_response(jsonify({"error": "Invalid mode"}), 400)
    
    # Call function
    result = compute(value)

    return make_response(jsonify({"result": result}), 200)

# TODO: Streaming video
    
# TODO: Image processing

#################################################################
# Main
#################################################################

def server_routine():
    print("Starting server...")
    app.run(debug=True, host="0.0.0.0", port=HTTP_SERVER_PORT)