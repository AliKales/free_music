import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/library/audio/audio.dart';
import 'package:music_app/library/pages/main_page/main_page_view.dart';
import 'package:music_app/library/providers/p_home_page.dart';
import 'package:music_app/library/services/hive/hive_db.dart';
import 'package:music_app/library/services/unity_ads/s_unity_ads.dart';
import 'package:provider/provider.dart';

import 'library/funcs.dart';
import 'library/providers/p_audio.dart';
import 'library/providers/p_page.dart';
import 'library/values.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Funcs().setPath();

  Audio audio = Audio();

  SUnityAds().init();

  await HiveDB().init();

  Funcs().setSystemUIColors();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PAudio>(
          create: (context) => PAudio(),
        ),
        ChangeNotifierProvider<PPage>(
          create: (context) => PPage(),
        ),
        ChangeNotifierProvider<PHomePage>(
          create: (context) => PHomePage(),
        ),
      ],
      child: MyApp(audio: audio),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.audio,
  }) : super(key: key);

  final Audio audio;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Free Download Listen Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink, //not neceserry
          surface: cPrimaryColor,
          surfaceTint: cSecondoryColor,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all<Color>(cSecondoryColor),
        ),
      ),
      home: const MainPageView(),
    );
  }
}
