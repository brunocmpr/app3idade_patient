import 'package:flutter/material.dart';

class AnimatedIconButton extends StatefulWidget {
  final double iconSize;
  final Color startColor;
  final Color endColor;
  final IconData icon;
  final VoidCallback onPressed;

  const AnimatedIconButton({
    Key? key,
    required this.iconSize,
    required this.startColor,
    required this.endColor,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(begin: widget.startColor, end: widget.endColor).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return SizedBox(
          height: widget.iconSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              shape: BoxShape.rectangle,
            ),
            child: IconButton(
              iconSize: widget.iconSize - 16,
              icon: Icon(widget.icon),
              onPressed: widget.onPressed,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
