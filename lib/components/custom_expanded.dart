

import 'package:flutter/material.dart';

class CustomExpanded extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final int flex;

  const CustomExpanded({
    super.key, 
    required this.child,
    this.isExpanded=false,
    this.flex=1
  });

  @override
  Widget build(BuildContext context) {
    return isExpanded?
    Expanded( flex:flex, child:child):
    child;
  }
}