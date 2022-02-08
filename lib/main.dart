import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/bloc_observer.dart';
import 'package:social_app/shared/cubit/cubit.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await CacheHelper.init();
      await Firebase.initializeApp();

      var token = await FirebaseMessaging.instance.getToken();

      print(token);

      FirebaseMessaging.onMessage.listen((event) {
        print(event.data.toString());
      });

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print(event.data.toString());
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      late Widget widget;
      Constants.uid = await CacheHelper.getData(key: 'uid');
      if (Constants.uid != null) {
        widget = const HomeLayout();
      } else {
        widget = const LoginScreen();
      }

      return runApp(MyApp(widget));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(this.widget, {Key? key}) : super(key: key);

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocialCubit>(
      create: (context) => SocialCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          fontFamily: 'jannah',
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0,
            titleSpacing: 20.0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: TextStyle(
              fontFamily: 'jannah',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 20.0,
          ),
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            subtitle1: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ),
        home: widget,
      ),
    );
  }
}
