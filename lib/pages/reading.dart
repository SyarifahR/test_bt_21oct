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
    refresh_itemlist(displaylist);
  }

  refresh_itemlist(Box<dynamic> displaylist){
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
                Text('Date: ',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 1.0,
                    fontSize: 14.0,
                  ),
                ),
                Text('Time: ',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 1.0,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GOOD',
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
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child:
                          CircleAvatar(
                            radius: 60.0,
                          ),
                          // Image.asset(
                          //   'assets/images/tiger.jfif',
                          //   height: 200,
                          //   width: 400,
                          //   fit: BoxFit.fitWidth,
                          // ),
                        ),
                        SizedBox(height: 50.0),
                      ],
                    ),
                    SizedBox(width: 40.0),
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
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '80',
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
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '67',
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
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '34',
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
                                // Text(
                                //   '/min ',
                                //   style: TextStyle(
                                //     color: Colors.grey[400],
                                //     letterSpacing: 2.0,
                                //     fontSize: 14.0,
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '65',
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
