

class PasswordResetTokenResponseDTO {
  final String token;

  PasswordResetTokenResponseDTO({
    required this.token
  });

  factory PasswordResetTokenResponseDTO.fromJson(Map<String, dynamic> json){
    return PasswordResetTokenResponseDTO(
      token: json['token']
    );
  }



}