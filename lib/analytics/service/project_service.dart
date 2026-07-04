
import 'dart:convert';

import 'package:apitor/analytics/data/project_create_request_dto.dart';
import 'package:apitor/analytics/data/project_details_dto.dart';
import 'package:apitor/analytics/service/api_client.dart';
import 'package:apitor/analytics/service/api_config.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';

class ProjectService {

  static Future<ProjectDetailsDTO> createProject(ProjectCreateRequestDTO projectCreateRequest) async {
    String? token = await JwtTokenStorage.getToken();
    final response = await  ApiClient.post(ApiConfiguration.createProjectEndpoint, projectCreateRequest.toJson(), token: token);
    if(response.statusCode >= 200 && response.statusCode<300){
      return ProjectDetailsDTO.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<ProjectDetailsDTO> getProjectById(int projectId) async{
    String? token = await JwtTokenStorage.getToken();
    final response = await ApiClient.get(ApiConfiguration.getProjectByIdEndpoint(projectId), token : token);
     if(response.statusCode >= 200 && response.statusCode<300){
      return ProjectDetailsDTO.fromJson(jsonDecode(response.body));
    } else {
     throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<List<ProjectDetailsDTO>> getAllProjects() async{
    String? token = await JwtTokenStorage.getToken();


    final response = await ApiClient.get(ApiConfiguration.getAllProjectsEndpoint, token : token);
   
      if(response.statusCode >= 200 && response.statusCode<300){
      return (jsonDecode(response.body) as List?)?.map((e)=>
        ProjectDetailsDTO.fromJson(e) 
      ).toList() ?? [];
    } else {
     throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<ProjectDetailsDTO> updateProject(int projectId, ProjectCreateRequestDTO projectCreateRequest) async {
    String? token = await JwtTokenStorage.getToken();
    final response = await  ApiClient.put(ApiConfiguration.updateProjectByIdEndpoint(projectId), projectCreateRequest.toJson(), token: token);
    if(response.statusCode >= 200 && response.statusCode<300){
      return ProjectDetailsDTO.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }

  static Future<bool> deleteProject(int projectId) async{
    String? token = await JwtTokenStorage.getToken();
     final response = await  ApiClient.delete(ApiConfiguration.deleteProjectByIdEndpoint(projectId), token: token);
    if(response.statusCode >= 200 && response.statusCode<300){
      return true;
    } else {
      throw HttpException(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
    }
  }
}