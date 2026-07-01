class LoginRequestDTO{
  final String identifier;
  final String password;

  LoginRequestDTO({
    required this.identifier,
    required this.password
  });

  Map<String, dynamic> toJson(){
    return {
      'identifier': identifier,
      'password': password
    };
  }
  
}