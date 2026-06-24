import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/translations.dart';

export '../i18n/translations.dart';

/// Global notifier for locale changes. Lets InheritedWidget tree update
/// without rebuilding MaterialApp.
class LocaleNotifier extends ValueNotifier<AppLocale> {
  LocaleNotifier(AppLocale value) : super(value);

  static LocaleNotifier? _instance;
  static LocaleNotifier get I => _instance!;

  static Future<LocaleNotifier> init() async {
    AppLocale locale = AppLocale.en;
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('app_locale');
      if (saved != null) {
        locale = AppLocale.values.firstWhere(
          (l) => l.name == saved,
          orElse: () => AppLocale.en,
        );
      }
    } catch (_) {}
    _instance = LocaleNotifier(locale);
    Translations.init(locale);
    return _instance!;
  }

  Future<void> setLocale(AppLocale locale) async {
    if (locale == value) return;
    Translations.init(locale);
    value = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_locale', locale.name);
    } catch (_) {}
  }
}

/// InheritedWidget that propagates locale to all descendants.
class _LocaleScope extends InheritedWidget {
  final AppLocale locale;
  const _LocaleScope({
    required this.locale,
    required super.child,
  });

  static _LocaleScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LocaleScope>();
  }

  @override
  bool updateShouldNotify(_LocaleScope old) => old.locale != locale;
}

/// Wraps child in _LocaleScope, rebuilding when locale changes.
/// Use once at the top of the widget tree (inside MaterialApp's home).
class LocaleScopeWidget extends StatefulWidget {
  final Widget child;
  const LocaleScopeWidget({super.key, required this.child});

  @override
  State<LocaleScopeWidget> createState() => _LocaleScopeWidgetState();
}

class _LocaleScopeWidgetState extends State<LocaleScopeWidget> {
  @override
  void initState() {
    super.initState();
    LocaleNotifier.I.addListener(_onLocaleChange);
  }

  @override
  void dispose() {
    LocaleNotifier.I.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return _LocaleScope(
      locale: LocaleNotifier.I.value,
      child: widget.child,
    );
  }
}

/// TrText — looks up translation key. Rebuilds when locale changes
/// via _LocaleScope dependency.
class TrText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool translate;

  const TrText(this.textKey, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.translate = true,
  });

  @override
  Widget build(BuildContext context) {
    _LocaleScope.maybeOf(context);
    final text = translate ? Translations.I.t(textKey) : textKey;
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
