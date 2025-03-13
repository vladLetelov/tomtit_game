import 'package:flutter/material.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';

class DefaultGameButton extends StatelessWidget {
  const DefaultGameButton({
    super.key,
    required this.text,
    required this.onTap
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.deepPurple),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyles.defaultStyle,
        ),
      ),
    );
  }
}
