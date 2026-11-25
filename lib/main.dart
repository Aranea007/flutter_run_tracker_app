import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //บอก Supabase ว่าเราจะใช้ Supabase ในแอปของเรา
  await Supabase.initialize(
    url: 'https://ozcacdyzruyuufpupyyk.supabase.co',
    //anonKey: 'your-anon-key',
    publishableKey: 'sb_publishable_68vtp32YCKfMCxUwGoHiLA_5S3tt3mm',
  );

  runApp(FlutterRunTrackerApp());
}

class FlutterRunTrackerApp extends StatefulWidget {
  const FlutterRunTrackerApp({super.key});

  @override
  State<FlutterRunTrackerApp> createState() => _FlutterRunTrackerAppState();
}

class _FlutterRunTrackerAppState extends State<FlutterRunTrackerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenUi(),
        theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
                fontFamily: GoogleFonts.kanit().fontFamily,
                fontFamilyFallback: GoogleFonts.kanit().fontFamilyFallback)));
  }
}
