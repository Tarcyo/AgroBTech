import 'package:flutter/material.dart';

class VeryLargeInsertCamp extends StatelessWidget {
  final TextEditingController controller;
  final double margin;
  final String text;
  final IconData icon;

  const VeryLargeInsertCamp({
    Key? key,
    required this.controller,
    required this.text,
    required this.icon,
    this.margin = 16.0, // Valor padrão de margem
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.05, vertical: screenHeight*0.007),
      child: Positioned(
        top: margin,
        left: margin,
        right: margin,
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.green,
                  size: screenHeight * 0.035,
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                SizedBox(
                  width: screenWidth - (margin * 5),
                  height: screenHeight * 0.06,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(180),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Adiciona um pequeno padding
                      child: TextField(
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: text,
                          hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: screenHeight *
                                  0.02), // Altera a cor do texto de dica para preto
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0), // Define o padding do conteúdo
                        ),
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            color: Colors.grey[900]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
