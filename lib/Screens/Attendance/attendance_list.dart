import 'package:flutter/material.dart';
import 'package:schoolapplication/ApiCalls/attendace_api.dart';

class AttendanceList extends StatefulWidget {
  final String id;
  const AttendanceList({super.key, required this.id});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  Future<Map<String, dynamic>>? _attendanceList;

  List atlist = [];
 
  bool edit = true;
  @override
  void initState() {
    _attendanceList = AttendanceApi().ayyendanceApi(widget.id, getatLsit);
    print("-------------------------------");
    super.initState();
  }

  void getatLsit(data) {
    print("hiii$data");
    atlist = data;

    setState(() {
      
    });
  }

  void updateAttendance(id) {
 
    for (var student in atlist) {
      if (student['student_id'] == id) {
        student['attendance'] = !student['attendance'];
        setState(() {});
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text("StudentsList"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                 
                  edit = !edit;
                 
                });
              },
              icon: edit ? Icon(Icons.edit) : Icon(Icons.cancel))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _attendanceList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              } else {
                final data = snapshot.data!["attendance"];

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final classs = data[i];
                    final status = atlist[i];

                    return Card(
                      child: ListTile(
                          // onTap: () {
                          //   updateAttendance(classs["roll_no"]);
                          // },
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Text(classs["student_name"]
                                .toString()
                                .substring(0, 1)),
                          ),
                          title: Text(
                            "${classs["student_name"]}",
                            style:
                                TextStyle(color: Colors.purple, fontSize: 18),
                          ),
                          subtitle: Text(
                            "${classs["roll_no"]}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: edit
                              ? (status["attendance"]
                                  ? const Icon(
                                      color: Colors.green,
                                      Icons.check_circle_rounded)
                                  : const Icon(
                                      color: Colors.red, Icons.cancel_rounded))
                              : Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.green,
                                  value: status["attendance"],
                                  onChanged: (bool? value) {
                                    updateAttendance(classs["student_id"]);
                                  },
                                )),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(onPressed: () async{
       var data=await AttendanceApi().postAttendance(atlist, widget.id.toString());
       if(data){
         _attendanceList = AttendanceApi().ayyendanceApi(widget.id, getatLsit);
         edit =true;
         setState(() {
           
         });
       }
      },  child:Text("Update") ,),
    );
  }
}
