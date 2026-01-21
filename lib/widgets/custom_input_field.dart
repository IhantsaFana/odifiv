import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixIconPressed;
  final int maxLines;

  const CustomInputField({
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSuffixIconPressed,
    this.maxLines = 1,
    super.key,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: const Color(0xFF1a4d7e),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocus(bool isFocused) {
    setState(() => _isFocused = isFocused);
    if (isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _borderColorAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1a4d7e).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Focus(
                onFocusChange: _handleFocus,
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  maxLines: widget.obscureText ? 1 : widget.maxLines,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    labelText: null,
                    prefixIcon: Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? const Color(0xFF1a4d7e)
                          : Colors.grey[400],
                    ),
                    suffixIcon: widget.suffixIcon != null
                        ? IconButton(
                            icon: Icon(
                              widget.suffixIcon,
                              color: _isFocused
                                  ? const Color(0xFF1a4d7e)
                                  : Colors.grey[400],
                            ),
                            onPressed: widget.onSuffixIconPressed,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _borderColorAnimation.value ?? Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1a4d7e),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE74C3C),
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE74C3C),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
