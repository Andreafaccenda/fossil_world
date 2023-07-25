import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mapbox_navigator/screens/fossili/fossil_view_model.dart';
import 'package:mapbox_navigator/ui/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/binding.dart';
import 'model/fossil.dart';

late SharedPreferences sharedPreferences;
late List<FossilModel> fossili;
final viewmodel = FossilViewModel();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  fossili = await viewmodel.fossilModel;
  await dotenv.load(fileName: "assets/config/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const Splash(),
    );
  }
}