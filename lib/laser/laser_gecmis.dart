import 'package:beta_flex/laser/laser_drawer_menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class laser_gecmis extends StatefulWidget {
  const laser_gecmis({super.key});

  @override
  State<laser_gecmis> createState() => _laser_gecmisState();
}

class _laser_gecmisState extends State<laser_gecmis> {
  bool _circularprogress  = false;
  final ScrollController _controller = ScrollController();
  final DatabaseReference dbreft =
      FirebaseDatabase.instance.ref().child('laser').child('kayitlar');
  String _secilentarihday = DateTime.now().day.toString();
  String _secilentarihmonth = DateTime.now().month.toString();
  String _secilentarihyear = DateTime.now().year.toString();

  bool _tarihsecilmedi = true;
  bool _dataYok = true;

  Map<dynamic, dynamic> map1 = <dynamic, dynamic> {};
  List<dynamic> list1 = [];

  @override
  void initState() {
    super.initState();
    _getTempDatas();

  }

  @override
  void dispose() {
    super.dispose();

  }

  Future<void> _showDateDialog() async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    ).then((value) {
      setState(() {
        _secilentarihday = value!.day.toString();
        _secilentarihmonth = value!.month.toString();
        _secilentarihyear = value!.year.toString();
        _tarihsecilmedi = false;
        setState(() {
          list1.clear();
        });
        _getTempDatas();
      });
    });
  }

  Future<void> _getTempDatas() async {
    _circularprogress = true;


    final snapshot = await dbreft.child(_secilentarihday).get();

    if(snapshot.exists) {
          setState(() {
            map1.clear();
            list1.clear();
            map1 = snapshot.value as dynamic;
            final y = map1.values.where((element) =>
            element['day'].toString().startsWith(_secilentarihday) &&
                element['month'].toString().startsWith(_secilentarihmonth) &&
                element['year'].toString().startsWith(_secilentarihyear)
            );

            list1.addAll(y);
            list1 = list1..sort((a, b) => b['orderid'].compareTo(a['orderid']));
            _dataYok = false;
          });
    }
    else {
      setState(() {
        map1.clear();
        list1.clear();
        _dataYok = true;
      });
    }

    if(_circularprogress = true) {
      _circularprogress = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sıcaklık Geçmişi',
          style: TextStyle(fontSize: 15, color: Colors.white),
          maxLines: 1,
        ),
        centerTitle: true,
        backgroundColor: Color(0xff283773),
        actions: [
          TextButton.icon(
            onPressed: () {
              _showDateDialog();
            },
            icon: Icon(Icons.date_range_sharp
            ),
            label: Text('Tarih Seç',style: TextStyle(fontSize: 12,color: Colors.white),maxLines: 1,)
            ,),
        ],
      ),
      drawer: laser_drawer_menu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10,),
                Text('Saat',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
              ],),
              Text('S1',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
              Text('S2',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
              Text('S3',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
              Text('S4',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
              Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('S5',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 1,),
                SizedBox(width: 10,),
              ],),
            ],
          ),
          Divider(
            color: Colors.red,
            thickness: 2,
          ),
          _circularprogress == true ? Center(child: CircularProgressIndicator(),) :
          _dataYok == true && _circularprogress == false ? Center(child: Text('VERİ YOK'),) :
          Expanded(
            child: RawScrollbar(
              thickness: 10.0,
              thumbColor: Colors.red,
              minOverscrollLength: 15,
              minThumbLength: 50,
              radius: Radius.circular(10),
              controller: _controller,
              child: ListView.builder(
                reverse: false,
                controller: _controller,
                itemCount: list1.length,
                itemBuilder: (context, index) {
                  String _min ;
                  String _hour;
                  if(list1[index]['min'] < 10) {_min = '0${list1[index]['min']}';}
                  else{_min = list1[index]['min'].toString();}
                  if(list1[index]['hour'] < 10) {_hour = '0${list1[index]['hour']}';}
                  else{_hour = list1[index]['hour'].toString();}
                    return ListTile(
                      title:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${_hour}.${_min}',
                                style: TextStyle(fontSize: 15, color: Colors.blue),
                                maxLines: 1,),
                              Text((list1[index]['t1'].toDouble() / 10.00)
                                  .toString(),
                                style: TextStyle(fontSize: 15, color: Colors.black),
                                maxLines: 1,),
                              Text((list1[index]['t2'].toDouble() / 10.00)
                                  .toString(),
                                style: TextStyle(fontSize: 15, color: Colors.black),
                                maxLines: 1,),
                              Text((list1[index]['t3'].toDouble() / 10.00)
                                  .toString(),
                                style: TextStyle(fontSize: 15, color: Colors.black),
                                maxLines: 1,),
                              Text((list1[index]['t4'].toDouble() / 10.00)
                                  .toString(),
                                style: TextStyle(fontSize: 15, color: Colors.black),
                                maxLines: 1,),
                              Text((list1[index]['t5'].toDouble() / 10.00)
                                  .toString(),
                                style: TextStyle(fontSize: 15, color: Colors.black),
                                maxLines: 1,),
                            ],
                          ),
                          Divider(thickness: 1,color: Colors.blue,),
                        ],
                      ),
                    );

                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_secilentarihday}.${_secilentarihmonth}.${_secilentarihyear}',style: TextStyle(fontSize: 20,color: Colors.blue),maxLines: 1,),
            ],
          ),
        ],

      ),
    );
  }
}
