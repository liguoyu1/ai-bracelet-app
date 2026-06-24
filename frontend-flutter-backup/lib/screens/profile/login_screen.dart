import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isRegister = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    final auth = context.read<AuthProvider>();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (_isRegister) {
      final name = _nameCtrl.text.trim();
      if (name.isEmpty) {
        setState(() => _error = Translations.I.t('auth.enterName'));
        return;
      }
      await auth.register(email, pass, name);
    } else {
      await auth.login(email, pass);
    }

    if (auth.error != null && mounted) {
      setState(() => _error = auth.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isShort = screenHeight < 640;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: isShort ? 24 : 48,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Logo ──
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TrText(
                      'auth.aura',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: isShort ? 36 : 42,
                        letterSpacing: 6,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Tagline ──
                  TrText(
                    'auth.tagline',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 13,
                      fontFamily: 'Raleway',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Decorative divider ──
                  Container(
                    width: 50,
                    height: 1,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 28),

                  // ── Name field (register only) ──
                  if (_isRegister) ...[
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: Translations.I.t('auth.name'),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ── Email ──
                  TextField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                      labelText: Translations.I.t('auth.email'),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 14),

                  // ── Password ──
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: Translations.I.t('auth.password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 22),

                  // ── Submit ──
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: auth.loading ? null : _submit,
                        child: auth.loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : TrText(
                                _isRegister ? 'auth.createAccount' : 'auth.signIn',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  // ── Error ──
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: Color(0xFFCF6679),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 14),

                  // ── Toggle ──
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isRegister = !_isRegister;
                        _error = null;
                      });
                    },
                    child: TrText(
                      _isRegister
                          ? 'auth.alreadyHave'
                          : 'auth.dontHave',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFC8A45C),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
