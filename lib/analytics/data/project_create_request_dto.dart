class ProjectCreateRequestDTO {
   final String projectName;
   final String targetURL;

   ProjectCreateRequestDTO({
    required this.projectName,
    required this.targetURL
   });

   Map<String, dynamic> toJson() {
     return {
       'projectName': projectName,
       'targetURL': targetURL
     };
   }
}