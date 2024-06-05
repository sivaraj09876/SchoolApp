import 'package:flutter/material.dart';
import 'package:schoolapplication/ApiCalls/studentlist_api.dart';


class StudentsList extends StatefulWidget {
  final String id;
  const StudentsList({super.key,required this.id});

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  Future<List>? _studentsList;
  @override
  void initState() {
   
  _studentsList=  StudentsListApi().studentsListApi(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Text("StudentsList"),centerTitle: true,),
     body: SingleChildScrollView(
       child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child:  FutureBuilder<List>(
              future: _studentsList,
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
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text(classs["first_name"].toString().substring(0,1)),
                        ),
                        title: Text("${classs["first_name"]}  ${classs["last_name"]}",style: TextStyle(color: Colors.purple,fontSize: 18),),
                        subtitle: Text("${classs["gender"]}",style: TextStyle(fontWeight: FontWeight.bold),),
                        trailing: Text("${classs["roll_no"]}"),
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