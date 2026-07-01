import 'dart:async';

import 'package:apitor/analytics/data/login_request_dto.dart';
import 'package:apitor/analytics/data/login_response_dto.dart';
import 'package:apitor/analytics/service/auth_service.dart';
import 'package:apitor/analytics/service/google_auth_service.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';
import 'package:apitor/analytics/service/storage/user_profile_storage_service.dart';
import 'package:apitor/components/google_sign_in_button.dart';
import 'package:apitor/routing/user_session.dart';
import 'package:apitor/screens/auth/forgot_password_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_components.dart';


class LoginMain extends StatefulWidget {
  const LoginMain({
    super.key,
   
  });
  @override
  State<LoginMain> createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late TextEditingController identifierController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    identifierController = TextEditingController();
    passwordController = TextEditingController();
  }

  bool _isLoading=false;

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async{
     
    setState(() {
      _isLoading = true;
    });

    try{
      final String identifier = identifierController.text;
      final String password = passwordController.text;
      LoginRequestDTO loginRequest = LoginRequestDTO(identifier: identifier, password: password);
      LoginResponseDTO response = await AuthService.login(loginRequest);

      await JwtTokenStorage.saveToken(response.token);
      UserProfileStorageService.saveProfile(response.userDetails);
    
      UserSession.instance.setUser(response.userDetails);

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed In successfully!')),
        );
        context.go('/dashboard');
      }

      if(!mounted) return;
    }catch(error){
        if(!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to LogIn!')),
        );
        
    }finally{
      setState((){
        _isLoading=false;
      });
     
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Login Icon and Heading
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.login,
                    size: 28,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Login',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Email/Username Field
            AuthFormField(
              field: 'Email or Username',
              placeholder: 'Enter your email or username',
              controller: identifierController,
              icon: Icons.email_outlined,
              validate: (value){
                if(value==null || value.isEmpty) {
                  return "This field cannot be blank";
                }else{
                  return null;
                }
              }
            ),
            const SizedBox(height: 20),
            // Password Field
            AuthFormField(
              field: 'Password',
              placeholder: 'Enter your password',
              controller: passwordController,
              icon: Icons.lock_outlined,
              isPassword: true,
              onPasswordVisibilityToggle: (obscure) {
                setState(() {
                  _obscurePassword = obscure;
                });
              },
              obscurePassword: _obscurePassword,
              validate: (value){
                if(value==null || value.isEmpty) {
                  return "This field cannot be blank";
                }else{
                  return null;
                }
              },
            ),
            const SizedBox(height: 12),
            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                 
                  showForgotPasswordDialog(context);
                },
                child: Text(
                  'Forgot Password?',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Login Button
            SizedBox(

              width: double.infinity,
              height: 40,
            
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  if(_isLoading) return;
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                child: (
                  !_isLoading ?
                  Text(
                    'Login',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ) : 
                  Transform.scale(
                    scale: 0.75,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      
                    ),
                  )
                )
              ),
            ),
            // const SizedBox(height: 15),
            Center(
              
              widthFactor: double.infinity,
              heightFactor: 1.4,
              child:Text(
                'OR',
                style: TextStyle(
                  color:Colors.grey,
                  fontSize: 12,
                )
                
              )
            ),

            kIsWeb
            ? const GoogleSignInButtonWeb()
            : ElevatedButton(
              onPressed: GoogleAuthService.signInWithGoogle,
              child: const Text('Sign in with Google'),
            ),
            // Sign Up Link
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New to Apitor? ',
                  style: theme.textTheme.bodySmall,
                ),
                InkWell(
                  onTap: (){
                     context.go('/auth/register');
                  },
                  child: Text(
                    'Create Account',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

