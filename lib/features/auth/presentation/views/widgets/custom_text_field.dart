import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.isPassword = false,
    this.onChanged,
    this.controller,
    this.validator,
    this.prefixIcon,
  });

  final String? hintText;
  final bool isPassword;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Icon? prefixIcon;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) return 'Field is required';
            return null;
          },
      onChanged: widget.onChanged ?? (_) {},
      obscureText: widget.isPassword ? _obscureText : false,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon:
            widget.prefixIcon != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: widget.prefixIcon,
                )
                : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 22,
                    color: Color(0xff525252),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Color(0xff525252), fontSize: 15),
        filled: true,
        fillColor: const Color(0xffEFEFEF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 0.05),
        ),
      ),
    );
  }
}
