import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_adaptivity/adaptive_widgets.dart';

class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.placeholder,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final String? placeholder;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    if (isCupertino)
      return CupertinoTextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        autocorrect: false,
        autofocus: autofocus,
        placeholder: placeholder,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        style: TextStyle(color: Theme.of(context).primaryColor),
        clearButtonMode: OverlayVisibilityMode.editing,
        textInputAction: textInputAction,
      );
    else
      return TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        autocorrect: false,
        autofocus: autofocus,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: placeholder,
          suffixIcon: controller?.text.isNotEmpty ?? false
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller?.clear(),
                )
              : null,
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        style: TextStyle(color: Theme.of(context).primaryColor),
        textInputAction: textInputAction,
      );
  }
}
