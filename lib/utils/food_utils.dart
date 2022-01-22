import 'package:intl/intl.dart' as intl;

class FoodUtils {
  static String formatPrice(int price, {String prefix = 'đ'}) {
    return '${intl.NumberFormat.decimalPattern().format(price)}$prefix';
  }
}
