import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/cart_provider.dart';
import '../../providers/locale_provider.dart';
import '../../i18n/translations.dart';
import '../../services/api_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'US');
  final _phoneCtrl = TextEditingController();
  bool _processing = false;
  String? _orderId;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _addrCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    _countryCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _processing = true;
      _error = null;
    });
    final cart = context.read<CartProvider>();

    // 1. Create order
    final orderId = await cart.checkout(
      shippingAddress: {
        'name': _nameCtrl.text.trim(),
        'address': _addrCtrl.text.trim(),
        'city': _cityCtrl.text.trim(),
        'state': _stateCtrl.text.trim(),
        'zip': _zipCtrl.text.trim(),
        'country': _countryCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
      },
      contactEmail: _emailCtrl.text.trim(),
    );

    if (orderId == null) {
      if (mounted) {
        setState(() {
          _processing = false;
          _error = Translations.I.orderFailed;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TrText('order.failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // 2. Get Stripe Checkout URL
    final piRes = await _api.post('/api/orders/$orderId/payment-intent', body: {});
    if (piRes.isOk && piRes.data != null && piRes.data['checkout_url'] != null) {
      final checkoutUrl = piRes.data['checkout_url'] as String;
      cart.clear();
      // 3. Redirect to Stripe Checkout
      final uri = Uri.parse(checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (mounted) Navigator.pop(context);
      } else {
        // Fallback: show URL to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please complete payment: $checkoutUrl')),
          );
        }
      }
    } else {
      // Payment intent failed but order was created
      if (mounted) {
        setState(() {
          _processing = false;
          _error = Translations.I.orderContactSupport;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TrText('order.contactSupport'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  static const _gold = Color(0xFFC8A45C);
  static const _cream = Color(0xFFF5F0E8);
  static const _darkBg = Color(0xFF0A0A0A);
  static const _surface = Color(0xFF1A1A1A);
  static const _border = Color(0xFF333333);

  InputDecoration _inputDeco(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: _gold),
      hintStyle: const TextStyle(color: Color(0xFF666666)),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _border),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _gold, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      filled: true,
      fillColor: _surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (_orderId != null) {
      return Scaffold(
        backgroundColor: _darkBg,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: _gold),
            onPressed: () => Navigator.pop(context),
          ),
          title: TrText('order.orderConfirmed',
              style: const TextStyle(color: _gold, fontFamily: 'Serif')),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 80, color: _gold),
                const SizedBox(height: 24),
                TrText('order.orderPlaced',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _cream)),
                const SizedBox(height: 8),
                Text('${Translations.I.orderOrderId}: $_orderId',
                    style: const TextStyle(color: _cream, fontSize: 14)),
                const SizedBox(height: 8),
                Text('${Translations.I.orderTotal}: ${cart.totalStr}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _gold)),
                const SizedBox(height: 24),
                TrText('order.shippingNotice',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF999999))),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: TrText('order.backToShop',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _gold),
          onPressed: () => Navigator.pop(context),
        ),
        title: TrText('cart.checkout',
            style: const TextStyle(color: _gold, fontFamily: 'Serif', fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Order Summary ---
            Container(
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrText('order.summary',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _gold)),
                  const SizedBox(height: 12),
                  ...cart.items.map((i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('${i.name} x${i.quantity}',
                              style: const TextStyle(color: _cream, fontSize: 14)),
                        ),
                        Text('\$${(i.totalCents / 100).toStringAsFixed(2)}',
                            style: const TextStyle(color: _cream, fontSize: 14)),
                      ],
                    ),
                  )),
                  const Divider(color: _border, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TrText('order.total',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: _cream, fontSize: 16)),
                      Text(cart.totalStr,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: _gold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Shipping Heading ---
            TrText('order.shippingInfo',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _gold)),
            const SizedBox(height: 12),

            TextFormField(
              controller: _emailCtrl,
              decoration: _inputDeco(Translations.I.orderEmail),
              style: const TextStyle(color: _cream),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || v.isEmpty ? Translations.I.orderRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: _inputDeco(Translations.I.orderFullName),
              style: const TextStyle(color: _cream),
              validator: (v) => v == null || v.isEmpty ? Translations.I.orderRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addrCtrl,
              decoration: _inputDeco(Translations.I.orderAddress),
              style: const TextStyle(color: _cream),
              validator: (v) => v == null || v.isEmpty ? Translations.I.orderRequired : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _cityCtrl,
                    decoration: _inputDeco(Translations.I.orderCity),
                    style: const TextStyle(color: _cream),
                    validator: (v) => v == null || v.isEmpty ? Translations.I.orderRequired : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _stateCtrl,
                    decoration: _inputDeco(Translations.I.orderState),
                    style: const TextStyle(color: _cream),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _zipCtrl,
                    decoration: _inputDeco(Translations.I.orderZip),
                    style: const TextStyle(color: _cream),
                    validator: (v) => v == null || v.isEmpty ? Translations.I.orderRequired : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _countryCtrl,
                    decoration: _inputDeco(Translations.I.orderCountry),
                    style: const TextStyle(color: _cream),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _phoneCtrl,
                    decoration: _inputDeco(Translations.I.orderPhone),
                    style: const TextStyle(color: _cream),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),

            // --- Error display ---
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 14)),
            ],

            const SizedBox(height: 24),

            // --- Place Order Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processing ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: Color(0xFF6B5A30),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _processing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black))
                    : Text('${Translations.I.orderPlaceOrder} — ${cart.totalStr}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
