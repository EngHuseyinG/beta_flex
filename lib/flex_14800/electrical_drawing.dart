import 'package:beta_flex/flex_14800/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class electrical_drawing extends StatefulWidget {
  const electrical_drawing({super.key});

  @override
  State<electrical_drawing> createState() => _electrical_drawingState();
}

class _electrical_drawingState extends State<electrical_drawing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elektrik Plan Çizimi',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),

      ),
      body: SfPdfViewer.asset("pdf/electrical_drawing.pdf"),



      drawer: drawer_menu(),
    );
  }
}
