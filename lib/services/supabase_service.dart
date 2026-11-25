import 'package:flutter_run_tracker_app/models/run.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*class SupabaseService {
อันนี้ใช้ได้แค่กับเครื่องandoir ทรศเลยจะแก้ใหม่
  //ก่อนจะทำงานใดๆ ให้สร้าง instance(object,ตัวแทน) ของsupabase เพื่อเรียกใช้ทำงานใดๆ
  final supabase = Supabase.instance.client;

  //1. method อัพโหลดรูปไปยัง Bucket ของ Supabase
 
  Future<String> uploadImageToSupabase(File imageFile) async {
   
    //ก่อนอัพโหลดให้สร้างชื่อไฟล์ใหม่เพื่อกันไม่ให้ชื่อไฟล์ซ้ำกัน เลยเอาวันที่มารวมด้วย
    //แล้วเก็บไว้ในตัวแปรในที่นี้ใช้ชื่อว่า newFileName
    final newFileName = "${DateTime.now}.millisecondsSinceEpoch_${imageFile.path.split('/').last}";
  
    //อัพโหลดไฟท์ที่ได้ไปยัง supabase
    await supabase.storage.from('run_bk').upload(newFileName, imageFile);
    
    //เอาที่อยู่ของไฟล์ที่อัปโหลดส่งกลับมา
    return supabase.storage.from('run_bk').getPublicUrl(newFileName);
  }

  //2. method เพิ่มข้อมูลไปยัง Table

  Future<void> insertRunDate(Run run) async {
    //สั่งให้insertที่ run_tb(ชื่อตาราง)
    await supabase.from('run_tb').insert(run.toJson());
  }

  //3. method ดึงข้อมูลทั้งหมดจาก Table


  //4. medthod แก้ไขข้อมูลใน Table

  //5. method ลบข้อมูลออกจาก Table
*/
class SupabaseService {
  //ก่อนจะทำงานใดๆ ให้สร้าง instance(object,ตัวแทน) ของsupabase เพื่อเรียกใช้ทำงานใดๆ
  final supabase = Supabase.instance.client;

  //1. method อัพโหลดรูปไปยัง Bucket ของ Supabase
 //ใช้file ไม่สามารถใข้ได้กับ web ต้องใช้Uint8List แทน
 //เลยไปใช้xfileแทน
  Future<String> uploadImageToSupabase(XFile imageFile) async {
   
    //ก่อนอัพโหลดให้สร้างชื่อไฟล์ใหม่เพื่อกันไม่ให้ชื่อไฟล์ซ้ำกัน เลยเอาวันที่มารวมด้วย
    //แล้วเก็บไว้ในตัวแปรในที่นี้ใช้ชื่อว่า newFileName
    final newFileName = "${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}";
  
    //อัพโหลดไฟท์ที่ได้ไปยัง supabase uploadเป็นไบนารี่ไฟลื
    await supabase.storage.from('run_bk').uploadBinary(
      newFileName,
      await imageFile.readAsBytes(),//อ่านไฟล์เป็นไบนารี่
      fileOptions: FileOptions(contentType: 'image/jpeg'),
    );
    
    //เอาที่อยู่ของไฟล์ที่อัปโหลดส่งกลับมา จากbucket run_bk
    return supabase.storage.from('run_bk').getPublicUrl(newFileName);
  }

  //2. method เพิ่มข้อมูลไปยัง Table

  Future<void> insertRunDate(Run run)//run คือ object ของ class Run ที่เราสร้างไว้ในไฟล์ run.dart และ Run มี method toJson() เพื่อแปลง object เป็น json
   async {
    //สั่งให้insertที่ run_tb(ชื่อตาราง)
    await supabase.from('run_tb').insert(run.toJson());//ที่toJson() คือการแปลงobject run เป็นjsonเพื่อส่งไปยังsupabase
  }

  //3. method ดึงข้อมูลทั้งหมดจาก Table
  Future<List<Run>> getAllRunData() async {
    final response = await supabase.from('run_tb').select('*');
    //แปลงข้อมูลที่ได้จากsupabaseเป็นList<Run>
    return (response as List).map((e) => Run.fromJson(e)).toList();
  }

  //4. medthod แก้ไขข้อมูลใน Table
  Future<void> updateRunData(Run run, String id) async {
    await supabase.from('run_tb').update(run.toJson()).eq('id', id);
  }

  //5. method ลบข้อมูลออกจาก Bucket ของ Supabase
  Future<void> deleteImageFromBucket(String fileName) async {
    await supabase.storage.from('run_bk').remove([fileName]);
  }

  //6. method ลบข้อมูลออกจาก Table
  Future<void> deleteRunData(String id) async {
    await supabase.from('run_tb').delete().eq('id', id);
  }
}
