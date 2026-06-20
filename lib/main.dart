import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart'; // অ্যাডমব প্যাকেজ কমেন্ট আউট করা হলো
import 'home_screen.dart'; // হোম স্ক্রিন ইমপোর্ট করা হলো

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // বিজ্ঞাপনের ইনিশিয়ালাইজেশন কমেন্ট আউট করা হলো
  // await MobileAds.instance.initialize();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jetlia Logistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
