import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;
  final bool showSuffixIcon;
  final bool passwordVisible;
  final ValueChanged<String>? onChanged;
  final bool enableObscureText;
  final VoidCallback? suffixIconOnPressed;

  const MyTextField({
    Key? key,
    required this.controller,
    this.labelText,
    this.keyboardType,
    this.suffixIcon,
    this.showSuffixIcon = false,
    required this.passwordVisible,
    this.onChanged,
    this.enableObscureText = false,
    this.suffixIconOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: enableObscureText ? !passwordVisible : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        contentPadding: const EdgeInsets.only(
          left: 16.0,
          bottom: 12.0,
          top: 12.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(24.0),
        ),
        suffixIcon: showSuffixIcon
            ? Padding(
                padding: const EdgeInsets.only(
                    right: 5.0), 
                child: IconButton(
                  icon: Icon(
                    suffixIcon ??
                        (passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: suffixIconOnPressed,
                ),
              )
            : null,
      ),
      keyboardType: keyboardType,
      maxLines: 1,
    );
  }
}
