class ProjectDetailsDTO {
  final int id;
  final String projectName;
  final String projectToken;
  final String targetURL;
  final DateTime createdAt;

  ProjectDetailsDTO({
    required this.id,
    required this.projectName,
    required this.projectToken,
    required this.targetURL,
    required this.createdAt
  });

  factory ProjectDetailsDTO.fromJson(Map<String,dynamic> json){
    return ProjectDetailsDTO(
       id: json['id'],
       projectName: json['projectName'],
       projectToken: json['projectToken'],
       targetURL: json['targetURL'],
       createdAt: DateTime.parse(json['createdAt'])
    );
  }

  @override
  String toString() {
    return 'ProjectDetailsDTO{id: $id, projectName: $projectName, projectToken: $projectToken, targetURL: $targetURL, createdAt: $createdAt}';
  }


}