import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:AgroBTech/providers/fileNameProvider.dart';
import '../screens/pdfViewer.dart';

class PdfCard extends StatelessWidget {
  final String _text;
  PdfCard(this._text);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.02; // 3% da largura da tela

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      child: Container(
        height: screenHeight * 0.085, // 10% da altura da tela
        width: screenWidth * 0.95, //// 94% da largura da tela
        padding: EdgeInsets.symmetric(horizontal: padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenHeight *
              0.15), // 15% da altura da tela para borda arredondada
          border: Border.all(
            color: Colors.green,
            width: screenWidth *
                0.003, // 0.3% da largura da tela para a largura da borda
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  color: Colors.green,
                  size: screenWidth * 0.085,
                ),
                SizedBox(
                  width: screenWidth *
                      0.02, // 2% da largura da tela para o espaçamento entre o ícone e o texto
                ),
                Container(
                  // Container para limitar a largura do texto
                  width: screenWidth * 0.45, // Defina a largura máxima do texto
                  child: Text(
                    _text,
                    overflow: TextOverflow
                        .ellipsis, // Adiciona reticências se o texto for muito grande
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: screenHeight *
                          0.02, // 3.5% da altura da tela para o tamanho da fonte
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    const Duration duration = Duration(milliseconds: 600);
                    String filePath = await _getFiePath();
                    print("caminho: " + filePath);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: duration,
                        pageBuilder: (_, __, ___) =>
                            PDFViewPage(filePath, _text),
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
                    Icons.visibility,
                    color: Colors.green,
                    size: screenWidth * 0.07,
                  ),
                ),
                IconButton(
                  onPressed: () async {
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
                                "Deseja deletar o arquivo?",
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 16),
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
                                      borderRadius:
                                          BorderRadius.circular(180.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Implementar aqui a lógica para sair
                                    await _deleteFile();
                                    Provider.of<FileNameProvider>(
                                            listen: false, context)
                                        .removePdf(_text);
                                    Navigator.of(context).pop();
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
                                      borderRadius:
                                          BorderRadius.circular(180.0),
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
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[800],
                    size: screenWidth * 0.07,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getFiePath() async {
    final String fileName = _text + ".pdf";
    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Obter o caminho da pasta "rascunhos"
      String rascunhosPath = '${documentsDirectory.path}/meus pdfs';

      // Verificar se a pasta "rascunhos" existe
      if (await Directory(rascunhosPath).exists()) {
        // Construir o caminho completo do arquivo
        String filePath = '$rascunhosPath/$fileName';

        // Verificar se o arquivo existe
        if (await File(filePath).exists()) {
          // Ler o conteúdo do arquivo
          return filePath;
        } else {
          print('O arquivo "$fileName" não existe na pasta "meu pdfs".');
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
    final String fileName = _text + ".pdf";

    try {
      // Obter o diretório de documentos
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      // Obter o caminho da pasta "rascunhos"
      String rascunhosPath = '${documentsDirectory.path}/meus pdfs';

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
