

import 'package:flutter/services.dart';

class MayusculasFormatter extends TextInputFormatter {
  
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue){
    
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }

}