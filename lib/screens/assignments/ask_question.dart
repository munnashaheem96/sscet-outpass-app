import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/color/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AskQuestionScreen extends StatefulWidget {
  @override
  _AskQuestionScreenState createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUserRole;
  String? _currentUserName;
  String? _currentUserDepartment; // Added department
  String? _currentUserYear; // Added year

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _currentUserRole = doc.data()?['role'];
          _currentUserName = doc.data()?['lastName'] ?? 'User';
          _currentUserDepartment = doc.data()?['department']; // e.g., 'CSE'
          _currentUserYear = doc.data()?['year']; // e.g., '2'
        });
      }
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty || _currentUserDepartment == null || _currentUserYear == null) return;

    final chatMessage = {
      'text': message,
      'sender': _currentUserName,
      'role': _currentUserRole,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'department': _currentUserDepartment,
      'year': _currentUserYear,
    };

    // Store in a specific collection based on department and year
    await _firestore
        .collection('classChats')
        .doc(_currentUserDepartment)
        .collection(_currentUserYear!)
        .add(chatMessage);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.secondaryColor),
        title: Text(
          'Class Chat - ${_currentUserDepartment ?? ''} ${_currentUserYear ?? ''}',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _currentUserDepartment == null || _currentUserYear == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('classChats')
                        .doc(_currentUserDepartment)
                        .collection(_currentUserYear!)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                      }

                      final messages = snapshot.data!.docs;
                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final messageData = messages[index].data() as Map<String, dynamic>;
                          return _buildChatBubble(messageData);
                        },
                      );
                    },
                  ),
                ),
                _buildChatInput(),
              ],
            ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> messageData) {
    final isCurrentUser = messageData['sender'] == _currentUserName;
    final timeFormat = DateFormat('HH:mm, MMM d');
    final timestamp = (messageData['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    final isAdvisor = messageData['role'] == 'Class Advisor';

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.secondaryColor : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messageData['sender'] ?? 'Unknown',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrentUser ? Colors.black : Colors.white,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 4),
            Text(
              messageData['text'] ?? '',
              style: TextStyle(
                color: isCurrentUser ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              timeFormat.format(timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isCurrentUser ? Colors.grey[600] : Colors.white70,
              ),
            ),
            if (!isCurrentUser && isAdvisor) ...[
              SizedBox(height: 4),
              Text(
                'Seen',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              maxLines: null,
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.primaryColor),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}