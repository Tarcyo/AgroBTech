import 'package:flutter/material.dart';
import 'package:AgroBTech/myWidgets/headerBuilder.dart';
import 'package:AgroBTech/myWidgets/observationsLIst.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:AgroBTech/myWidgets/veryLargeInserCamp.dart';
import 'package:AgroBTech/myWidgets/tableOfResults.dart';
import 'package:AgroBTech/myWidgets/attachmentsList.dart';
import 'package:provider/provider.dart';
import 'package:AgroBTech/providers/fileNameProvider.dart';
import 'package:AgroBTech/utils/savePdf.dart';

class CreateFilesScreen extends StatefulWidget {
  CreateFilesScreen(this._savedData, {Key? key}) : super(key: key);
  final String _savedData;

  @override
  State<CreateFilesScreen> createState() => _CreateFilesScreenState(_savedData);
}

class _CreateFilesScreenState extends State<CreateFilesScreen> {
  final String _savedData;

  _CreateFilesScreenState(this._savedData) {
    if (_savedData.isEmpty == false) {
      final data = json.decode(_savedData);
      print("Aqui:" + _savedData);
      _fileNameController.text = data['informacoes']['Nome_Arquivo'];
      _analyzeController.text = data['informacoes']['Tipo_de_analise'];
      _numberController.text = data['informacoes']['Numero_laudo'];
      _contractorController.text = data['informacoes']['Contratante'];
      _materialController.text = data['informacoes']['Material'];
      _dateController.text = data['informacoes']['Data_de_entrada'];
      _cnpjController.text = data['informacoes']['CNPJ'];
      _farmController.text = data['informacoes']['Fazenda'];

      DataRow linha = DataRow(cells: []);

      for (final i in data['resultados']) {
        for (final j in i) {
          linha.cells.add(DataCell(tableCell(TextEditingController(text: j))));
        }
        _results.add(linha);
        linha = DataRow(cells: []);
      }

      for (final i in data['observacoes']) {
        TextEditingController tc = TextEditingController();
        tc.text = i;

        _observations.add(tc);
      }
      for (final i in data['anexos']) {
        _images.add(File(i));
      }
      for (final i in data['descricao_anexos']) {
        TextEditingController tc = TextEditingController();
        tc.text = i;
        _attrachmentsControllers.add(tc);
      }
    } else {
    }
  }

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

  int _index = 1;

  @override
  void initState() {
    super.initState();
    _index = 1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _createAndWriteToFile(String nome, String jsonData) async {
    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Criar a pasta "rascunhos" se não existir
      String rascunhosPath = '${documentsDirectory.path}/rascunhos';
      await Directory(rascunhosPath).create(recursive: true);

      // Criar o arquivo JSON
      File file = File('$rascunhosPath/$nome.json');

      // Escrever os dados no arquivo
      await file.writeAsString(jsonData);

      // Exibir mensagem de sucesso usando um SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("O rascunho foi salvo com sucesso!"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green, // Definindo a cor de fundo como verde
        ),
      );
    } catch (e) {
      // Exibir mensagem de erro usando um SnackBar, se houver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao criar o arquivo!"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<List<FileSystemEntity>?> _listFilesInRascunhos() async {
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
          return files;
        } else {
          print('Nenhum arquivo encontrado na pasta "rascunhos".');
        }
      } else {
        print('A pasta "rascunhos" não existe.');
      }
    } catch (e) {
      print('Erro ao listar arquivos: $e');
    }

    return null;
  }

  List<String> _obterNomesArquivos(List<FileSystemEntity> entidades) {
    List<String> nomesArquivos = [];
    for (FileSystemEntity entidade in entidades) {
      // Verificar se a entidade é um arquivo
      if (entidade is File) {
        // Obter apenas o nome do arquivo sem o caminho nem a extensão
        String nomeArquivo = entidade.path;

        while (nomeArquivo.contains('\\') || nomeArquivo.contains('/')) {
          nomeArquivo = nomeArquivo.split('/').last;
          nomeArquivo = nomeArquivo.split('\\').last;
        }
        while (nomeArquivo.contains('.')) {
          nomeArquivo = nomeArquivo.split('.').first;
        }
        nomesArquivos.add(nomeArquivo);
      }
    }
    return nomesArquivos;
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
                child: _buildBody(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return HeaderBuilder(
      left: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: screenWidth * 0.06,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      right: IconButton(
        icon: Icon(
          Icons.save_as,
          color: Colors.white,
          size: screenWidth * 0.06,
        ),
        onPressed: () async {
          await _criarArquivoJson();
          Provider.of<FileNameProvider>(listen: false, context)
              .adicionaRascunho(_fileNameController.text);
        },
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
            Icons.assignment_add,
            size: MediaQuery.of(context).size.width * 0.15, // Tamanho do ícone
            color: Colors.green, // Cor do ícone
          ),
        ),
      ),
      top: Text(
        "Criar laudo",
        style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
      ),
      bottom: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Center(
            child: Text(_index.toString() + " de 4",
                style: TextStyle(
                    fontSize: screenWidth * 0.039, color: Colors.white)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _index > 1
                  ? TextButton(
                      onPressed: () => {
                        setState(() {
                          _index--;
                        })
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(180.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: screenWidth * 0.039,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Voltar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.039,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ),
              _index < 4
                  ? TextButton(
                      onPressed: () => {
                        setState(() {
                          _index++;
                        })
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Próximo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.039,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: screenWidth * 0.039,
                          ),
                        ],
                      ),
                    )
                  : TextButton(
                      onPressed: () async {
                        await createPDF(
                            context,
                            _fileNameController.text,
                            _analyzeController.text,
                            _numberController.text,
                            _contractorController.text,
                            _materialController.text,
                            _dateController.text,
                            _cnpjController.text,
                            _farmController.text,
                            _results,
                            _observations,
                            _images,
                            _attrachmentsControllers);
                        Provider.of<FileNameProvider>(listen: false, context)
                            .adicionaPdf(_fileNameController.text);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Exportar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.039,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                            size: screenWidth * 0.039,
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ],
      )),
    );
  }

  Future<void> _criarArquivoJson() async {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Coloque um nome no arquivo!"),
          duration: Duration(seconds: 3),
        ),
      );

      return;
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

    await _createAndWriteToFile(nomeArquivo, jsonString);
  }

  Widget _buildBody(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    Widget page = Text("Erro ao carregar ");

    switch (_index) {
      case 1:
        page = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VeryLargeInsertCamp(
                              TextInputType: TextInputType.text,
                              controller: _fileNameController,
                              text: "Nome do arquivo",
                              icon: Icons.description),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          VeryLargeInsertCamp(
                              TextInputType: TextInputType.text,
                              controller: _analyzeController,
                              text: "Tipo análise",
                              icon: Icons.biotech),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          VeryLargeInsertCamp(
                              TextInputType: TextInputType.number,
                              controller: _numberController,
                              text: "Número laudo",
                              icon: Icons.pin),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          VeryLargeInsertCamp(
                              TextInputType: TextInputType.name,
                              controller: _contractorController,
                              text: "Contratante",
                              icon: Icons.handshake_sharp),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          VeryLargeInsertCamp(
                              TextInputType: TextInputType.text,
                              controller: _materialController,
                              text: "Material",
                              icon: Icons.science_rounded),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          VeryLargeInsertCamp(
                              TextInputType: TextInputType.datetime,
                              controller: _dateController,
                              text: "Data de entrada",
                              icon: Icons.calendar_month),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          VeryLargeInsertCamp(
                              TextInputType: TextInputType.text,
                              controller: _cnpjController,
                              text: "CNPJ",
                              icon: Icons.corporate_fare_outlined),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          VeryLargeInsertCamp(
                              TextInputType: TextInputType.name,
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
        );
        break;

      case 2:
        page = Column(
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
        );
        break;

      case 3:
        page = Column(
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
        );

        break;

      case 4:
        page = Column(
          children: [
            AttachmentsList(
              attachments: _attrachments,
              images: _images,
              observationsControllers: _attrachmentsControllers,
            ),
          ],
        );
    }

    return SingleChildScrollView(
      child: page,
    );
  }
}
