import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scasell/bar_menu/perfil/Perfil.dart';
import 'package:scasell/bar_menu/vender/Vender.dart';
import 'package:scasell/rutas/Rutas.gr.dart';

import 'Estilo/Theme.dart';
import 'bar_menu/negocio/Negocio.dart';
import 'db/db_setting.dart';

void dbSetting() {
  FirebaseFirestore db = FirebaseFirestore.instance;

  DBSetting dbSetting = DBSetting(db);

  dbSetting.habilitarPersistenciaSinConexion();
  dbSetting.setSizeCache();
  //dbSetting.inabilitarAccesoRed();
  dbSetting.habilitarAccesoRed();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  dbSetting();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(Main());
}

class Main extends StatelessWidget {

   Main({Key? key}) : super(key: key);

  // This widget is the root of your application.
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: Stilos.themeData,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppLocalizations? valores;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late TabsRouter routes;

  int currentIndex = 0;
  void _onItemTapped(int index) {
    print('index $index');
    setState(() {
      currentIndex = index;
    });
    switch (index) {
      case 0:
        routes.navigate(const NegocioRouter());
        return;
      case 1:
        routes.navigate(const NegocioRouter());
        return;
      case 2:
        routes.navigate(const NegocioRouter());
        return;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    valores = AppLocalizations.of(context);
    return AutoTabsScaffold(
      routes: const [NegocioRouter(), NegocioRouter(), NegocioRouter()],
      bottomNavigationBuilder: (_, tabRouter) {
        routes = tabRouter;
        return BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront),
              label: valores?.menu_negocio,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: valores?.menu_vender,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: valores?.menu_perfil),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          onTap: (index) => _onItemTapped(index),
        );
      },
    );
  }
}
