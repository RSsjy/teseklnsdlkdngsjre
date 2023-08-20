import 'package:flutter/services.dart';

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();
    int selectionIndex = newValue.selection.end;

    for (int i = 0; i < newValue.text.length; i++) {
      if (i == 0) {
        newText.write('2');
        continue;
      }
      if (i == 1) {
        newText.write('0');
        continue;
      }
      if (i == 4) {
        newText.write('-');
        if (selectionIndex >= i) selectionIndex++;
      }
      newText.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
