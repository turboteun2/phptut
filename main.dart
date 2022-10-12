import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "";

  String? _newMessage;

  getData(_msg) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var url = Uri.parse(
        'http://localhost/phptut/index.php'); // Url of the website where we get the data from.
    var request = http.Request('POST', url); // Now set our  request to POST
    request.bodyFields = {"msg": _msg.toString()};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send(); // Send request.
    // Check if response is okay
    if (response.statusCode == 200) {
      dynamic data =
          await response.stream.bytesToString(); // Turn bytes to readable data.
      setState(() => message = data);
    } else {
      print("${response.statusCode} - Something went wrong..");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              message, // The data what we get from the web is going to be displayed here.
            ),
            TextFormField(
              onChanged: (e) => _newMessage = e,
            ),
            MaterialButton(
              onPressed: () => getData(
                  _newMessage), // Click this button to send our new message
              child: Text("Send message"),
            )
          ],
        ),
      ),
    );
  }
}
