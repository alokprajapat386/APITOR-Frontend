
class ResetPasswordRequestDTO {
  final String identifier;

  ResetPasswordRequestDTO({
    required this.identifier
  });

  Map<String, dynamic> toJson(){
    return {
      'identifier': identifier,
    };
  }
}