class RegisterRequestDTO{
  final String username;
  final String fullName;
  final String email;
  final String password;

  RegisterRequestDTO({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password
  });

  Map<String, dynamic> toJson(){
    return {
      'username': username,
      'fullName': fullName,
      'email': email,
      'password': password
    };
  }
}