import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.label,
    this.leadingWidget,
    this.backButton = false,
  });
  final String label;
  final Widget? leadingWidget;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (backButton) BackButton(),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  leadingWidget ?? SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
