import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_e2e_app/screens/splash_screen.dart';
import 'screens/home.dart';
import 'screens/draw.dart';
import 'screens/history.dart';
import 'screens/auth.dart';
import 'providers/auth.dart';
import 'providers/drawing.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Drawing>(
            update: (ctx, auth, previousDrawings) => Drawing(auth.token,
                previousDrawings == null ? [] : previousDrawings.drawings),
            create: null,
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      fontFamily: 'Open Sans',
                    ),
                    home: auth.isAuth
                        ? Home()
                        : FutureBuilder(
                            future: auth.tryAutoLogin(),
                            builder: (_, authResultSnapshot) =>
                                authResultSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? SplashScreen()
                                    : AuthScreen(),
                          ),
                    routes: {
                      '/draw': (context) => Draw(),
                      '/history': (context) => History(),
                    })));
  }
}
