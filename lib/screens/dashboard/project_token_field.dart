import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectTokenField extends StatelessWidget {
  final String token;
  final TextStyle? style;

  const ProjectTokenField({
    super.key,
    required this.token,
    this.style,
  });

  void _copyToken(BuildContext context) {
    Clipboard.setData(ClipboardData(text: token));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Token copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        const TextStyle(
          color: Colors.black87,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        );

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              token,
              style: textStyle,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _copyToken(context),
          icon: const Icon(Icons.copy, size: 14),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          tooltip: 'Copy token',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
