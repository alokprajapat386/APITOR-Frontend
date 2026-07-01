class PasswordChangeRequestDTO {
  final String oldPassword;
  final String newPassword;

  PasswordChangeRequestDTO({
    required this.oldPassword,
    required this.newPassword
  });

  Map<String, dynamic> toJson(){
    return {
      'oldPassword' : oldPassword,
      'newPassword' : newPassword
    };
  }

}