import 'package:cancha_tennis/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'application/providers/agendamiento_provider.dart';
import 'infrastructure/database/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.initializeDatabaseProvider();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AgendamientosProvider>(
            create: (context) => AgendamientosProvider(),
            ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agendamiento de Canchas de Tenis',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/home',
        routes: {'/home': (_) => HomePage()},
      ),
    );
  }
}
