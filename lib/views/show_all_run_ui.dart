import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/models/run.dart';
import 'package:flutter_run_tracker_app/services/supabase_service.dart';
import 'package:flutter_run_tracker_app/views/add_run_ui.dart';
import 'package:flutter_run_tracker_app/views/update_delete_run_ui.dart';

class ShowAllRunUi extends StatefulWidget {
  const ShowAllRunUi({super.key});

  @override
  State<ShowAllRunUi> createState() => _ShowAllRunUiState();
}

class _ShowAllRunUiState extends State<ShowAllRunUi> {
  //ตัวแปรไว้เก็บค่าที่ดึงมาจากsupabase
  List<Run>? runs;

  //สร้างmethodดึงข้อมูลจากsupabase
  Future<void> fetchAllRuns() async {
    //ดึงข้อมูลผ่านSupabaseService()
    final data = await SupabaseService().getAllRunData();

    //เอาข้อมูลที่ได้มาเก็บไว้ในตัวแปร
    setState(() {
      runs = data;
    });
  }

  @override
  void initState() {
    //เรียกใช้คำสั่งดึงข้อมูลจากsupabase
    fetchAllRuns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 43, 78),
        title: Text(
          'Run Tracker',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      //floatingActionButton: FloatingActionButton(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRunUi(),
            ),
          );

          //สั่งให้ดึงข้อมูลจากsupabase มาอีกรอบ
          fetchAllRuns();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 1, 43, 78),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //body
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.25,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              'วิ่งกันเถอะ',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.08,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: runs?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      //ทุกครั้งที่กดจะไปที่หน้าจอ Update แบบย้อนกลับได้
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateDeleteRunUi(
                            runDateShowUD: runs![index],
                          ),
                        ),
                      );
                      //เสร็จแล้วให้ดึงข้อมูลจากsupabaseมาอีกรอบเพื่อupdateหน้าจอ
                      fetchAllRuns();
                    },
                    tileColor:
                        index % 2 == 0 ? Colors.green[100] : Colors.green[50],
                    title: Text(
                      'วิ่งที่ไหน:${runs![index].runwhere}',
                    ),
                    subtitle: Text(
                      'วิ่งไปเท่าไหร่ ${runs![index].runDistance} กม.',
                    ),
                    trailing: Icon(
                      Icons.info,
                      color: Colors.deepOrange,
                    ),
                    leading: (runs![index].runImageUrl == null ||
                            runs![index].runImageUrl!.isEmpty)
                        ? Image.asset(
                            'assets/images/logo.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            runs![index].runImageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
