import 'dart:convert';

import 'package:apitor/analytics/data/user_details_dto.dart';
import 'package:apitor/analytics/service/auth_service.dart';
import 'package:apitor/analytics/service/storage/user_profile_storage_service.dart';
import 'package:apitor/components/custom_expanded.dart';
import 'package:apitor/components/pop_up_card.dart';
import 'package:apitor/routing/user_session.dart';
import 'package:apitor/screens/charts/dynamic_bar_chart.dart';
import 'package:apitor/screens/charts/dynamic_line_chart.dart';
import 'package:apitor/screens/dashboard/metrics_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  static  Color green  = Colors.green.shade500;
  static  Color orange = Colors.orange.shade400; 
  static  Color red    = Colors.red.shade400; 
  static  Color blue   = Colors.blue.shade400;

    final Widget latencyCard=PopupHoverCard(
      child: ChartCard(
        title: 'API Hits',
        legendColors: [green, orange, red],
        legendLabels: ['Average latency', 'P50 latency', 'P99 latency'],
        chart:DynamicLineChart(
          dataList:  [
            {'time': '10:00', 'Avg': 120, 'P50': 95,  'P99': 420},
            {'time': '10:05', 'Avg': 125, 'P50': 98,  'P99': 410},
            {'time': '10:10', 'Avg': 140, 'P50': 110, 'P99': 530},
            {'time': '10:15', 'Avg': 290, 'P50': 210, 'P99': 890}, 
            {'time': '10:20', 'Avg': 150, 'P50': 115, 'P99': 460}, 
            {'time': '10:25', 'Avg': 115, 'P50': 90,  'P99': 310},
            {'time': '10:30', 'Avg': 110, 'P50': 88,  'P99': 295},
            {'time': '10:35', 'Avg': 135, 'P50': 102, 'P99': 510},
            {'time': '10:40', 'Avg': 190, 'P50': 150, 'P99': 680}, 
            {'time': '10:45', 'Avg': 122, 'P50': 94,  'P99': 415},
          ],
          dataKeys: ['Avg', 'P50', 'P99'],
          lineColors:  [green, orange, red],
          xAxisKey: 'time',
          chartHeight: 200,
        ),
        backgroundColor: Colors.transparent,
      
      ),
    );

    bool isLoading=false;

    final Widget httpMethodCard=PopupHoverCard(
      child: ChartCard(
        title: 'HTTP Methods',
        legendColors:[green, orange, blue,red],
        legendLabels: ['GET', 'POST', 'PUT', 'DELETE'],
        chart:DynamicBarChart(
        dataList: [
          {'time': '10:00', 'POST': 120, 'PUT': 95,  'GET': 420,  'DELETE': 24},
          {'time': '10:05', 'POST': 125, 'PUT': 98,  'GET': 410,  'DELETE': 23},
          {'time': '10:10', 'POST': 140, 'PUT': 110, 'GET': 530,  'DELETE': 34},
          {'time': '10:15', 'POST': 290, 'PUT': 210, 'GET': 890,  'DELETE': 64}, 
          {'time': '10:20', 'POST': 150, 'PUT': 115, 'GET': 460,  'DELETE': 24}, 
          {'time': '10:25', 'POST': 115, 'PUT': 90,  'GET': 310,  'DELETE': 57},
          {'time': '10:30', 'POST': 110, 'PUT': 88,  'GET': 295,  'DELETE': 59},
          {'time': '10:35', 'POST': 135, 'PUT': 102, 'GET': 510,  'DELETE': 73},
          {'time': '10:40', 'POST': 190, 'PUT': 150, 'GET': 680,  'DELETE': 24}, 
          {'time': '10:45', 'POST': 122, 'PUT': 94,  'GET': 415,  'DELETE': 34},
        ],
          dataKeys: ['GET', 'POST', 'PUT', 'DELETE'],
          barColors:  [green, orange,blue, red],
          xAxisKey: 'time',
          chartHeight: 240,
        ),
        backgroundColor: Colors.transparent,
        
      ),
    );


  Future<void> navigateToMainPage() async {
    setState(() {
      isLoading = true;
    });
    try{
      bool isLoggedin = await AuthService.isLoggedin();
      if(isLoggedin){
        final userProfile = await UserProfileStorageService.fetchProfile();
        UserSession.instance.setUser(userProfile ?? UserDetailsDTO.defaultProfile);
        if(!mounted) return;
        context.go('/dashboard');
      }else{
        if(!mounted) return;
        context.go('/auth/login');
      }
    }catch(e){
      if(!mounted) return;
      context.go('/auth/login');
    } finally{
      if(mounted){
        setState((){
          isLoading=false;
        });
      }
    }
   
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth<450;
    return Scaffold(
      body: Container(
        
        // width: MediaQuery.of(context).size.width*0.75,
       
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
        child:SingleChildScrollView(
          scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: isMobile?8:16, vertical: 80),
          
          child: Center(
          
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: isMobile?310:750, 
                  maxWidth: isMobile?(screenWidth * 0.9 < 310 ? 310 : screenWidth * 0.9):
                  (screenWidth * 0.6 < 750 ? 750 : screenWidth * 0.6)
                ),
                
                
                child:Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: theme.primaryColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt_rounded,
                              size: 16, color: theme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Apitor · API Analytics Tool',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:32),
                    Text(
                      'Watch How Your API Performs In Real Time',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.2,
                       
                      ),
                    ),
                    SizedBox(height:20),
                    Text(
                      'Track request hits, unique visitors, latency, and '
                      'more — then plan your next move '
                      'with data instead of guesswork.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height:24),
                    Flex(
                      direction: (isMobile? Axis.vertical:Axis.horizontal),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: ()=>navigateToMainPage(),
                          icon: !isLoading?
                            const Icon(
                              Icons.rocket_launch_outlined,
                              size: 20
                            ):
                            SizedBox(
                              width: 20,
                              height:20,
                              child: CircularProgressIndicator(
                                color:Colors.white
                              ),
                            )
                              ,
                          label: const Text('Launch Workspace'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                       
              
                        ),
                        SizedBox(width: 12, height:12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            
                            final String configString = await rootBundle.loadString('assets/config.json');
                            final Map<String, dynamic> configJson = jsonDecode(configString);
                            final String? githubUrl = configJson['GITHUB_LINK'];

                            final Uri url = Uri.parse(githubUrl ?? 'https://github.com/repository-name/');
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                               if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    final theme = Theme.of(dialogContext);
                                    
                                    return Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min, 
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.red.withValues(alpha: 0.1),
                                              child: const Icon(Icons.link_off_rounded, color: Colors.red, size: 28),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Could Not Launch Link',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            
                                            Text(
                                              'We were unable to open the GitHub repository link. Please verify if a browser is installed on your device or try again later.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: theme.hintColor, fontSize: 13, height: 1.4),
                                            ),
                                            const SizedBox(height: 20),
                                            
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: theme.primaryColor,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                ),
                                                onPressed: () => Navigator.pop(dialogContext), 
                                                child: const Text('Dismiss', style: TextStyle(fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                );
                            }
                        
                          },
                          icon: const FaIcon(
                               FontAwesomeIcons.github,
                              size: 20),
                              
                          label: const Text('View Repo On Github'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withValues(alpha:0.7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40,),
                    Text(
                      'Analyse How Your API Performs',
                      textAlign: TextAlign.start,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                       
                      ),
                    ),
                    SizedBox(height:15),
                    Flex(
                      direction: (isMobile? Axis.vertical:Axis.horizontal),
                      
                      children: [
                        CustomExpanded(
                          isExpanded: !isMobile,
                          child: latencyCard
                        ),
                        SizedBox(height:12, width:12),
                        CustomExpanded(
                          isExpanded: !isMobile,
                          child: httpMethodCard
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                             Icons.flash_on_rounded,
                             color: theme.primaryColor,

                          ),
                          SizedBox(width: 10,),
                          Text(
                            'Features ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:  FontWeight.bold,
                              color: Colors.black87
                            ),
                          ),
                        ],
                      ),
                    ),
              
                    SizedBox(height:12),
                    Flex(
                      direction: isMobile? Axis.vertical: Axis.horizontal,
                      children: [
                        CustomExpanded(
                          isExpanded: !isMobile,
                          child: FeatureCard(
                            icon: Icons.speed_rounded,
                            title: 'Track Request Latency',
                            description: 'Go beyond average. Monitor real-time P50 and P99 latency percentiles to capture distribution of slow requests. ',
                          ),
                        ),
                        SizedBox(width: 12,height:12),
                        CustomExpanded(
                          isExpanded: !isMobile,
                          child: FeatureCard(
                            icon: Icons.bar_chart_outlined,
                            title: 'Visual Anlytics Board',
                            description: 'Transform numbers into insights. Track real-time API trends with clean charts engineered for readabiltiy.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:12),
                    Flex(
                      direction: isMobile? Axis.vertical: Axis.horizontal,
                      children: [
                        CustomExpanded(
                          isExpanded: !isMobile,
                          child: FeatureCard(
                            icon: Icons.admin_panel_settings_outlined,
                            title: 'Data Isolation',
                            description: 'Your data is strictly yours. Built with user isolation ensuring that no one can ever intercept or view other accounts\' details.',
                          ),
                        ),
                        SizedBox(width: 12, height:12),
                        CustomExpanded(
                          isExpanded: !isMobile,
                          child: FeatureCard(
                            icon: Icons.key_outlined,
                            title: 'Secure Authenticaiton',
                            description: 'Experience smooth onboarding with secure Google Sign-In, coupled with JWT authentication to keep every API handshake light and verified.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:12),
                    Flex(
                      direction:isMobile? Axis.vertical: Axis.horizontal,
                      children: [
                        CustomExpanded(
                          isExpanded:!isMobile,
                          child: FeatureCard(
                            icon: Icons.analytics_outlined,
                            title: 'Identify Bottlenecks',
                            description: 'Analyze real-time request volume streams alongside route-level tracking and latency distributions to see your API performance.',
                          ),
                        ),
                        SizedBox(width:12, height:12),
                        CustomExpanded(
                          isExpanded: !isMobile,
                          child: FeatureCard(
                            icon: Icons.storage_outlined,
                            title: 'Optimized Storage',
                            description: 'A secure and optimized PostGreSQL schema deisgn for fast time series telemetry indexing and optimized queries for telemetry analysis.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                             Icons.construction_rounded,
                             color: theme.primaryColor,

                          ),
                          SizedBox(width: 10,),
                          Text(
                            'Tech Stack Used',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:  FontWeight.bold,
                              color: Colors.black87
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:12),
                    Wrap(
                     alignment: WrapAlignment.center,
                     spacing: isMobile?16: 40,
                     runSpacing: 16,

                      children: [
                        TechStackCard(
                          iconWidget: SvgPicture.asset(
                            'assets/icons/flutter_logo.svg',
                          ), 
                          title: 'FLUTTER '
                        ),
                        TechStackCard(
                          iconWidget: SvgPicture.asset(
                            'assets/icons/spring_boot_logo.svg'
                          ), 
                          title: 'SPRING BOOT'
                        ),
                        TechStackCard(
                          iconWidget: Image.asset(
                            'assets/icons/fl_chart_logo.png'
                          ), 
                          title: 'FL CHART'
                        ),
                        TechStackCard(
                          iconWidget: SvgPicture.asset(
                            'assets/icons/postgres_logo.svg'
                          ), 
                          title: 'POSTGRESQL'
                        ),
                      ],
                    ),
              
                    SizedBox(height: 40,),
                    FinalCta(
                      navigateToMainPage: navigateToMainPage,
                    ),
                  ]
                ),
              ),
            ),
          )
        )
      ),
    );
  }

  
}


class FeatureCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String description;
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description
  });
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupHoverCard(
      child: Card(
      
        elevation: 2,
        // margin:EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: theme.primaryColor.withValues(alpha:0.05),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:  theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ],
              ),
              SizedBox(height:10),
              Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            ],
          )
          
        )
      ),
    );
  }
}


class FinalCta extends StatelessWidget {
  final VoidCallback navigateToMainPage;
  const FinalCta({
    super.key,
    required this.navigateToMainPage
  });




  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    return PopupHoverCard(
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
      
            colors: [
              theme.primaryColor,
              theme.primaryColor.withValues(alpha: 0.7),
              theme.primaryColor
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Start watching your API in minutes',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to dive into your API metrics? Sign in to track endpoint latencies, and analyse your system performance data instantly.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: ()=> navigateToMainPage(),
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: const Text('Continue Your Journey'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: theme.primaryColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TechStackCard extends StatelessWidget {

  final Widget iconWidget;
  final String title;
  const TechStackCard({
    super.key,
    required this.iconWidget,
    required this.title,
  });
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupHoverCard(
      child: Card(
      
        elevation: 2,
        
        // margin:EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: theme.primaryColor.withValues(alpha:0.05),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 10,
            children: [
              Container(
                width: 24,
                height:24,
                clipBehavior: Clip.antiAlias,
                // padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:  theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: iconWidget,
              ),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
                                ),
            ],
          ),
        )
      ),
    );
  }
}
