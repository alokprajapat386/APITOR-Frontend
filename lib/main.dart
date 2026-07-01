import 'package:apitor/analytics/service/api_config.dart';
import 'package:apitor/analytics/service/google_auth_service.dart';
import 'package:apitor/screens/landing_page/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:apitor/routing/router.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   bool isLoading =true;

   @override
   void initState() {
     super.initState();
     initialize();
   }

  // This widget is the root of your application.
  Future<void>  initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GoogleAuthService.initialize();
    await ApiConfiguration.loadConfiguration();
    setState((){
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    MaterialApp(
      title: 'APITOR',
      
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: SplashScreen(),
    
    ):
    MaterialApp.router(
      title: 'APITOR',
      
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: router,
    );
  }
}

