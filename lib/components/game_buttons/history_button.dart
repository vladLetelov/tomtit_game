import 'package:flutter/material.dart';

class HistoryGameButton extends StatelessWidget {
  const HistoryGameButton({
    super.key,
    required this.onTap,
    required this.backgroundImage,
    this.isLocked = false,
  });

  final VoidCallback onTap;
  final String backgroundImage;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLocked ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isLocked ? Colors.grey : Colors.deepPurple,
          ),
        ),
      ),
      child: Container(
        width: 300, // Задайте нужный размер
        height: 600, // Задайте нужный размер
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: isLocked
                ? ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.srcATop,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
