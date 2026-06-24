import '../providers/locale_provider.dart';

/// Fixed exchange rates (USD → target). Updated periodically.
const Map<String, double> _usdRates = {
  'USD': 1.0,
  'CNY': 7.25,
  'JPY': 150.0,
  'KRW': 1350.0,
  'RUB': 88.0,
  'EUR': 0.92,
};

/// Locale-aware currency formatting.
class CurrencyUtil {
  CurrencyUtil._();

  /// Format price_cents (USD base) into the current locale's currency.
  /// e.g. 4999 USD cents → "$49.99" or ¥362" or "€45.99"
  static String format(int cents) {
    final loc = LocaleNotifier.I.value;
    final rate = _usdRates[loc.currencyCode] ?? 1.0;
    final converted = (cents / 100) * rate;
    final sym = loc.currencySymbol;

    // JPY, KRW, RUB: no decimal
    if (loc.currencyCode == 'JPY' || loc.currencyCode == 'KRW' || loc.currencyCode == 'RUB') {
      return '$sym${converted.round()}';
    }

    return '$sym${converted.toStringAsFixed(2)}';
  }
}
