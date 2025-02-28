import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/color/Colors.dart'; // Import AppColors

class ClassWiseUsersScreen extends StatefulWidget {
  @override
  _ClassWiseUsersScreenState createState() => _ClassWiseUsersScreenState();
}

class _ClassWiseUsersScreenState extends State<ClassWiseUsersScreen> {
  bool _isLoading = true;
  Map<String, List<DocumentSnapshot>> _studentsByClass = {};
  Map<String, DocumentSnapshot?> _hodsByDept = {};
  Map<String, DocumentSnapshot?> _advisorsByClass = {};
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    setState(() => _isLoading = true);

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<DocumentSnapshot> users = usersSnapshot.docs;

    Map<String, List<DocumentSnapshot>> studentsByClass = {};
    Map<String, DocumentSnapshot?> hodsByDept = {};
    Map<String, DocumentSnapshot?> advisorsByClass = {};

    for (var user in users) {
      Map<String, dynamic> userData = user.data() as Map<String, dynamic>;
      String role = userData['role'] ?? '';
      String department = userData['department'] ?? '';
      String year = userData['year'] ?? '';
      String key = "$year - $department";

      if (role == 'Student') {
        studentsByClass.putIfAbsent(key, () => []).add(user);
      } else if (role == 'HOD') {
        hodsByDept[department] = user;
      } else if (role == 'Class Advisor') {
        advisorsByClass[key] = user;
      }
    }

    setState(() {
      _studentsByClass = studentsByClass;
      _hodsByDept = hodsByDept;
      _advisorsByClass = advisorsByClass;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Class-Wise Users", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: _studentsByClass.keys.map((key) => _buildClassSection(key, _studentsByClass[key]!)).toList(),
            ),
    );
  }

  Widget _buildClassSection(String key, List<DocumentSnapshot> students) {
    String department = key.split(" - ")[1];
    String year = key.split(" - ")[0];

    return Card(
      color: AppColors.primaryColor,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text("$year - $department", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("HOD: ${_getFullName(_hodsByDept[department])}", style: TextStyle(color: Colors.white)),
            Text("Class Advisor: ${_getFullName(_advisorsByClass[key])}", style: TextStyle(color: Colors.white)),
          ],
        ),
        children: students.map((student) => ListTile(
          title: Text(_getFullName(student),style: TextStyle(color: Colors.white),),
          subtitle: Text("SIN: ${student.get('sin') ?? 'N/A'}", style: TextStyle(color: Colors.white)),
          leading: Icon(Icons.person, color: AppColors.secondaryColor),
        )).toList(),
      ),
    );
  }

  String _getFullName(DocumentSnapshot? user) {
    if (user == null) return "N/A";
    return "${user.get('firstName') ?? ''} ${user.get('lastName') ?? ''}".trim();
  }
}
