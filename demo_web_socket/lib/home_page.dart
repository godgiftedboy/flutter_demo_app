import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel channel;
  bool isSubscribed = true;

  createConnection() {
    /// Create the WebSocket channel
    try {
      channel = WebSocketChannel.connect(
        Uri.parse("wss://ws.eodhistoricaldata.com/ws/forex?api_token=demo"),
      );
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
    }
  }

  // listenToSocket() {
  //   channel.stream.listen((data) {
  //     // var d = jsonDecode(data);
  //     log(data.toString());

  //     setState(() {});
  //   });
  // }

  @override
  void initState() {
    super.initState();
    createConnection();
    // listenToSocket();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                final Map<String, dynamic> data =
                    jsonDecode(snapshot.data ?? "{}");
                if (snapshot.hasData) {
                  print("Hello :   : : :: $data");
                  if (isSubscribed) {
                    channel.sink.add(jsonEncode(
                        {"action": "subscribe", "symbols": "EURUSD"}));
                    // setState(() {
                    isSubscribed = false;
                    // });
                  }

                  return data.containsKey("status_code")
                      ? Text(data['message'])
                      : Table(
                          border: TableBorder.all(), // Add borders to cells
                          children: [
                            const TableRow(
                              children: [
                                TableCell(
                                    child: Center(child: Text('Ticker code'))),
                                TableCell(
                                    child: Center(child: Text('Ask Price'))),
                                TableCell(
                                    child: Center(child: Text('Bid price'))),
                                TableCell(
                                    child:
                                        Center(child: Text('Daily change %'))),
                                TableCell(child: Center(child: Text('dd'))),
                                TableCell(child: Center(child: Text('ppms'))),
                                TableCell(
                                    child: Center(child: Text('timestamp'))),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                    child:
                                        Center(child: Text(data['s'] ?? ""))),
                                TableCell(
                                    child: Center(
                                        child: Text(data['a'].toString()))),
                                TableCell(
                                    child: Center(
                                        child: Text(data['b'].toString()))),
                                TableCell(
                                    child: Center(
                                        child: Text(data['dc'].toString()))),
                                TableCell(
                                    child: Center(
                                        child: Text(data['dd'].toString()))),
                                TableCell(
                                    child: Center(
                                        child: Text(data['ppms'].toString()))),
                                TableCell(
                                    child: Center(
                                        child: Text(
                                            ' ${(data['t'] ~/ (86400000 * 30))} days'))),

                                //truncate()  and ~/ does same to cut off decimal digits
                              ],
                            ),
                          ],
                        );
                } else {
                  return const Text('No data received');
                }
              },
            ),
            TextField(
              onSubmitted: (text) {
                channel.sink.add(text);
                // setState(() {});
              },
              decoration: const InputDecoration(labelText: 'Send a message'),
            ),
            ElevatedButton(
              onPressed: () {
                channel.sink.add(
                    jsonEncode({"action": "subscribe", "symbols": "EURUSD"}));
              },
              child: const Text("Subscribe"),
            ),
            ElevatedButton(
              onPressed: () {
                channel.sink.add(
                    jsonEncode({"action": "unsubscribe", "symbols": "EURUSD"}));
              },
              child: const Text("Unsubscribe"),
            ),
          ],
        ),
      ),
    );
  }
}
