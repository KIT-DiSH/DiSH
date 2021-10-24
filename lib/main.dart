import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dish/widgets/routes/route.dart';
import 'package:dish/screens/select_signin_signup_screen.dart';

final isLoginProvider = StateProvider((ref) => false);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    bool isLogin = watch(isLoginProvider).state;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Navigator(
        pages: [
          MaterialPage(
            child: SelectSigninSginupScreen(),
          ),
          if (isLogin) MaterialPage(child: RouteWidget()),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          context.read(isLoginProvider).state = false;
          return true;
        },
      ),
      // home: SplashScreen(),
      // home: SelectSigninSginupScreen(),
    );
  }
}
