import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class RoundTextEditField extends StatelessWidget {
  final String placeholder;
  final int maxLength;
  final bool isDateTime;
  final TextInputType inputType;
  final format = DateFormat("yyyy/MM/dd");
  final  controller =TextEditingController();

  RoundTextEditField({this.placeholder, this.maxLength, this.isDateTime, this.inputType,controller});
 

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: isDateTime ? DateTimeField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder
          
        ),

        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ) : TextFormField(
        controller: controller,
        style: TextStyle(
          backgroundColor: Colors.white,
          fontSize: 16
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        keyboardType: inputType,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: placeholder,
          hintStyle: TextStyle(fontSize: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
