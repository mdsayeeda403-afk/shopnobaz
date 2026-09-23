// এই ফাইলটি অটোমেটিক জেনারেট হওয়ার কথা `flutterfire configure` কমান্ড চালালে।
// README.md এর "Firebase কানেক্ট করা" অংশে ধাপে ধাপে দেখানো আছে কীভাবে করবে।
//
// এই কমান্ড চালালে এই পুরো ফাইলটা অটোমেটিক তোমার আসল Firebase প্রজেক্টের
// তথ্য দিয়ে রিপ্লেস হয়ে যাবে - তখন এই প্লেসহোল্ডার আর লাগবে না।
//
// এখনকার মতো এই ফাইলটা placeholder হিসেবে রাখা হয়েছে যাতে প্রজেক্ট
// স্ট্রাকচার সম্পূর্ণ দেখায়। flutterfire configure না চালিয়ে অ্যাপ রান করলে
// এরর আসবে - এটাই স্বাভাবিক, README অনুসরণ করলে ঠিক হয়ে যাবে।

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
          'DefaultFirebaseOptions এই প্ল্যাটফর্মের জন্য কনফিগার করা হয়নি - '
          'flutterfire configure চালাও।',
        );
    }
  }

  // ⚠️ এই ভ্যালুগুলো placeholder। `flutterfire configure` চালালে
  // এগুলো তোমার আসল Firebase প্রজেক্টের তথ্য দিয়ে অটো রিপ্লেস হবে।
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    storageBucket: 'REPLACE_ME',
  );
}
