class LariModel {
  final int? id;
  final DateTime mulai;
  final DateTime? selesai;

  LariModel({
    this.id,
    required this.mulai,
    this.selesai,
  });

  factory LariModel.fromJson(Map<String, dynamic> json) => LariModel(
        id: json['id'],
        mulai: DateTime.parse(json['mulai']),
        selesai: json['selesai'] == null ? null : DateTime.parse(json['selesai']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'mulai': mulai.toIso8601String(),
        'selesai': selesai?.toIso8601String(), 
      };
}