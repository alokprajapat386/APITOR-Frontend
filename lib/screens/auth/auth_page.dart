import 'package:apitor/components/pop_up_card.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final Widget child;
  const AuthScreen({super.key, required this.child});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth= MediaQuery.of(context).size.width;
    bool isMobile = screenWidth<450;
    final theme = Theme.of(context);
    // final screen_height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          
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
        child: SafeArea(
           
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child:SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        // width: 0.75*screenWidth,
                         constraints: BoxConstraints(
                          minWidth: isMobile?310:750, 
                          maxWidth: isMobile?(screenWidth * 0.9 < 310 ? 310 : screenWidth * 0.9):
                          (screenWidth * 0.75 < 750 ? 750 : screenWidth * 0.75)
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:Colors.white.withValues(alpha:0.5),
                              blurRadius:10,
                              // spreadRadius: 15,
                              offset: const Offset(-4, -4)
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(4, 4),                    
                            )
                          ]
                        ),
                        child:IntrinsicHeight(
                          child: Flex(
                            direction: (isMobile? Axis.vertical: Axis.horizontal),
                            children: [
                              Expanded(
                                flex: 1,
                                child: const AboutUs(),
                              ),
                              Expanded(
                                flex: 1,
                                child: widget.child,
                              )
                            ],
                          ),
                        )
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth= MediaQuery.of(context).size.width;
    bool isMobile = screenWidth<450;
    return Padding(
      padding: EdgeInsets.all(isMobile?16:40),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // app icon and name
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius:  BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/icons/apitor_logo.png',
                  width: 30,
                  height: 30,
                )
              ),
              const SizedBox(width: 12,),
              ShaderMask(
                shaderCallback: (bounds){
                  return LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).secondaryHeaderColor
                    ],
                    begin:Alignment.topLeft,
                    end:Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "APITOR",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                    
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
          Text(
            "Welcome",
            style:Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w400
            )

          ),
          const SizedBox(height:12),
           // Login Message
          Text(
            'Login to continue your projects',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          // Feature Cards
          FeatureCard(
            icon: Icons.track_changes,
            title: 'Track your API',
            description: 'Monitor API performance in real-time',
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.analytics,
            title: 'See Detailed Analytics',
            description: 'Get comprehensive insights and reports',
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.add_box,
            title: 'Register New Projects',
            description: 'Easily add and manage your projects',
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.security,
            title: 'Secure & Reliable',
            description: 'Enterprise-grade security for your data',
          ),
        ],
      )
    );
  }
}

class FeatureCard extends StatelessWidget {
 
  final IconData icon;
  final String title;
  final String description;
   const FeatureCard({super.key, required this.icon, required this.title, required this.description});
  

  @override
  Widget build(BuildContext context) {
    return PopupHoverCard(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha:0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

