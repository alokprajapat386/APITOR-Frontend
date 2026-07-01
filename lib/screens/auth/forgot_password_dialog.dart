import 'package:apitor/analytics/data/reset_password_request_dto.dart';
import 'package:apitor/analytics/data/reset_request_verification_dto.dart';
import 'package:apitor/analytics/service/auth_service.dart';
import 'package:apitor/analytics/service/storage/password_reset_token_storage.dart';
import 'package:flutter/material.dart';
import 'package:apitor/screens/auth/auth_components.dart';

void showForgotPasswordDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController(); 
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isSubmitting = false;
  int currentStage = 1; // 1: Request OTP/Token, 2: Reset Password

  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      final theme = Theme.of(context);

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.all(32.0), 
            backgroundColor: Colors.white,
            content: SizedBox(
              width: 400, 
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header Setup ---
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            currentStage == 1 ? Icons.lock_reset_outlined : Icons.verified_user_outlined,
                            size: 24,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          currentStage == 1 ? 'Reset Password' : 'Verify Details',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // --- STAGE 1 UI FIELDS ---
                    if (currentStage == 1) ...[
                      AuthFormField(
                        field: 'Username / Email',
                        placeholder: 'Enter registered usernme or email',
                        controller: identifierController,
                        icon: Icons.person_outline,
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Identity parameter cannot be blank";
                          }
                          return null;
                        },
                      ),
                    ],

                    // --- STAGE 2 UI FIELDS ---
                    if (currentStage == 2) ...[
                      AuthFormField(
                        field: '6-Digit OTP',
                        placeholder: 'Enter OTP sent to your mail status loop',
                        controller: otpController,
                        icon: Icons.lock_clock_outlined,
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "OTP cannot be blank";
                          }
                          if (value.trim().length < 6) {
                            return "Enter a valid 6-digit confirmation code";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AuthFormField(
                        field: 'New Password',
                        placeholder: 'Enter your new secure code engine string',
                        controller: passwordController,
                        icon: Icons.vpn_key_outlined,
                        isPassword: true, 
                        validate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Password configuration string cannot be empty";
                          }
                          if (value.trim().length < 6) {
                            return "Password must be at least 6 characters long";
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 32),

                    // --- PRIMARY ACTION BUTTON (Submit / Get OTP) ---
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
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  setDialogState(() { isSubmitting = true; });

                                  try {
                                    // ---- EXECUTE STAGE 1 ----
                                    if (currentStage == 1) {
                                      ResetPasswordRequestDTO request =ResetPasswordRequestDTO(identifier: identifierController.text);
                                      final response = await AuthService.generatePasswordResetToken(request);
                                      PasswordResetTokenStorageService.saveTempToken(response.token);
                                      if(!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('OTP sent successfully! Valid for 5 minutes'),
                                        )
                                      );
                                      setDialogState((){
                                            currentStage = 2;
                                      });
                                      
                                    } 
                                    // ---- EXECUTE STAGE 2 ----
                                    else if (currentStage == 2) {
                                       ResetRequestVerificationDTO request = ResetRequestVerificationDTO(otp: otpController.text, token: PasswordResetTokenStorageService.getTempToken() ?? (() => throw Exception("Reset token not available!"))(), newPassword: passwordController.text);
                                       await AuthService.verifyPasswordResetToken(request);
                                       if(!context.mounted) return;
                                       ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Password reset successfully!')),
                                       );
                                       if(context.mounted) Navigator.of(context).pop();
                                    }
                                    
                                  } catch (e) {
                                    if(!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Something went wrong! : ${e.toString()}')),
                                       );
                                  } finally {
                                    setDialogState(() { isSubmitting = false; });
                                  }
                                }
                              },
                        child: !isSubmitting
                            ? Text(
                                currentStage == 1 ? 'Get OTP' : 'Reset Password',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Transform.scale(
                                scale: 0.75,
                                child: const CircularProgressIndicator(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- CANCEL BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 210, 210, 210),
                          foregroundColor: const Color.fromARGB(255, 189, 189, 189).withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          elevation: 2,
                        ),
                        onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.black.withValues(alpha: 0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}