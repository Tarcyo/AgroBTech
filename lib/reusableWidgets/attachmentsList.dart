import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AttachmentsList extends StatefulWidget {
  final List<Widget> attachments;
  final List<File> images;
  final List<TextEditingController> observationsControllers;


  const AttachmentsList({
    Key? key,
    required this.attachments,
    required this.images,
    required this.observationsControllers,
  }) : super(key: key);

  @override
  _AttachmentsListState createState() => _AttachmentsListState();
}

class _AttachmentsListState extends State<AttachmentsList> {
  late List<TextEditingController> _observationsControllers;
  late List<Widget> _attrachments;
  late List<File> _images;

  @override
  void initState() {
    super.initState();
    _observationsControllers = widget.observationsControllers;
    _attrachments = widget.attachments;
    _images = widget.images;
  }
  @override
  Widget build(BuildContext context) {
    

    return _attrachments.isEmpty == false
        ? Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ..._attrachments,
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: IconButton(
                          onPressed: () async {
                            final result = await _openFilePicker();
                            if (result == null) {
                              return;
                            } else {
                              setState(() {
                                _observationsControllers
                                    .add(TextEditingController());
                                _images.add(File(result));
                                _attrachments.add(
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Anexo " +
                                              (_attrachments.length + 1)
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Center(
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                  image:
                                                      FileImage(File(result)),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Positioned(
                                          top: 1,
                                          left: 1,
                                          right: 1,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            (0.3 * 5),
                                                    height: 50,
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(180),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 2,
                                                            blurRadius: 7,
                                                            offset:
                                                                Offset(0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                                8.0), // Adiciona um pequeno padding
                                                        child: TextField(
                                                          controller:
                                                              _observationsControllers
                                                                  .last,
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .center,
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: null,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Descrição',
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey[500],
                                                                fontSize:
                                                                    16), // Altera a cor do texto de dica para preto
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        12.0), // Define o padding do conteúdo
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[900]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: IconButton(
                          onPressed: () {
                            _images.removeLast();
                            setState(() {
                              _attrachments.removeLast();
                              _observationsControllers.removeLast();
                            });
                          },
                          icon: Icon(
                            Icons.remove,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Column(
              children: [
                Text(
                  "Nenhum anexo adicionado",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final result = await _openFilePicker();
                      if (result == null) {
                        return;
                      } else {
                        setState(() {
                          _observationsControllers.add(TextEditingController());
                          _images.add(File(result));
                          _attrachments.add(
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.01),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Anexo " +
                                        (_attrachments.length + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.green),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Center(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            image: FileImage(File(result)),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Positioned(
                                    top: 1,
                                    left: 1,
                                    right: 1,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  (0.3 * 5),
                                              height: 50,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          180),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 7,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                          8.0), // Adiciona um pequeno padding
                                                  child: TextField(
                                                    controller:
                                                        _observationsControllers
                                                            .last,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.start,
                                                    maxLines: null,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Descrição',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                          fontSize:
                                                              16), // Altera a cor do texto de dica para preto
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  12.0), // Define o padding do conteúdo
                                                    ),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Colors.grey[900]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Future<String?> _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        return file.path;
      } else {
        // Usuário cancelou a seleção
        return null;
      }
    } catch (e) {
      print('Erro ao selecionar o arquivo: $e');
      return null;
    }
  }
}
