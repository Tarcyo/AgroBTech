import 'package:flutter/material.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/headerBuilder.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/editCard.dart';
import 'package:ifg_mobile_estudante/reusableWidgets/pdfCard.dart';
import 'dart:io';
import 'CreateScreen.dart';

class SaveFilesScreen extends StatefulWidget {
  SaveFilesScreen({Key? key}) : super(key: key);

  @override
  State<SaveFilesScreen> createState() => _SaveFilesScreenState();
}

class _SaveFilesScreenState extends State<SaveFilesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> pages = [
    "Rascunhos",
    "Meus PDFs",
  ];

  @override
  void initState() {
    super.initState();
    int currentDayIndex = DateTime.now().weekday - 1;
    if (currentDayIndex < 0 || currentDayIndex >= pages.length) {
      currentDayIndex = 0;
    }
    _tabController = TabController(
      length: pages.length,
      vsync: this,
      initialIndex: currentDayIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors
              .white, // Defina uma cor sólida aqui para cobrir toda a tela
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              Expanded(
                child: _body(context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
       onPressed: () async {
  // Definir a duração da animação
  const Duration duration = Duration(milliseconds: 600);

  // Adicionar uma animação de escala
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (_, __, ___) => CreateFilesScreen(),
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
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        hoverColor: Colors.white,
        splashColor: Colors.white,
        focusColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _body(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: pages.map((page) => _buildBody(page, context)).toList(),
    );
  }

  Widget _header(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return HeaderBuilder(
      left: IconButton(
        icon: Icon(
          Icons.logout,
          color: Colors.white,
          size: screenWidth * 0.07,
        ),
        onPressed: () {
          exit(0);
        },
      ),
      right: IconButton(
        icon: Icon(
          Icons.help_outline,
          color: Colors.white,
          size: screenWidth * 0.07,
        ),
        onPressed: () {},
      ),
      center: Container(
        height: MediaQuery.of(context).size.width * 0.6,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/logo B.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
      top: Text(
        "Gerador de laudos",
        style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white),
      ),
      bottom: Center(
        child: TabBar(
          tabAlignment: TabAlignment.center,
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.greenAccent[100],
          indicatorColor: Colors.white,
          dividerColor: Colors.transparent,
          indicatorPadding: EdgeInsets.zero,
          tabs: pages
              .map(
                (day) => Tab(
                  child: Container(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildBody(String page, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (page == "Meus PDFs") {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PdfCard(color: Colors.green, height: 100),
                          PdfCard(color: Colors.green, height: 100),
                          PdfCard(color: Colors.green, height: 100),
                          PdfCard(color: Colors.green, height: 100)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.05),
                ],
              ),
            )
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: screenHeight * 0.01),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EditCard(color: Colors.green, height: 100),
                        EditCard(color: Colors.green, height: 100),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
              ],
            ),
          )
        ],
      ),
    );
  }
}
