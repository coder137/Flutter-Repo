import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_test/mqtt_model.dart';

class MqttChatScreen extends StatelessWidget {
  final MqttModel mModel;
  final String topic;

  MqttChatScreen({
    @required this.mModel,
    @required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MqttChatBody(mModel, topic),
    );
  }
}

class MqttChatBody extends StatefulWidget {
  final MqttModel mModel;
  final String topic;
  MqttChatBody(this.mModel, this.topic);

  @override
  _MqttChatBodyState createState() => _MqttChatBodyState();
}

class _MqttChatBodyState extends State<MqttChatBody> {
  @override
  void initState() {
    super.initState();
    this.widget.mModel.subscribe(this.widget.topic);
  }

  @override
  void dispose() {
    super.dispose();
    this.widget.mModel.unsubscribe(this.widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: this.widget.mModel.broadcastStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<MqttReceivedMessage<MqttMessage>>>
                    snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: Text("No Data Received"),
                );

              final c = snapshot.data;
              final MqttPublishMessage recMess = c[0].payload;
              final String pt = MqttPublishPayload.bytesToStringAsString(
                  recMess.payload.message);

              print(
                  'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');

              return Center(child: Text("${c[0].topic} -- $pt"));
            },
          ),

          // TextField here
          Card(
            child: ListTile(
              title: Text("Press me"),
              onTap: () {
                this.widget.mModel.publish(
                      this.widget.topic,
                      "Hello World ${DateTime.now().millisecondsSinceEpoch}",
                    );
              },
            ),
          ),

          // END
        ],
      ),
    );
  }
}
