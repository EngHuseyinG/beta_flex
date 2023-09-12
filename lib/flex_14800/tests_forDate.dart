import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beta_flex/flex_14800/drawer_menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Row, Column, Alignment;
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';


class tests_forDate extends StatefulWidget {
  const tests_forDate({super.key});

  @override
  State<tests_forDate> createState() => _tests_forDateState();
}

class _tests_forDateState extends State<tests_forDate> {



  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();


  Map<dynamic, dynamic> map1 = <dynamic, dynamic> {};
  List<dynamic> list1 = [];


  late int _testcounter = 0 ;
  late int _okUrun = 0;
  late int _nokUrun = 0;
  late int _reURUN = 0;

  DateTime now = DateTime.now();

  late bool _circularprogress = false;


  late String _min = '';
  late String _hour = '';
  late String _day = '';
  late String _month = '';

  late int adlema_1 = 10 ;
  late int adlema_2 = 10 ;
  late int adlema_3 = 10 ;
  late int adlema_4 = 10 ;

  late bool veriyok = false;
  late bool _searchopened = false ;
  late bool _tarihsecilmedi = true ;
   bool? _cubukluChecked = false;
   bool? _cubuksuzChecked = false;
   bool? _tekrarTestChecked = false;


  late int _secilenstartday = 0;
  late int _secilenstartmonth = 0;
  late int _secilenstartyear = 0;
  late int _secilenendday = 0;
  late int _secilenendmonth = 0;
  late int _secilenendyear = 0;

  final DatabaseReference dbrefa = FirebaseDatabase.instance.ref().child('14800').child('sonuclar');
  final DatabaseReference dbrefb = FirebaseDatabase.instance.ref().child('14800').child('tekrar_sonuclar');

  _getDatasforDates() async {
    if(_secilenstartmonth == _secilenendmonth && _secilenstartyear == _secilenendyear && _tarihsecilmedi == false) {
      _ifDatesinSameMonth();
    }
    else if(_secilenstartmonth != _secilenendmonth && _secilenstartyear == _secilenendyear && _tarihsecilmedi == false) {
      _ifDatesinDifferentMonths();
    }
    else{
      setState(() {
        veriyok = true;
        _tarihsecilmedi = false;
        _reURUN = 0;
        _okUrun = 0;
        _nokUrun = 0;
        map1.clear();
        list1.clear();
        _testcounter = 0;
        if(_circularprogress == true) {
          Navigator.of(context).pop();
          _circularprogress = false;
        }

      });
    }

  }


    _ifDatesinSameMonth() async {

      _reURUN = 0;
      _okUrun = 0;
      _nokUrun = 0;
      map1.clear();
      list1.clear();
      _testcounter = 0;

      for(var k = _secilenstartday; k <=_secilenendday; k++) {
        String _day1;
        if(k < 10) {_day1 = '0${k}';}
        else{_day1 = '${k}';}
        var snapshot;
        if(_tekrarTestChecked == false) {
          snapshot = await dbrefa.child(_day1).get();
        }
        else if(_tekrarTestChecked == true) {
          snapshot = await dbrefb.child(_day1).get();
        }


        if(snapshot.exists) {
          map1.addAll(snapshot.value as dynamic);

          setState(() {
            if(_cubukluChecked == true && _cubuksuzChecked == false) {
              final i = map1.values.where((element) =>
              element['day'].toString().startsWith(k.toString()) &&
                  element['month'].toString().startsWith(_secilenstartmonth.toString()) &&
                  element['year'].toString().startsWith(_secilenstartyear.toString()) &&
                  element['D145'].toString().startsWith('1'));
              list1.addAll(i);
            }
           else if(_cubuksuzChecked == true && _cubukluChecked == false) {
              final i = map1.values.where((element) =>
              element['day'].toString().startsWith(k.toString()) &&
                  element['month'].toString().startsWith(_secilenstartmonth.toString()) &&
                  element['year'].toString().startsWith(_secilenstartyear.toString()) &&
                  element['D145'].toString().startsWith('2'));
              list1.addAll(i);
            }
            else {
              final i = map1.values.where((element) =>
              element['day'].toString().startsWith(k.toString()) &&
                  element['month'].toString().startsWith(_secilenstartmonth.toString()) &&
                  element['year'].toString().startsWith(_secilenstartyear.toString()));
              list1.addAll(i);
            }
          });

        }
      }

      setState(() {
                if(map1.isEmpty) {
                  veriyok = true;
                }
                else {
                  veriyok = false;
                  list1 = list1..sort((a, b) => b['orderid'].compareTo(a['orderid']));
                  _testcounter = list1.length;
                  _urunSayaci();
                }

                if(_circularprogress == true) {
                  Navigator.of(context).pop();
                    _circularprogress = false;
                  }

      });
    }

    _ifDatesinDifferentMonths() async {

      _reURUN = 0;
      _okUrun = 0;
      _nokUrun = 0;
      map1.clear();
      list1.clear();
      _testcounter = 0;

      ////////////////////////Ne kadar test sonucu varsa hepsini çek ve Mape Ekle/////////////////////////////
      for(var k = 1; k <= 31; k++) {
        String _day1;
        if(k < 10) {_day1 = '0${k}';}
        else{_day1 = '${k}';}
        var snapshot;
        if(_tekrarTestChecked == false) {
          snapshot = await dbrefa.child(_day1).get();
        }
        else if(_tekrarTestChecked == true) {
          snapshot = await dbrefb.child(_day1).get();
        }

        if(snapshot.exists) {
            map1.addAll(snapshot.value as dynamic);
        }
      }

      /////Seçilen ilk ayın 31'ine kadar olan verileri listeye ekle////////////////////

      for(var m = _secilenstartday; m <= 31 ; m++) {

        if(_cubukluChecked == true && _cubuksuzChecked == false) {
          final i = map1.values.where((element) => element['day'].toString().startsWith(m.toString()) &&
              element['month'].toString().startsWith(_secilenstartmonth.toString()) &&
              element['year'].toString().startsWith(_secilenstartyear.toString()) &&
              element['D145'].toString().startsWith('1'));
          list1.addAll(i);
        }
        else if(_cubuksuzChecked == true && _cubukluChecked == false) {
          final i = map1.values.where((element) => element['day'].toString().startsWith(m.toString()) &&
              element['month'].toString().startsWith(_secilenstartmonth.toString()) &&
              element['year'].toString().startsWith(_secilenstartyear.toString()) &&
              element['D145'].toString().startsWith('2'));
          list1.addAll(i);
        }
        else {
          final i = map1.values.where((element) => element['day'].toString().startsWith(m.toString()) &&
              element['month'].toString().startsWith(_secilenstartmonth.toString()) &&
              element['year'].toString().startsWith(_secilenstartyear.toString()));
          list1.addAll(i);
        }


      }

      ////////////////////////Seçilen ayların arasındaki full ayları listeye ekle//////////////////////

      if(_secilenendmonth - _secilenstartmonth >= 2) {
        for(var n = (_secilenstartmonth+1) ; n <= (_secilenendmonth-1) ; n++) {

          for(var j = 1 ; j <= 31; j++) {
            final i = map1.values.where((element) => element['day'].toString().startsWith(j.toString()) &&
                element['month'].toString().startsWith(n.toString()) &&
                element['year'].toString().startsWith(_secilenstartyear.toString()));
            list1.addAll(i);
          }
        }
      }
   //////////////////////////Seçilen son ayda ki verilerin listeye eklenmesi///////////////////////////////////

      for(var o = 1 ; o <= _secilenendday; o++) {
        final i = map1.values.where((element) => element['day'].toString().startsWith(o.toString()) &&
            element['month'].toString().startsWith(_secilenendmonth.toString()) &&
            element['year'].toString().startsWith(_secilenstartyear.toString()));

        list1.addAll(i);

      }

      /////////////////////////Veriler Listeye eklendi artık sıralama ve sayım işlemlerini yapabiliriz//////////////////////////////

      setState(() {
              if(map1.isEmpty) {
                veriyok = true;
              }
              else {
                veriyok = false ;
                list1 = list1..sort((a, b) => b['orderid'].compareTo(a['orderid']));
                _testcounter = list1.length;
                _urunSayaci();
              }


              if(_circularprogress == true) {
                Navigator.of(context).pop();
                  _circularprogress = false;
                 }

      });

    }


  _searchFilter() async {
    if(_searchController.text.trim().isNotEmpty) {

      setState(() {
        _reURUN = 0;
        _okUrun = 0;
        _nokUrun = 0;
        list1.clear();
        _testcounter = 0;
      });

      final y = map1.values.where((element,) =>
          element['D142'].toString().startsWith(_searchController.text.toString()));

      setState(() {

        list1.addAll(y);
        _testcounter = y.length;
        list1 = list1..sort((a, b) => b['orderid'].compareTo(a['orderid']));
        _urunSayaci();
      });
    }

    else if(_searchController.text.trim().isEmpty){
      _buildShowDialog(context);
      _getDatasforDates();
    }
  }

  _urunSayaci() async {
    list1.asMap().forEach((key, value) {
      if(list1[key]['D130'] == 0) {_okUrun =_okUrun+2;}
      else if(list1[key]['D130'] == 1 ||list1[key]['D130'] == 2) {_okUrun=_okUrun+1;_nokUrun=_nokUrun+1;}
      else if(list1[key]['D130'] == 3) {_nokUrun = _nokUrun+2;}
      else if(list1[key]['D130'] == 4 || list1[key]['D130'] == 5) {_nokUrun=_nokUrun+1;_reURUN=_reURUN+1;}
      else if(list1[key]['D130'] == 6 ) {_reURUN=_reURUN+2;}
      if(list1[key]['D133'] == 0) {_okUrun =_okUrun+2;}
      else if(list1[key]['D133'] == 1 ||list1[key]['D133'] == 2) {_okUrun=_okUrun+1;_nokUrun=_nokUrun+1;}
      else if(list1[key]['D133'] == 3) {_nokUrun = _nokUrun+2;}
      else if(list1[key]['D133'] == 4 || list1[key]['D133'] == 5) {_nokUrun=_nokUrun+1;_reURUN=_reURUN+1;}
      else if(list1[key]['D133'] == 6 ) {_reURUN=_reURUN+2;}
      if(list1[key]['D136'] == 0) {_okUrun =_okUrun+2;}
      else if(list1[key]['D136'] == 1 ||list1[key]['D136'] == 2) {_okUrun=_okUrun+1;_nokUrun=_nokUrun+1;}
      else if(list1[key]['D136'] == 3) {_nokUrun = _nokUrun+2;}
      else if(list1[key]['D136'] == 4 || list1[key]['D136'] == 5) {_nokUrun=_nokUrun+1;_reURUN=_reURUN+1;}
      else if(list1[key]['D136'] == 6 ) {_reURUN=_reURUN+2;}
      if(list1[key]['D139'] == 0) {_okUrun =_okUrun+2;}
      else if(list1[key]['D139'] == 1 ||list1[key]['D139'] == 2) {_okUrun=_okUrun+1;_nokUrun=_nokUrun+1;}
      else if(list1[key]['D139'] == 3) {_nokUrun = _nokUrun+2;}
      else if(list1[key]['D139'] == 4 || list1[key]['D139'] == 5) {_nokUrun=_nokUrun+1;_reURUN=_reURUN+1;}
      else if(list1[key]['D139'] == 6 ) {_reURUN=_reURUN+2;}
    });
  }

  Future<void> _createExcel() async {



    // Create a new Excel document.
    final Workbook workbook = new Workbook();
//Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];
    Style globalStyle = workbook.styles.add('style');
    globalStyle.bold = true;
    sheet.getRangeByName('A1:M1').cellStyle = globalStyle;


//Add Text.
    sheet.getRangeByName('A1').setText('Tarih\nSaat');
    sheet.getRangeByName('B1').setText('Reçete Kodu');
    sheet.getRangeByName('C1').setText('Ürün Boyu(mm)');
    sheet.getRangeByName('D1').setText('Ön Dolum Süresi(sn)\nDolum Süresi(sn)\nStabilizasyon Süresi(sn)\nTest Süresi(sn)');
    sheet.getRangeByName('E1').setText('Ön Basınç(mBar)\nTest Basıncı(mBar)');
    sheet.getRangeByName('F1').setText('Kanal 1-2\nSonuç');
    sheet.getRangeByName('G1').setText('Kanal 3-4\nSonuç');
    sheet.getRangeByName('H1').setText('Kanal 5-6\nSonuç');
    sheet.getRangeByName('I1').setText('Kanal 7-8\nSonuç');


    list1.asMap().forEach((key, value) {
      late String _hourr = '';
      late String _minn = '';
      late String _dayy = '';
      late String _monthh = '';
      late String _a1Sonuc = '';
      late String _a2Sonuc = '';
      late String _a3Sonuc = '';
      late String _a4Sonuc = '';

      if(list1[key]['hour'] < 10 ) {_hourr = '0${list1[key]['hour']}';}
      else if(list1[key]['hour'] >= 10 ) {_hourr = '${list1[key]['hour']}';}
      if(list1[key]['min'] < 10 ) {_minn = '0${list1[key]['min']}';}
      else if(list1[key]['min'] >= 10 ) {_minn = '${list1[key]['min']}';}
      if(list1[key]['day'] < 10 ) {_dayy = '0${list1[key]['day']}';}
      else if(list1[key]['day'] >= 10 ) {_dayy = '${list1[key]['day']}';}
      if(list1[key]['month'] < 10 ) {_monthh = '0${list1[key]['month']}';}
      else if(list1[key]['month'] >= 10 ) {_monthh = '${list1[key]['month']}';}

      if(list1[key]['D130'] == 0) {_a1Sonuc = 'OK/OK';}
      else if(list1[key]['D130'] == 1) {_a1Sonuc = 'OK/NOK';}
      else if(list1[key]['D130'] == 2) {_a1Sonuc = 'NOK/OK';}
      else if(list1[key]['D130'] == 3) {_a1Sonuc = 'NOK/NOK';}
      else if(list1[key]['D130'] == 4) {_a1Sonuc = 'NOK/RE';}
      else if(list1[key]['D130'] == 5) {_a1Sonuc = 'RE/NOK';}
      else if(list1[key]['D130'] == 6) {_a1Sonuc = 'RE/RE';}
      if(list1[key]['D133'] == 0) {_a2Sonuc = 'OK/OK';}
      else if(list1[key]['D133'] == 1) {_a2Sonuc = 'OK/NOK';}
      else if(list1[key]['D133'] == 2) {_a2Sonuc = 'NOK/OK';}
      else if(list1[key]['D133'] == 3) {_a2Sonuc = 'NOK/NOK';}
      else if(list1[key]['D133'] == 4) {_a2Sonuc = 'NOK/RE';}
      else if(list1[key]['D133'] == 5) {_a2Sonuc = 'RE/NOK';}
      else if(list1[key]['D133'] == 6) {_a2Sonuc = 'RE/RE';}
      if(list1[key]['D136'] == 0) {_a3Sonuc = 'OK/OK';}
      else if(list1[key]['D136'] == 1) {_a3Sonuc = 'OK/NOK';}
      else if(list1[key]['D136'] == 2) {_a3Sonuc = 'NOK/OK';}
      else if(list1[key]['D136'] == 3) {_a3Sonuc = 'NOK/NOK';}
      else if(list1[key]['D136'] == 4) {_a3Sonuc = 'NOK/RE';}
      else if(list1[key]['D136'] == 5) {_a3Sonuc = 'RE/NOK';}
      else if(list1[key]['D136'] == 6) {_a3Sonuc = 'RE/RE';}
      if(list1[key]['D139'] == 0) {_a4Sonuc = 'OK/OK';}
      else if(list1[key]['D139'] == 1) {_a4Sonuc = 'OK/NOK';}
      else if(list1[key]['D139'] == 2) {_a4Sonuc = 'NOK/OK';}
      else if(list1[key]['D139'] == 3) {_a4Sonuc = 'NOK/NOK';}
      else if(list1[key]['D139'] == 4) {_a4Sonuc = 'NOK/RE';}
      else if(list1[key]['D139'] == 5) {_a4Sonuc = 'RE/NOK';}
      else if(list1[key]['D139'] == 6) {_a4Sonuc = 'RE/RE';}

      sheet.getRangeByName('A${key+2}').setText('${_dayy}/${_monthh}/${list1[key]['year']}\n${_hourr}.${_minn}');
      sheet.getRangeByName('B${key+2}').setText('${(list1[key]['D122'] * 65536) + (list1[key]['D121'])}');
      sheet.getRangeByName('C${key+2}').setText('${list1[key]['D142']}');
      sheet.getRangeByName('D${key+2}').setText('${list1[key]['D123'].toDouble()/10.00}\t\t${list1[key]['D124'].toDouble()/10.00}\t\t${list1[key]['D125'].toDouble()/10.00}\t\t${list1[key]['D144'].toDouble()/10.00}');
      sheet.getRangeByName('E${key+2}').setText('${list1[key]['D126']}\n${list1[key]['D127']}');
      sheet.getRangeByName('F${key+2}').setText('${_a1Sonuc}\n${list1[key]['D131'].toDouble()/100.00}\tmbar');
      sheet.getRangeByName('G${key+2}').setText('${_a2Sonuc}\n${list1[key]['D134'].toDouble()/100.00}\tmbar');
      sheet.getRangeByName('H${key+2}').setText('${_a3Sonuc}\n${list1[key]['D137'].toDouble()/100.00}\tmbar');
      sheet.getRangeByName('I${key+2}').setText('${_a4Sonuc}\n${list1[key]['D140'].toDouble()/100.00}\tmbar');

    });

    sheet.getRangeByName('K1').setText('OK Urun Sayisi:${_okUrun}\nNOK Urun Sayisi:${_nokUrun}\nRE Urun Sayisi:${_reURUN}\nToplam Test:${_testcounter}');


    final Range range = sheet.getRangeByName('A1:M1500');
    range.cellStyle.wrapText = false;

// Auto-Fit column the range
    range.autoFitColumns();

// Auto-Fit row the range
    range.autoFitRows();
// Save the document.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the workbook.
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/14800_Rapor.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);

    if(_circularprogress == true) {
      Navigator.of(context).pop();
      _circularprogress = false;
    }

  }


  _buildShowDialog(BuildContext context) {
    setState(() {
      _circularprogress = true;
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Lottie.asset('animations/kas_animation.json',repeat: true),
            ),

          );
        });
  }

  _showQuestionDialog(BuildContext context) {
    // set up the button
    Widget yesButton = TextButton(
      child: Text("ÇIKTI AL"),
      onPressed: () {
        Navigator.of(context).pop();
        _buildShowDialog(context);
        _createExcel();
      },
    );
    Widget noButton = TextButton(
      child: Text("İPTAL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Excel Çıktısı?"),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            Text("Şu an listelenen testlerin excel çıktısını almak istediğinizden emin misiniz?",style: TextStyle(fontSize: 15),),
            SizedBox(height: 15,),
            Text('(Bu özelliğin kullanılabilmesi için "Google Tablolar" uygulamasının yüklü olması gerekmektedir)',style: TextStyle(fontSize: 10),),
          ],
        ),
      ),
      icon: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Image(image: AssetImage('images/img_kasprojeotomasyon.png'),),
      ),
      actions: [
        yesButton,
        noButton,

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  alert;

      },
    );
  }


  Future<void> _showDateRangeDialog() async {

    final DateTimeRange? dateTimeRange = await showDateRangePicker(context: context, firstDate: DateTime(2023),helpText: 'Tarih aralığı seçin', lastDate: DateTime(2030),saveText: 'Kaydet',);

    if(dateTimeRange != null) {
        setState(() {
          _buildShowDialog(context);
            _secilenstartday = dateTimeRange.start.day;
            _secilenstartmonth = dateTimeRange.start.month;
            _secilenstartyear = dateTimeRange.start.year;
            _secilenendday = dateTimeRange.end.day;
            _secilenendmonth = dateTimeRange.end.month;
            _secilenendyear = dateTimeRange.end.year;
            _tarihsecilmedi = false;

            _getDatasforDates();

        });
    }

  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        title: Text('Geçmiş Testler',style: TextStyle(fontSize: 15, color: Colors.white),maxLines: 1 ,),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
        actions: [
          TextButton.icon(
              onPressed: () {
                _showDateRangeDialog();
              },
              icon: Icon(Icons.date_range_sharp
              ),
              label: Text('Tarih Seç',style: TextStyle(fontSize: 12,color: Colors.white),maxLines: 1,)
          ,),
        ],

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _tarihsecilmedi == true ? AutoSizeText('Tarih Seçilmedi',style: TextStyle(fontSize: 15,color: Colors.red),maxLines: 1,) :
                        AutoSizeText('${_secilenstartday}.${_secilenstartmonth}.${_secilenstartyear} - ${_secilenendday}.${_secilenendmonth}.${_secilenendyear}',style: TextStyle(fontSize: 15,color: Colors.blue.shade700,),maxLines: 1,)
                  ],
                ),
              
            _tarihsecilmedi == false && veriyok == true && _testcounter == 0 ? const Center(child: AutoSizeText("Bu tarih için veri bulunamadı..", style: TextStyle(fontSize: 18, color: Colors.black),maxLines: 1,),) :
                _tarihsecilmedi == true ? const Center(child: AutoSizeText('Lütfen tarih seçin',style: TextStyle(fontSize: 25,color: Colors.black,),maxLines: 1,),) :
            Expanded(
              child:
              RawScrollbar(
                thickness: 10.0,

                thumbColor: Colors.red,
                minOverscrollLength: 15,
                minThumbLength: 50,
                radius: Radius.circular(10),
                controller: _controller,
                child:
                ListView.builder(
                  reverse: false,
                  controller: _controller,
                  itemCount: _testcounter,
                  itemBuilder: (context, index){

                    if (list1[index]['day'] != null) {
                      if (list1[index]['day'] < 10) {
                        _day = '0${list1[index]['day']}';
                      }
                      else if (list1[index]['day'] >= 10) {
                        _day = '${list1[index]['day']}';
                      }
                    }
                    if (list1[index]['month'] != null) {
                      if (list1[index]['month'] < 10) {
                        _month = '0${list1[index]['month']}';
                      }
                      else if (list1[index]['month'] >= 10) {
                        _month = '${list1[index]['month']}';
                      }
                    }
                    if (list1[index]['min'] != null) {
                      if (list1[index]['min'] < 10) {
                        _min = '0${list1[index]['min']}';
                      }
                      else if (list1[index]['min'] >= 10) {
                        _min = '${list1[index]['min']}';
                      }
                    }
                    if (list1[index]['hour'] != null) {
                      if (list1[index]['hour'] < 10) {
                        _hour = '0${list1[index]['hour']}';
                      }
                      else if (list1[index]['hour'] >= 10) {
                        _hour = '${list1[index]['hour']}';
                      }
                    }
                    if (list1[index]['D130'] != null) {
                      adlema_1 = list1[index]['D130'];
                    }
                    if (list1[index]['D133'] != null) {
                      adlema_2 = list1[index]['D133'];
                    }
                    if (list1[index]['D136'] != null) {
                      adlema_3 = list1[index]['D136'];
                    }
                    if (list1[index]['D139'] != null) {
                      adlema_4 = list1[index]['D139'];
                    }

                    _detailDialog() async {
                      showDialog(context: context, builder: (context) =>
                          AlertDialog(

                            title: Text('Test Ayrıntıları',style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reçete Ayarları',style: TextStyle(fontSize: 12,color: Colors.blue.shade700, fontWeight: FontWeight.bold),maxLines: 1,),
                                Divider(thickness: 1, color: Colors.red,),
                                Text(list1[index]['D145'] == 1 ? 'Reçete Tipi: Çubuklu' : list1[index]['D145'] == 2 ? 'Reçete Tipi: Çubuksuz' : 'Reçete Tipi: ?',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Reçete Kodu:\t${(list1[index]['D122'] * 65536) + (list1[index]['D121'])}',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Ürün Boyu:\t${list1[index]['D142']}\tmm',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Ön Dolum Süresi:\t${list1[index]['D123'].toDouble()/10.00}\tsn',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Dolum Süresi:\t${list1[index]['D124'].toDouble()/10.00}\tsn',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Stabilizasyon Süresi:\t${list1[index]['D125'].toDouble()/10.00}\tsn',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Test Süresi:\t${list1[index]['D144'].toDouble()/10.00}\tsn',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Ön Basınç:\t${list1[index]['D126']}\tmbar',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Test Basıncı:\t${list1[index]['D127']}\tmbar',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                Text('Max Dta:\t${list1[index]['D128'].toDouble()/100.00}\tmbar',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                                SizedBox(height: 5,),
                                Text('Sonuçlar',style: TextStyle(fontSize: 12,color: Colors.blue.shade700 , fontWeight: FontWeight.bold),maxLines: 1,),
                                Divider(thickness: 1, color: Colors.red,),
                                Text('Kanal 1 ve 2', style: TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      list1[index]['D130'] == 0 || list1[index]['D130'] == 1
                                          ? 'OK'
                                          : list1[index]['D130'] == 2 ||
                                          list1[index]['D130'] == 3 ||
                                          list1[index]['D130'] == 4
                                          ? 'NOK'
                                          : list1[index]['D130'] ==
                                          5 || list1[index]['D130'] == 6
                                          ? 'RE'
                                          : list1[index]['D130'] == 10
                                          ? '-'
                                          : '?',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:  list1[index]['D130'] == 0 ||
                                        list1[index]['D130'] == 1
                                        ? Colors.green
                                        :  list1[index]['D130'] == 2 ||
                                        list1[index]['D130'] == 3 ||
                                        list1[index]['D130'] == 4
                                        ? Colors.red
                                        :  list1[index]['D130'] == 5 ||
                                        list1[index]['D130'] == 6
                                        ? Colors.yellow
                                        .shade700
                                        :  list1[index]['D130'] == 10
                                        ? Colors.blueAccent
                                        : Colors
                                        .blueAccent),maxLines: 1,),
                                    Text('/',style: TextStyle(fontSize: 15, color: Colors.black),maxLines: 1,),
                                    Text(
                                      list1[index]['D130'] == 0 || list1[index]['D130'] == 2
                                          ? 'OK'
                                          : list1[index]['D130'] == 1 ||
                                          list1[index]['D130'] == 3 ||
                                          list1[index]['D130'] == 5
                                          ? 'NOK'
                                          : list1[index]['D130'] ==
                                          4 || list1[index]['D130'] == 6
                                          ? 'RE'
                                          : list1[index]['D130'] == 10
                                          ? '-'
                                          : '?',
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                                          color: list1[index]['D130'] == 0 ||
                                              list1[index]['D130'] == 2
                                              ? Colors.green
                                              : list1[index]['D130'] == 1 ||
                                              list1[index]['D130'] == 3 ||
                                              list1[index]['D130'] == 5
                                              ? Colors.red
                                              : list1[index]['D130'] == 4 ||
                                              list1[index]['D130'] == 6
                                              ? Colors.yellow
                                              .shade700
                                              : list1[index]['D130'] == 10
                                              ? Colors.blueAccent
                                              : Colors
                                              .blueAccent),
                                    ),
                                    SizedBox(width: 5,),
                                    list1[index]['D130'] != 10 ? FittedBox(
                                      child:
                                      Text('${list1[index]['D131']
                                          .toDouble() /
                                          100.00}\tmbar',
                                        style: TextStyle(fontSize: 12),),
                                    ) : Text('-', style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black),
                                      maxLines: 1,),
                                  ],
                                ),
                                Text('Kanal 3 ve 4', style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      list1[index]['D133'] == 0 || list1[index]['D133'] == 1
                                          ? 'OK'
                                          : list1[index]['D133'] == 2 ||
                                          list1[index]['D133'] == 3 ||
                                          list1[index]['D133'] == 4
                                          ? 'NOK'
                                          : list1[index]['D133'] ==
                                          5 || list1[index]['D133'] == 6
                                          ? 'RE'
                                          : list1[index]['D133'] == 10
                                          ? '-'
                                          : '?',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:  list1[index]['D133'] == 0 ||
                                        list1[index]['D133'] == 1
                                        ? Colors.green
                                        :  list1[index]['D133'] == 2 ||
                                        list1[index]['D133'] == 3 ||
                                        list1[index]['D133'] == 4
                                        ? Colors.red
                                        :  list1[index]['D133'] == 5 ||
                                        list1[index]['D133'] == 6
                                        ? Colors.yellow
                                        .shade700
                                        :  list1[index]['D133'] == 10
                                        ? Colors.blueAccent
                                        : Colors
                                        .blueAccent),maxLines: 1,),
                                    Text('/',style: TextStyle(fontSize: 15, color: Colors.black),maxLines: 1,),
                                    Text(
                                      list1[index]['D133'] == 0 || list1[index]['D133'] == 2
                                          ? 'OK'
                                          : list1[index]['D133'] == 1 ||
                                          list1[index]['D133'] == 3 ||
                                          list1[index]['D133'] == 5
                                          ? 'NOK'
                                          : list1[index]['D133'] ==
                                          4 || list1[index]['D133'] == 6
                                          ? 'RE'
                                          : list1[index]['D133'] == 10
                                          ? '-'
                                          : '?',
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                                          color: list1[index]['D133'] == 0 ||
                                              list1[index]['D133'] == 2
                                              ? Colors.green
                                              : list1[index]['D133'] == 1 ||
                                              list1[index]['D133'] == 3 ||
                                              list1[index]['D133'] == 5
                                              ? Colors.red
                                              : list1[index]['D133'] == 4 ||
                                              list1[index]['D133'] == 6
                                              ? Colors.yellow
                                              .shade700
                                              : list1[index]['D133'] == 10
                                              ? Colors.blueAccent
                                              : Colors
                                              .blueAccent),
                                    ),
                                    SizedBox(width: 10,),
                                    list1[index]['D133'] != 12 ? FittedBox(
                                      child:
                                      Text('${list1[index]['D134']
                                          .toDouble() /
                                          100.00}\tmbar',
                                        style: TextStyle(fontSize: 12),),
                                    ) : Text('-', style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black),
                                      maxLines: 1,),
                                  ],
                                ),
                                SizedBox(width: 5,),
                                Text('Kanal 5 ve 6', style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      list1[index]['D136'] == 0 || list1[index]['D136'] == 1
                                          ? 'OK'
                                          : list1[index]['D136'] == 2 ||
                                          list1[index]['D136'] == 3 ||
                                          list1[index]['D136'] == 4
                                          ? 'NOK'
                                          : list1[index]['D136'] ==
                                          5 || list1[index]['D136'] == 6
                                          ? 'RE'
                                          : list1[index]['D136'] == 10
                                          ? '-'
                                          : '?',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:  list1[index]['D136'] == 0 ||
                                        list1[index]['D136'] == 1
                                        ? Colors.green
                                        :  list1[index]['D136'] == 2 ||
                                        list1[index]['D136'] == 3 ||
                                        list1[index]['D136'] == 4
                                        ? Colors.red
                                        :  list1[index]['D136'] == 5 ||
                                        list1[index]['D136'] == 6
                                        ? Colors.yellow
                                        .shade700
                                        :  list1[index]['D136'] == 10
                                        ? Colors.blueAccent
                                        : Colors
                                        .blueAccent),maxLines: 1,),
                                    Text('/',style: TextStyle(fontSize: 15, color: Colors.black),maxLines: 1,),
                                    Text(
                                      list1[index]['D136'] == 0 || list1[index]['D136'] == 2
                                          ? 'OK'
                                          : list1[index]['D136'] == 1 ||
                                          list1[index]['D136'] == 3 ||
                                          list1[index]['D136'] == 5
                                          ? 'NOK'
                                          : list1[index]['D136'] ==
                                          4 || list1[index]['D136'] == 6
                                          ? 'RE'
                                          : list1[index]['D136'] == 10
                                          ? '-'
                                          : '?',
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                                          color: list1[index]['D136'] == 0 ||
                                              list1[index]['D136'] == 2
                                              ? Colors.green
                                              : list1[index]['D136'] == 1 ||
                                              list1[index]['D136'] == 3 ||
                                              list1[index]['D136'] == 5
                                              ? Colors.red
                                              : list1[index]['D136'] == 4 ||
                                              list1[index]['D136'] == 6
                                              ? Colors.yellow
                                              .shade700
                                              : list1[index]['D136'] == 10
                                              ? Colors.blueAccent
                                              : Colors
                                              .blueAccent),
                                    ),
                                    SizedBox(width: 5,),
                                    list1[index]['D136'] != 10 ? FittedBox(
                                      child:
                                      Text('${list1[index]['D137']
                                          .toDouble() /
                                          100.00}\tmbar',
                                        style: TextStyle(fontSize: 12),),
                                    ) : Text('-', style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black),
                                      maxLines: 1,),
                                  ],
                                ),
                                Text('Kanal 7 ve 8', style: TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      list1[index]['D139'] == 0 || list1[index]['D139'] == 1
                                          ? 'OK'
                                          : list1[index]['D139'] == 2 ||
                                          list1[index]['D139'] == 3 ||
                                          list1[index]['D139'] == 4
                                          ? 'NOK'
                                          : list1[index]['D139'] ==
                                          5 || list1[index]['D139'] == 6
                                          ? 'RE'
                                          : list1[index]['D139'] == 10
                                          ? '-'
                                          : '?',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:  list1[index]['D139'] == 0 ||
                                        list1[index]['D139'] == 1
                                        ? Colors.green
                                        :  list1[index]['D139'] == 2 ||
                                        list1[index]['D139'] == 3 ||
                                        list1[index]['D139'] == 4
                                        ? Colors.red
                                        :  list1[index]['D139'] == 5 ||
                                        list1[index]['D139'] == 6
                                        ? Colors.yellow
                                        .shade700
                                        :  list1[index]['D139'] == 10
                                        ? Colors.blueAccent
                                        : Colors
                                        .blueAccent),maxLines: 1,),
                                    Text('/',style: TextStyle(fontSize: 15, color: Colors.black),maxLines: 1,),
                                    Text(
                                      list1[index]['D139'] == 0 || list1[index]['D139'] == 2
                                          ? 'OK'
                                          : list1[index]['D139'] == 1 ||
                                          list1[index]['D139'] == 3 ||
                                          list1[index]['D139'] == 5
                                          ? 'NOK'
                                          : list1[index]['D139'] ==
                                          4 || list1[index]['D139'] == 6
                                          ? 'RE'
                                          : list1[index]['D139'] == 10
                                          ? '-'
                                          : '?',
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                                          color: list1[index]['D139'] == 0 ||
                                              list1[index]['D139'] == 2
                                              ? Colors.green
                                              : list1[index]['D139'] == 1 ||
                                              list1[index]['D139'] == 3 ||
                                              list1[index]['D139'] == 5
                                              ? Colors.red
                                              : list1[index]['D139'] == 4 ||
                                              list1[index]['D139'] == 6
                                              ? Colors.yellow
                                              .shade700
                                              : list1[index]['D139'] == 10
                                              ? Colors.blueAccent
                                              : Colors
                                              .blueAccent),
                                    ),
                                    SizedBox(width: 10,),
                                    list1[index]['D139'] != 10 ? FittedBox(
                                      child:
                                      Text('${list1[index]['D140']
                                          .toDouble() /
                                          100.00}\tmbar',
                                        style: TextStyle(fontSize: 12),),
                                    ) : Text('-', style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black),
                                      maxLines: 1,),
                                  ],
                                ),
                                Divider(thickness: 0.5,color: Colors.red,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Sıcaklık:\t${list1[index]['t'].toDouble()/10.00}°C',style: TextStyle(fontSize: 12,color: Colors.blue.shade700),maxLines: 1,),
                                    SizedBox(width: 15,),
                                    Text('Nem:\t${list1[index]['h'].toDouble()/10.00}%',style: TextStyle(fontSize: 12,color: Colors.blue.shade700),maxLines: 1,),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Saat:\t${list1[index]['hour']}.${list1[index]['min']}',style: TextStyle(fontSize: 12,color: Colors.blue.shade700),maxLines: 1,),
                                    SizedBox(width: 15,),
                                    Text('Tarih:\t${_day}.${_month}.${list1[index]['year']}',style: TextStyle(fontSize: 12,color: Colors.blue.shade700),maxLines: 1,),
                                  ],
                                ),


                                FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('images/img_kaslogo.png',height: MediaQuery.of(context).size.height * 0.065,filterQuality: FilterQuality.medium,),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text('TAMAM ',style: TextStyle(fontSize: 15, color: Colors.blue.shade700),maxLines: 1,),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                              ),
                            ],
                          ),
                      );
                    }
                    //////////////////NULLL CONTROLLLLLLL/////////////////////////////(
                    if(
                    list1[index]['D121'] == null || list1[index]['D122'] == null  ||  list1[index]['D123'] == null ||
                        list1[index]['D124'] == null || list1[index]['D125'] == null ||list1[index]['D126'] == null || list1[index]['D127'] == null ||
                        list1[index]['D128'] == null ||list1[index]['D130'] == null ||list1[index]['D131'] == null || list1[index]['D133'] == null ||
                        list1[index]['D134'] == null || list1[index]['D136'] == null || list1[index]['D137'] == null || list1[index]['D139'] == null ||
                        list1[index]['D140'] == null || list1[index]['D142'] == null || list1[index]['D144'] == null || list1[index]['D145'] == null ||
                        list1[index]['day'] == null || list1[index]['h'] == null ||list1[index]['hour'] == null || list1[index]['min'] == null ||
                        list1[index]['month'] == null ||list1[index]['orderid'] == null || list1[index]['t'] == null || list1[index]['uid'] == null ||
                        list1[index]['year'] == null ) {return Column(children: [Divider(thickness: 1,color: Colors.green,),CircularProgressIndicator()],);}
                    else {
                      return ListTile(
                        tileColor: Colors.white70,
                        dense: true,
                        onTap: () {
                          _detailDialog();
                        },
                        title:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Divider(thickness: 2, color: Colors.red,),
                            Text('${index + 1}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Container(
                                  width: width * 0.35,
                                  child: FittedBox(
                                    child: Text(
                                      'Uzunluk:${list1[index]['D142']}\tmm',
                                      style: const TextStyle(
                                          fontSize: 25,
                                          color: Colors.black),
                                      maxLines: 1,),
                                  ),
                                ),
                                Container(
                                  width: width * 0.35,
                                  child: FittedBox(
                                    child:
                                     Column(
                                       children: [
                                         Text(
                                           'Reçete Kodu:\t${(list1[index]['D122'] * 65536) + (list1[index]['D121'])}',
                                           style: const TextStyle(
                                               fontSize: 25,
                                               color: Colors.black),
                                           maxLines: 1,),
                                         Text(list1[index]['D145'] == 1 ? 'Reçete Tipi: Çubuklu' : list1[index]['D145'] == 2 ? 'Reçete Tipi: Çubuksuz' : 'Reçete Tipi: ?',style: TextStyle(fontSize: 20,color: Colors.black),maxLines: 1,),

                                       ],
                                     ),

                                  ),
                                ),
                              ],
                            ),
                           SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ///////////////////////////////////////////ADLEMA 1////////////////////////////////////////////////////
                                Container(
                                  height: 180,
                                  width: width * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      FittedBox(child: Text('1',
                                        style: TextStyle(fontSize: 30,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,),),
                                      FittedBox(child: Icon(
                                        Icons.tablet_outlined, size: 50,
                                        color: Colors.black,),),
                                      FittedBox(
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              adlema_1 == 0 || adlema_1 == 1
                                                  ? 'OK'
                                                  : adlema_1 == 2 ||
                                                  adlema_1 == 3 ||
                                                  adlema_1 == 4
                                                  ? 'NOK'
                                                  : adlema_1 ==
                                                  5 || adlema_1 == 6
                                                  ? 'RE'
                                                  : adlema_1 == 10
                                                  ? '-'
                                                  : '?',
                                              style: TextStyle(fontSize: 25,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: adlema_1 == 0 ||
                                                      adlema_1 == 1
                                                      ? Colors.green
                                                      : adlema_1 == 2 ||
                                                      adlema_1 == 3 ||
                                                      adlema_1 == 4
                                                      ? Colors.red
                                                      : adlema_1 == 5 ||
                                                      adlema_1 == 6
                                                      ? Colors.yellow
                                                      .shade700
                                                      : adlema_1 == 10
                                                      ? Colors.blueAccent
                                                      : Colors
                                                      .blueAccent),),
                                            const Text(
                                              '/', style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black),
                                              maxLines: 1,),
                                            Text(
                                              adlema_1 == 0 || adlema_1 == 2
                                                  ? 'OK'
                                                  : adlema_1 == 1 ||
                                                  adlema_1 == 3 ||
                                                  adlema_1 == 5
                                                  ? 'NOK'
                                                  : adlema_1 ==
                                                  4 || adlema_1 == 6
                                                  ? 'RE'
                                                  : adlema_1 == 10
                                                  ? '-'
                                                  : '?',
                                              style: TextStyle(fontSize: 25,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: adlema_1 == 0 ||
                                                      adlema_1 == 2
                                                      ? Colors.green
                                                      : adlema_1 == 1 ||
                                                      adlema_1 == 3 ||
                                                      adlema_1 == 5
                                                      ? Colors.red
                                                      : adlema_1 == 4 ||
                                                      adlema_1 == 6
                                                      ? Colors.yellow
                                                      .shade700
                                                      : adlema_1 == 10
                                                      ? Colors.blueAccent
                                                      : Colors
                                                      .blueAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                      adlema_1 != 10 ? FittedBox(
                                        child:
                                        Text('${list1[index]['D131']
                                            .toDouble() /
                                            100.00}\nmbar',
                                          style: TextStyle(fontSize: 15),),
                                      ) : Text('-', style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black),
                                        maxLines: 1,),
                                    ],
                                  ),
                                ),
                                ///////////////////////////////////////////ADLEMA 2////////////////////////////////////////////////////
                                Container(
                                  height: 180,
                                  width: width * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      FittedBox(child: Text('2',
                                        style: TextStyle(fontSize: 30,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,),),
                                      FittedBox(child: Icon(
                                        Icons.tablet_outlined, size: 50,
                                        color: Colors.black,),),
                                      FittedBox(
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              adlema_2 == 0 || adlema_2 == 1
                                                  ? 'OK'
                                                  : adlema_2 == 2 ||
                                                  adlema_2 == 3 ||
                                                  adlema_2 == 4
                                                  ? 'NOK'
                                                  : adlema_2 ==
                                                  5 || adlema_2 == 6
                                                  ? 'RE'
                                                  : adlema_2 == 10
                                                  ? '-'
                                                  : '?',
                                              style: TextStyle(fontSize: 25,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: adlema_2 == 0 ||
                                                      adlema_2 == 1
                                                      ? Colors.green
                                                      : adlema_2 == 2 ||
                                                      adlema_2 == 3 ||
                                                      adlema_2 == 4
                                                      ? Colors.red
                                                      : adlema_2 == 5 ||
                                                      adlema_2 == 6
                                                      ? Colors.yellow
                                                      .shade700
                                                      : adlema_2 == 10
                                                      ? Colors.blueAccent
                                                      : Colors
                                                      .blueAccent),),
                                            const Text(
                                              '/', style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black),
                                              maxLines: 1,),
                                            Text(
                                              adlema_2 == 0 || adlema_2 == 2
                                                  ? 'OK'
                                                  : adlema_2 == 1 ||
                                                  adlema_2 == 3 ||
                                                  adlema_2 == 5
                                                  ? 'NOK'
                                                  : adlema_2 ==
                                                  4 || adlema_2 == 6
                                                  ? 'RE'
                                                  : adlema_2 == 10
                                                  ? '-'
                                                  : '?',
                                              style: TextStyle(fontSize: 25,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: adlema_2 == 0 ||
                                                      adlema_2 == 2
                                                      ? Colors.green
                                                      : adlema_2 == 1 ||
                                                      adlema_2 == 3 ||
                                                      adlema_2 == 5
                                                      ? Colors.red
                                                      : adlema_2 == 4 ||
                                                      adlema_2 == 6
                                                      ? Colors.yellow
                                                      .shade700
                                                      : adlema_2 == 10
                                                      ? Colors.blueAccent
                                                      : Colors
                                                      .blueAccent),),
                                          ],
                                        ),
                                      ),
                                      adlema_2 != 10 ? FittedBox(
                                        child:
                                        Text('${list1[index]['D134']
                                            .toDouble() /
                                            100.00}\nmbar',
                                          style: TextStyle(fontSize: 15),),
                                      ) : Text('-', style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black),
                                        maxLines: 1,),
                                    ],
                                  ),

                                ),
                                ///////////////////////////////////////////ADLEMA 3////////////////////////////////////////////////////
                                Container(
                                  height: 180,
                                  width: width * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      FittedBox(child: Text('3',
                                        style: TextStyle(fontSize: 30,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,),),
                                      FittedBox(child: Icon(
                                        Icons.tablet_outlined, size: 50,
                                        color: Colors.black,),),
                                      FittedBox(
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              adlema_3 == 0 || adlema_3 == 1
                                                  ? 'OK'
                                                  : adlema_3 == 2 ||
                                                  adlema_3 == 3 ||
                                                  adlema_3 == 4
                                                  ? 'NOK'
                                                  : adlema_3 ==
                                                  5 || adlema_3 == 6
                                                  ? 'RE'
                                                  : adlema_3 == 10
                                                  ? '-'
                                                  : '?',
                                              style: TextStyle(fontSize: 25,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: adlema_3 == 0 ||
                                                      adlema_3 == 1
                                                      ? Colors.green
                                                      : adlema_3 == 2 ||
                                                      adlema_3 == 3 ||
                                                      adlema_3 == 4
                                                      ? Colors.red
                                                      : adlema_3 == 5 ||
                                                      adlema_3 == 6
                                                      ? Colors.yellow
                                                      .shade700
                                                      : adlema_3 == 10
                                                      ? Colors.blueAccent
                                                      : Colors
                                                      .blueAccent),),
                                            const Text(
                                              '/', style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black),
                                              maxLines: 1,),
                                            Text(
                                              adlema_3 == 0 || adlema_3 == 2
                                                  ? 'OK'
                                                  : adlema_3 == 1 ||
                                                  adlema_3 == 3 ||
                                                  adlema_3 == 5
                                                  ? 'NOK'
                                                  : adlema_3 ==
                                                  4 || adlema_3 == 6
                                                  ? 'RE'
                                                  : adlema_3 == 10
                                                  ? '-'
                                                  : '?',
                                              style: TextStyle(fontSize: 25,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: adlema_3 == 0 ||
                                                      adlema_3 == 2
                                                      ? Colors.green
                                                      : adlema_3 == 1 ||
                                                      adlema_3 == 3 ||
                                                      adlema_3 == 5
                                                      ? Colors.red
                                                      : adlema_3 == 4 ||
                                                      adlema_3 == 6
                                                      ? Colors.yellow
                                                      .shade700
                                                      : adlema_3 == 10
                                                      ? Colors.blueAccent
                                                      : Colors
                                                      .blueAccent),),
                                          ],
                                        ),
                                      ),
                                      adlema_3 != 10 ? FittedBox(
                                        child:
                                        Text('${list1[index]['D137']
                                            .toDouble() /
                                            100.00}\nmbar',
                                          style: TextStyle(fontSize: 15),),
                                      ) : Text('-', style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black),
                                        maxLines: 1,),
                                    ],
                                  ),
                                ),
                                ///////////////////////////////////////////ADLEMA 4////////////////////////////////////////////////////
                                Container(
                                  height: 180,
                                  width: width * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      FittedBox(child: Text('4',
                                        style: TextStyle(fontSize: 30,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,),),
                                      FittedBox(child: Icon(
                                        Icons.tablet_outlined, size: 50,
                                        color: Colors.black,),),
                                      FittedBox(
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              adlema_4 == 0 || adlema_4 == 1
                                                  ? 'OK'
                                                  : adlema_4 == 2 ||
                                                  adlema_4 == 3 ||
                                                  adlema_4 == 4
                                                  ? 'NOK'
                                                  : adlema_4 ==
                                                  5 || adlema_4 == 6
                                                  ? 'RE'
                                                  : adlema_4 == 10
                                                  ? '-'
                                                  : '?',
                                              style: TextStyle(fontSize: 25,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: adlema_4 == 0 ||
                                                      adlema_4 == 1
                                                      ? Colors.green
                                                      : adlema_4 == 2 ||
                                                      adlema_4 == 3 ||
                                                      adlema_4 == 4
                                                      ? Colors.red
                                                      : adlema_4 == 5 ||
                                                      adlema_4 == 6
                                                      ? Colors.yellow
                                                      .shade700
                                                      : adlema_4 == 10
                                                      ? Colors.blueAccent
                                                      : Colors
                                                      .blueAccent),),
                                            const Text(
                                              '/', style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black),
                                              maxLines: 1,),
                                            Text(
                                              adlema_4 == 0 || adlema_4 == 2
                                                  ? 'OK'
                                                  : adlema_4 == 1 ||
                                                  adlema_4 == 3 ||
                                                  adlema_4 == 5
                                                  ? 'NOK'
                                                  : adlema_4 ==
                                                  4 || adlema_4 == 6
                                                  ? 'RE'
                                                  : adlema_4 == 10
                                                  ? '-'
                                                  : '?',
                                              style: TextStyle(fontSize: 25,
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: adlema_4 == 0 ||
                                                      adlema_4 == 2
                                                      ? Colors.green
                                                      : adlema_4 == 1 ||
                                                      adlema_4 == 3 ||
                                                      adlema_4 == 5
                                                      ? Colors.red
                                                      : adlema_4 == 4 ||
                                                      adlema_4 == 6
                                                      ? Colors.yellow
                                                      .shade700
                                                      : adlema_4 == 10
                                                      ? Colors.blueAccent
                                                      : Colors
                                                      .blueAccent),),
                                          ],
                                        ),
                                      ),
                                      adlema_4 != 10 ? FittedBox(
                                        child:
                                        Text('${list1[index]['D140']
                                            .toDouble() /
                                            100.00}\nmbar',
                                          style: TextStyle(fontSize: 15),),
                                      ) : Text('-', style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black),
                                        maxLines: 1,),

                                    ],
                                  ),
                                ),
                              ],

                            ),

                          ],
                        ),


                        subtitle: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Container(
                                width: width * 0.2,
                                child: Column(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        'Tarih:${_day}/${_month}/${list1[index]['year']}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.brown),
                                        maxLines: 1,),
                                    ),
                                    FittedBox(
                                      child: Text('Saat:${_hour}.${_min}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.brown),
                                        maxLines: 1,),
                                    ),
                                  ],
                                ),
                              ),
                              Container(width: width * 0.2,),
                              Container(
                                width: width * 0.2,
                                child: Column(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        'Sıcaklık:${list1[index]['t']
                                            .toDouble() /
                                            10.00}°C', style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueAccent),
                                        maxLines: 1,),
                                    ),
                                    FittedBox(
                                      child: Text('Nem:${list1[index]['h']
                                          .toDouble() /
                                          10.00}%', style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueAccent),
                                        maxLines: 1,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(width: 5,),
                    Text('OK:${_okUrun}',style: TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold),maxLines: 1,),
                  ],
                ),
                Text('NOK:${_nokUrun}',style: TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),maxLines: 1,),
                Text('RE:${_reURUN}',style: TextStyle(fontSize: 15, color: Colors.yellow.shade700, fontWeight: FontWeight.bold),maxLines: 1,),
                Row(
                  children: [
                    Text('Toplam Test:${_testcounter}',style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),maxLines: 1,),
                    SizedBox(width: 5,),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
      floatingActionButton:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(padding: EdgeInsets.only(left: 25,bottom: 10),
            child:
            FloatingActionButton(
              onPressed: () {
                    if(_tarihsecilmedi == false ) {
                      _showQuestionDialog(context);
                    }
                    else {
                       var _snackbar = SnackBar(
                        content: Text('Tarih Seçmediniz !'),
                        action: SnackBarAction(
                          label: 'Tamam',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
                    }
              },
              backgroundColor: Color(0xff283773),
              child: Padding(
                padding: EdgeInsets.all(7),
                child: Image(image: AssetImage('images/excel_icon.png',),filterQuality: FilterQuality.low,),
              ),
            ) ,
          ),
          _searchopened == true ?
          Container(
            color: Colors.white,
            height: _tekrarTestChecked == true || _cubukluChecked == true || _cubuksuzChecked == true || _searchController.text.isNotEmpty  ? height* 0.35 : height* 0.30 ,
            width: width * 0.42,
            child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _tekrarTestChecked == true || _cubukluChecked == true || _cubuksuzChecked == true || _searchController.text.isNotEmpty ?
                          TextButton.icon(onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _tekrarTestChecked = false;
                              _cubuksuzChecked = false;
                              _cubukluChecked = false;
                              _buildShowDialog(context);
                              _getDatasforDates();
                            });
                          }, icon: Icon(Icons.clear,size: 20,color: Colors.red,), label: Text('Temizle',style: TextStyle(fontSize: 15,color: Colors.lightBlue,),maxLines: 1,),) : SizedBox(width: 5,),
                          CheckboxListTile(
                            tristate: false,
                            title: Text('Çubuklu',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _cubukluChecked,
                            onChanged: (newBool){
                              setState(() {
                                if(_tarihsecilmedi == false) {
                                  _cubukluChecked = newBool;
                                  _buildShowDialog(context);
                                  _searchController.clear();
                                  _getDatasforDates();
                                }
                                else {
                                  var _snackbar = SnackBar(
                                    content: Text('Tarih Seçmediniz !'),
                                    action: SnackBarAction(
                                      label: 'Tamam',
                                      onPressed: () {
                                        // Some code to undo the change.
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(_snackbar);
                                }
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.black,
                          ),
                          CheckboxListTile(
                            tristate: false,
                            title: Text('Çubuksuz',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _cubuksuzChecked,
                            onChanged: (newBool){
                              setState(() {
                                  if(_tarihsecilmedi == false) {
                                    _cubuksuzChecked = newBool;
                                    _buildShowDialog(context);
                                    _searchController.clear();
                                    _getDatasforDates();
                                  }
                                  else {
                                    var _snackbar = SnackBar(
                                      content: Text('Tarih Seçmediniz !'),
                                      action: SnackBarAction(
                                        label: 'Tamam',
                                        onPressed: () {
                                          // Some code to undo the change.
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(_snackbar);
                                  }
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.black,
                          ),
                          CheckboxListTile(
                            tristate: false,
                            title: Text('Tekrar Testleri',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _tekrarTestChecked,
                            onChanged: (newBool){
                              setState(() {
                                    if(_tarihsecilmedi == false ) {
                                      _tekrarTestChecked = newBool;
                                      _buildShowDialog(context);
                                      _searchController.clear();
                                      _getDatasforDates();
                                    }
                                    else {
                                      var _snackbar = SnackBar(
                                        content: Text('Tarih Seçmediniz !'),
                                        action: SnackBarAction(
                                          label: 'Tamam',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
                                    }
                              });
                            },
                            activeColor: Colors.green,
                            checkColor: Colors.black,
                          ),

                        ],
                      ),

                    Padding(
                      padding: EdgeInsets.all(1),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        style:  TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                        autofocus: false,
                        controller: _searchController,
                        decoration: InputDecoration(
                          fillColor: Colors.white70,
                          hintText: 'Uzunluk ile Ara',
                          hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                          suffixIcon: Icon(Icons.code),
                          suffixIconColor: Colors.blue.shade700,
                          border:  OutlineInputBorder(),
                        ),
                        onChanged: (String value) {

                          if(_tarihsecilmedi == false) {
                            _searchFilter();
                          }
                        },
                      ),
                    ),
                  ],
                ),
          ) : SizedBox(width: 0.01,),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                FloatingActionButton(
                  backgroundColor : _searchController.text.trim().isEmpty && _cubukluChecked == false && _cubuksuzChecked == false && _tekrarTestChecked == false ? Color(0xff283773) : Colors.green  ,
                  onPressed: (){
                    setState(() {
                      if(_tarihsecilmedi == false) {
                        _searchopened = !_searchopened;
                      }
                      else {
                        var _snackbar = SnackBar(
                          content: Text('Tarih Seçmediniz !'),
                          action: SnackBarAction(
                            label: 'Tamam',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(_snackbar);
                      }

                    });
                  },
                  child: Icon(Icons.search,size: 35,color: Colors.white,),
                ),
                SizedBox(width: 5,),
                FloatingActionButton(
                  backgroundColor: Color(0xff283773),
                  onPressed: () {
                    if(_tarihsecilmedi == false) {
                      _buildShowDialog(context);
                      _getDatasforDates();
                    }
                  },
                  child: Icon(Icons.refresh,size: 35,color: Colors.white,),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const drawer_menu(),
    );

  }
}



