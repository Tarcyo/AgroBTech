import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:AgroBTech/myWidgets/headerBuilder.dart';
import 'dart:io';
import 'package:share/share.dart';

class PDFViewPage extends StatelessWidget {
  final String _pdfPath;
  final String _name;
  PDFViewPage(
    this._pdfPath,
    this._name, {
    Key? key,
  }) : super(key: key);

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
          if (Platform.isAndroid || Platform.isIOS) {
            Share.shareFiles([_pdfPath], text: 'Compartilhando PDF');
          }
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
      filePath: _pdfPath,
    );
  }

  Widget _header(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return HeaderBuilder(
        left: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: screenWidth * 0.07,
          ),
          onPressed: () {
            Navigator.of(context).pop();
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
              size:
                  MediaQuery.of(context).size.width * 0.15, // Tamanho do ícone
              color: Colors.green, // Cor do ícone
            ),
          ),
        ),
        top: Text(
          "Visualização de PDF",
          style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white),
        ),
        bottom: Center(
          child: Text(
            _name,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ));
  }
}
