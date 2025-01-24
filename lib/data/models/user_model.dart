class UserModel {
  final String id; // Unique ID for the user
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? sin; // SIN is optional, applicable for students
  final String? year; // Year is optional, applicable for students or advisors
  final String? department; // Department is optional, applicable for roles like HOD or Class Advisor

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.sin,
    this.year,
    this.department,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'], // Ensure to store the user's unique Firestore document ID
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      role: json['role'],
      sin: json['sin'], // Nullable field
      year: json['year'], // Nullable field
      department: json['department'], // Nullable field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'sin': sin,
      'year': year,
      'department': department,
    };
  }
}
