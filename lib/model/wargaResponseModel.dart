// To parse this JSON data, do
//
//     final wargaResponseModel = wargaResponseModelFromJson(jsonString);

import 'dart:convert';

WargaResponseModel wargaResponseModelFromJson(String str) =>
    WargaResponseModel.fromJson(json.decode(str));

String wargaResponseModelToJson(WargaResponseModel data) =>
    json.encode(data.toJson());

class WargaResponseModel {
  WargaResponseModel({
    required this.data,
  });

  List<Datum> data;

  factory WargaResponseModel.fromJson(Map<String, dynamic> json) =>
      WargaResponseModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.nik,
    required this.namaWarga,
    required this.alamat,
    required this.noHp,
    required this.fotoKtp,
    required this.idKelurahan,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String nik;
  String namaWarga;
  String alamat;
  String noHp;
  String fotoKtp;
  int idKelurahan;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nik: json["nik"],
        namaWarga: json["nama_warga"],
        alamat: json["alamat"],
        noHp: json["no_hp"],
        fotoKtp: json["foto_ktp"],
        idKelurahan: json["id_kelurahan"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nik": nik,
        "nama_warga": namaWarga,
        "alamat": alamat,
        "no_hp": noHp,
        "foto_ktp": fotoKtp,
        "id_kelurahan": idKelurahan,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
