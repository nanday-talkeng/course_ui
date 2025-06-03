import 'package:flutter_windowmanager/flutter_windowmanager.dart';

Future<void> secureScreen() async {
  // Prevent screenshots and screen recordings
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}
