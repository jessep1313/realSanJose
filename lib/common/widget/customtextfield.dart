import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTextField extends ConsumerStatefulWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final bool isPassword;
  final Widget? leadingIconData;
  final Widget? trailing;
  bool isVisible = false;
  final String? errorText;
  final Color? color;

  CustomTextField({
    required this.hintText,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.leadingIconData,
    this.trailing,
    this.errorText,
    this.color = Colors.white,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      CustomTextFieldState();
}

class CustomTextFieldState extends ConsumerState<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 45,
          child: TextFormField(
            maxLines: 1,
            obscureText: widget.isPassword
                ? !widget.isVisible
                    ? true
                    : false
                : false,
            cursorColor: Colors.black12,
            keyboardType: widget.textInputType,
            controller: widget.controller,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              hintText: widget.hintText,
              errorText: widget.errorText == "" ? null : widget.errorText,
              hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
              prefixIcon: widget.leadingIconData,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () {
                        widget.isVisible = !widget.isVisible;
                        setState(() {});
                      },
                      child: Icon(
                        widget.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    )
                  : widget.trailing,
              fillColor: widget.color,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

