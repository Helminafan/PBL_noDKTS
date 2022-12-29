import 'dart:convert';

import 'package:banksampah/Home.dart';
import 'package:banksampah/form.dart';
import 'package:banksampah/model/dataWarga.dart';
import 'package:banksampah/model/loginResponModel.dart';
import 'package:banksampah/viewWarga.dart';
import 'package:banksampah/formdata.dart';
import 'package:banksampah/data/MyColor.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:http/http.dart' as myHttp;

class menu extends StatefulWidget {
  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  @override
  int selectedItem = 0;
  List<Widget> listWidget = <Widget>[
    CounterPage(),
    MultiContactFormWidget(),
    View(),
  ];

  static get contactModel => null;

  static get onRemove => null;
  void onTap(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: listWidget.elementAt(selectedItem),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.green,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.add, title: 'Tambah'),
            TabItem(icon: Icons.map, title: 'Penduduk'),
          ],
          onTap: onTap,
        ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> name, token;
  DataWarga? dataWarga;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
    token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  Future getData() async {
    final Map<String, String> headres = {
      'Authorization': 'Bearer ' + await token
    };
    var response = await myHttp.get(
        Uri.parse('http://127.0.0.1:8000/api/dataPenduduk'),
        headers: headres);
    dataWarga = DataWarga.fromJson(json.decode(response.body));
    return dataWarga;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green,
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: Icon(Icons.home, color: Colors.white),
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                        ),
                        title: Text("Home"),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.refresh, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                dataWarga!.jumlahWarga;
                                dataWarga!.boyolangu;
                              });
                            },
                          ),
                        ]),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Text(
                            "Daftar Grafik Warga Miskin",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            height: 170,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              color: Colors.white,
                              elevation: 1,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: SfCartesianChart(
                                // Initialize category axis
                                primaryXAxis: CategoryAxis(),
                                series: <ColumnSeries<SalesData, String>>[
                                  ColumnSeries<SalesData, String>(
                                      // Bind data source
                                      dataSource: <SalesData>[
                                        SalesData(
                                            'Mojo',
                                            double.parse(dataWarga!.mojopanggung
                                                .toString())),
                                        SalesData(
                                            'Giri',
                                            double.parse(
                                                dataWarga!.giri.toString())),
                                        SalesData(
                                            'Boyo',
                                            double.parse(dataWarga!.boyolangu
                                                .toString())),
                                        SalesData(
                                            'Pena',
                                            double.parse(dataWarga!.penataban
                                                .toString())),
                                        SalesData(
                                            'Jembe',
                                            double.parse(dataWarga!.jembersari
                                                .toString())),
                                        SalesData(
                                            'Grogol',
                                            double.parse(
                                                dataWarga!.grogol.toString())),
                                      ],
                                      xValueMapper: (SalesData sales, _) =>
                                          sales.year,
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.sales,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Data Penduduk",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(181, 182, 181, 1),
                                          blurRadius: 20,
                                          offset: Offset(0, 1))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 70,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Kecamatan",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          FutureBuilder(
                                              future: name,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                    snapshot.data!,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  );
                                                } else {
                                                  return Text(
                                                    "-",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  );
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(181, 182, 181, 1),
                                          blurRadius: 20,
                                          offset: Offset(0, 1))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 70,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Jumlah Warga Miskin",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            dataWarga!.jumlahWarga.toString() +
                                                " Org",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(181, 182, 181, 1),
                                          blurRadius: 20,
                                          offset: Offset(0, 1))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 70,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Jumlah Kecamatan",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "6 Kecamatan",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
