import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    bool isMobile = screenWidth <350;
    return Scaffold(
      body: Container(
         decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withValues(alpha: 0.03),
              theme.scaffoldBackgroundColor,
              theme.primaryColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        
        constraints:  BoxConstraints.expand(),
        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flex(
                direction: isMobile? Axis.vertical: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: 
                    Image.asset(
                      'assets/icons/apitor_logo.png',
                      width: 60,
                      height: 60,
                      // color:Colors.white,
                      filterQuality: FilterQuality.high,
                    )
                  ),
                  SizedBox(height: 20, width: 20,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: isMobile
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColorLight
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Text(
                          "APITOR",
                          style: TextStyle(
                            fontSize: 65,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    
                    ],
                  ),
                  SizedBox(width: 30, height:20),
              
                  CircularProgressIndicator(
                    strokeWidth: 7,
                    color: theme.primaryColor.withValues(alpha:0.8),
                    constraints: BoxConstraints(
                      minHeight: 40,
                      minWidth:  40,
                      maxHeight: 40,
                      maxWidth:  40
                    ),
                  )
              
                ],
              ),

              Text(
                "APITOR :Your Personal API Telemetry Engine.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black.withValues(alpha: 0.7),
                  fontSize: 24,
                  fontWeight: FontWeight.w800
                )
              ),
              Text(
                "Loading the system configurations from secure storage, safely retrieving keys... Just a minute",
              
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          )
        )
      )
       
    );
  }
}