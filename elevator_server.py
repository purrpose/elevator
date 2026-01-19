from flask import Flask, request, jsonify
from flask_cors import CORS
import paho.mqtt.client as mqtt

app = Flask(__name__)
CORS(app)  

MQTT_BROKER = "fa3ef5827c7347d7b6f2f6d246967f86.s1.eu.hivemq.cloud"  
MQTT_PORT   = 8883                
MQTT_USER   = "slavik"
MQTT_PASS   = "A123123a"
MQTT_TLS    = True                

client = mqtt.Client()
client.username_pw_set(MQTT_USER, MQTT_PASS)

if MQTT_TLS:
    # включаем TLS без явной проверки CA — быстро для теста
    client.tls_set()  # можно передать CA файл, если хочешь строгую проверку

status_map = {}

def on_connect(client, userdata, flags, rc):
    print("Connected to MQTT broker with code:", rc)
    client.subscribe("lift/status/#")

def on_message(client, userdata, msg):
    floor = msg.topic.split("/")[-1]
    status = msg.payload.decode()
    status_map[floor] = status
    print(f"Status from floor {floor}: {status}")

client.on_connect = on_connect
client.on_message = on_message
client.connect(MQTT_BROKER, MQTT_PORT)
client.loop_start()

@app.route("/call", methods=["POST"])
def call_lift():
    data = request.json or {}
    floor = str(data.get("floor", "1"))
    topic = f"lift/call/{floor}"
    client.publish(topic, "press")
    return jsonify({"message": f"Lift called to floor {floor}."}), 200

@app.route("/status/<floor>", methods=["GET"])
def get_status(floor):
    status = status_map.get(str(floor), "unknown")
    return jsonify({"floor": floor, "status": status}), 200

if __name__ == "__main__":
    # локальный запуск
    app.run(host="0.0.0.0", port=5000)
