import  'package:flutter/material.dart';


class AuthFormField extends StatefulWidget {
  final String field;
  final String placeholder;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final bool obscurePassword;
  final Function(bool)? onPasswordVisibilityToggle;
  final String? Function(String?)? validate;

  const AuthFormField({
    super.key,
    required this.field,
    required this.placeholder,
    required this.controller,
    required this.icon,
    this.isPassword = false,
    this.obscurePassword = true,
    this.onPasswordVisibilityToggle,
    this.validate
  });

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}


class _AuthFormFieldState extends State<AuthFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscurePassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validate ?? (value) => null,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.field,
        hintText: widget.placeholder,
        prefixIcon: Icon(
          widget.icon,
          color: theme.primaryColor,
        ),
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                  widget.onPasswordVisibilityToggle?.call(_obscureText);
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: theme.primaryColor,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.primaryColor.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        labelStyle: theme.textTheme.bodyMedium,
        hintStyle: theme.textTheme.bodySmall?.copyWith(
          color: Colors.grey[400],
        ),
      ),
    );
  }
}