import 'package:apitor/analytics/data/user_details_dto.dart';
import 'package:apitor/components/custom_expanded.dart';
import 'package:apitor/components/pop_up_card.dart';
import 'package:apitor/routing/user_session.dart';
import 'package:flutter/material.dart';
import 'project_page.dart';

class DashboardComponent extends StatelessWidget {
  final String fullName;

  const DashboardComponent({
    super.key,
    this.fullName = 'User',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth<450;

     return ValueListenableBuilder(valueListenable: UserSession.instance.notifier, builder: (context, userDetails, child) {
      final UserDetailsDTO user = userDetails;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Text with Name
          Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome , ${user.firstName()}! ',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                  const SizedBox(height: 8),
            
                // Introductory Paragraph
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.double_arrow_sharp,
                            color:theme.primaryColor
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                            child: Text(
                                'Stop Guessing. Visualize Your API Performance.',
                               style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:12),
                      Text(
                        'From request hits and unique IP tracking to deep-dive route latency analytics, APITOR breaks down your API traffic into beautiful, interactive charts. Secure by design, completely isolated, and engineered for high-performance low-latency monitoring.',
    
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  )
                ),
            
              ],
            ),
          ),
        
          const SizedBox(height: 32),
            
          // Service Details Cards Header
          Text(
            'Featured Services',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
            
          // Service Cards Grid
          _buildServiceCards(context, theme, isMobile),
          const SizedBox(height: 32),
            
          // Start Your Journey Card
          _buildStartJourneyCard(context, theme),
          const SizedBox(height: 24),
        ],
      ),
    );
     });
  }

  Widget _buildServiceCards(BuildContext context, ThemeData theme, bool isMobile) {

    final cardHeight = isMobile? 150.0: 120.0;

    final services = [
      {
        'title': 'API Tacking',
        'description': 'Real-time monitoring of Request Hits, traffic frequencies, and unique IP distributions.',
        'icon': Icons.analytics_outlined,
      },
      {
        'title': 'Latency Profiling',
        'description': 'Track and visualize endpoint-specific response times to eliminate bottlenecks instantly.',
        'icon': Icons.speed_outlined,
      },
      {
        'title': 'Interactive Visuals',
        'description': 'High-fidelity fl_charts implementation providing fluid, multi-dimensional timeline trends.',
        'icon': Icons.auto_graph_outlined,
      },
      {
        'title': 'Isolated Security',
        'description': 'Stateless JWT authentication engineering complete data isolation from other tenants.',
        'icon': Icons.security,
      },
    ];

    return Column(
      children: [
        for (int i = 0; i < services.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Flex(
              direction: isMobile? Axis.vertical: Axis.horizontal,
              children: [
                
                CustomExpanded(
                  isExpanded: !isMobile,
                  child: _buildServiceCard(
                    context,
                    theme,
                    services[i]['title'].toString(),
                    services[i]['description'].toString(),
                    services[i]['icon'] as IconData,
                    cardHeight,
                  ),
                ),
                const SizedBox(width: 16, height:16),
                
                if (i + 1 < services.length)
                  CustomExpanded(
                    isExpanded: !isMobile,
                    child: _buildServiceCard(
                      context,
                      theme,
                      services[i + 1]['title'].toString(),
                      services[i + 1]['description'].toString(),
                      services[i + 1]['icon'] as IconData,
                      cardHeight,
                    ),
                  )
                else
                  CustomExpanded(
                    isExpanded:!isMobile,
                    child: Container()
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    ThemeData theme,
    String title,
    String description,
    IconData icon,
    double height,
  ) {
    return PopupHoverCard(
      
      popupColor: Colors.black.withValues(alpha: 0.1),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon Container
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
              ],
            ),
            // Title and Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                
                
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartJourneyCard(BuildContext context, ThemeData theme) {
    return PopupHoverCard(
      popupColor: Colors.black.withValues(alpha: 0.1),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor,
              theme.primaryColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ready to Start?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Begin your journey and create your first project today',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.rocket_launch_outlined,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                // width: double.infinity,
                height: 48,
                child: PopupHoverCard(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to Projects page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProjectPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Start Your Journey',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

