//MGS. M. FAKHRI ABDILLAH
//082176619855
//mgsmfakhria@gmail.com

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sejuta_cita_test/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
