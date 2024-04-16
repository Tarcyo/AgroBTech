import 'package:flutter/material.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/headerBuilder.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/observationsLIst.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:ifg_mobile_estudante/reusableWidgets/veryLargeInserCamp.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/tableOfResults.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/attachmentsList.dart';

class CreateFilesScreen extends StatefulWidget {
  CreateFilesScreen({Key? key}) : super(key: key);

  @override
  State<CreateFilesScreen> createState() => _CreateFilesScreenState();
}

class _CreateFilesScreenState extends State<CreateFilesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TextEditingController _controller = TextEditingController();

  // Informações:
  TextEditingController _fileNameController = TextEditingController();
  TextEditingController _analyzeController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _contractorController = TextEditingController();
  TextEditingController _materialController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _cnpjController = TextEditingController();
  TextEditingController _farmController = TextEditingController();

  // Resultados
  List<DataRow> _results = [];

  //Observações
  List<TextEditingController> _observations = [];

  //Anexos
  List<Widget> _attrachments = [];
  List<File> _images = [];
  List<TextEditingController> _attrachmentsControllers = [];

  final List<String> pages = [
    "Informações",
    "Resultados",
    "Observações",
    "Anexos",
    "Exportar",
  ];

  @override
  void initState() {
    super.initState();
    int currentDayIndex = 0;
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

  Future<void> _createAndWriteToFile(String nome) async {
    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Criar a pasta "rascunhos" se não existir
      String rascunhosPath = '${documentsDirectory.path}/rascunhos';
      await Directory(rascunhosPath).create(recursive: true);

      // Criar o arquivo JSON
      File file = File('$rascunhosPath/' + nome + '.json');

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
          color: Colors.white,
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
          criarArquivoJson();
        },
        child: Icon(Icons.add), // Ícone do botão flutuante
        backgroundColor: Colors.blue, // Cor de fundo do botão flutuante
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
          Icons.save_as,
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

  void criarArquivoJson() {
    String nomeArquivo = "";
    String tipoAnalise = "";
    String numeroLaudo = "";
    String contratante = "";
    String material = "";
    String dataEntrada = "";
    String cnpj = "";
    String fazenda = "";

    if (_fileNameController.text.isEmpty == false) {
      nomeArquivo = _fileNameController.text;
    }
    if (_analyzeController.text.isEmpty == false) {
      tipoAnalise = _analyzeController.text;
    }
    if (_numberController.text.isEmpty == false) {
      numeroLaudo = _numberController.text;
    }
    if (_contractorController.text.isEmpty == false) {
      contratante = _contractorController.text;
    }
    if (_materialController.text.isEmpty == false) {
      material = _materialController.text;
    }
    if (_dateController.text.isEmpty == false) {
      dataEntrada = _dateController.text;
    }
    if (_cnpjController.text.isEmpty == false) {
      cnpj = _cnpjController.text;
    }
    if (_farmController.text.isEmpty == false) {
      fazenda = _farmController.text;
    }

    final results = [];

    for (final r in _results) {
      final cells = [];
      for (final c in r.cells) {
        final cell = c.child as tableCell;
        cells.add(cell.controller.text);
      }
      results.add(cells);
    }

    final observacoes = [];

    for (final o in _observations) {
      observacoes.add(o.text);
    }

    final anexos = [];

    for (final i in _images) {
      anexos.add(i.path);
    }

    final descricaoAnexos = [];

    for (final da in _attrachmentsControllers) {
      descricaoAnexos.add(da.text);
    }

    Map<String, dynamic> dados = {
      "informacoes": {
        "Nome_Arquivo": nomeArquivo,
        "Tipo_de_analise": tipoAnalise,
        "Numero_laudo": numeroLaudo,
        "Contratante": contratante,
        "Material": material,
        "Data_de_entrada": dataEntrada,
        "CNPJ": cnpj,
        "Fazenda": fazenda,
      },
      "resultados": results,
      "observacoes": observacoes,
      "anexos": anexos,
      "descricao_anexos": descricaoAnexos,
    };

    String jsonString = json.encode(dados);

    print(jsonString);
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
                  ObservationsList(controllers: _observations),
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
                          DataTableWidget(
                            initialRows: _results,
                          ),
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

    if (page == "Anexos") {
      return AttachmentsList(
        attachments: _attrachments,
        images: _images,
        observationsControllers: _attrachmentsControllers,
      );
    }

    if (page == "Exportar") {
      return Column(children: [
        Icon(
          Icons.picture_as_pdf,
          size: 120,
          color: Colors.green,
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                // Adicione aqui a lógica para salvar o PDF
                print('PDF salvo!');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.save)
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                // Adicione aqui a lógica para salvar o PDF
                print('PDF salvo!');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Compartilhar",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.share)
                ],
              ),
            ),
          ],
        )
      ]);
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
                            controller: _fileNameController,
                            text: "Nome do arquivo",
                            icon: Icons.description),
                        SizedBox(
                          height: 5,
                        ),
                        VeryLargeInsertCamp(
                            controller: _analyzeController,
                            text: "Tipo análise",
                            icon: Icons.biotech),
                        SizedBox(
                          height: 5,
                        ),
                        VeryLargeInsertCamp(
                            controller: _numberController,
                            text: "Número laudo",
                            icon: Icons.pin),
                        SizedBox(
                          height: 5,
                        ),
                        VeryLargeInsertCamp(
                            controller: _contractorController,
                            text: "Contratante",
                            icon: Icons.handshake_sharp),
                        SizedBox(
                          height: 5,
                        ),
                        VeryLargeInsertCamp(
                            controller: _materialController,
                            text: "Material",
                            icon: Icons.science_rounded),
                        SizedBox(
                          height: 5,
                        ),
                        VeryLargeInsertCamp(
                            controller: _dateController,
                            text: "Data de entrada",
                            icon: Icons.calendar_month),
                        SizedBox(
                          height: 5,
                        ),
                        VeryLargeInsertCamp(
                            controller: _cnpjController,
                            text: "CNPJ",
                            icon: Icons.corporate_fare_outlined),
                        SizedBox(
                          height: 5,
                        ),
                        VeryLargeInsertCamp(
                            controller: _farmController,
                            text: "Fazenda",
                            icon: Icons.agriculture),
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
