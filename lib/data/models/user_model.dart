class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      role: json['role'],
    );
  }
}
