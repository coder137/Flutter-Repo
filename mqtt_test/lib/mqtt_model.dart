import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttModel extends ChangeNotifier {
  // static const String BrokerUrl = "test.mosquitto.org";
  static const String BrokerUrl = "iot.eclipse.org";

  final MqttClient client = MqttClient(BrokerUrl, '');

  // Using variables
  Stream<List<MqttReceivedMessage<MqttMessage>>> broadcastStream;
  bool isConnected = false;

  // NOTE, Dynamically set the Broker here if needed
  MqttModel() {
    _init();
  }

  /// [_init]
  // ! IMPORTANT -> ClientIdentifier needs to be set
  void _init() {
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
    client.onUnsubscribed = _onUnsubscribed;
    // client.pongCallback

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('Test1234567890')
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;
  }

  /// [connect]
  void connect() async {
    try {
      await client.connect();
      broadcastStream = client.updates.asBroadcastStream();

      // // When subscribe events are received
      // client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      //   final MqttPublishMessage recMess = c[0].payload;
      //   final String pt =
      //       MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      //   print(
      //       'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      // });

    } catch (e) {
      print("Could not connect: $e");
      client.disconnect();
    }
  }

  /// [subscribe]
  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  /// [unsubscribe]
  void unsubscribe(String topic) {
    client.unsubscribe(topic);
  }

  /// [publish]
  void publish(String topic, String data) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(data);

    /// Publish it
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  /// [disconnect]
  void disconnect() {
    client.disconnect();
  }

  /// Callbacks
  void _onConnected() {
    print("Connected to $BrokerUrl");
    isConnected = true;
    notifyListeners();
  }

  void _onDisconnected() {
    print("Disconnected from $BrokerUrl");
    isConnected = false;
    notifyListeners();
  }

  void _onSubscribed(String topic) {
    print("Subscribed to $topic");
  }

  void _onUnsubscribed(String topic) {
    print("Unsubscribed from $topic");
  }
}
