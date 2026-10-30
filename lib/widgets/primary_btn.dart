import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

class PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final FontWeight? fontWeight;

  const PrimaryBtn({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: cinemaBrand,
        foregroundColor: cinemaFontWhite,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontWeight: fontWeight),
      ),
    );
  }
}
