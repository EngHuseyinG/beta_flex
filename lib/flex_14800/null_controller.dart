import 'package:beta_flex/flex_14800/drawer_menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class null_controller extends StatefulWidget {
  const null_controller({super.key});

  @override
  State<null_controller> createState() => _null_controllerState();
}





class _null_controllerState extends State<null_controller> {
final DatabaseReference dbrefs = FirebaseDatabase.instance.ref().child('14800').child('sonuclar');
Map<dynamic, dynamic> _map1 = <dynamic, dynamic> {};
List<dynamic> _list1 = [];
TextEditingController _searchController = TextEditingController();




@override
  void initState() {
    super.initState();

    _listenDatasOnce();

}


@override
  void dispose() {
    super.dispose();

}


    _listenDatasOnce() async {
      _map1.clear();
      final snapshot = await dbrefs.child(_searchController.text.toString()).get();
      if(snapshot.exists) {
        _map1 =  snapshot.value as dynamic;

          setState(() {
            _list1.clear();
            _map1.forEach((key, value) {
                  if(
                      _map1[key]['D121'] == null ||
                      _map1[key]['D122'] == null ||
                      _map1[key]['D123'] == null ||
                      _map1[key]['D124'] == null ||
                      _map1[key]['D125'] == null ||
                      _map1[key]['D126'] == null ||
                      _map1[key]['D127'] == null ||
                      _map1[key]['D128'] == null ||

                      _map1[key]['D130'] == null ||
                      _map1[key]['D131'] == null ||

                      _map1[key]['D133'] == null ||
                      _map1[key]['D134'] == null ||

                      _map1[key]['D136'] == null ||
                      _map1[key]['D137'] == null ||

                      _map1[key]['D139'] == null ||
                      _map1[key]['D140'] == null ||

                      _map1[key]['D142'] == null ||
                      _map1[key]['D144'] == null ||
                      _map1[key]['D145'] == null ||


                      _map1[key]['day'] == null ||
                      _map1[key]['h'] == null ||
                      _map1[key]['hour'] == null ||
                      _map1[key]['min'] == null ||
                      _map1[key]['month'] == null ||
                      _map1[key]['orderid'] == null ||
                      _map1[key]['t'] == null ||
                      _map1[key]['uid'] == null ||
                      _map1[key]['year'] == null ) {
                      _list1.add(_map1[key]['uid']);
                    }

            });
          });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Null Controller'),
        centerTitle: true,
      ),
      body: Text(_list1.toString()),




      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 5,),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,

                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                        hintText: 'Ara',
                    ),
                  ),
                ),
              ),

          Padding(
              padding: EdgeInsets.all(5),
              child: FloatingActionButton(
                onPressed: () { _listenDatasOnce(); },
                child: Icon(Icons.refresh,color: Colors.white,size: 35,),
              )
          ),
        ],
      ),


      drawer: drawer_menu(),
    );




  }
}



/*


D120 = Test Sonucu var mı yok mu dinleme
D121/D122 = Reçetede ki Urun Kodu
D123 = Adlema Ön dolum Süresi
D124 = Adlema Doldurma Süresi
D125 = Adlema Stabilizasyon Süresi
D126 = Adlema Ön Dolum Basıncı
D127 = Test Basıncı
D128/D129 = Reçete Max Kaçak Değeri*100
D130 = Adlema 1 Sonuc
D131/ D132 = Adlema 1 Kaçan Değer
D133 = Adlema 2 Sonuc
D134/D135 = Adlema 2 Kaçan Değer
D136 = Adlema 3 Sonuc
D137/D138 = Adlema 3 Kaçan Değer
D139 = Adlema 4 Sonuc
D140/D141 = Adlema 4 Kaçan Değer
D142/D143 = Urun Boyu
D144 = Test Süresi
D145 =  Reçete Grup No
D146/D147 = Reserv

*/