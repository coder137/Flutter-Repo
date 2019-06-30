# mqtt_test

23.06.19
Using MQTT with Flutter (1.6.3)

# Packages used

- [mqtt_client 5.5.3](https://pub.dev/packages/mqtt_client)

# Explanation

- Contains `mqtt_model.dart` where all the MQTT Actions take place
- Inside `mqtt_screen.dart` we connect to the mqtt server
  - ListTiles are rendered to subscribe to a particular topic
- Inside `mqtt_chat_screen.dart` we subscribe to a particular topic
  - On clicking the button we **publish** the message
  - The **broadcast stream** receives the message and displays it onto the screen
