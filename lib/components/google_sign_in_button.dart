import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

class GoogleSignInButtonWeb extends StatelessWidget {
  const GoogleSignInButtonWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: web.renderButton(
        configuration: web.GSIButtonConfiguration(
          type: web.GSIButtonType.standard,
          theme: web.GSIButtonTheme.outline,
          size: web.GSIButtonSize.large,
          shape: web.GSIButtonShape.pill,
          text: web.GSIButtonText.continueWith,
          logoAlignment: web.GSIButtonLogoAlignment.left, 
          minimumWidth: 280
        ),
        
      ),
    );
  }
}