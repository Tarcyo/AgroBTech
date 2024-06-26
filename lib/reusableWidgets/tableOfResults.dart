import 'package:flutter/material.dart';

class DataTableWidget extends StatefulWidget {
  final List<DataRow>?
      initialRows; // Alterando a lista de linhas para ser opcional

  DataTableWidget({Key? key, this.initialRows}) : super(key: key);

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  late List<DataRow> rows;

  @override
  void initState() {
    super.initState();
    // Inicializando a lista de linhas com a lista recebida no construtor ou uma lista vazia se não for fornecida
    rows = widget.initialRows ?? [];
    if (rows.isEmpty) {
      addRow(); // Adicionando uma linha inicial se a lista estiver vazia
    }
  }

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
                DataColumn(
                    label:
                        Text('ID lab', style: TextStyle(color: Colors.green))),
                DataColumn(
                    label: Text('ID cliente',
                        style: TextStyle(color: Colors.green))),
                DataColumn(
                    label: Text('Conídios/ml',
                        style: TextStyle(color: Colors.green))),
                DataColumn(
                    label:
                        Text('UFC/ml', style: TextStyle(color: Colors.green))),
              ],
              rows: List.from(rows),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: addRow,
              icon: Icon(Icons.add, size: 40),
            ),
            SizedBox(width: 5),
            IconButton(
              onPressed: removeRow,
              icon: Icon(Icons.remove, size: 40),
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
          DataCell(tableCell(TextEditingController())),
          DataCell(tableCell(TextEditingController())),
          DataCell(tableCell(TextEditingController())),
          DataCell(tableCell(TextEditingController())),
        ]),
      );
    });
  }

  void removeRow() {
    setState(() {
      if (rows.isNotEmpty) {
        rows.removeLast();
      }
    });
  }
}

class tableCell extends StatelessWidget {
  final TextEditingController _controller;

  TextEditingController get controller => _controller;

  tableCell(
    this._controller,
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
    );
  }
}
