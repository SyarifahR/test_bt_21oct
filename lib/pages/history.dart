import 'package:flutter/material.dart';
import 'package:test_bt/pages/home.dart';
import 'package:test_bt/pages/reading.dart';
import 'package:test_bt/pages/route_generator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class History extends StatefulWidget {
  Box itemlist;
  History({Key? key, required this.itemlist}) : super(key: key);

  @override
  State<History> createState() => _HistoryState(itemlist);
}

class _HistoryState extends State<History> {
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  // List<Map<String,dynamic>> month_list = [];
  List<Map<String,dynamic>> Current_ItemList = [];
  late Box itemlist;
  late Box monthSelected;
  _HistoryState(this.itemlist);
  bool sort = false;

  // final List<String> items = [
  //   'JANUARY',
  //   'FEBRUARY',
  //   'MARCH',
  //   'APRIL',
  //   'MAY',
  //   'JUNE',
  //   'JULY',
  //   'AUGUST',
  //   'SEPTEMBER',
  //   'OCTOBER',
  //   'NOVEMBER',
  //   'DICEMBER',
  // ];
  // String? selectedValue;
  // String? m;
  // late String  Jan = items[0];
  // late String  Feb = items[1];
  // late String  Mar = items[2];
  // late String  Apr = items[3];
  // late String  May = items[4];
  // late String  Jun = items[5];
  // late String  Jul = items[6];
  // late String  Aug = items[7];
  // late String  Sep = items[8];
  // late String  Oct = items[9];
  // late String  Nov = items[10];
  // late String  Dec = items[11];

  @override
  initState() {
    super.initState();
    refresh_itemlist(itemlist);
  }

  // List<Map<String,dynamic>> janlist = [
  //   {
  //     'no': 1,
  //     'date': '16/01/2022',
  //     'time' : 12.59,
  //     'sys': 65,
  //     'dia': 43,
  //     'mean': 77,
  //     'pr': 36,
  //   },
  //   {
  //     'no': 1,
  //     'date': '16/01/2022',
  //     'time' : 12.59,
  //     'sys': 65,
  //     'dia': 43,
  //     'mean': 77,
  //     'pr': 36,
  //   },
  // ];
  //
  // List<Map<String,dynamic>> feblist = [
  //   {
  //     'no': 2,
  //     'date': '22/02/2222',
  //     'time' : 15.22,
  //     'sys': 22,
  //     'dia': 22,
  //     'mean': 22,
  //     'pr': 22,
  //   },
  //   {
  //     'no': 2,
  //     'date': '22/02/2222',
  //     'time' : 15.22,
  //     'sys': 22,
  //     'dia': 22,
  //     'mean': 22,
  //     'pr': 22,
  //   },
  // ];
  //
  // int counter = 1;


  refresh_itemlist(Box<dynamic> itemlist){
    final final_itemlist = itemlist.keys.map((key) {
      final value = itemlist.get(key);
      // return {"key": key, "no": value['no'], "date": value['date'], "time": value['time'], "sys": value["sys"], "dia": value['dia'], "mean": value['mean'], "pr": value['pr']};
      return {"key": key, "date": value['date'], "time": value['time'], "sys": value["sys"], "dia": value['dia'], "mean": value['mean'], "pr": value['pr']};
    }).toList();
    if (sort == false){
      setState(() {
        // Current_ItemList = final_itemlist.toList();
        Current_ItemList = final_itemlist.reversed.toList();
      });
    }else if (sort == true){
      setState(() {
        Current_ItemList = final_itemlist.toList();
        // Current_ItemList = final_itemlist.reversed.toList();
      });
    }
  }

  // List<Map<String, dynamic>> selectedMonth (String month){
  //
  //   monthSelected = itemlist;
  //   List values = monthSelected.values.toList();
  //
  //   if (month == Jan){
  //     m = month as String;
  //     month_list = janlist;
  //     month_list = month_list + janlist;
  //   }
  //   else if (month == Feb){
  //     m = month as String ;
  //     month_list = feblist;
  //     month_list = month_list + feblist;
  //   }
  //   else if (month == Mar){
  //     m = month as String;
  //   }
  //   else if (month == Apr){
  //     m = month as String;
  //   }
  //   else if (month == May){
  //     m = month as String;
  //   }
  //   else if (month == Jun){
  //     m = month as String;
  //   }
  //   else if (month == Jul){
  //     m = month as String;
  //   }
  //   else if (month == Aug){
  //     m = month as String;
  //   }
  //   else if (month == Sep){
  //     m = month as String;
  //   }
  //   else if (month == Oct){
  //     m = month as String;
  //   }
  //   else if (month == Nov){
  //     m = month as String;
  //   }
  //   else if (month == Dec){
  //     m = month as String;
  //   }
  //
  //   return month_list;
  //   // return m.toString();
  // }


  @override
  Widget build(BuildContext context) {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String date = DateFormat('MMM').format(tsdate);//month in words
    int last_index = itemlist.length - 1;

    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text('HISTORY',style: TextStyle(color: Colors.white,letterSpacing:1.0,fontWeight: FontWeight.bold,fontSize: 20.0)),
        centerTitle: true,
        leading: Transform.scale(
          scale: 1.1,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pushNamed('/reading', arguments: itemlist);
            },
          ),
        ),
        leadingWidth: 80,
        backgroundColor: Colors.blue[800],
        elevation: 30.0,
      ),
      body: Padding(padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.sort_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              sort = true;
                            });
                          },
                        ),

                        // Text(
                        //   'MONTH : ',
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontSize: 15.0,
                        //     fontWeight: FontWeight.bold,
                        //     letterSpacing: 1.0,
                        //   ),
                        // ),
                        // SizedBox(width: 30.0),
                        // DropdownButtonHideUnderline(
                        //     child: DropdownButton2(
                        //       isExpanded: true,
                        //       hint: Row(
                        //         children: const[
                        //           Expanded(
                        //             child: Text(
                        //               'Select Month',
                        //               style: TextStyle(
                        //                   fontSize: 14,
                        //                   fontWeight: FontWeight.bold,
                        //                   color: Colors.black54),
                        //               overflow: TextOverflow.ellipsis,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       items: items.map((item)=> DropdownMenuItem<String>(
                        //         value: item,
                        //         child: Text(
                        //             item,
                        //             style: const TextStyle(
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Colors.black),
                        //             overflow: TextOverflow.ellipsis
                        //         ),
                        //       )).toList(),
                        //       value: selectedValue,
                        //       onChanged: (value){
                        //         setState(() {
                        //           selectedValue = value as String;
                        //         });
                        //         selectedMonth(selectedValue.toString());
                        //       },
                        //
                        //       icon: const Icon(Icons.arrow_forward_ios_outlined),
                        //       iconSize: 14,
                        //       iconEnabledColor: Colors.black54,
                        //       iconDisabledColor: Colors.red,
                        //       buttonHeight: 30,
                        //       buttonWidth: 140,
                        //       buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                        //       buttonDecoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(4),
                        //           border: Border.all(color: Colors.black26,),
                        //           color: Colors.white70),
                        //       buttonElevation: 10,
                        //       itemHeight: 40,
                        //       itemPadding: const EdgeInsets.only(left: 14, right: 14),
                        //       dropdownMaxHeight: 200,
                        //       dropdownWidth: 150,
                        //       dropdownPadding: null,
                        //       dropdownDecoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(8),
                        //           color: Colors.white60),
                        //       dropdownElevation: 1,
                        //       scrollbarRadius: const Radius.circular(40),
                        //       scrollbarThickness: 6,
                        //       scrollbarAlwaysShow: true,
                        //       offset: const Offset(0, 0),
                        //     )
                        // ),
                      ]
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  'NIBP RECORDS\t',
                  // 'NIBP RECORDS\t'+ m.toString(),
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child:
                    Container(
                      height: 380,
                      padding: const EdgeInsets.all(10),
                      color: Colors.blueGrey[50],
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                      child:
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child:
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Center(
                            child:
                            DataTable(
                              columnSpacing: 8,
                              horizontalMargin: 0,
                              dataRowHeight: 40,
                              showCheckboxColumn: false,

                              columns: [
                                // DataColumn(label: Expanded(child: Center(child: Text('NO.',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),)),
                                DataColumn(label: Expanded(child: Center(child: Text('DATE',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),)),
                                DataColumn(label: Expanded(child: Center(child: Text('TIME',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),)),
                                DataColumn(label: Expanded(child: Center(child: Text('SYSTOLIC\n/mmHG',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),)),
                                DataColumn(label: Expanded(child: Center(child: Text('DIASTOLIC\n/mmHG',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),)),
                                DataColumn(label: Expanded(child: Center(child: Text('MEAN',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),)),
                                DataColumn(label: Expanded(child: Center(child: Text('PULSE RATE\n/min',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),)),
                              ],
                              rows: Current_ItemList.map((e) => DataRow(
                                cells: [
                                  // DataCell(Container(width:25,child:Text(e['no'].toString(),style: TextStyle(fontSize: 12),textAlign: TextAlign.center))),
                                  DataCell(Container(width:70,child:Text(e['date'].toString(),style: TextStyle(fontSize: 12)))),
                                  DataCell(Container(width:40,child:Text(e['time'].toString(),style: TextStyle(fontSize: 12),textAlign: TextAlign.center))),
                                  DataCell(Container(width:70,child:Text(e['sys'].toString(),style: TextStyle(fontSize: 12),textAlign: TextAlign.center))),
                                  DataCell(Container(width:70,child:Text(e['dia'].toString(),style: TextStyle(fontSize: 12),textAlign: TextAlign.center))),
                                  DataCell(Container(width:70,child:Text(e['mean'].toString(),style: TextStyle(fontSize: 12),textAlign: TextAlign.center))),
                                  DataCell(Container(width:70,child:Text(e['pr'].toString(),style: TextStyle(fontSize: 12),textAlign: TextAlign.center))),
                                ],
                              ),).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text('Total Results: '+Current_ItemList.length.toString(),style: TextStyle(fontSize: 12),textAlign: TextAlign.center)]
                  )
                ],
              ),
            ]
        ),
      ),
    );
  }
}
