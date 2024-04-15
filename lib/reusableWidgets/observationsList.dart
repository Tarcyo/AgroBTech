import 'package:flutter/material.dart';
import 'veryLargeInserCamp.dart';

class ObservationsList extends StatefulWidget {
  @override
  _ObservationsListState createState() => _ObservationsListState();
}

class _ObservationsListState extends State<ObservationsList> {
  List<TextEditingController> _controllers = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> observations = [];

    for (TextEditingController controller in _controllers) {
      observations.add(
        VeryLargeInsertCamp(
            controller: controller,
            text: "Digite a observação",
            icon: Icons.assignment),
      );
    }
    return _controllers.isEmpty==false
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
                              _controllers.add(TextEditingController());
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
                              _controllers.removeLast();
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
                  "Nenhuma observação adicionado",
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
                      _controllers.add(TextEditingController());
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
          ));
  }
}
