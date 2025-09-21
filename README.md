# smart_home_assistant_iot
control and monitor smart devices in real-time. The system integrates hardware such as ESP32 microcontrollers and sensors with a mobile app, allowing users to manage their home environment conveniently and securely.
## Project Structure

``` bash
lib
├── core  
│   ├── config # config application
│   │   └── theme
│   │       ├── app_color.dart # color of application
│   │       └── app_theme.dart # theme
│   └── service # service
│       ├── firebase # firebase service realtimedatabase
│       │   └── realtime_database_service.dart
│       └── voice # voice service n8n webhook
│           └── voice_command_service.dart
├── main.dart
└── presentation # screen
    └── devices
        ├── devices.dart # main screen
        ├── pages
        │   └── device_detail.dart 
        └── widget # widget 
            ├── goal_tracker.dart
            ├── manage_devices.dart
            ├── saving_mode.dart
            ├── security_mode.dart
            ├── temperature.dart
            ├── timer_widget.dart
            └── voice_command_button.dart
esp # IOT code 
└── esp_smart_home_firebase
    └── esp_smart_home_firebase.ino
```