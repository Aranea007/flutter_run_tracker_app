class Run {
  String? id;
  String? runwhere;
  String? runperson;
  String? runImageUrl;
  int? runDistance;

  //สร้าง constructor สำหรับคลาส Run
  Run({
    this.id,
    this.runwhere,
    this.runperson,
    this.runImageUrl,
    this.runDistance,
  });

  //แปลงข้อมูลจาก supabase เพื่อมาใช้ใน flutter from json
  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      id: json['id'] as String?,
      runwhere: json['runwhere'] as String?,
      runperson: json['runperson'] as String?,
      runImageUrl: json['runImageUrl'] as String?,
      runDistance: json['runDistance'] as int?,
    );
  }

  //แปลงข้อมูลจาก flutter เพื่อไปเก็บใน supabase to json
  Map<String, dynamic> toJson() {
    return {
      //'id': id, อันนี้เอาออกเพราะเราใช้เป็นprimary keyหรือสร้างใหม่เองอยู่แล้ว
      'runwhere': runwhere,
      'runperson': runperson,
      'runImageUrl': runImageUrl,
      'runDistance': runDistance,
    };
  }
}