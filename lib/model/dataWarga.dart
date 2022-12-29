// To parse this JSON data, do
//
//     final dataWarga = dataWargaFromJson(jsonString);

import 'dart:convert';

DataWarga dataWargaFromJson(String str) => DataWarga.fromJson(json.decode(str));

String dataWargaToJson(DataWarga data) => json.encode(data.toJson());

class DataWarga {
  DataWarga({
    required this.mojopanggung,
    required this.giri,
    required this.boyolangu,
    required this.grogol,
    required this.penataban,
    required this.jembersari,
    required this.jumlahWarga,
  });

  int mojopanggung;
  int giri;
  int boyolangu;
  int grogol;
  int penataban;
  int jembersari;
  int jumlahWarga;

  factory DataWarga.fromJson(Map<String, dynamic> json) => DataWarga(
        mojopanggung: json["mojopanggung"],
        giri: json["giri"],
        boyolangu: json["Boyolangu"],
        grogol: json["Grogol"],
        penataban: json["Penataban"],
        jembersari: json["Jembersari"],
        jumlahWarga: json["jumlahWarga"],
      );

  Map<String, dynamic> toJson() => {
        "mojopanggung": mojopanggung,
        "giri": giri,
        "Boyolangu": boyolangu,
        "Grogol": grogol,
        "Penataban": penataban,
        "Jembersari": jembersari,
        "jumlahWarga": jumlahWarga,
      };
}
