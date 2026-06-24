import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:bracelet_web/providers/locale_provider.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';
import '../../models/models.dart';
import '../../i18n/currency_util.dart';
import '../admin/admin_screen.dart';
import '../../providers/locale_provider.dart';

// Luxury dark theme palette
const Color _bgDark = Color(0xFF0A0A0A);
const Color _surfaceDark = Color(0xFF1A1A1A);
const Color _gold = Color(0xFFC8A45C);
const Color _cream = Color(0xFFF5F0E8);
const Color _copper = Color(0xFFB87333);
const Color _copperDark = Color(0xFFA0622A);

const _serif = 'Georgia';
const _sans = 'Helvetica';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _api = ApiService();

  void _showDesignActions(UserDesign design) {
    final nameCtrl = TextEditingController(text: design.name);
    final priceCtrl = TextEditingController(
      text: design.priceCents > 0 ? '${design.priceCents / 100}' : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text('Edit Design', style: const TextStyle(color: Color(0xFFC8A45C), fontFamily: 'Cormorant Garamond')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color(0xFFC8A45C)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFC8A45C))),
                ),
                style: const TextStyle(color: Color(0xFFF5F0E8)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price (USD)',
                  labelStyle: TextStyle(color: Color(0xFFC8A45C)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFC8A45C))),
                ),
                style: const TextStyle(color: Color(0xFFF5F0E8)),
              ),
              const SizedBox(height: 12),
              Text('Status: ${design.isPublished ? "Published" : "Draft"}',
                  style: TextStyle(color: const Color(0xFFF5F0E8).withValues(alpha: 0.7))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFFF5F0E8))),
          ),
          if (!design.isPublished)
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await _publishDesign(design.id, nameCtrl.text, priceCtrl.text);
              },
              child: const Text('Publish', style: TextStyle(color: Color(0xFF4CAF50))),
            ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _saveDesign(design.id, nameCtrl.text, priceCtrl.text);
            },
            child: const Text('Save', style: TextStyle(color: Color(0xFFC8A45C))),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDesign(String id, String name, String priceStr) async {
    final priceCents = (double.tryParse(priceStr) ?? 0) * 100;
    final res = await _api.put('${ApiConfig.designs}/$id', body: {
      'name': name,
      'price_cents': priceCents.toInt(),
    });
    if (res.isOk) _loadDesigns();
  }

  Future<void> _publishDesign(String id, String name, String priceStr) async {
    final priceCents = (double.tryParse(priceStr) ?? 0) * 100;
    if (priceCents <= 0) return;
    // First save, then publish
    await _api.put('${ApiConfig.designs}/$id', body: {
      'name': name,
      'price_cents': priceCents.toInt(),
    });
    final res = await _api.post('${ApiConfig.designs}/$id/publish');
    if (res.isOk) _loadDesigns();
  }

  // Data
  List<Order> _orders = [];
  List<UserDesign> _myDesigns = [];
  Map<String, dynamic>? _earnings;
  bool _loadingOrders = true;
  bool _loadingDesigns = true;
  bool _loadingEarnings = true;

  @override
  void initState() {
    super.initState();
    LocaleNotifier.I.addListener(_onLocaleChange);
    _load();
  }

  @override
  void dispose() {
    LocaleNotifier.I.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() => setState(() {});

  Future<void> _load() async {
    _loadOrders();
    _loadDesigns();
    _loadEarnings();
  }

  Future<void> _loadOrders() async {
    final res = await _api.get(ApiConfig.orders);
    if (res.isOk && res.data != null) {
      _orders = (res.data as List).map((j) => Order.fromJson(j)).toList();
    }
    setState(() => _loadingOrders = false);
  }

  Future<void> _loadDesigns() async {
    final res = await _api.get(ApiConfig.myDesigns);
    if (res.isOk && res.data != null) {
      _myDesigns = (res.data as List).map((j) => UserDesign.fromJson(j)).toList();
    }
    setState(() => _loadingDesigns = false);
  }

  Future<void> _loadEarnings() async {
    final res = await _api.get(ApiConfig.earnings);
    if (res.isOk && res.data != null) {
      _earnings = res.data as Map<String, dynamic>;
    }
    setState(() => _loadingEarnings = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TrText('profile.title', style: TextStyle(fontFamily: _serif, color: _gold, fontSize: 20)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: _copper),
            onPressed: () => auth.logout(),
            tooltip: Translations.I.t('profile.signOut'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: _gold,
        onRefresh: () async { _load(); },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---- User Info ----
            _buildUserHeader(auth),
            const SizedBox(height: 24),

            // ---- Earnings (designer) ----
            if (_earnings != null) ...[
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TrText('profile.designerEarnings',
                        style: TextStyle(fontFamily: _serif, color: _gold, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _EarningTile(Translations.I.t('profile.totalEarned'), CurrencyUtil.format((_earnings!['total_earned_cents'] ?? 0) as int)),
                        _EarningTile(Translations.I.t('profile.pending'), CurrencyUtil.format((_earnings!['pending_cents'] ?? 0) as int)),
                        _EarningTile(Translations.I.t('profile.designsSold'), '${_earnings!['total_design_sales'] ?? 0}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ---- Orders ----
            TrText('profile.orders', style: TextStyle(fontFamily: _serif, color: _gold, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            if (_loadingOrders)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: _gold)))
            else if (_orders.isEmpty)
              _SectionCard(child: Padding(padding: const EdgeInsets.all(24),
                  child: Center(child: TrText('profile.noOrders', style: TextStyle(color: _cream.withValues(alpha: 0.6))))))
            else
              ..._orders.take(5).map((o) => _OrderCard(order: o, onTap: () => _showOrderDetail(o))),

            const SizedBox(height: 24),

            // ---- My Designs ----
            TrText('profile.myDesigns', style: TextStyle(fontFamily: _serif, color: _gold, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            if (_loadingDesigns)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: _gold)))
            else if (_myDesigns.isEmpty)
              _SectionCard(child: Padding(padding: const EdgeInsets.all(24),
                  child: Center(child: TrText('profile.noDesigns',
                      style: TextStyle(color: _cream.withValues(alpha: 0.6))))))
            else
              ..._myDesigns.map((d) => _DesignCard(
                design: d,
                onTap: () => _showDesignActions(d),
              )),
            const SizedBox(height: 24),

            // ---- Admin panel ----
            if (auth.isAdmin) ...[
              _GoldOutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const AdminScreen(),
                  ));
                },
                icon: Icons.admin_panel_settings,
                label: Translations.I.t('profile.adminPanel'),
              ),
              const SizedBox(height: 16),
            ],

            // ---- Language selector ----
            _SectionCard(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Row(
                children: [
                  Icon(Icons.language, color: _gold, size: 20),
                  const SizedBox(width: 12),
                  Text(Translations.I.t('profile.language'),
                      style: const TextStyle(fontFamily: _sans, color: _cream, fontSize: 14)),
                  const Spacer(),
                  DropdownButtonHideUnderline(
                    child: ValueListenableBuilder<AppLocale>(
                      valueListenable: LocaleNotifier.I,
                      builder: (context, locale, _) => DropdownButton<AppLocale>(
                        dropdownColor: _surfaceDark,
                        value: locale,
                        style: const TextStyle(color: _gold, fontSize: 14),
                        selectedItemBuilder: (ctx) => AppLocale.values.map((l) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text('${l.flag} ${l.label}'),
                        )).toList(),
                        items: AppLocale.values.map((l) => DropdownMenuItem(
                          value: l,
                          child: Text('${l.flag} ${l.label}'),
                        )).toList(),
                        onChanged: (loc) {
                          if (loc == null) return;
                          LocaleNotifier.I.setLocale(loc);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),

            // ---- Logout ----
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  auth.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: CircularProgressIndicator()))),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: _copper),
                label: TrText('profile.logout', style: const TextStyle(color: _copper)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: _copper),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(AuthProvider auth) {
    final firstChar = (auth.user?.displayName ?? auth.user?.email ?? '?')[0].toUpperCase();
    return Row(
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _gold, width: 2),
          ),
          child: CircleAvatar(
            backgroundColor: _surfaceDark,
            child: Text(firstChar,
                style: TextStyle(fontFamily: _serif, fontSize: 28, fontWeight: FontWeight.bold, color: _gold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(auth.user?.displayName ?? 'User',
                  style: TextStyle(fontFamily: _serif, fontSize: 24, fontWeight: FontWeight.w400, color: _gold)),
              const SizedBox(height: 4),
              Text(auth.user?.email ?? '',
                  style: TextStyle(fontFamily: _sans, fontSize: 14, color: _cream)),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: _gold),
          onPressed: () => _showEditDialog(context, auth),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, AuthProvider auth) {
    final nameCtrl = TextEditingController(text: auth.user?.displayName ?? '');
    final bioCtrl = TextEditingController(text: auth.user?.bio ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _surfaceDark,
        title: TrText('profile.editTitle', style: TextStyle(fontFamily: _serif, color: _gold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: Translations.I.t('auth.name'),
                labelStyle: const TextStyle(color: _cream),
                border: OutlineInputBorder(borderSide: BorderSide(color: _cream.withValues(alpha: 0.3))),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _cream.withValues(alpha: 0.3))),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: _gold, width: 2)),
                filled: true,
                fillColor: _bgDark,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bioCtrl,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: Translations.I.t('profile.bio'),
                labelStyle: const TextStyle(color: _cream),
                border: OutlineInputBorder(borderSide: BorderSide(color: _cream.withValues(alpha: 0.3))),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _cream.withValues(alpha: 0.3))),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: _gold, width: 2)),
                filled: true,
                fillColor: _bgDark,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: TrText('profile.cancel', style: const TextStyle(color: _cream)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: _bgDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              await auth.updateProfile({'display_name': nameCtrl.text, 'bio': bioCtrl.text});
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: TrText('profile.save'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetail(Order order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surfaceDark,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ${order.id.substring(0, 8)}',
                style: TextStyle(fontFamily: _serif, color: _gold, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Text('Status: ${order.statusLabel}', style: const TextStyle(color: _cream)),
            Text('Total: ${order.totalStr}', style: const TextStyle(color: _gold)),
            Text('Date: ${order.createdAt.substring(0, 10)}', style: const TextStyle(color: _cream, fontSize: 12)),
            if (order.shippingAddress != null) ...[
              const SizedBox(height: 8),
              Text('Shipping: ${order.shippingAddress}',
                  style: TextStyle(color: _cream.withValues(alpha: 0.6), fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}

// ---- Reusable Components ----

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _gold, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  const _OrderCard({required this.order, required this.onTap});

  Color _statusColor(String label) {
    switch (label.toUpperCase()) {
      case 'PENDING':
        return _copper;
      case 'SHIPPED':
      case 'DELIVERED':
        return const Color(0xFF4CAF50);
      case 'CANCELLED':
        return Colors.redAccent;
      default:
        return _cream;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: _surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _cream.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #${order.id.substring(0, 8)}',
                        style: const TextStyle(fontFamily: _sans, fontSize: 14, color: Colors.white)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _statusColor(order.statusLabel).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(order.statusLabel,
                              style: TextStyle(fontSize: 11, color: _statusColor(order.statusLabel))),
                        ),
                        const SizedBox(width: 8),
                        Text(order.totalStr,
                            style: const TextStyle(fontSize: 13, color: _gold)),
                      ],
                    ),
                  ],
                ),
              ),
              Text(order.createdAt.substring(0, 10),
                  style: const TextStyle(fontSize: 12, color: _cream)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesignCard extends StatelessWidget {
  final UserDesign design;
  final VoidCallback onTap;
  const _DesignCard({required this.design, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cream.withValues(alpha: 0.1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: _bgDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: design.previewImages.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(design.previewImages.first, fit: BoxFit.cover))
                  : const Icon(Icons.diamond, size: 22, color: _gold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(design.name,
                      style: const TextStyle(fontFamily: _serif, fontSize: 14, color: _gold)),
                  const SizedBox(height: 4),
                  Text('${design.isPublished ? "Published" : "Draft"} • ${design.priceStr} • ${design.salesCount} sold',
                      style: TextStyle(fontFamily: _sans, fontSize: 12, color: _cream.withValues(alpha: 0.7))),
                ],
              ),
            ),
            Icon(
              design.isPublished ? Icons.public : Icons.lock,
              size: 18,
              color: design.isPublished ? const Color(0xFF4CAF50) : _cream.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    ));
  }
}

class _EarningTile extends StatelessWidget {
  final String label;
  final String value;
  const _EarningTile(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _gold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 12, color: _copper)),
        ],
      ),
    );
  }
}

class _GoldOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  const _GoldOutlinedButton({required this.onPressed, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: _gold),
        label: Text(label, style: const TextStyle(color: _gold)),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: _gold),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
