import 'dart:convert';
import 'dart:js';
import 'package:banksampah/model/wargaResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;

class View extends StatefulWidget {
  const View({super.key});
  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> token;
  WargaResponseModel? wargaResponseModel;
  List<Datum> miskin = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  Future getDataWarga() async {
    final Map<String, String> headres = {
      'Authorization': 'Bearer ' + await token
    };
    var response = await Http.get(
        Uri.parse('http://127.0.0.1:8000/api/view_mojopanggung'),
        headers: headres);
    wargaResponseModel =
        WargaResponseModel.fromJson(json.decode(response.body));
    wargaResponseModel!.data.forEach(
      (element) {
        miskin.add(element);
      },
    );
    return wargaResponseModel;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green,
        body: FutureBuilder(
            future: getDataWarga(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
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
                        title: Text("Data Penduduk"),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "search",
                                hintStyle: TextStyle(color: Colors.white),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  DataTable(
                                      columns: [
                                        DataColumn(
                                          label: Text('Nama'),
                                        ),
                                        DataColumn(
                                          label: Text('Alamat'),
                                        ),
                                        DataColumn(
                                          label: Text('NIK'),
                                        ),
                                        DataColumn(
                                          label: Text('No HP'),
                                        ),
                                      ],
                                      rows: miskin
                                          .map((e) => DataRow(cells: [
                                                DataCell(Text(e.namaWarga)),
                                                DataCell(Text(e.alamat)),
                                                DataCell(Text(e.nik)),
                                                DataCell(Text(e.noHp)),
                                              ]))
                                          .toList())
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
