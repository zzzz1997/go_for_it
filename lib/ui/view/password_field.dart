import 'package:flutter/material.dart';

///
/// 密码输入控件
///
class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.controller,
    this.hintText,
    this.labelText,
    this.icon,
    this.onSaved,
    this.validator,
  });

  // 空间键
  final Key fieldKey;
  // 文本编辑控制器
  final TextEditingController controller;
  // 提示文本
  final String hintText;
  // 标签文本
  final String labelText;
  // 图标
  final Icon icon;
  // 表单设置器
  final FormFieldSetter<String> onSaved;
  // 表单验证器
  final FormFieldValidator<String> validator;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

///
/// 密码输入控件状态
///
class _PasswordFieldState extends State<PasswordField> {
  // 是否隐藏v密码
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      obscureText: _obscureText,
      onSaved: widget.onSaved,
      validator: widget.validator,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        icon: widget.icon,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child:
          Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
