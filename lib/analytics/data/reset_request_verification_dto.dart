
class ResetRequestVerificationDTO {
  final String otp;
  final String token;
  final String newPassword;

  ResetRequestVerificationDTO({
    required this.otp,
    required this.token,
    required this.newPassword
  });

  Map<String, dynamic> toJson(){
    return {
      'otp': otp,
      'token': token,
      'newPassword' : newPassword
    };
  }
}