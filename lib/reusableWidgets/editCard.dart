import 'package:flutter/material.dart';
import 'package:AgroBTech/screens/EditScreen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:AgroBTech/providers/fileNameProvider.dart';

class EditCard extends StatelessWidget {
  final String _nomeArquivo;

  EditCard(this._nomeArquivo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        height: 65,
        width: 360,
        padding:
            EdgeInsets.only(left: 15.0), // Adiciona padding apenas à esquerda
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(180.0),
          border: Border.all(
            color: Colors.green,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.description,
                  color: Colors.green,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  _nomeArquivo,
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      final content = await _getFileContentInRascunhos();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 600),
                          pageBuilder: (_, __, ___) => EditFilesScreen(content),
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
                    icon: Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: 30,
                    )),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                    onPressed: () async {
                      await _deleteFile();
                      Provider.of<FileNameProvider>(listen: false, context)
                          .removeRascunho(_nomeArquivo);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[800],
                      size: 30,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> _getFileContentInRascunhos() async {
    final String fileName = _nomeArquivo + ".json";
    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Obter o caminho da pasta "rascunhos"
      String rascunhosPath = '${documentsDirectory.path}/rascunhos';

      // Verificar se a pasta "rascunhos" existe
      if (await Directory(rascunhosPath).exists()) {
        // Construir o caminho completo do arquivo
        String filePath = '$rascunhosPath/$fileName';

        // Verificar se o arquivo existe
        if (await File(filePath).exists()) {
          // Ler o conteúdo do arquivo
          String fileContent = await File(filePath).readAsString();
          return fileContent;
        } else {
          print('O arquivo "$fileName" não existe na pasta "rascunhos".');
          return "";
        }
      } else {
        print('A pasta "rascunhos" não existe.');
        return "";
      }
    } catch (e) {
      print('Erro ao obter conteúdo do arquivo: $e');
      return "";
    }
  }

  Future<void> _deleteFile() async {
    final String fileName = _nomeArquivo + ".json";

    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Obter o caminho da pasta "rascunhos"
      String rascunhosPath = '${documentsDirectory.path}/rascunhos';

      // Verificar se o arquivo existe
      File fileToDelete = File('$rascunhosPath/$fileName');
      if (await fileToDelete.exists()) {
        // Excluir o arquivo
        await fileToDelete.delete();
        print('Arquivo $fileName excluído com sucesso.');
      } else {
        print('O arquivo $fileName não existe na pasta "rascunhos".');
      }
    } catch (e) {
      print('Erro ao excluir o arquivo: $e');
    }
  }
}
