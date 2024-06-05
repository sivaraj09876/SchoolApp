import 'package:flutter/material.dart';
import 'package:schoolapplication/ApiCalls/classlist_api.dart';
import 'package:schoolapplication/Screens/Attendance/attendance_list.dart';
import 'package:schoolapplication/Screens/StudentsList/studeny_list.dart';

class ClassList extends StatefulWidget {
  final bool attendancePage;
  const ClassList({super.key, required this.attendancePage});

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  Future<List>? _classList;
  @override
  void initState() {
   
  _classList=  ClassListApi().classListAPi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Text("ClassList"),centerTitle: true,),
     body: SingleChildScrollView(
       child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child:  FutureBuilder<List>(
              future: _classList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                } else {
                  final data = snapshot.data!;
                 
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                     final classs = data[i];
                     return Card(
                      child: ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> widget.attendancePage? AttendanceList(id: classs["id"].toString()):StudentsList(id:classs["id"].toString()  )));
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text(classs["class_incharge"].toString().substring(0,1)),
                        ),
                        title: Text("${classs["class_name"]}",style: TextStyle(color: Colors.purple,fontSize: 18),),
                        subtitle: Text("${classs["class_incharge"]}",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        
        
                     );
                  },);
                }
              },
            ),
       ),
     ),    
    );
  }
}