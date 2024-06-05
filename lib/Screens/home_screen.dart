import 'package:flutter/material.dart';


import 'package:schoolapplication/ApiCalls/dashboard_api.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>>? _dashboardData;
  @override
  void initState() {
    _dashboardData = DashboardApi().dashboardApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("DASHBOARD"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _dashboardData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              } else {
                final data = snapshot.data!;
                
                return HomeView(data: data);
              }
            },
          ),
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  final Map<String, dynamic> data;
  const HomeView({super.key, required this.data});

  Widget _count(String imagePath, String title, String count, Color color) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 50,
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
            ),
            Text(
              count,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 25),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                     Text(
                     "${data["date"]}",
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text("${data["school_status"]}",style: const TextStyle(color: Colors.teal ,fontWeight: FontWeight.bold),)
                  ],
                ),
                _count("assets/total.png", "Total Students",
                    "${data["total_students"]}", Colors.blueAccent),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _count("assets/present.png", "Total Prsent",
                    "${data["total_present"]}", Colors.green),
                _count("assets/absent.png", "Total Absent",
                    "${data["total_absent"]}", Colors.green)
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _count("assets/male.png", "Male Students",
                    "${data["male_total"]}", Colors.purple),
                _count("assets/girl.png", "Female Students",
                    "${data["female_total"]}", Colors.pinkAccent)
              ],
            ),
          ),
        ),
         Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _count("assets/male.png", "Male Present",
                    "${data["male_present"]}", Colors.green),
                _count("assets/girl.png", "Female Present",
                    "${data["female_present"]}", Colors.green)
              ],
            ),
          ),
        ),
      ],
    );
  }
}










// Container(
//         child: Column(children: [
//           Expanded(
//             child: BlocBuilder<UserdataCubit ,Map<String,dynamic>>(
             
//               builder:(context, state) {
//             return Text("${state.toString()}");
              
//             }, ),
//           )
//         ],),
//       ),