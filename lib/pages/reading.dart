import 'package:flutter/material.dart';
import 'package:test_bt/pages/home.dart';
import 'package:test_bt/pages/history.dart';
import 'package:test_bt/pages/route_generator.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Reading extends StatefulWidget {
  Box displaylist;
  Reading({Key? key, required this.displaylist}) : super(key: key);

  @override
  State<Reading> createState() => _ReadingState(displaylist);
}

class _ReadingState extends State<Reading> {

  late Box displaylist;
  _ReadingState(this.displaylist);
  List<Map<String,dynamic>> Current_DisplayList = [];

  @override
  initState() {
    super.initState();
    refresh_displaylist(displaylist);
  }

  refresh_displaylist(Box<dynamic> displaylist){
    final final_displaylist = displaylist.keys.map((key) {
      final value = displaylist.get(key);
      // return {"key": key, "no": value['no'], "date": value['date'], "time": value['time'], "sys": value["sys"], "dia": value['dia'], "mean": value['mean'], "pr": value['pr']};
      return {"key": key, "date": value['date'], "time": value['time'], "sys": value["sys"], "dia": value['dia'], "mean": value['mean'], "pr": value['pr']};
    }).toList();
    setState(() {
      Current_DisplayList = final_displaylist.toList();
      // items = data_bp.reversed.toList();
    });

  }


  @override
  Widget build(BuildContext context) {

    int last_index = displaylist.length - 1;
    Map<String,dynamic> latest_reading = Current_DisplayList[last_index];
    String latest_date = '0';
    String latest_time = '0';
    String latest_sys = '0';
    String latest_dia = '0';
    String latest_mean = '0';
    String latest_pr = '0';
    var sys = 0;
    var dia = 0;

    var reading = latest_reading.entries.map((e){
      return e.value;
    }).toList();

    if (reading != null){
      latest_date = reading[1].toString();
      latest_time = reading[2].toString();
      latest_sys = reading[3].toString();
      latest_dia = reading[4].toString();
      latest_mean = reading[5].toString();
      latest_pr = reading[6].toString();
      sys = int.parse(latest_sys);
      dia = int.parse(latest_dia);
    }

    String level = '';
    if(sys < 90 || dia < 60){
    level = 'LOW';
    }else if(sys < 120 && dia < 80){
      level = 'NORMAL';
    }else if(sys < 140 || dia < 90){
      level = 'PREHYPERTENSION';
    }else if(sys < 140 || dia < 89){
      level = 'HYPERTENSION (Stage 1)';
    }else if(sys > 140 || dia >= 90){
      level = 'HYPERTENSION (Stage 2)';
    }else if(sys > 180 || dia > 120){
      level = 'HYPERTENSION (Emergency)';
    }else{
      level = '-------';
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text('BP_01000019',style: TextStyle(color: Colors.white,letterSpacing:1.0,fontWeight: FontWeight.bold,fontSize: 20.0)),
        centerTitle: true,
        leading: Transform.scale(
          scale: 1.1,
          child: IconButton(
            icon: Icon(Icons.exit_to_app_rounded, color: Colors.white,),
            onPressed: (){
              Navigator.pushNamed(context, '/home');
              // displaylist.deleteAt(last_index);
            },
          ),
        ),
        leadingWidth: 80,
        backgroundColor: Colors.blue[800],
        elevation: 30.0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.of(context).pushNamed('/history', arguments: displaylist);
        },
        label: Text('HISTORY'),
        backgroundColor: Colors.lightBlue[800],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Date: ' + latest_date,
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 1.0,
                    fontSize: 14.0,
                  ),
                ),
                Text('Time: ' + latest_time,
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 1.0,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      level,
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2.0,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 6.0,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: <Widget>[
                                Text(
                                  'SYS',
                                  style: TextStyle(
                                    color: Colors.grey[100],
                                    fontSize: 18.0,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                Text(
                                  'mmHG',
                                  style: TextStyle(
                                    color: Colors.grey[100],
                                    fontSize: 12.0,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 60.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  latest_sys,
                                  style: TextStyle(
                                    color: Colors.yellow[400],
                                    fontSize: 46.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: <Widget>[
                                Text(
                                  'DIA',
                                  style: TextStyle(
                                    color: Colors.grey[100],
                                    fontSize: 18.0,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                Text(
                                  'mmHG',
                                  style: TextStyle(
                                    color: Colors.grey[100],
                                    fontSize: 12.0,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 60.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  latest_dia,
                                  style: TextStyle(
                                    color: Colors.yellow[400],
                                    fontSize: 46.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 40.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: <Widget>[
                                Text(
                                  'PUL',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  '/min ',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    letterSpacing: 2.0,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 60.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  latest_pr,
                                  style: TextStyle(
                                    color: Colors.purple[200],
                                    letterSpacing: 2.0,
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: <Widget>[
                                Text(
                                  'MEAN',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    letterSpacing: 2.0,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 60.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  latest_mean,
                                  style: TextStyle(
                                    color: Colors.purple[200],
                                    letterSpacing: 2.0,
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
