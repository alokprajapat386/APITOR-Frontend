class UserDetailsDTO {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final DateTime registeredAt;

  UserDetailsDTO({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.registeredAt
  });

  factory UserDetailsDTO.fromJson(Map<String, dynamic> json) {
    return UserDetailsDTO(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      registeredAt: DateTime.parse(json['registeredAt']),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'fullName' : fullName,
      'email' : email,
      'username' : username,
      'registeredAt' : registeredAt.toIso8601String()
    };
  }

  static UserDetailsDTO defaultProfile = UserDetailsDTO(id: 99999999, fullName: "User", email: "user999@gmail.com", username: "username_999", registeredAt: DateTime.now());

  String  firstName() {
  if (fullName.isEmpty) return 'Guest';
  List<String> parts = fullName.trim().split(RegExp(r'\s+'));
  return parts.isNotEmpty ? parts[0] : 'Guest';
}
 
}