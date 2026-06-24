import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/locale_provider.dart';
import 'services/api_service.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize locale before building the widget tree
  await LocaleNotifier.init();
  // Sync API lang with initial locale
  ApiService().lang = LocaleNotifier.I.value.name;
  // Update API lang on every locale change
  LocaleNotifier.I.addListener(() {
    ApiService().lang = LocaleNotifier.I.value.name;
  });
  runApp(const BraceletApp());
}

class BraceletApp extends StatefulWidget {
  const BraceletApp({super.key});

  @override
  State<BraceletApp> createState() => _BraceletAppState();
}

class _BraceletAppState extends State<BraceletApp> {
  @override
  Widget build(BuildContext context) {
    final locale = LocaleNotifier.I.value;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        title: 'AURA · Artisan Bracelets',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildDarkTheme(),
        locale: locale.flutterLocale,
        localizationsDelegates: const [],
        supportedLocales: const [
          Locale('en'), Locale('zh'), Locale('ja'),
          Locale('ko'), Locale('ru'), Locale('fr'), Locale('de'),
        ],
        home: LocaleScopeWidget(child: const AuthGate()),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.initialized) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (auth.isLoggedIn) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
