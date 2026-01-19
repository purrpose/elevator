#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>

const char* ssid = "TP-LINK_F98848";
const char* password = "89824978970";

const char* MQTT_HOST = "fa3ef5827c7347d7b6f2f6d246967f86.s1.eu.hivemq.cloud"; 
const int   MQTT_PORT = 8883;               // TLS порт
const char* MQTT_USER = "purrpose";
const char* MQTT_PASS = "a123123A";


#define RELAY_PIN D1       
#define LED_PIN LED_BUILTIN 

const char* floorNumber = "1";  // этаж платы

WiFiClient espClient;
PubSubClient client(espClient);

void setup_wifi() {
  Serial.print("Connecting to Wi-Fi: ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWi-Fi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (unsigned int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  Serial.print("Message received [");
  Serial.print(topic);
  Serial.print("]: ");
  Serial.println(message);

  if (message == "press") {
    Serial.println("Simulating button press...");
    digitalWrite(RELAY_PIN, HIGH);
    digitalWrite(LED_PIN, LOW); 
    delay(500);
    digitalWrite(RELAY_PIN, LOW);
    digitalWrite(LED_PIN, HIGH);

    String statusTopic = String("lift/status/") + floorNumber;
    client.publish(statusTopic.c_str(), "called");
    Serial.println("Call sent, confirmation published");
  }
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Connecting to MQTT broker... ");
    String clientId = "ESP_Lift_Floor_" + String(floorNumber);
    if (client.connect(clientId.c_str())) {
      Serial.println("Connected!");

      String topic = String("lift/call/") + floorNumber;
      client.subscribe(topic.c_str());
      Serial.print("Subscribed to topic: ");
      Serial.println(topic);
    } else {
      Serial.print("Failed, error code: ");
      Serial.print(client.state());
      Serial.println(". Retrying in 5 seconds...");
      delay(5000);
    }
  }
}

void setup() {
  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, LOW);

  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, HIGH); 

  Serial.begin(115200);
  setup_wifi();

  wifiClient.setInsecure();
  
  client.setServer(MQTT_HOST, MQTT_PORT);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}

