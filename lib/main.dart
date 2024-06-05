import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schoolapplication/Screens/bottom_screen.dart';

import 'package:schoolapplication/Screens/signin_screen.dart';
import 'package:schoolapplication/cubit/userdata_cubit.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   Future<bool> checkLoginStatus() async {
    final box = await Hive.openBox("login");
    final token = await box.get("token");
    return token != null;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserdataCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        home: FutureBuilder(future: checkLoginStatus(), builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text('Error occurred')),
              );
            } else {
              final status = snapshot.data ?? false;
              return status ? const BottomScreen() : const SignInScreen();
            }
        },),
      ),
    );
  }
}
