import 'package:flutter/material.dart';
import '../products/product_list_screen.dart';
import '../products/product_detail_screen.dart';
import '../designer/designer_screen.dart';
import '../energy/energy_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/locale_provider.dart';
import '../../i18n/translations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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

  final _pages = const [
    _ShopPage(),
    DesignerScreen(),
    EnergyScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: const Color(0xFF0A0A0A).withValues(alpha: 0.92),
          elevation: 0,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: const Color(0xFFF5F0E8).withValues(alpha: 0.4),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 11,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.store_outlined, size: 22),
              activeIcon: const Icon(Icons.store, size: 22),
              label: Translations.I.navShop,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.design_services_outlined, size: 22),
              activeIcon: const Icon(Icons.design_services, size: 22),
              label: Translations.I.navDesignStudio,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.auto_awesome_outlined, size: 22),
              activeIcon: const Icon(Icons.auto_awesome, size: 22),
              label: Translations.I.navEnergy,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined, size: 22),
              activeIcon: const Icon(Icons.shopping_cart, size: 22),
              label: Translations.I.navCart,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outlined, size: 22),
              activeIcon: const Icon(Icons.person, size: 22),
              label: Translations.I.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ShopPage — the home tab content
// ─────────────────────────────────────────────────────────────────────────────

class _ShopPage extends StatefulWidget {
  const _ShopPage();

  @override
  State<_ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<_ShopPage> {
  @override
  void initState() {
    super.initState();
    LocaleNotifier.I.addListener(_onLocaleChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchFeatured();
    });
  }

  @override
  void dispose() {
    LocaleNotifier.I.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() => setState(() {});

  void _showLanguagePicker(BuildContext context, Color gold) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 36, height: 4, decoration: BoxDecoration(color: gold.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text('Language', style: TextStyle(fontFamily: 'Georgia', color: gold, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...AppLocale.values.map((l) => ListTile(
                  leading: Text(l.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(l.label, style: const TextStyle(color: Color(0xFFF5F0E8), fontSize: 14)),
                  trailing: LocaleNotifier.I.value == l ? Icon(Icons.check, color: gold, size: 18) : null,
                  onTap: () {
                    LocaleNotifier.I.setLocale(l);
                    Navigator.pop(ctx);
                  },
                )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final cream = theme.colorScheme.onSurface;
    final screenHeight = MediaQuery.of(context).size.height;
    final isShort = screenHeight < 700;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. HERO BANNER ────────────────────────────────────────
              SizedBox(
                height: isShort ? 280 : 400,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Gradient background
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0A0A0A),
                            Color(0xFF1A1A1A),
                          ],
                        ),
                      ),
                    ),
                    // Decorative ornament
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Icon(
                        Icons.spa,
                        size: 200,
                        color: gold.withValues(alpha: 0.1),
                      ),
                    ),
                    // Language switcher — popup menu on tap
                    Positioned(
                      right: 16,
                      top: 8,
                      child: GestureDetector(
                        onTap: () => _showLanguagePicker(context, gold),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: gold.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.language, color: gold, size: 16),
                              const SizedBox(width: 4),
                              ValueListenableBuilder<AppLocale>(
                                valueListenable: LocaleNotifier.I,
                                builder: (_, locale, __) => Text(
                                  locale.flag,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 2),
                          TrText(
                            'home.title',
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: gold,
                              letterSpacing: 8,
                              fontSize: 56,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TrText(
                            'home.tagline',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: cream,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              SizedBox(
                                width: 170,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ProductListScreen(),
                                    ),
                                  ),
                                  child: TrText('home.shopCollection'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 170,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DesignerScreen(),
                                    ),
                                  ),
                                  child: TrText('home.designYours'),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── 2. BESTSELLERS SECTION ────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TrText(
                      'home.bestsellers',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: gold,
                        fontSize: 28,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductListScreen(),
                        ),
                      ),
                      child: TrText(
                        'home.viewAll',
                        style: TextStyle(
                          color: gold,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 320,
                child: Consumer<ProductProvider>(
                  builder: (context, provider, _) {
                    final featured = provider.featured;
                    if (featured.isEmpty && provider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (featured.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 24, right: 8),
                      children: featured.asMap().entries.map((entry) {
                        final p = entry.value;
                        return _ProductCard(
                          name: p.name,
                          price: p.priceStr,
                          imageUrl: p.images.isNotEmpty ? p.images[0] : '',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                product: p,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              // ── 3. CATEGORIES ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                child: TrText(
                  'home.categories',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: gold,
                    fontSize: 28,
                  ),
                ),
              ),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 24, right: 8),
                  children: [
                    _CategoryCard(
                      icon: Icons.diamond_outlined,
                      label: Translations.I.homeCrystal,
                      onTap: () {},
                    ),
                    _CategoryCard(
                      icon: Icons.forest_outlined,
                      label: Translations.I.homeJade,
                      onTap: () {},
                    ),
                    _CategoryCard(
                      icon: Icons.water_drop_outlined,
                      label: Translations.I.homeAmber,
                      onTap: () {},
                    ),
                    _CategoryCard(
                      icon: Icons.local_fire_department_outlined,
                      label: Translations.I.homeLava,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // ── 4. ENERGY ASSESSMENT CTA ──────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFC8A45C),
                          Color(0xFF8B7355),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative overlay
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            Icons.auto_awesome,
                            size: 100,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TrText(
                                'home.discoverEnergy',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TrText(
                                'home.energySubtitle',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 180,
                                height: 42,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A0A0A),
                                    foregroundColor: const Color(0xFFC8A45C),
                                    side: const BorderSide(
                                      color: Color(0xFF0A0A0A),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const EnergyScreen(),
                                    ),
                                  ),
                                  child: TrText(
                                    'home.startAssessment',
                                    style: const TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 5. COMMUNITY DESIGNS ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TrText(
                      'home.fromCommunity',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: gold,
                        fontSize: 28,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductListScreen(),
                        ),
                      ),
                      child: TrText(
                        'home.viewAll',
                        style: TextStyle(
                          color: gold,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _CommunityDesignCard(
                      initials: 'AK',
                      name: 'Crystal Cascade',
                      gradientColors: const [Color(0xFF2D1B69), Color(0xFF11998E)],
                    ),
                    _CommunityDesignCard(
                      initials: 'ML',
                      name: 'Lunar Tide',
                      gradientColors: const [Color(0xFF1A1A2E), Color(0xFFC8A45C)],
                    ),
                    _CommunityDesignCard(
                      initials: 'RJ',
                      name: 'Ember Flow',
                      gradientColors: const [Color(0xFF3D0C11), Color(0xFFCD7F32)],
                    ),
                    _CommunityDesignCard(
                      initials: 'TW',
                      name: 'Ocean\'s Breath',
                      gradientColors: const [Color(0xFF0F2027), Color(0xFF203A43)],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProductCard — individual product card widget
// ─────────────────────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final VoidCallback onTap;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 320,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: gold.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
              child: Image.network(
                imageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  width: 200,
                  color: const Color(0xFF1A1A1A),
                  child: Center(child: Icon(Icons.broken_image, color: gold.withValues(alpha: 0.3))),
                ),
                loadingBuilder: (_, child, progress) => progress == null ? child : Container(height: 200, width: 200, color: const Color(0xFF1A1A1A)),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF5F0E8),
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: gold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CategoryCard — luxury category card
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;
    final cream = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: gold.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold, size: 34),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'CormorantGaramond',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: cream,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CommunityDesignCard — community design grid card
// ─────────────────────────────────────────────────────────────────────────────

class _CommunityDesignCard extends StatelessWidget {
  final String initials;
  final String name;
  final List<Color> gradientColors;

  const _CommunityDesignCard({
    required this.initials,
    required this.name,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // User avatar
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Text(
                initials,
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Design name overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
