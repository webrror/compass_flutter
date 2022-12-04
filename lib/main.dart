import 'dart:math' as math;

import 'package:compass_flutter_all/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    fetchPermissionStatus();
  }

  void fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() {
          _hasPermissions = (status == PermissionStatus.granted);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: themeProvider.themeMode,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            home: Scaffold(
              body: Builder(builder: (context) {
                if (_hasPermissions) {
                  return buildCompass();
                } else {
                  return buildPermissionSheet();
                }
              }),
            ),
          );
        }
      );
  }

  // Permission request sheet widget

  Widget buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(text: 
            const TextSpan(
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Raleway'
              ),
              children: [
                TextSpan(text: 'This app requries access to '),
                TextSpan(text: 'location', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' to work'),
              ]
            )
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.deepPurple)
            ),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                fetchPermissionStatus();
              });
            },
            child: const Text('Request Permission', style: TextStyle(fontWeight: FontWeight.w600),)),
        ],
      ),
    );
  }

  // Compass Widget

  Widget buildCompass() {
    return StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          // on error
          if (snapshot.hasError) {
            return Text("Error : ${snapshot.error}");
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          double? direction = snapshot.data!.heading;

          // if device lacks the sensor, show error
          if (direction == null) {
            return const Center(
              child: Text('Your device lacks necassary sensors'),
            );
          }

          // success
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.rotate(
                    angle: (direction * (math.pi / 180) * -1),
                    child: Image.asset(
                      'assets/images/compass.png',
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (direction).toInt().toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Theme.of(context).primaryColor
                        ),
                      ),
                      Text(
                        '°',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Theme.of(context).primaryColor
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
