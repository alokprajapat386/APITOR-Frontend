import 'package:flutter/material.dart';

class PopupHoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color normalColor;
  final Color popupColor;
  final Color color;
  final MouseCursor cursor;

  const PopupHoverCard({
    super.key, 
    required this.child, 
    this.onTap,
    this.normalColor=Colors.transparent,
    this.popupColor=Colors.transparent,
    this.color=Colors.transparent,
    this.cursor = SystemMouseCursors.basic
    
  });

  @override
  State<PopupHoverCard> createState() => _PopupHoverCardState();
}

class _PopupHoverCardState extends State<PopupHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.cursor,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedPhysicalModel(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          shape: BoxShape.rectangle,
          elevation: _isHovered ? 12.0 : 2.0, 
          shadowColor: (_isHovered?widget.popupColor: widget.normalColor),
          color: widget.color, 
          borderRadius: BorderRadius.circular(12),
          
          child: AnimatedScale(
            scale: _isHovered ? 1.02 : 1.0, 
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: AnimatedSlide(
              offset: _isHovered ? const Offset(0, -0.03) : Offset.zero,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}