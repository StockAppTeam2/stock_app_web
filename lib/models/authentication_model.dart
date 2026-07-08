class AuthenticationModel {
  String mobileNumber;
  String password;

  AuthenticationModel({required this.mobileNumber, required this.password});

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationModel(
      mobileNumber: json['mobileNumber'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
