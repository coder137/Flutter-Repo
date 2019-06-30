import 'package:flutter/material.dart';
import 'package:mqtt_test/mqtt_chat_screen.dart';
import 'package:mqtt_test/mqtt_model.dart';

class MqttScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MQTT Test"),
      ),
      body: MqttBody(),
    );
  }
}

class MqttBody extends StatefulWidget {
  @override
  _MqttBodyState createState() => _MqttBodyState();
}

class _MqttBodyState extends State<MqttBody> {
  static const List<String> Topics = [
    "Hello/World/123",
    "Hello/World/456",
    "Hello/World/678"
  ];

  MqttModel mModel = MqttModel();

  @override
  void initState() {
    super.initState();
    mModel.connect();
    mModel.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
    mModel.removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        mModel.isConnected
            ? ListTile(
                title: Text("Connected"),
              )
            : CircularProgressIndicator(),

        //
        Flexible(
          child: ListView.builder(
            itemCount: Topics.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("${Topics[index]}"),
                onTap: () => navigateToSubscribeScreen(Topics[index]),
              );
            },
          ),
        ),

        // END
      ],
    );
  }

  void navigateToSubscribeScreen(String currentTopic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MqttChatScreen(
              mModel: mModel,
              topic: currentTopic,
            ),
      ),
    );
  }

  void listener() {
    if (this.mounted) setState(() {});
  }

  // END
}
