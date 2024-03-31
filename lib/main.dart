import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final List<Map<String, dynamic>> data = [
  {"id_lab": 1, "id_cliente": 101, "conidios_ml": 50, "ufc_ml": 100},
  {"id_lab": 2, "id_cliente": 102, "conidios_ml": 75, "ufc_ml": 120},
  {"id_lab": 3, "id_cliente": 103, "conidios_ml": 60, "ufc_ml": 90},
];

pw.Widget _buildTable() {
  final headers = [
    'ID lab',
    'ID cliente',
    'Conídios/ml',
    'UFC/ml',
  ];

  final tableHeaders = headers.map((header) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child:
          pw.Text(header, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      padding: pw.EdgeInsets.all(5),
      decoration: pw.BoxDecoration(color: PdfColors.grey300),
    );
  }).toList();

  final tableRows = data.map((rowData) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(5),
          child: pw.Text('${rowData["id_lab"]}'),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(5),
          child: pw.Text('${rowData["id_cliente"]}'),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(5),
          child: pw.Text('${rowData["conidios_ml"]}'),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(5),
          child: pw.Text('${rowData["ufc_ml"]}'),
        ),
      ],
    );
  }).toList();

  return pw.Container(
    child: pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: tableHeaders,
        ),
        ...tableRows,
      ],
    ),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _createPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          // Create a Container to position the Row and the "blackboard"
          return pw.Column(
            children: [
              // Content Row
              pw.Container(
                alignment: pw.Alignment.topCenter,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Add first text
                    pw.Text('Logo', style: pw.TextStyle(fontSize: 10)),
                    // Add spacer to create space between text
                    pw.SizedBox(width: 20),
                    // Add second text
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Agro Btech ",
                              style: pw.TextStyle(
                                  color: PdfColors.orange, fontSize: 12)),
                          pw.Text("Laboratório de Análises Biológicas ME ",
                              style: pw.TextStyle(
                                  color: PdfColors.orange, fontSize: 12)),
                          pw.Text("CNPJ 41.966.054/0001-93 ",
                              style: pw.TextStyle(
                                  color: PdfColors.orange, fontSize: 12)),
                        ]),

                    // Add spacer to create space between text
                    pw.SizedBox(width: 20),
                    // Add third text
                    pw.Text('QR-CODE', style: pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              pw.SizedBox(width: 25, height: 25),
              // Blackboard
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.black, // Cor da borda preta
                    width: 1, // Largura da borda
                  ),
                  color: PdfColors.white, // Cor de fundo branca
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      height: 5,
                      width: 5,
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              "Tipo análise",
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              "Número Laudo:",
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              "Contratante:",
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.SizedBox(width: 45),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              "Material:",
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              "Data Entrada:",
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text("Fungos",
                                style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text("513", style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text("Multividas",
                                style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text("Produto Biológico",
                                style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text("21/03/24",
                                style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 30, width: 70),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              "CNPJ:",
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              "Fazenda:",
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text(
                              "Data Emissão:",
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text("50.447.518/0001-46",
                                style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text("-", style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                        pw.Row(
                          children: [
                            pw.Text("22/03/2024 ",
                                style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                        pw.SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(
                height: 5,
              ),
              pw.Container(
                  width: double.infinity,
                  height: 25,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.orange, // Cor da borda preta
                      width: 1, // Largura da borda
                    ),
                    color: PdfColors.orange, // Cor de fundo branca
                  ),
                  child: pw.Center(
                      child: pw.Text("RESULTADOS",
                          style: const pw.TextStyle(
                              fontSize: 12, color: PdfColors.white)))),
              pw.SizedBox(height: 10),
              _buildTable(),
              pw.SizedBox(
                height: 10,
              ),
              pw.Row(children: [
                pw.SizedBox(width: 15),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          "NR: Não realizado. *Contaminação com bactérias e leveduras.",
                          style: pw.TextStyle(
                            fontSize: 8,
                          )),
                      pw.SizedBox(height: 15),
                      pw.Row(children: [
                        pw.SizedBox(width: 10),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Observações: ",
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                  )),
                              pw.SizedBox(
                                height: 5,
                              ),
                              pw.Row(children: [
                                pw.SizedBox(width: 10),
                                pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                          "1) A concentração de conídios é realizada através de um hemocitômetro no aumento de 25 – 40x em microscópio óptico ",
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                          )),
                                      pw.Text(
                                          "2) Avaliação de UFC é realizada  indiretamente (concentração x viabilidade dos conídios).",
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                          )),
                                      pw.Text(
                                          "3) Os resultados de análise são referentes às amostras enviadas pelo interessado;",
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                          )),
                                      pw.Text(
                                          "4) Estes resultados não possuem valor jurídico.  ",
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                          )),
                                    ]),
                              ]),
                            ]),
                      ]),
                    ]),
              ]),
              pw.SizedBox(
                height: 20,
              ),
              pw.Center(
                child: pw.Text("ANEXOS",
                    style: pw.TextStyle(
                      fontSize: 14,
                    )),
              ),
              pw.SizedBox(
                height: 5,
              ),
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(
                      File('assets/images/laudo.png').readAsBytesSync()),
                  width: 200, // largura da imagem
                  height: 200, // altura da imagem
                ),
              ),
              pw.SizedBox(
                height: 5,
              ),
              pw.Center(
                child: pw.Text(
                    "Figura 1. Viabilidade em placas: I000120 (A); I000121(B).",
                    style: pw.TextStyle(
                      fontSize: 14,
                    )),
              ),
              pw.SizedBox(
                height: 70,
              ),
              pw.Center(
                child: pw.Text(
                    "Avenida Lazinho Pimenta N° 440 Qd.20 Setor Municipal de Pequenas Empresas- Rio Verde GO",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    )),
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Center(
                child: pw.Text(
                    "64 99612-0249 / E-mail: laboratorio@agrobiontech.com",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    )),
              ),
            ],
          );
        },
      ),
    );

    // Get the documents directory
    String? folderPath = await FilePicker.platform.getDirectoryPath();
    if (folderPath == null) {
      return;
    }

    final path = '$folderPath/example.pdf';

    // Save the PDF
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _createPDF();
        },
        tooltip: 'Criar PDF',
        child: const Icon(Icons.picture_as_pdf),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
