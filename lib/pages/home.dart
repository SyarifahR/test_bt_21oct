import 'package:flutter/material.dart';
import 'package:test_bt/pages/reading.dart';
import 'package:test_bt/pages/history.dart';
import 'package:test_bt/pages/route_generator.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final boxA = Hive.box('boxA');
  final boxB = Hive.box('boxB');
  List<Map<String, dynamic>> itemsA = [];
  List<Map<String, dynamic>> itemsB = [];
  bool record = false;
  bool record_again = true;
  bool duplicate = false;
  bool reset = true;

  bool increment = true;

  @override
  initState() {
    super.initState();
    refreshA();
    refreshB();
  }

  void refreshA() {
    final data_A = boxA.keys.map((key) {
      final value = boxA.get(key);
      return {"key": key, "no": value['no'], "date": value['date'], "time": value['time'], "sys": value["sys"], "dia": value['dia'], "mean": value['mean'], "pr": value['pr']};
    }).toList();
    setState(() {
      itemsA = data_A.toList();
      // items = data_bp.reversed.toList();
    });
    print(boxA.toMap());
    if (increment){
      InjectA({
        "no":'1',
        "date":'16/01/2022',
        "time":'12.59',
        "sys":'65',
        "dia":'43',
        "mean":'77',
        "pr":'36',
      });
      InjectB({
        "no":'2',
        "date":'22/02/2222',
        "time":'15.22',
        "hex_data":'2,2,2,2,2,2',
      });
      increment=false;
    }
  }

  void refreshB() {
    final data_B = boxB.keys.map((key) {
      final value = boxB.get(key);
      return {"key": key, "no": value['no'], "date": value['date'], "time": value['time'], "hex_data": value['hex_data']};
    }).toList();
    setState(() {
      itemsB = data_B.toList();
      // items = data_bp.reversed.toList();
    });
    print(boxB.toMap());
  }

  Future<void> InjectA (Map<String, dynamic> newItemA) async {

    await boxA.add(newItemA);
    refreshA();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data has been added')));
    // History(itemlist: newItemA);

    // ## Clearing the Database
    // await boxA.deleteAll(boxA.keys);
    // print(boxA.toMap());
    // ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Databases has been cleared')));
  }

  Future<void> InjectB(Map<String, dynamic> newItemB) async {

    await boxB.add(newItemB);
    refreshB();

    // ## Clearing the Database
    // await boxB.deleteAll(boxB.keys);
    // print(boxB.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.of(context).pushNamed('/reading', arguments: boxA);
        },
        label: Text('READY >>'),
        backgroundColor: Colors.lightBlue[800],
      ),
      body: SafeArea(
        child:
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(height: 10.0),
              Center(
                child: Text(
                  'BLOOD',
                  style: TextStyle(color: Colors.white,
                      fontSize: 40.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  'PRESSURE',
                  style: TextStyle(color: Colors.white,
                      fontSize: 40.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  'MONITOR',
                  style: TextStyle(color: Colors.white,
                      fontSize: 40.0,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: CircleAvatar(
                  // backgroundImage: AssetImage('assets/images/zoo.jfif'),
                  radius: 80.0,
                  backgroundColor: Colors.grey,
                ),
              ),
              SizedBox(height: 30.0),

              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Before start: \n\nTurn on your phone`s Bluetooth\n& BP Scanner',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize:18, color: Colors.white, fontWeight: FontWeight.w300,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 2.0,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ])
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
