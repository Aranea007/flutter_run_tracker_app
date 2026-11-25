import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/models/run.dart';
import 'package:flutter_run_tracker_app/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDeleteRunUi extends StatefulWidget {
  //สร้างตัวแปรไว้เก็บข้อมูลจากอีกหน้าที่ส่งมาให้
  Run? runDateShowUD;

  //เอาตัวแปรมารับค่า
  UpdateDeleteRunUi({super.key, this.runDateShowUD});

  @override
  State<UpdateDeleteRunUi> createState() => _UpdateDeleteRunUiState();
}

class _UpdateDeleteRunUiState extends State<UpdateDeleteRunUi> {
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
  void initState() {
    //เอาข้อมูลที่ส่งมากำหนดให้ตัวcontroller
    runWhereCtrl.text = widget.runDateShowUD!.runwhere!;
    runPersonCtrl.text = widget.runDateShowUD!.runperson!;
    runDistanceCtrl.text = widget.runDateShowUD!.runDistance.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 43, 78),
        title: Text(
          'Run Tracker(แก้ไข/ลบ)',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 50),
          child: Center(
            child: Column(
              children: [
                //ตรวจว่ามีไฟล์รูปไหม
                xFile != null
                    //ใช้____?_____:____ในการแสดงค่า ทำซ้อนกัน
                    ? InkWell(
                        onTap: openGalleryAndSelectPicture,
                        child: Image.memory(
                          imageByte!,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.25,
                          fit: BoxFit.cover,
                        ),
                      )
                    : (widget.runDateShowUD!.runImageUrl != null &&
                            widget.runDateShowUD!.runImageUrl != '')
                        ? InkWell(
                            onTap: openGalleryAndSelectPicture,
                            child: Image.network(
                              widget.runDateShowUD!.runImageUrl!,
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.25,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            onTap: openGalleryAndSelectPicture,
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.25,
                              fit: BoxFit.cover,
                            ),
                          ),
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
                      String imageUrl = widget.runDateShowUD!.runImageUrl ?? '';
                      if (xFile != null) {
                        // ถ้ามีรูปเก่าอยู่ ให้ลบทิ้งก่อน
                        if (imageUrl.isNotEmpty) {
                          await SupabaseService().deleteImageFromBucket(
                            imageUrl.split('/').last,
                          );
                        }
                        // อัปโหลดรูปใหม่ขึ้น Supabase
                        imageUrl = await SupabaseService()
                            .uploadImageToSupabase(xFile!);
                      } else {
                        //กรณี xFile ไม่เท่ากับ null แปลว่าไม่ได้แก้ไขรูป
                        imageUrl = widget.runDateShowUD!.runImageUrl!;
                      }

                      // 4. แพ็กข้อมูลและบันทึกลง Table
                      Run run = Run(
                        runwhere: runWhereCtrl.text.trim(),
                        runperson: runPersonCtrl.text.trim(),
                        runDistance: distance,
                        runImageUrl: imageUrl,
                      );

                      await SupabaseService()
                          .updateRunData(run, widget.runDateShowUD!.id!);

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
                    'บันทึกแก้ไขข้อมูล',
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
                  onPressed: () async {
                    final oldUrl = widget.runDateShowUD!.runImageUrl ?? '';
                    if (oldUrl.isNotEmpty) {
                      await SupabaseService().deleteImageFromBucket(
                        oldUrl.split('/').last,
                      );
                    }

                    await SupabaseService()
                        .deleteRunData(widget.runDateShowUD!.id!);

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(
                        context); // เพิ่มบรรทัดนี้เพื่อให้เด้งกลับหน้าหลัก
                  },
                  child: Text(
                    'ลบข้อมูล',
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
