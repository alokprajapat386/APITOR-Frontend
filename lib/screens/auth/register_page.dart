import 'package:apitor/analytics/data/register_request_dto.dart';
import 'package:apitor/analytics/service/auth_service.dart';
import 'package:apitor/analytics/service/google_auth_service.dart';
import 'package:apitor/analytics/service/password_validator.dart';
import 'package:apitor/components/google_sign_in_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_components.dart';


class RegisterMain extends StatefulWidget {

  const RegisterMain({
    super.key,
  });

  @override
  State<RegisterMain> createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late TextEditingController usernameController;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool _isLoading=false;

  Future<void> _submitForm() async{
     
    setState(() {
      _isLoading = true;
    });

    try{
      final String username = usernameController.text;
      final String fullName = fullNameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;

      RegisterRequestDTO registerRequest = RegisterRequestDTO(username: username, fullName: fullName, email: email, password: password);

      bool response = await AuthService.register(registerRequest);
      

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((response ?'Regestered successfully!, Login to Continue' : 'Failed to Register'))),
        );
        
        if(response) context.go('/auth/login');
      }
    }catch(error){
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register')),
        );
        
    }finally{
      setState((){
        _isLoading=false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
            // Register Icon and Heading
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
                    Icons.person_add,
                    size: 28,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Register',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Username Field
            AuthFormField(
              field: 'Username',
              placeholder: 'Enter your username',
              controller: usernameController,
              icon: Icons.person_outline,
              validate: (value){
                if(value==null || value.isEmpty){
                  return "Field cannot be empty";
                }
                if(value.contains('@')){
                  return "Username cannot consist '@' symbol";
                }
                return null;
              }
            ),
            const SizedBox(height: 20),
            // Full Name Field
            AuthFormField(
              field: 'Full Name',
              placeholder: 'Enter your full name',
              controller: fullNameController,
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 20),
            // Email Field
            AuthFormField(
              field: 'Email',
              placeholder: 'Enter your email',
              controller: emailController,
              icon: Icons.email_outlined,
              validate: (value){
               if(value==null || value.isEmpty){
                return 'Field cannot be empty';
               }
               else if(!EmailValidator.validate(value)){
                return 'Please enter a valid email address';
               }
               return null;
              }
            ),
            const SizedBox(height: 20),
            // Password Field
            AuthFormField(
              field: 'Password',
              placeholder: 'Create a password',
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
                return PasswordValidator.validate(value);
              },
            ),
            const SizedBox(height: 28),
            // Register Button
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
                    'Create Account',
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
              child: const Text('Sign up with Google'),
            ),
            // Sign Up Link
            SizedBox(height: 20),
            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: theme.textTheme.bodySmall,
                ),
                InkWell(
                  
                  onTap:(){
                    context.go('/auth/login');
                  },
                  child: Text(
                    'Login',
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
