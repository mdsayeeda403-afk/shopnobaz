import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'এই প্রজেক্ট এখনো ওয়েবের জন্য কনফিগার করা হয়নি।',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions এই প্ল্যাটফর্মের জন্য কনফিগার করা হয়নি।',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnZY4T-6VyXLEv2k7SuE1UxLsS5Yl04-E',
    appId: '1:236853603707:android:dc76cee163453ca58861de',
    messagingSenderId: '236853603707',
    projectId: 'shopnobaz-10718',
    storageBucket: 'shopnobaz-10718.firebasestorage.app',
  );
}
