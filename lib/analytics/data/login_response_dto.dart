import 'package:apitor/analytics/data/user_details_dto.dart';

class LoginResponseDTO {
  final UserDetailsDTO userDetails;
  final String token;

  LoginResponseDTO({
    required this.userDetails,
    required this.token
  });

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) {
    return LoginResponseDTO(
      userDetails: UserDetailsDTO.fromJson(json['userDetails']),
      token: json['token'],
    );
  }
}