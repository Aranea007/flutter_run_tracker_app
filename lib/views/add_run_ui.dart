import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/models/run.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_run_tracker_app/services/supabase_service.dart';

class AddRunUi extends StatefulWidget {
  const AddRunUi({super.key});

  @override
  State<AddRunUi> createState() => _AddRunUiState();
}

class _AddRunUiState extends State<AddRunUi> {
  /* //ตัวแปรไว้เก็บภาพจากการถ่ายรูปหรือ gallery
  File? imageFileSeleted;
  //สร้างmethod ของการเปิดกล้องเพื่อถ่ายรูป
  Future<void> selectImageFromCamera() async {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 80);
  //ตรวจสอบว่าได้ถ่ายรูปไหม
    if (pickImage != null) {
    setState(() {
      imageFileSeleted = File(pickImage.path);
    });
  }
  }
  //สร้างmethod ของการเปิดgallertเพื่อเลือกรูปภาพ
  Future<void> selectImageFromGallery() async {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 80);
  //ตรวจสอบว่าได้เลือกรูปไหม
    if (pickImage != null) {
      setState(() {
        imageFileSeleted = File(pickImage.path);
      });
    }
  }*/
  //คำสั่งเปิดกล้องหรือเปิดgallery
  Uint8List? imageByte; //ตัวแปรไว้เก็บภาพจากการถ่ายรูปหรือ gallery
  XFile? xFile; //ตัวแปรไว้เก็บภาพจากการถ่ายรูปหรือ gallery
  //สร้างmethod ของการเปิดกล้องเพื่อถ่ายรูป
// เมธอดเปิดกล้อง
  Future<void> openCameraAndTakePicture() async {
    //คำสั่งเปิดกล้องเพื่อถ่ายรูป
    final pickImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    //เอารูปที่ถ่ายไปกำหนดให้กับตัวแปรด้านบนที่สร้างไว้ แต่ต้องตรวจสอบก่อนว่าเขาถ่ายไหม
    if (pickImage != null) {
      final bytes = await pickImage.readAsBytes();
      if (!mounted) return;
      setState(() {
        imageByte = bytes;
        xFile = pickImage;
      });
    }
  }

  // เมธอดเปิดแกลอรี่
  Future<void> openGalleryAndSelectPicture() async {
    //คำสั่งเปิดแกลอรี่เพื่อเลือกรูป
    final pickImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    //เอารูปที่เลือกไปกำหนดให้กับตัวแปรด้านบนที่สร้างไว้ แต่ต้องตรวจสอบก่อนว่าเขาเลือกไหม
    if (pickImage != null) {
      final bytes = await pickImage.readAsBytes();
      if (!mounted) return;
      setState(() {
        imageByte = bytes;
        xFile = pickImage;
      });
    }
  }

  //ตัวควบคุมTextfield
  TextEditingController runWhereCtrl = TextEditingController();
  TextEditingController runPersonCtrl = TextEditingController();
  TextEditingController runDistanceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 43, 78),
        title: Text(
          'Run Tracker(เพิ่ม)',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      //body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 40, right: 40, top: 50),
          child: Center(
            child: Column(
              children: [
                //ใช้ ternary operator เพื่อตรวจสอบว่ามีการเลือกรูปภาพหรือยัง ถ้ายังให้แสดง icon add_a_photo แต่ถ้าเลือกรูปแล้วให้แสดงรูปที่เลือก
                //รูปแบบคือ condition ? true : false
                //ถ้าใช้แสดง? ไม่ แสดง :
                xFile == null
                    //InkWell จะมีกรอบให้เห็นด้วย
                    //หรือ gestureDetector จะไม่มีเอฟเฟคกรอบให้
                    // ทำให้อันที่กดไม่ได้สามารถกดได้
/*แสดงอันนี้ ? */ ? InkWell(
                        onTap: () {
                          //เปิดกล้องหรือเปิดgallery เพื่อเพิ่มรูปภาพ ซึ่งในที่นี้คือเราสร้างmethodไว้ชื่อว่า
                          openCameraAndTakePicture();
                        },
                        child: Icon(Icons.add_a_photo,
                            size: MediaQuery.of(context).size.width * 0.2,
                            color: Colors.grey),
                      )
                    /*แสดงอันนี้ : */ : InkWell(
                        onTap: () {
                          //เปิดกล้องหรือเปิดgallery เพื่อเพิ่มรูปภาพ ซึ่งในที่นี้คือเราสร้างmethodไว้ชื่อว่า
                          openGalleryAndSelectPicture();
                        },
                        child: Image.memory(
                          imageByte!,
                          width: MediaQuery.of(context).size.width * 0.2,
                          fit: BoxFit.cover,
                        )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วิ่งที่ไหน',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextField(
                  controller: runWhereCtrl,
                  decoration: InputDecoration(
                    hintText: 'เช่น สวนสาธารณะ,สนามกีฬา หรือ อื่นๆ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วิ่งกับใคร',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextField(
                  controller: runPersonCtrl,
                  decoration: InputDecoration(
                    hintText: 'เช่น เพื่อน 3 คน,แฟน หรือ อื่นๆ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ระยะทาง',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextField(
                  controller: runDistanceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'เช่น 1,5,11 หรือ อื่นๆ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // 1. ตรวจสอบว่ากรอกข้อมูลครบไหม
                    if (runWhereCtrl.text.trim().isEmpty ||
                        runPersonCtrl.text.trim().isEmpty ||
                        runDistanceCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('กรุณาป้อนข้อมูลให้ครบ...'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    // 2. ตรวจสอบว่าระยะทางเป็นตัวเลขจำนวนเต็มหรือไม่
                    int? distance = int.tryParse(runDistanceCtrl.text.trim());
                    if (distance == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'กรุณากรอกระยะทางเป็นตัวเลขจำนวนเต็มเท่านั้น'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    // แจ้งเตือนบนจอให้รู้ว่าปุ่มทำงานและกำลังส่งข้อมูล
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('กำลังบันทึกข้อมูล...'),
                        duration: Duration(seconds: 1),
                      ),
                    );

                    try {
                      // 3. อัปโหลดรูป (ถ้ามี)
                      String imageUrl = '';
                      if (xFile != null) {
                        imageUrl = await SupabaseService()
                            .uploadImageToSupabase(xFile!);
                      }

                      // 4. แพ็กข้อมูลและบันทึกลง Table
                      Run run = Run(
                        runwhere: runWhereCtrl.text.trim(),
                        runperson: runPersonCtrl.text.trim(),
                        runDistance: distance,
                        runImageUrl: imageUrl,
                      );

                      await SupabaseService().insertRunDate(run);

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('บันทึกข้อมูลเสร็จสิ้น'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // กลับหน้าหลัก
                      Navigator.pop(context);
                    } catch (e) {
                      // ถ้าพังตรงไหน จะแสดงข้อความ Error สีแดงบนหน้าจอทันที
                      debugPrint('ERROR ตอนบันทึก: $e');
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('เกิดข้อผิดพลาด: $e'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 5),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'บันทึก',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      runWhereCtrl.clear();
                      runPersonCtrl.clear();
                      runDistanceCtrl.clear();
                      xFile = null;
                      imageByte = null;
                    });
                  },
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
