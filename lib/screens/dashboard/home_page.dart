import 'package:apitor/analytics/data/user_details_dto.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';
import 'package:apitor/analytics/service/storage/user_profile_storage_service.dart';
import 'package:apitor/components/pop_up_card.dart';
import 'package:apitor/routing/user_session.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDrawerOpen = false;
  final double _drawerWidth = 280;
  UserDetailsDTO user=UserDetailsDTO.defaultProfile;

  @override
  void initState()  {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try{
      final response = await UserProfileStorageService.fetchProfile();
      if(!mounted) return;
      setState((){
        user = response ?? UserDetailsDTO.defaultProfile;
      });

    }catch(e){
      setState((){
        user = UserDetailsDTO.defaultProfile;
      });
    }
  }



  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String currentRoute = GoRouterState.of(context).matchedLocation;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth<450;


    return ValueListenableBuilder(valueListenable: UserSession.instance.notifier, builder: (context, userDetails, child) {
      

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _toggleDrawer,
          ),
          title: InkWell(
            onTap:  ()  {
              context.go('/');
            },
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: 
                  Image.asset(
                    'assets/icons/apitor_logo.png',
                    width: 30,
                    height: 30,
                    // color:Colors.white,
                    filterQuality: FilterQuality.high,
                  )
                ),
                const SizedBox(
                  width: 12,
                ),
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
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          elevation: 2,
        ),
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
          // color: theme.scaffoldBackgroundColor,
          child: Stack(
            children: [
              // Main Content
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _isDrawerOpen ? (isMobile? 0: _drawerWidth) : 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _isDrawerOpen ? _closeDrawer : null,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            
                            constraints: BoxConstraints(
                              minWidth: isMobile?310:750, 
                              maxWidth: isMobile?(screenWidth * 0.75 < 310 ? 310 : screenWidth * 0.75):
                              (screenWidth * 0.6 < 750 ? 750 : screenWidth * 0.6)
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              if (_isDrawerOpen && isMobile)
                GestureDetector(
                  onTap: _closeDrawer,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5), 
                  ),
                ),
      
              // Drawer
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _isDrawerOpen ? 0 : -_drawerWidth,
                top: 0,
                bottom: 0,
                width: _drawerWidth,
                child: Container(
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: _buildDrawer(context, theme, _closeDrawer, currentRoute),
                ),
              ),
      
             
            ],
          ),
        )
      );
  });

    
  }

  Widget _buildDrawer(BuildContext context, ThemeData theme, VoidCallback closeDrawer, String currentRoute) {
    return Column(
      // padding: EdgeInsets.zero,
      
      children: [
        // App Header Section
        PopupHoverCard(
          child: Container(

            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(6)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap:(){
                    context.go('/dashboard');
                    setState((){
                      currentRoute='/dashboard';
                    });
                    closeDrawer();
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child:  Image.asset(
                            'assets/icons/apitor_logo.png',
                            width: 30,
                            height: 30,
                            // color: theme.primaryColor,
                            filterQuality: FilterQuality.high,

                        )
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'APITOR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // User Profile Section
        PopupHoverCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Icon
              
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Full Name
                Center(
                  child: Text(
                    user.fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Username
                Center(
                  child: Text(
                    user.username,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Divider
        Divider(
          color: theme.primaryColor.withValues(alpha: 0.2),
          height: 1,
          thickness: 1,
        ),

        // Navigation Tiles
        const SizedBox(height: 8),

        // Projects Tile
        PopupHoverCard(
          // popupColor: Colors.black.withValues(alpha:0.1),
          color: (currentRoute=='/dashboard/projects'
          ?theme.primaryColor.withValues(alpha:0.05)
          : Colors.transparent
          ),
          child: ListTile(
            
            leading: Icon(
              Icons.folder_outlined,
              color: theme.primaryColor,
            ),
            title: Text(
              'Projects',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              context.go('/dashboard/projects');
              closeDrawer();
            },
            selected: currentRoute=='/dashboard/projects',
            selectedTileColor: theme.primaryColor.withValues(alpha:0.1),
          ),
        ),

        // Spacer to push settings and logout to bottom
        const Spacer(),

        // Settings Tile
        PopupHoverCard(
          color: (currentRoute=='/dashboard/settings'
          ?theme.primaryColor.withValues(alpha:0.05)
          : Colors.transparent
          ),
          child: ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: theme.primaryColor,
            ),
            title: Text(
              'Settings',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
               context.go('/dashboard/settings');
               closeDrawer();
         
            }, 
            selected: currentRoute=='/dashboard/settings',
            selectedTileColor:Colors.deepOrange,
          ),
        ),

        // Logout Tile
        PopupHoverCard(
          child: ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red[400],
            ),
            title: Text(
              'Logout',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.red[400],
              ),
            ),
            onTap: () {
              JwtTokenStorage.clearToken();
              UserProfileStorageService.clearProfile();
              context.go('/auth/login');

              // closeDrawer();
            },
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
