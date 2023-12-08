from flask import Flask, jsonify, request
from flask_cors import CORS
import json

app = Flask(__name__)
CORS(app)

config = "scripts/config.json"

# ! Route to receive data
@app.route('/receive_data', methods=['POST'])
def receive_data():
    data = request.get_json()
    print("Received data:", data)

    return jsonify({"message": "Data received successfully"})

# ! Route to get config data
@app.route('/config', methods=['GET'])
def get_config():
    try:
        with open(config, 'r') as config_file:
            config_data = json.load(config_file)
            return jsonify(config_data)
    except FileNotFoundError:
        return jsonify({"error": "Config file not found"}), 404
    except Exception as e:
        print(f"Error reading config file: {str(e)}")
        return jsonify({"error": str(e)}), 500

# ! Route to toggle module's parameters
@app.route('/modules/<module>/params/<id_param>', methods=['POST'])
def set_parameter_state(module, id_param):
    try:
        data = request.get_json()
        is_active = data.get('isActive', False)

        with open(config, 'r') as config_file:
            config_data = json.load(config_file)

        if 'modules' in config_data and module in config_data['modules']:
            print(f"Module {module} found")
            device = config_data['modules'][module]
            if 'parameters' in device:
                print(f"Parameters found for module {module}")
                for param in device['parameters']:
                    print(f"Checking parameter {param['id']}")
                    print(id_param)
                    if int(param['id']) == int(id_param):
                        print(f"Parameter {id_param} found")
                        print(f"Setting parameter {id_param} to {is_active}")
                        param['isActive'] = is_active
                        # TODO : toggle parameter on module

        with open(config, 'w+') as config_file:
            config_file.write(json.dumps(config_data, indent=2))
            config_file.close()

        return jsonify({"message": "Parameter toggled successfully"})
    except Exception as e:
        print(f"Error toggling parameter: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
