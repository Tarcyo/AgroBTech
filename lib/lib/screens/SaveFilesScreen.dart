import 'package:AgroBTech/myWidgets/pdfCardList.dart';
import 'package:flutter/material.dart';
import 'package:AgroBTech/myWidgets/headerBuilder.dart';
import 'dart:io';
import 'CreateScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:AgroBTech/myWidgets/editCardList.dart';
import 'package:provider/provider.dart';
import 'package:AgroBTech/providers/fileNameProvider.dart';

class SaveFilesScreen extends StatefulWidget {
  SaveFilesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SaveFilesScreen> createState() => _SaveFilesScreenState();
}

class _SaveFilesScreenState extends State<SaveFilesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> pages = [
    "Rascunhos",
    "Meus PDFs",
  ];

  @override
  void initState() {
    super.initState();
    int currentIndex = 0;
    _tabController = TabController(
      length: pages.length,
      vsync: this,
      initialIndex: currentIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _listFilesInRascunhos() async {
    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Obter o caminho da pasta "rascunhos"
      String rascunhosPath = '${documentsDirectory.path}/rascunhos';

      // Verificar se a pasta "rascunhos" existe
      if (await Directory(rascunhosPath).exists()) {
        // Listar todos os arquivos na pasta "rascunhos"
        List<FileSystemEntity> files = Directory(rascunhosPath).listSync();

        // Verificar se há arquivos
        if (files.isNotEmpty) {
          // Imprimir o caminho de cada arquivo
          print('Arquivos encontrados na pasta "rascunhos":');
          for (var file in files) {
            print(file.path);
          }
        } else {
          print('Nenhum arquivo encontrado na pasta "rascunhos".');
        }
      } else {
        print('A pasta "rascunhos" não existe.');
      }
    } catch (e) {
      print('Erro ao listar arquivos: $e');
    }
  }

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
              pageBuilder: (_, __, ___) => CreateFilesScreen(""),
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
        child: Icon(Icons.add),
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
    return TabBarView(
      controller: _tabController,
      children: pages.map((page) => _buildBody(page, context)).toList(),
    );
  }

  Widget _header(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return HeaderBuilder(
      left: IconButton(
        icon: Icon(
          Icons.logout,
          color: Colors.white,
          size: screenWidth * 0.06,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      32.0), // Ajuste o valor conforme desejado
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Atenção",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Deseja realmente sair?",
                      style: TextStyle(color: Colors.grey[800], fontSize: 16),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(180.0),
                          ),
                        ),
                        onPressed: () {
                          // Implementar aqui a lógica para sair

                          exit(0);
                        },
                        child: Text(
                          "Sim",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(180.0),
                          ),
                        ),
                        onPressed: () {
                          // Fechar o diálogo sem sair
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Não",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
      right: IconButton(
        icon: Icon(
          Icons.help_outline,
          color: Colors.white,
          size: screenWidth * 0.06,
        ),
        onPressed: () {},
      ),
      center: Container(
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/logo B.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
      top: Text(
        "Gerador de laudos",
        style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
      ),
      bottom: Center(
        child: TabBar(
          tabAlignment: TabAlignment.center,
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.greenAccent[100],
          indicatorColor: Colors.white,
          dividerColor: Colors.transparent,
          indicatorPadding: EdgeInsets.zero,
          tabs: pages
              .map(
                (day) => Tab(
                  child: Container(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildBody(String page, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (page == "Meus PDFs") {
      if (Provider.of<FileNameProvider>(listen: true, context)
          .nomesPdfs
          .isEmpty) {
        return Center(
          child: Text("Nenhum PDF encontrado!"),
        );
      }
      ;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: Consumer<FileNameProvider>(
                        builder: (context, counterProvider, child) {
                          return Center(
                              child: PdfCardList(counterProvider.nomesPdfs));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.05),
                ],
              ),
            )
          ],
        ),
      );
    }
    if (Provider.of<FileNameProvider>(listen: true, context)
        .nomesRascunhos
        .isEmpty) {
      return Center(
        child: Text("Nenhum rascunho encontrado!"),
      );
    }
    ;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: screenHeight * 0.01),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Consumer<FileNameProvider>(
                      builder: (context, counterProvider, child) {
                        return Center(
                            child:
                                EditCardList(counterProvider.nomesRascunhos));
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
              ],
            ),
          )
        ],
      ),
    );
  }
}
