import 'dart:async';
import 'package:apitor/analytics/service/api_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomSnackBar {

  static SnackBar snackBar(
    IconData icon,
    String title,
    String description,
    Color iconColor,
  ){
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 380,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 88, 88, 88),
            boxShadow:const [
              BoxShadow(
                color:  Color.fromARGB(80, 0, 0, 0),
                blurRadius: 5.0,
                offset: Offset(2, 2),
              )
            ],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            spacing: 12,
            children: [
              Icon(icon, color: iconColor ),
              Expanded(
                child: Column(
                  mainAxisSize:  MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height:2),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white70, 
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ),
            ],
          )
        ),
      ),
    );
  }

  static SnackBar success(
    String title,
    String description
  ){
    return snackBar(Icons.check_circle_outline_rounded, title, description, const Color.fromARGB(255, 44, 255, 132));
  }

  static SnackBar error(
    String title,
    Object exception
  ){


    IconData icon = Icons.error_outline_rounded;
    String description = 'Unexpected Error: Something went wrong';
    Color iconColor = const Color.fromARGB(255, 255, 82, 82);
    if(exception is HttpException){
        switch(exception.statusCode){
          case(401):
          case(403):
            icon = Icons.lock_outlined;
            iconColor = const Color.fromARGB(255, 255, 177, 100);
            break;
          case int c when (c>=400 && c<500):
            icon = Icons.warning_amber_rounded;
            iconColor = const Color.fromARGB(255, 253, 255, 119);
            break;
          case int c when (c>=500 && c<600):
            icon = Icons.cloud_off_rounded;
            iconColor = const Color.fromARGB(255, 229, 81, 255);
            break;
        }
        if(exception.statusCode<500){
          description = exception.toString();
        }else if(exception.statusCode>=500 && exception.statusCode<600){
          description = 'Server Error [${exception.statusCode}]: Something went wrong on our side';
        }else{
          description = 'Unexpected Error [${exception.statusCode}]: Something went wrong';
         
        }
    }else if(exception is http.ClientException){
      icon = Icons.link_off;
      iconColor = const Color.fromARGB(255, 106, 108, 255);
      description = 'Connection Failed';
    }else if(exception is TimeoutException){
        icon = Icons.timer_outlined;
        iconColor = const Color.fromARGB(255, 94, 236, 255);
        description = 'Connection Timed Out: Server is taking too long to respond, try again later';
    }

    return snackBar(icon, title, description, iconColor);
  }
  
}