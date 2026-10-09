import 'package:doctor_appointmentapp/firebase_options.dart';
import 'package:doctor_appointmentapp/providers/authproviders.dart';
import 'package:doctor_appointmentapp/providers/doctorprovider.dart';
import 'package:doctor_appointmentapp/screens/diversion.dart';
import 'package:doctor_appointmentapp/screens/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>Authproviders() ,),
        ChangeNotifierProvider(create: (_) =>Doctorprovider(),)
      ],
      child: const MainApp(),)
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:diversionpage()
      ),
    );
  }
}
