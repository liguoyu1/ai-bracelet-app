import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';
import '../../models/models.dart';
import '../products/product_list_screen.dart';
import '../products/product_detail_screen.dart';
import '../../providers/locale_provider.dart';

class EnergyScreen extends StatefulWidget {
  const EnergyScreen({super.key});

  @override
  State<EnergyScreen> createState() => _EnergyScreenState();
}

class _EnergyScreenState extends State<EnergyScreen> {
  final _api = ApiService();
  bool _loading = false;
  bool _assessed = false;
  String? _error;

  // Form fields
  final _birthCtrl = TextEditingController();
  String _zodiac = '';
  String _element = '';
  final _concernsCtrl = TextEditingController();
  final _lifestyleCtrl = TextEditingController();

  // Results
  List<EnergyRecommendation> _recommendations = [];

  final _zodiacSigns = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];

  final _elements = ['Wood', 'Fire', 'Earth', 'Metal', 'Water'];

  // Theme colors
  static const _bg = Color(0xFF0A0A0A);
  static const _surface = Color(0xFF1A1A1A);
  static const _gold = Color(0xFFC8A45C);
  static const _cream = Color(0xFFF5F0E8);
  static const _copper = Color(0xFF8B6F47);

  @override
  void dispose() {
    _birthCtrl.dispose();
    _concernsCtrl.dispose();
    _lifestyleCtrl.dispose();
    super.dispose();
  }

  Future<void> _assess() async {
    if (_zodiac.isEmpty) {
      setState(() => _error = Translations.I.t('energy.selectZodiac'));
      return;
    }
    if (_element.isEmpty) {
      setState(() => _error = Translations.I.t('energy.selectElement'));
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final res = await _api.post(ApiConfig.energyAssess, body: {
      'birth_date': _birthCtrl.text.trim(),
      'zodiac_sign': _zodiac,
      'preferred_element': _element,
      'concerns': _concernsCtrl.text.trim(),
      'lifestyle': _lifestyleCtrl.text.trim(),
    });

    setState(() => _loading = false);

    if (res.isOk && res.data != null) {
      final recs = res.data['recommendations'] as List? ?? [];
      _recommendations = recs.map((r) => EnergyRecommendation.fromJson(r)).toList();
      setState(() => _assessed = true);
    } else {
      setState(() => _error = res.error ?? Translations.I.t('energy.failed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TrText(
          'energy.title',
          style: TextStyle(
            color: _gold,
            fontFamily: 'serif',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _assessed ? _buildResults() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Icon(Icons.auto_awesome, size: 48, color: _gold),
        ),
        const SizedBox(height: 12),
        Center(
          child: TrText(
            'energy.discover',
            style: TextStyle(
              color: _cream,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: TrText(
            'energy.subtitle',
            textAlign: TextAlign.center,
            style: TextStyle(color: _cream.withValues(alpha: 0.6), fontSize: 14),
          ),
        ),
        const SizedBox(height: 28),

        // Birth date
        TextField(
          controller: _birthCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: Translations.I.t('energy.birthDate'),
            labelStyle: TextStyle(color: _gold.withValues(alpha: 0.8)),
            filled: true,
            fillColor: _surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _gold, width: 1.5),
            ),
            prefixIcon: Icon(Icons.calendar_today, color: _gold.withValues(alpha: 0.7)),
          ),
        ),
        const SizedBox(height: 16),

        // Zodiac dropdown
        DropdownButtonFormField<String>(
          value: _zodiac.isEmpty ? null : _zodiac,
          dropdownColor: _surface,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: Translations.I.t('energy.zodiac'),
            labelStyle: TextStyle(color: _gold.withValues(alpha: 0.8)),
            filled: true,
            fillColor: _surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _gold, width: 1.5),
            ),
            prefixIcon: Icon(Icons.star, color: _gold.withValues(alpha: 0.7)),
          ),
          icon: Icon(Icons.arrow_drop_down, color: _gold),
          items: _zodiacSigns.map((z) => DropdownMenuItem(
            value: z,
            child: Text(z),
          )).toList(),
          onChanged: (v) => setState(() => _zodiac = v ?? ''),
        ),
        const SizedBox(height: 16),

        // Element dropdown with colored icon balls
        DropdownButtonFormField<String>(
          value: _element.isEmpty ? null : _element,
          dropdownColor: _surface,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: Translations.I.t('energy.element'),
            labelStyle: TextStyle(color: _gold.withValues(alpha: 0.8)),
            filled: true,
            fillColor: _surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _gold, width: 1.5),
            ),
            prefixIcon: Icon(Icons.whatshot, color: _gold.withValues(alpha: 0.7)),
          ),
          icon: Icon(Icons.arrow_drop_down, color: _gold),
          items: _elements.map((e) => DropdownMenuItem(
            value: e,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _elementColor(e),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(e),
              ],
            ),
          )).toList(),
          onChanged: (v) => setState(() => _element = v ?? ''),
        ),
        const SizedBox(height: 16),

        // Concerns
        TextField(
          controller: _concernsCtrl,
          style: const TextStyle(color: Colors.white),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: Translations.I.t('energy.concerns'),
            labelStyle: TextStyle(color: _gold.withValues(alpha: 0.8)),
            hintText: Translations.I.t('energy.concernsHint'),
            hintStyle: TextStyle(color: _cream.withValues(alpha: 0.3)),
            filled: true,
            fillColor: _surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _gold, width: 1.5),
            ),
            prefixIcon: Icon(Icons.psychology, color: _gold.withValues(alpha: 0.7)),
          ),
        ),
        const SizedBox(height: 16),

        // Lifestyle
        TextField(
          controller: _lifestyleCtrl,
          style: const TextStyle(color: Colors.white),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: Translations.I.t('energy.lifestyle'),
            labelStyle: TextStyle(color: _gold.withValues(alpha: 0.8)),
            hintText: Translations.I.t('energy.lifestyleHint'),
            hintStyle: TextStyle(color: _cream.withValues(alpha: 0.3)),
            filled: true,
            fillColor: _surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _copper.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _gold, width: 1.5),
            ),
            prefixIcon: Icon(Icons.directions_walk, color: _gold.withValues(alpha: 0.7)),
          ),
        ),
        const SizedBox(height: 28),

        // Submit button - full width gold
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _loading ? null : _assess,
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black,
                    ),
                  )
                : TrText(
                    'energy.start',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),

        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
      ],
    );
  }

  Widget _buildResults() {
    if (_recommendations.isEmpty) {
      return Center(
        child: TrText(
          'energy.noResults',
          style: TextStyle(color: _cream.withValues(alpha: 0.6)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Icon(Icons.auto_awesome, size: 36, color: _gold),
        ),
        const SizedBox(height: 8),
        Center(
          child: TrText(
            'energy.profile',
            style: TextStyle(
              color: _cream,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: TrText(
            'energy.profileSub',
            style: TextStyle(color: _cream.withValues(alpha: 0.5), fontSize: 13),
          ),
        ),
        const SizedBox(height: 24),

        ...List.generate(_recommendations.length, (i) {
          final rec = _recommendations[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _gold.withValues(alpha: 0.3), width: 1),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Element badge - colored circle + name
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _elementColor(rec.element),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rec.element.toUpperCase(),
                      style: TextStyle(
                        color: _elementColor(rec.element),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Explanation in cream, 1.6 line height
                Text(
                  rec.explanation,
                  style: TextStyle(
                    color: _cream,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),

                // Energy Focus - large gold quote-style text
                if (rec.energyFocus.isNotEmpty) ...[
                  Text(
                    '✦ ${rec.energyFocus} ✦',
                    style: TextStyle(
                      color: _gold,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                ],

                // Recommended Colors - colored circles (24px) with labels
                if (rec.recommendedColors.isNotEmpty) ...[
                  TrText(
                    'energy.colors',
                    style: TextStyle(
                      color: _cream.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 14,
                    runSpacing: 10,
                    children: rec.recommendedColors.map((c) {
                      final color = _parseColor(c);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _cream.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c,
                            style: TextStyle(
                              color: _cream.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Recommended Materials
                if (rec.recommendedMaterials.isNotEmpty) ...[
                  TrText(
                    'energy.materials',
                    style: TextStyle(
                      color: _cream.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: rec.recommendedMaterials.map((m) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _gold.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        m,
                        style: TextStyle(
                          color: _cream.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Crystal Suggestions - chips with gold border, cream text
                if (rec.crystalSuggestions.isNotEmpty) ...[
                  TrText(
                    'energy.crystals',
                    style: TextStyle(
                      color: _cream.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: rec.crystalSuggestions.map((c) => GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductListScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _gold.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          c,
                          style: TextStyle(
                            color: _cream,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 12),

        // Try Another Assessment - outlined copper
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => setState(() => _assessed = false),
            style: OutlinedButton.styleFrom(
              foregroundColor: _copper,
              side: BorderSide(color: _copper.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: TrText(
              'energy.tryAgain',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Color _elementColor(String element) {
    switch (element.toLowerCase()) {
      case 'wood': return const Color(0xFF4CAF50);
      case 'fire': return const Color(0xFFE53935);
      case 'earth': return const Color(0xFF8D6E63);
      case 'metal': return const Color(0xFFBDBDBD);
      case 'water': return const Color(0xFF42A5F5);
      default: return _gold;
    }
  }

  Color _parseColor(String name) {
    const colors = {
      'deep blue': Color(0xFF1a237e),
      'silver': Color(0xFFbdbdbd),
      'aquamarine': Color(0xFF7fffd4),
      'emerald green': Color(0xFF2e7d32),
      'brown': Color(0xFF5d4037),
      'gold': Color(0xFFFFD700),
      'red': Color(0xFFd32f2f),
      'orange': Color(0xFFf57c00),
    };
    return colors[name.toLowerCase()] ?? Colors.grey;
  }
}
