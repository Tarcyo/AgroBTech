import 'package:flutter/material.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/headerBuilder.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/observationsLIst.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:ifg_mobile_estudante/reusableWidgets/veryLargeInserCamp.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/tableOfResults.dart';

class CreateFilesScreen extends StatefulWidget {
  CreateFilesScreen({Key? key}) : super(key: key);

  @override
  State<CreateFilesScreen> createState() => _CreateFilesScreenState();
}

class _CreateFilesScreenState extends State<CreateFilesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _controller = TextEditingController();

  final List<String> pages = [
    "Informações",
    "Resultados",
    "Observações",
  ];

  @override
  void initState() {
    super.initState();
    int currentDayIndex = DateTime.now().weekday - 1;
    if (currentDayIndex < 0 || currentDayIndex >= pages.length) {
      currentDayIndex = 0;
    }
    _tabController = TabController(
      length: pages.length,
      vsync: this,
      initialIndex: currentDayIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _createAndWriteToFile() async {
    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Criar a pasta "rascunhos" se não existir
      String rascunhosPath = '${documentsDirectory.path}/rascunhos';
      await Directory(rascunhosPath).create(recursive: true);

      // Criar o arquivo JSON
      File file = File('$rascunhosPath/oi.json');

      // Criar os dados que serão escritos no arquivo JSON
      Map<String, dynamic> data = {
        'nome': 'João',
        'idade': 30,
        'cidade': 'São Paulo',
      };

      print(file);

      // Converter os dados em formato JSON
      String jsonData = jsonEncode(data);

      // Escrever os dados no arquivo
      await file.writeAsString(jsonData);

      // Exibir mensagem de sucesso
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucesso'),
            content: Text('Arquivo criado e escrito com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Exibir mensagem de erro, se houver
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Ocorreu um erro ao criar ou escrever no arquivo.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
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

  Future<void> _deleteFile(String filename) async {
    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Obter o caminho da pasta "rascunhos"
      String rascunhosPath = '${documentsDirectory.path}/rascunhos';

      // Verificar se o arquivo existe
      File fileToDelete = File('$rascunhosPath/$filename');
      if (await fileToDelete.exists()) {
        // Excluir o arquivo
        await fileToDelete.delete();
        print('Arquivo $filename excluído com sucesso.');
      } else {
        print('O arquivo $filename não existe na pasta "rascunhos".');
      }
    } catch (e) {
      print('Erro ao excluir o arquivo: $e');
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
        height: MediaQuery.of(context).size.width * 0.6,
        width: MediaQuery.of(context).size.width * 0.6,
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
        "Criar laudo",
        style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white),
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
                        fontSize: screenWidth * 0.042,
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

    if (page == "Observações") {
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
                  ObservationsList(),
                  SizedBox(height: screenWidth * 0.05),
                ],
              ),
            )
          ],
        ),
      );
    }

    if (page == "Resultados") {
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DataTableWidget(),
                        ],
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VeryLargeInsertCamp(
                            controller: _controller,
                            text: "Nome do arquivo",
                            icon: Icons.description),
                        VeryLargeInsertCamp(
                            controller: _controller,
                            text: "Tipo análise",
                            icon: Icons.biotech),
                        VeryLargeInsertCamp(
                            controller: _controller,
                            text: "Contratante",
                            icon: Icons.handshake_sharp),
                        VeryLargeInsertCamp(
                            controller: _controller,
                            text: "Material",
                            icon: Icons.science_rounded),
                        VeryLargeInsertCamp(
                            controller: _controller,
                            text: "Data de entrada",
                            icon: Icons.calendar_month),
                        VeryLargeInsertCamp(
                            controller: _controller,
                            text: "CNPJ",
                            icon: Icons.corporate_fare_outlined),
                        SizedBox(
                          height: 100,
                        )
                      ],
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
