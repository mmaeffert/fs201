import "package:intl/intl.dart";

class TextKit{

  static String textwithEuro(double input) {
    return   NumberFormat.currency(locale: 'eu')
        .format(input).toString();
  }
}