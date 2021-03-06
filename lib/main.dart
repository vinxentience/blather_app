// ignore_for_file: prefer_const_constructors

import 'package:blather_app/pages/homepage.dart';
import 'package:blather_app/pages/signin.dart';
import 'package:blather_app/provider/image_upload_provider.dart';
import 'package:blather_app/provider/user_provider.dart';
import 'package:blather_app/screens/search.dart';
import 'package:blather_app/screens/splashscreen.dart';
import 'package:blather_app/service/auth_service.dart';
import 'package:blather_app/service/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Widget currentPage = const Splash();
  final FirebaseMethods _authMethods = FirebaseMethods();
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        currentPage = Homepage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
              ChangeNotifierProvider(create: (_) => UserProvider()),
            ],
            child: MaterialApp(
              theme: ThemeData.dark().copyWith(
                textTheme: GoogleFonts.latoTextTheme(
                  Theme.of(context).textTheme,
                ),
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              routes: {
                '/search': (context) => Search(),
              },
              home: FutureBuilder(
                future: _authMethods.getCurrentUser(),
                builder: (context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.hasData) {
                    return Homepage();
                  } else {
                    return Splash();
                  }
                },
              ),
            ),
          );
        }

        // Check for errors
        if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
