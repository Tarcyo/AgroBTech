import 'package:flutter/material.dart';
import 'veryLargeInserCamp.dart';

class ObservationsList extends StatefulWidget {
  @override
  _ObservationsListState createState() => _ObservationsListState();
}

class _ObservationsListState extends State<ObservationsList> {
  List<TextEditingController> _controllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    if (_controllers.isEmpty) {
      _controllers.add(TextEditingController());
    }

    List<Widget> observations = [];

    for (TextEditingController controller in _controllers) {
      observations.add(
        VeryLargeInsertCamp(
            controller: controller,
            text: "Digite a observação",
            icon: Icons.assignment),
      );
    }
    return SingleChildScrollView(
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
    );
  }
}
