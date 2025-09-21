#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <ESP32Servo.h>
#include <DHT.h>

#define WIFI_SSID "XXXXXXX"
#define WIFI_PASSWORD "XXXXXXX"
#define FIREBASE_HOST "XXXXXXX"
#define FIREBASE_AUTH "XXXXXXX"
#define DHTTYPE DHT22

unsigned long lastFirebase = 0;
const unsigned long interval = 500;

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
Servo myServo;

int ledPin = 2;
int relayPin = 4;
int fanPin = 16;
int servoPin = 14;
int doorPin = 5;
int LDRPin = 36;
int DHTPin = 21;
const int LDRTURN_ON = 2500;
const int LDRTURN_OFF = 3000;
bool DevicesAutoOn = false;
bool ledAutoOn = false;
bool fanOn = false;
// Energy vars
const int VT_PIN = 34; // ADC
float energy_kWh = 0.0;
const float V_LOAD = 5.0;
const float SENSITIVITY = 0.185; // V/A
unsigned long lastUpdate = 0;

// DHT
DHT dht(DHTPin, DHTTYPE);

void setup()
{
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  pinMode(relayPin, OUTPUT);
  pinMode(doorPin, OUTPUT);
  myServo.attach(servoPin);
  analogSetAttenuation(ADC_11db);
  dht.begin();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(5000);
  }
  Serial.println("");
  Serial.println("WiFi Connected!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  config.database_url = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  Serial.println("Firebase initialized!");
}

void loop()
{

  unsigned long now = millis();

  int ldrValue = analogRead(LDRPin);
  Serial.print("LDR Value: ");
  Serial.println(ldrValue);
  float temperature = dht.readTemperature();

  fanOn = digitalRead(relayPin) == LOW;

  if (fanOn)
  {
    if (now - lastUpdate >= 1000)
    { // ทุก 1 วินาที
      lastUpdate = now;
      if (Firebase.RTDB.getFloat(&fbdo, "energy_usage"))
      {
        energy_kWh = fbdo.floatData();
        Serial.print("Initial energy from Firebase: ");
        Serial.println(energy_kWh, 4);
      }
      else
      {
        Serial.println("Failed to get initial energy value, start from 0");
      }
      int sensorValue = analogRead(VT_PIN);
      float voltage = sensorValue * (3.3 / 4095.0);
      float current = voltage / 1.0;
      float power = V_LOAD * current;  // W
      float deltaTime_h = 1.0 / 360.0; // 1 sec -> h
      energy_kWh += power * deltaTime_h;
      Firebase.RTDB.setFloat(&fbdo, "energy_usage", energy_kWh);
    }
  }

  if (Firebase.ready() && millis() - lastFirebase > interval)
  {
    lastFirebase = millis();
    Firebase.RTDB.setFloat(&fbdo, "temp", temperature);
    int savingMode = Firebase.RTDB.getInt(&fbdo, "/Devices/SavingMode") ? fbdo.intData() : -1;

    if (savingMode)
    {
      int light1 = Firebase.RTDB.getInt(&fbdo, "/Devices/Light") ? fbdo.intData() : -1;
      int fan = Firebase.RTDB.getInt(&fbdo, "/Devices/Fan") ? fbdo.intData() : -1;
      int door = Firebase.RTDB.getInt(&fbdo, "/Devices/Door") ? fbdo.intData() : -1;
      int lightLevel = Firebase.RTDB.getInt(&fbdo, "/Levels/Light") ? fbdo.intData() : -1;
      int fanLevel = Firebase.RTDB.getInt(&fbdo, "/Levels/Fan") ? fbdo.intData() : -1;

      if (light1 != -1 && light1)
      {
        int pwmLight = map(lightLevel, 0, 3, 0, 255);
        analogWrite(ledPin, pwmLight);
      }
      else
      {
        analogWrite(ledPin, 0);
      }

      if (fan != -1)
        digitalWrite(relayPin, fan ? LOW : HIGH);

      if (door != -1)
      {
        if (door)
        {
          digitalWrite(doorPin, LOW);
          delay(1000);
          myServo.write(0);
        }
        else
        {
          myServo.write(100);
          delay(1000);
          digitalWrite(doorPin, HIGH);
        }
      };
    }
    else
    {
      digitalWrite(ledPin, ldrValue < LDRTURN_ON ? HIGH : LOW);
      int tempSet = Firebase.RTDB.getInt(&fbdo, "/tempset") ? fbdo.intData() : -1;

      if (!isnan(temperature))
      {
        digitalWrite(relayPin, temperature > tempSet ? LOW : HIGH);
      }
      else
      {
        Serial.println("Failed to read DHT22");
      }
    }
  }
}
