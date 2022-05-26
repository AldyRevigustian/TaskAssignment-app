import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/notificationservice/local_notification_service.dart';
import 'package:flutter_task_planner_app/provider/parent.dart';
import 'package:flutter_task_planner_app/screens/login_page.dart';
import 'package:flutter_task_planner_app/screens/user/user_menu_bottom_bar.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.transparent, // navigation bar color
  //   // systemNavigationBarColor: Color(0xFFE5E5E5), // navigation bar color
  //   statusBarColor: Colors.transparent, // status bar color
  //   // statusBarColor: LightColors.mainBlue, // status bar color
  //   // statusBarColor: Colors.red, // status bar color
  // ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    MaterialColor colorCustom = MaterialColor(0xFF2FA0BF, color);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Parent(), // parentProvier
        ),
      ],
      child: MaterialApp(
        title: 'Task Assignment',
        // onGenerateRoute: generateRoute,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: colorCustom,
          textTheme:
              Theme.of(context).textTheme.apply(fontFamily: 'Montserrat'),
        ),
        // home: HomePage(),
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          UserMenuBottomBarPage.routeName: (ctx) => UserMenuBottomBarPage(),
          LoginPage.routeName: (ctx) => LoginPage(),
        },
      ),
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(47, 160, 191, .1),
  100: Color.fromRGBO(47, 160, 191, .2),
  200: Color.fromRGBO(47, 160, 191, .3),
  300: Color.fromRGBO(47, 160, 191, .4),
  400: Color.fromRGBO(47, 160, 191, .5),
  500: Color.fromRGBO(47, 160, 191, .6),
  600: Color.fromRGBO(47, 160, 191, .7),
  700: Color.fromRGBO(47, 160, 191, .8),
  800: Color.fromRGBO(47, 160, 191, .9),
  900: Color.fromRGBO(47, 160, 191, 1),
};
