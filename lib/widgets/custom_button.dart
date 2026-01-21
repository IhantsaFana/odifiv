import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;
  final double? height;

  const CustomButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor = const Color(0xFF1a4d7e),
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.height,
    super.key,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePress() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: widget.isFullWidth ? double.infinity : null,
        height: widget.height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.backgroundColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : _handlePress,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor,
              disabledBackgroundColor: widget.backgroundColor.withValues(
                alpha: 0.6,
              ),
              padding: widget.padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              elevation: 0,
            ),
            child: widget.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.textColor,
                      ),
                    ),
                  )
                : Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: widget.fontWeight,
                      color: widget.textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;

  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.borderColor = const Color(0xFF1a4d7e),
    this.textColor = const Color(0xFF1a4d7e),
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    super.key,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: widget.textColor,
      end: widget.textColor.withValues(alpha: 0.7),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _animationController.forward(),
      onExit: (_) => _animationController.reverse(),
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Padding(
                padding: widget.padding,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, child) {
                      return Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          fontWeight: widget.fontWeight,
                          color: _colorAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  const CustomOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.width,
    this.height = 56,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? const Color(0xFF1a4d7e),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? const Color(0xFF1a4d7e),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
