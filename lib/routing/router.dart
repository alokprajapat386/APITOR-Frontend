

import 'package:apitor/analytics/data/project_details_dto.dart';
import 'package:apitor/analytics/service/auth_service.dart';
import 'package:apitor/screens/auth/auth_page.dart';
import 'package:apitor/screens/auth/login_page.dart';
import 'package:apitor/screens/auth/register_page.dart';
import 'package:apitor/screens/dashboard/dashboard.dart';
import 'package:apitor/screens/dashboard/home_page.dart';
import 'package:apitor/screens/dashboard/project_page.dart';
import 'package:apitor/screens/dashboard/metrics_analytics.dart';
import 'package:apitor/screens/dashboard/settings_page.dart';
import 'package:apitor/screens/landing_page/landing_page.dart';

import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async{
      final bool isLoggedin = await AuthService.isLoggedin();
     

      if(!isLoggedin &&  state.matchedLocation.startsWith('/dashboard')){
        return '/auth/login';
      }
      if(isLoggedin &&  state.matchedLocation.startsWith('/auth')){
        return '/dashboard';
      }

      return null;
      
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const  LandingPage(),
    ),
    ShellRoute(
      builder: (context, state, child){
        return AuthScreen(child:child);
      },

      routes: [
        GoRoute(
          path: '/auth/login',
          builder: (context, state) => LoginMain(),
        ),
        GoRoute(
          path: '/auth/register',
          builder: (context, state) => RegisterMain(),
        )

      ]

    ),
    ShellRoute(
      builder: (context, state, child) {
        return HomePage(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardComponent(), // Sub-page 1
        ),
        GoRoute(
          path: '/dashboard/projects',
          builder: (context, state) => ProjectPage(),
        ),
        GoRoute(
          path: '/dashboard/projects/analytics',
        
          redirect: (context, state){
            final project  = state.extra as ProjectDetailsDTO?;
            if(project==null){
              return '/dashboard/projects';
            }
            return null;
          },
          builder: (context, state){
              final project = state.extra as ProjectDetailsDTO;
              return MetricsAnalyticsPage(project: project);
          }
          
        ),
        
        GoRoute(
          path: '/dashboard/settings',
          builder: (context, state) => SettingsPage(),
        ),

      ],
    ),
  ]
);