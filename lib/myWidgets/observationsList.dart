import 'package:flutter/material.dart';
import '../myWidgets/veryLargeInserCamp.dart';

class ObservationsList extends StatefulWidget {
  final List<TextEditingController> controllers;

  const ObservationsList({Key? key, required this.controllers}) : super(key: key);

  @override
  _ObservationsListState createState() => _ObservationsListState();
}

class _ObservationsListState extends State<ObservationsList> {
  @override
  Widget build(BuildContext context) {
    List<Widget> observations = [];

    for (TextEditingController controller in widget.controllers) {
      observations.add(
        VeryLargeInsertCamp(
          controller: controller,
          text: "Digite a observação",
          icon: Icons.assignment,
        ),
      );
    }
    return widget.controllers.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...observations,
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.controllers.add(TextEditingController());
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.controllers.removeLast();
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
                  )
                ],
              ),
            ),
          )
        : Center(
            child: Column(
              children: [
                Text(
                  "Nenhuma observação adicionada",
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
                    onPressed: () {
                      setState(() {
                        widget.controllers.add(TextEditingController());
                      });
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
}