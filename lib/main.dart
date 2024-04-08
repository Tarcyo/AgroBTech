import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/SaveFilesScreen.dart';

void main() {
  runApp(const AgroBioTech());
}

class AgroBioTech extends StatelessWidget {
  const AgroBioTech({Key? key});

  @override
  Widget build(BuildContext context) {
    // Definindo a cor da barra de status como verde
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green,
    ));

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Agro Bio Tech: Gerador de laudos',
      theme: ThemeData(
        fontFamily: "Quicksand",
        primaryColor: Colors.green, // Definindo a cor verde
      ),
      debugShowCheckedModeBanner: false,
      home: SaveFilesScreen(),
    );
  }
}
