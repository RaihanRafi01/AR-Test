import 'package:ar_test/aRPaperPlaneTutorial.dart';
import 'package:ar_test/arFlutter.dart';
import 'package:ar_test/arScreen.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), // Home screen where the button is
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the notification screen when pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AR_Test()),
                );
              },
              child: Text('Go to AR Screen'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to the notification screen when pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ARPaperPlaneTutorial()),
                );
              },
              child: Text('Go to Tapped screen'),
            ),
            const SizedBox(height: 40),
            /*ElevatedButton(
              onPressed: () {
                // Navigate to the notification screen when pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ARFlutter()),
                );
              },
              child: const Text('Go to Tapped screen AR Flutter'),
            ),*/

          ],
        ),
      ),
    );
  }
}
