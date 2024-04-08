import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DataTableWidget extends StatefulWidget {
  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  List<DataRow> rows = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              horizontalMargin: 10,
              columns: [
                DataColumn(label: Text('ID lab', style: TextStyle(color: Colors.green))), // Definindo o estilo de texto verde
                DataColumn(label: Text('ID cliente', style: TextStyle(color: Colors.green))), // Definindo o estilo de texto verde
                DataColumn(label: Text('Conídios/ml', style: TextStyle(color: Colors.green))), // Definindo o estilo de texto verde
                DataColumn(label: Text('UFC/ml', style: TextStyle(color: Colors.green))), // Definindo o estilo de texto verde
              ],
              rows: List.from(rows),
            ),
          ),
        ),
        SizedBox(height: 10), // Espaçamento entre a tabela e os botões
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: addRow,
              icon: Icon(Icons.add,size: 40,),
            ),
            SizedBox(width: 5,),
            IconButton(
              onPressed: removeRow,
              icon: Icon(Icons.remove,size: 40,),
            ),
          ],
        ),
      ],
    );
  }

  void addRow() {
    setState(() {
      rows.add(
        DataRow(cells: [
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          
        ]),
      );
    });
  }

  void removeRow() {
    setState(() {
      if (rows.isNotEmpty) {
        rows.removeLast(); // Removendo a última linha
      }
    });
  }

  @override
  void initState() {
    super.initState();
    addRow(); // Adicionando uma linha inicial
  }
}