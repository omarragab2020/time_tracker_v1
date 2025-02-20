import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_buffers.dart';
import 'package:time_tracker/app/services/api.dart';

class MQTTClientManager {
  MqttServerClient client =
      MqttServerClient.withPort('mqtt.abuzeit.com', api.userID, 8883);

  Future<int> connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMessage =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      client.disconnect();
    } on SocketException catch (e) {
      client.disconnect();
    }

    return 0;
  }

  void disconnect() {
    client.disconnect();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.exactlyOnce);
  }

  void onConnected() {}

  void onDisconnected() {}

  void onSubscribed(String topic) {}

  void pong() {}

  void publishMessage(String topic, String message) {
    Uint8List data = Uint8List.fromList(message.codeUnits);
    Uint8Buffer dataBuffer = Uint8Buffer();
    dataBuffer.addAll(data);
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    var answer = client.publishMessage(topic, MqttQos.exactlyOnce, dataBuffer);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }
}
