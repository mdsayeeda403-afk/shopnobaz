# স্বপ্নবাজ 📖

গল্প, কবিতা ও উপন্যাস লেখা ও পড়ার অ্যাপ।

## সেটআপ ধাপ (টার্মিনাল বা কিছু ইনস্টল ছাড়াই, সম্পূর্ণ ব্রাউজার দিয়ে)

### ধাপ ১: এই পুরো ফোল্ডার GitHub এ আপলোড করা
GitHub এ নতুন রিপো বানিয়ে "uploading an existing file" দিয়ে এই ফোল্ডারের ভেতরের সব ফাইল/ফোল্ডার (.github সহ) ড্র্যাগ করে দিয়ে Commit করো।

**নোট:** GitHub Actions workflow (`.github/workflows/build_apk.yml`) বিল্ডের সময় ক্লাউডেই অটোমেটিক Flutter এর Android নেটিভ ফাইল (gradle ইত্যাদি) তৈরি করে নেবে — তাই এগুলো আলাদাভাবে বানানোর দরকার নেই।

### ধাপ ২: Firebase থেকে কনফিগ তথ্য বের করা (ব্রাউজারেই)
1. https://console.firebase.google.com এ গিয়ে তোমার `shopnobaz` প্রজেক্টে ঢোকো
2. উপরে বাম পাশে ⚙️ (Settings) আইকনে ক্লিক → **Project settings**
3. নিচে "Your apps" সেকশনে যদি কোনো Android অ্যাপ যোগ করা না থাকে, তাহলে Android আইকনে ক্লিক করে একটা অ্যাপ যোগ করো:
   - Android package name: `com.shopnobaz.shopnobaz`
   - বাকি ফিল্ড খালি রেখে "Register app" ক্লিক করো
   - এরপরের ধাপগুলো (google-services.json ডাউনলোড ইত্যাদি) স্কিপ করে দাও — লাগবে না
4. Project settings পেজে "SDK setup and configuration" অংশে `apiKey`, `appId`, `messagingSenderId`, `projectId`, `storageBucket` — এই ৫টা ভ্যালু দেখতে পাবে

### ধাপ ৩: `firebase_options.dart` ফাইল GitHub এর ওয়েবসাইটেই এডিট করা
1. GitHub রিপোতে গিয়ে `lib/firebase_options.dart` ফাইলে ক্লিক করো
2. উপরে ডান পাশে পেন্সিল (✏️) আইকনে ক্লিক করো (এডিট মোড)
3. `REPLACE_ME` করে লেখা ৫টা জায়গায় ধাপ ২ থেকে পাওয়া আসল ভ্যালু বসাও (quotes ঠিক রেখে)
4. নিচে "Commit changes" এ ক্লিক করো

### ধাপ ৪: Firestore Security Rules বসানো
- Firebase Console → Firestore Database → Rules ট্যাব
- এই প্রজেক্টের `firestore.rules` ফাইলের সবটুকু কপি করে ওখানে পেস্ট করো
- "Publish" বাটনে ক্লিক করো

এই কমিট হওয়ার সাথে সাথেই GitHub Actions অটোমেটিক নতুন APK বিল্ড শুরু করে দেবে।

## APK কোথায় পাবে

1. GitHub রিপোতে যাও
2. উপরে **Actions** ট্যাবে ক্লিক করো
3. সর্বশেষ workflow run এ ক্লিক করো (সবুজ টিক মানে সফল হয়েছে)
4. নিচে **Artifacts** সেকশনে `shopnobaz-apk` নামে একটা জিপ ফাইল থাকবে — ওটা ডাউনলোড করো
5. জিপ থেকে বের করলে `app-release.apk` পাবে — এটাই ইন্সটল করার ফাইল

ফোনে APK ইন্সটল করতে গেলে "Unknown apps" পারমিশন দিতে হতে পারে (ফোনের সেটিংসে একবার allow করে দিলেই হবে)।

## ম্যানুয়ালি বিল্ড রান করতে চাইলে (ল্যাপটপ ছাড়া, ফোন দিয়েও)
GitHub রিপোতে গিয়ে **Actions → Build APK → Run workflow** বাটনে ক্লিক করলেই নতুন বিল্ড শুরু হয়ে যাবে — কোনো কোড পরিবর্তন ছাড়াই।

## গুরুত্বপূর্ণ ফাইল কোথায়

| কী | কোথায় |
|---|---|
| থিম/কালার | `lib/theme/app_theme.dart` |
| ৭০০ শব্দের নিয়ম | `lib/models/chapter_model.dart` (এর `kMinWordCount`) |
| Firestore ডাটাবেস লজিক | `lib/services/story_service.dart` |
| Security Rules | `firestore.rules` |
| অ্যাপের নাম | `android/app/src/main/AndroidManifest.xml` |

## এরপর কী যোগ করা যাবে (পরবর্তী ধাপে)
- কমেন্ট সিস্টেম
- লাইক/রিয়েক্ট বাটন
- লাইব্রেরি (সেভ করা লেখা)
- সার্চ
- নোটিফিকেশন
