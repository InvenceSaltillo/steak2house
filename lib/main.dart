import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:steak2house/src/routes.dart';
import 'package:steak2house/src/screens/splash/splash_screen.dart';
import 'package:steak2house/src/services/fcm_service.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.instance.initPrefs();

  await FCMService.initializeApp();

  initializeDateFormatting('es_MX', null).then((_) => runApp(MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor:
            (Platform.isAndroid) ? Colors.transparent : Colors.white,
      ),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(fontFamily: 'PTSansNarrow'),
      // initialRoute: MainScreen.routeName,
      routes: routes,
      home: SplashScreen(),
    );
  }
}
