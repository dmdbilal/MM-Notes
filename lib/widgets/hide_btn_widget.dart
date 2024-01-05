import 'package:flutter/material.dart';

class HideButton extends StatefulWidget {
  final bool initialVisibility;
  final ValueChanged<bool> onVisibilityChanged;
  
  HideButton({
    super.key,
    required this.initialVisibility,
    required this.onVisibilityChanged
  });

  @override
  State<HideButton> createState() => _HideButtonState();
}

class _HideButtonState extends State<HideButton> {
  late bool isVisible;
  
  @override
  void initState() {
    super.initState();
    isVisible = widget.initialVisibility;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
              icon: isVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                  widget.onVisibilityChanged(isVisible);
                });
              },
            );
  }
}