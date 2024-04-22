import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:AgroBTech/myWidgets/headerBuilder.dart';
import 'dart:io';
import 'package:AgroBTech/screens/CreateScreen.dart';

class PDFViewPAge extends StatefulWidget {
  final String _pdfPath;
  final String _name;
  PDFViewPAge(
    this._pdfPath,
    this._name, {
    Key? key,
  }) : super(key: key);

  @override
  State<PDFViewPAge> createState() => _PDFViewPAgeState();
}

class _PDFViewPAgeState extends State<PDFViewPAge>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors
              .white, // Defina uma cor sólida aqui para cobrir toda a tela
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              Expanded(
                child: _body(context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Definir a duração da animação
          const Duration duration = Duration(milliseconds: 600);

          // Adicionar uma animação de escala
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: duration,
              pageBuilder: (_, __, ___) => CreateFilesScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: child,
                );
              },
            ),
          );
        },
        child: Icon(Icons.share),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        hoverColor: Colors.white,
        splashColor: Colors.white,
        focusColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _body(BuildContext context) {
    return PDFView(
      filePath: widget._pdfPath,
    );
  }

  Widget _header(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return HeaderBuilder(
        left: IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.white,
            size: screenWidth * 0.07,
          ),
          onPressed: () {
            exit(0);
          },
        ),
        right: IconButton(
          icon: Icon(
            Icons.help_outline,
            color: Colors.white,
            size: screenWidth * 0.07,
          ),
          onPressed: () {},
        ),
        center: Container(
          height: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.picture_as_pdf,
              size: MediaQuery.of(context).size.width * 0.15, // Tamanho do ícone
              color: Colors.green, // Cor do ícone
            ),
          ),
        ),
        top: Text(
          "Visualização de PDF",
          style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white),
        ),
        bottom: Center(child: Text(widget._name,style: TextStyle(fontSize: 18,color: Colors.white),),));
  }
}
