import 'package:apitor/analytics/data/password_change_request_dto.dart';
import 'package:apitor/analytics/data/user_update_request_dto.dart';
import 'package:apitor/analytics/service/storage/jwt_token_storage_service.dart';
import 'package:apitor/analytics/service/storage/user_profile_storage_service.dart';
import 'package:apitor/analytics/service/user_service.dart';
import 'package:apitor/components/custom_expanded.dart';
import 'package:apitor/components/custom_snack_bar.dart';
import 'package:apitor/screens/auth/auth_components.dart';
import 'package:flutter/material.dart';

import 'package:apitor/routing/user_session.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isEditing = false;
  bool _isSavingProfile = false;

  final _profileFormKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = UserSession.instance.user;
    _fullNameController = TextEditingController(text: user.fullName);
    _usernameController = TextEditingController(text: user.username);
    _emailController = TextEditingController(text: user.email);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      final user = UserSession.instance.user;
      _fullNameController.text = user.fullName;
      _usernameController.text = user.username;
      _emailController.text = user.email;
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;

    setState(() => _isSavingProfile = true);

    try {
      final updatedUser = UserUpdateRequestDTO(
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(), 
      );

      final response = await UserService.updateUserProfile(updatedUser);
      await UserProfileStorageService.saveProfile(response.userDetails);
      await JwtTokenStorage.saveToken(response.token);
      UserSession.instance.setUser(response.userDetails);

      if (!mounted) return;
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.success('Profile Updated Successfully', '')
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.error('Failed to update profile', e)
      );
    } finally {
      if (mounted) setState(() => _isSavingProfile = false);
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(dialogContext);
        final screenWidth= MediaQuery.of(context).size.width;
        bool isMobile = screenWidth<450;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding:  EdgeInsets.all(isMobile? 10: 32.0),
              backgroundColor: Colors.white,
              content: SizedBox(
                width: 320,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
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
                              Icons.lock_outline,
                              size: 24,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Change Password',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Old Password
                      AuthFormField(
                        controller: oldPasswordController,
                        field: 'Old Password',
                        icon: Icons.lock_outline_rounded,
                        placeholder: 'Enter your old password',
                        isPassword: true,
                        obscurePassword: true,
                        validate: (value){
                          if(value==null || value.isEmpty){
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // New Password
                       AuthFormField(
                        controller: newPasswordController,
                        field: 'New Password',
                        icon: Icons.lock_outline_rounded,
                        placeholder: 'Enter new password',
                        isPassword: true,
                        obscurePassword: true,
                        validate: (value){
                          if(value==null || value.isEmpty){
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Confirm New Password
                       AuthFormField(
                        controller: confirmPasswordController,
                        field: 'Confirm Password',
                        icon: Icons.lock_outline_rounded,
                        placeholder: 'Enter password again',
                        isPassword: true,
                        obscurePassword: true,
                        validate: (value){
                          if(value==null || value.isEmpty){
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 44,
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
                                  if (!formKey.currentState!.validate()) return;

                                  setDialogState(() => isSubmitting = true);

                                  try {

                                    PasswordChangeRequestDTO request = PasswordChangeRequestDTO(
                                      oldPassword: oldPasswordController.text,
                                      newPassword: newPasswordController.text,
                                    );
                                    await UserService.changePassword(
                                     request
                                    );

                                    if (dialogContext.mounted) {
                                      Navigator.of(dialogContext).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        CustomSnackBar.success('Password Changed Successfully', 'Never share your password to anyone')                                      );
                                    }
                                  } catch (e) {
                                    setDialogState(() => isSubmitting = false);
                                    if (dialogContext.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                                        CustomSnackBar.error('Failed to change password', e)
                                      );
                                    }
                                  }
                                },
                          child: !isSubmitting
                              ? Text(
                                  'Update Password',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Transform.scale(
                                  scale: 0.75,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 210, 210, 210),
                            foregroundColor: const Color.fromARGB(255, 189, 189, 189).withValues(alpha:0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            elevation: 2,
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.black.withValues(alpha:0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                            
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

  Widget _buildField(
    ThemeData theme, {
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool isEditing,
    required String placeholder,
    String? Function(String?)? validator,
  }) {
    if (isEditing) {
      return AuthFormField(
        controller: controller,
        field: label,
        icon: Icons.lock_outline_rounded,
        placeholder: placeholder,
        validate: validator,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.primaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          controller.text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.primaryColor.withValues(alpha: 0.1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth<450;
    return ValueListenableBuilder(
      valueListenable: UserSession.instance.notifier,
      builder: (context, userDetails, child) {
        return Container(
            padding:  EdgeInsets.symmetric(horizontal: (isMobile?16:24), vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                // padding: const EdgeInsets.all(24.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Account Settings',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    Spacer(),
                      IconButton(
                        onPressed: _isSavingProfile ? null : _toggleEdit,
                          icon: Icon(

                          _isEditing ? Icons.close : Icons.edit_outlined,
                          color: theme.primaryColor,
                        ),
                        tooltip: _isEditing ? 'Cancel editing' : 'Edit profile',
                      ),
                   
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Flex(
                  direction: isMobile? Axis.vertical: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomExpanded(
                      isExpanded: !isMobile,
                      flex: 6,
                      child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                      child: Form(
                        key: _profileFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(Icons.person, size: 40, color: theme.primaryColor),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  // isExpanded: !isMobile,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userDetails.fullName,
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '@${userDetails.username}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                               
                              ],
                            ),
                            const SizedBox(height: 32),

                            _buildField(
                              theme,
                              label: 'Full Name',
                              icon: Icons.badge_outlined,
                              placeholder: 'Enter your full Name',
                              controller: _fullNameController,
                              isEditing: _isEditing,
                            ),
                            _buildFieldDivider(theme),

                            _buildField(
                              theme,
                              label: 'Username',
                              icon: Icons.alternate_email,
                              placeholder: 'Enter your username',
                              controller: _usernameController,
                              isEditing: _isEditing,
                            
                            ),
                            _buildFieldDivider(theme),

                            _buildField(
                              theme,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              controller: _emailController,
                              placeholder: 'Enter your email',
                              isEditing: _isEditing,
                              validator: (v) {
                                if(v==null) return null;
                                if (!v.contains('@')) return 'Enter a valid email';
                                return null;
                              },
                            ),

                            if (_isEditing) ...[
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: _isSavingProfile ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: !_isSavingProfile
                                      ? Text(
                                          'Save Changes',
                                          style: theme.textTheme.labelLarge?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : Transform.scale(
                                          scale: 0.75,
                                          child: const CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      ),
                    ),

                    const SizedBox(width: 16, height:16),

                   
                    CustomExpanded(
                      flex: 4,
                      isExpanded:!isMobile,
                      child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.lock_outline, color: theme.primaryColor, size: 24),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Password',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        
                          const SizedBox(height: 4),
                          Text(
                            'Change your account password',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => _showChangePasswordDialog(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: theme.primaryColor),
                                foregroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Change Password',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
