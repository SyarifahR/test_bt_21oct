import 'package:flutter/material.dart';
import 'package:test_bt/pages/reading.dart';
import 'package:test_bt/pages/history.dart';
import 'package:test_bt/pages/route_generator.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  String stateText = 'Connecting';
  String connectButtonText = 'Disconnect';
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  StreamSubscription<BluetoothDeviceState>? _stateListener;
  List<BluetoothService> bluetoothService = [];
  Map <String, List<int>> notifyDatas = {};
  final boxA = Hive.box('boxA');
  final boxB = Hive.box('boxB');
  List<ScanResult> scanResultList = [];
  late BluetoothDevice device;
  List<Map<String, dynamic>> itemsA = [];
  List<Map<String, dynamic>> itemsB = [];
  String device_name = '';
  String device_channel = '';
  String device_characteristic = '';
  bool _isScanning = false;
  bool record = false;
  bool record_again = true;
  bool duplicate = false;
  bool reset = true;
  bool increment = true;
  late FToast fToast;

  @override
  initState() {
    super.initState();
    initBle();
    refreshA();
    refreshB();
    fToast = FToast();
    fToast.init(context);
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  scan() async {
    if (!_isScanning) {
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
        setState(() {});
        for(ScanResult item in scanResultList){
          String name = 'BP_01000019';
          if(item.device.name == name){
            device_name = item.device.name;
            device = item.device;
            connect();
            _stateListener = device.state.listen((event) {
              debugPrint('event :  $event');
              if (deviceState == event) {
                return;
              }
              // setBleConnectionState(event);
              // connect();
            });
          }
        }
      });
      // for(ScanResult item in scanResultList){
      //   String name = 'BP_01000019';
      //   if(item.device.name == name){
      //     device_name = item.device.name;
      //     device = item.device;
      //     _stateListener = device.state.listen((event) {
      //       debugPrint('event :  $event');
      //       if (deviceState == event) {
      //         return;
      //       }
      //       setBleConnectionState(event);
      //       connect();
      //     });
      //   }
      // }
    } else {
      flutterBlue.stopScan();
    }
  }

  void refreshA() {
    final data_A = boxA.keys.map((key) {
      final value = boxA.get(key);
      return {"key": key, "device": value['device'], "date": value['date'], "time": value['time'], "sys": value["sys"], "dia": value['dia'], "mean": value['mean'], "pr": value['pr']};
    }).toList();
    int last_index = boxA.length - 1;
    // Map<String, dynamic> last_item = data_A.toList()[last_index];
    // Map<String, dynamic> sec_last_item = data_A.toList()[last_index-1];
    // if (last_item[3] != sec_last_item[3] && last_item[4] != sec_last_item[4]){
    //   boxA.deleteAt(last_index);
    //   print(boxA.toMap());
    // }
    setState(() {
      itemsA = data_A.toList();
      // items = data_bp.reversed.toList();
    });
  }

  void refreshB() {
    final data_B = boxB.keys.map((key) {
      final value = boxB.get(key);
      return {"key": key, "device": value['device'], "date": value['date'], "time": value['time'], "hex_data": value['hex_data']};
    }).toList();
    // int last_index = boxB.length -1;
    // Map<String, dynamic> last_item = data_B.toList()[last_index];
    // Map<String, dynamic> sec_last_item = data_B.toList()[last_index-1];
    // if (last_item[3] != sec_last_item[3] && last_item[4] != sec_last_item[4]){
    //   boxB.deleteAt(last_index);
    //   print(boxB.toMap());
    // }
    setState(() {
      itemsB = data_B.toList();
      // items = data_bp.reversed.toList();
    });
  }

  Future<void> InjectA (Map<String, dynamic> newItemA) async {
    record = false;
    record_again = false;

    // int old_lengthA = boxA.length;
    // print(old_lengthA);

    if(!duplicate){
      await boxA.add(newItemA);
      // int new_lengthA = boxA.length;
      // print(new_lengthA);
      refreshA();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data has been added')));
      duplicate = true;
    }else if (duplicate){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Already added before')));
    }

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
  void dispose() {
    _stateListener?.cancel();
    disconnect();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  setBleConnectionState(BluetoothDeviceState event) {
    switch (event) {
      case BluetoothDeviceState.disconnected:
        stateText = 'Disconnected';
        // connectButtonText = 'Connect';
        break;
      case BluetoothDeviceState.disconnecting:
        stateText = 'Disconnecting';
        break;
      case BluetoothDeviceState.connected:
        stateText = 'Connected';
        // connectButtonText = 'Disconnect';
        break;
      case BluetoothDeviceState.connecting:
        stateText = 'Connecting';
        break;
    }
    deviceState = event;
    setState(() {});
  }

  Future<bool> connect() async {

    Future<bool>? returnValue;
    setState(() {
      stateText = 'Connecting';
    });

    await device
        .connect(autoConnect: false)
        .timeout(Duration(milliseconds: 15000),
        onTimeout: () {
      returnValue = Future.value(false);
      debugPrint('timeout failed');
      setBleConnectionState(BluetoothDeviceState.disconnected);
    }).then((data) async {
      bluetoothService.clear();
      if (returnValue == null) {
        debugPrint('connection successful');
        print('start discover service');
        List<BluetoothService> bleServices = await device.discoverServices();
        setState((){
          bluetoothService = bleServices;
          for(BluetoothService item in bluetoothService){
            String channel = '00001810-0000-1000-8000-00805f9b34fb';
            if(item.uuid.toString() == channel){
              device_channel = item.uuid.toString();
              bluetoothService = [item];
              showToast();
              // device_characteristic = item.characteristics.toString();
              // characteristicInfo();
            }
          }
        });
        for (BluetoothService service in bluetoothService){
          print('============================================');
          print('Service UUID: ${service.uuid}');
          if (device_channel.isNotEmpty){
            for (BluetoothCharacteristic c in service.characteristics){
              // print('\tcharacteristic UUID: ${c.uuid.toString()}');
              // print('\t\twrite: ${c.properties.write}');
              // print('\t\tread: ${c.properties.read}');
              // print('\t\tnotify: ${c.properties.notify}');
              // print('\t\tisNotifying: ${c.isNotifying}');
              // print('\t\twriteWithoutResponse: ${c.properties.writeWithoutResponse}');
              // print('\t\tindicate: ${c.properties.indicate}');
              print(characteristicInfo(service));
              if (c.properties.notify && c.descriptors.isNotEmpty){
                for (BluetoothDescriptor d in c.descriptors){
                  print('BluetoothDescriptor uuid ${d.uuid}');
                  if (d.uuid == BluetoothDescriptor.cccd){
                    print('d.lastValue: ${d.lastValue}');
                  }
                }
                if (!c.isNotifying){
                  try {
                    await c.setNotifyValue(true);
                    notifyDatas[c.uuid.toString()] = List.empty();
                    c.value.listen((value){
                      print('${c.uuid}: $value');
                      setState(() {
                        notifyDatas[c.uuid.toString()] = value;
                      });
                    });
                    await Future.delayed(const Duration(milliseconds: 500));
                  } catch (e){
                    print('error ${c.uuid} $e');
                  }
                }
              }
            }
          }

        }
        returnValue = Future.value(true);
      }
    });
    return returnValue ?? Future.value(false);
  }

  void disconnect() {
    try {
      setState(() {
        stateText = 'Disconnecting';
      });
      device.disconnect();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
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
              SizedBox(height: 50.0),

              // Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             Text('$stateText'),
              //
              //             // OutlinedButton(
              //             //     onPressed: () {
              //             //       if (deviceState == BluetoothDeviceState.connected) {
              //             //         disconnect();
              //             //       } else if (deviceState == BluetoothDeviceState.disconnected) {
              //             //         connect();
              //             //       }
              //             //     },
              //             //     child: Text(connectButtonText)),
              //
              //           ],
              //         ),
              //       ],
              //     )
              //   // child: CircleAvatar(
              //   //   // backgroundImage: AssetImage('assets/images/zoo.jfif'),
              //   //   radius: 80.0,
              //   //   backgroundColor: Colors.grey,
              //   // ),
              // ),

              SizedBox(height: 50.0),
              // Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Text('Before start: \n\nTurn on your phone`s Bluetooth\n& BP Scanner',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(fontSize:18, color: Colors.white, fontWeight: FontWeight.w300,
              //             shadows: [
              //               Shadow(
              //                 offset: Offset(2.0, 2.0),
              //                 blurRadius: 2.0,
              //                 color: Colors.white.withOpacity(0.1),
              //               ),
              //             ])
              //       ),
              //     ]),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue[800],
        // this creates a notch in the center of the bottom bar
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              },
            ),
            const SizedBox(
              width: 80,
            ),
            IconButton(
              icon: const Icon(
                Icons.list_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/reading', arguments: boxA);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(

        onPressed: scan,
        label: _isScanning? Text('\t\t\t\t\t\t\t\t$stateText\t\t\t\t\t\t\t\t') : Text('\t\t\t\t\t\t\t\tSCAN\t\t\t\t\t\t\t\t'),
        backgroundColor: Colors.blueGrey[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: Text("Succesfully paired with BP Monitor"),
    );

    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 3),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 480.0,
            left: 76.0,
          );
        }
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Before start:'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("1. Turn on your phone`s Bluetooth \n\t\t\t\t\t& BP Scanner.\n\n2. Scan until the pairing success."),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          // textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget? characteristicInfo(BluetoothService r) {
    String name = '';
    String properties = '';
    String data = '';

    for (BluetoothCharacteristic c in r.characteristics) {
      properties = '';
      data = '';
      name += '\t\t${c.uuid}\n';
      if (c.properties.write) {
        properties += 'Write ';
      }
      if (c.properties.read) {
        properties += 'Read ';
      }
      if (c.properties.notify) {
        properties += 'Notify ';
        if (notifyDatas.containsKey(c.uuid.toString())){
          if (notifyDatas[c.uuid.toString()]!.isNotEmpty){
            data = notifyDatas[c.uuid.toString()].toString();
          }
        }
      }
      if (c.properties.writeWithoutResponse) {
        properties += 'WriteWR ';
      }
      if (c.properties.indicate) {
        properties += 'Indicate ';
      }
      name += '\t\t\tProperties: $properties\n';
      if (data.isNotEmpty){
        final List<String> dataList = data.split(",");
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        String device = device_name;
        String date = DateFormat('yyyy-MM-dd').format(tsdate);
        String time = DateFormat('HH:mm:ss').format(tsdate);
        String sys = dataList[1];
        String dia = dataList[3];
        String mean = dataList[5];
        String pr = dataList[14];
        name += '\t\t\t Device = ' + device + '\n';
        name += '\t\t\t Date = ' + date + '\n';
        name += '\t\t\t Time = ' + time + '\n';
        name += '\t\t\t Sys = ' + sys + '\n';
        name += '\t\t\t Dia = ' + dia + '\n';
        name += '\t\t\t Mean = ' + mean + '\n';
        name += '\t\t\t Pr = ' + pr + '\n';

        if (sys != dia){
          record = true;

          if (record && record_again && sys != dia ){
            InjectA({
              "device": device,
              "date": date,
              "time": time,
              "sys": sys,
              "dia": dia,
              "mean": mean,
              "pr": pr,
            });
            InjectB({
              "device": device,
              "date": date,
              "time": time,
              "hex_data": data,
            });
          }
        }else if(sys==dia){
          record_again = true;
          duplicate = false;
        }
      }
    }
    return Text(name);
    // return null;
  }
}
