class UserUpdateRequestDTO {
  final String username;
  final String fullName;
  final String email;

  UserUpdateRequestDTO({
    required this.username,
    required this.fullName,
    required this.email
  });

  Map<String, dynamic> toJson(){
    return {
      'username': username,
      'fullName': fullName,
      'email': email
    };
  }
}