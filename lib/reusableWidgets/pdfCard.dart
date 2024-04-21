import 'package:flutter/material.dart';

class PdfCard extends StatelessWidget {
  final String _text;
  PdfCard(this._text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        height: 65,
        width: 390,
        padding: EdgeInsets.only(
            left: 15.0, right: 15), // Adiciona padding apenas à esquerda
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
                  Icons.picture_as_pdf,
                  color: Colors.green,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  _text,
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share,
                      color: Colors.green,
                      size: 30,
                    )),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                    onPressed: () {},
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
}
