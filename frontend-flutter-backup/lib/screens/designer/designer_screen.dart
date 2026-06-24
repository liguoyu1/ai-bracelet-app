import 'package:flutter/material.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../config/api_config.dart';
import '../../models/models.dart';
import '../../providers/locale_provider.dart';

class DesignerScreen extends StatefulWidget {
  const DesignerScreen({super.key});

  @override
  State<DesignerScreen> createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen> {
  final _api = ApiService();
  List<DesignElement> _elements = [];
  final List<_PlacedElement> _placed = [];
  DesignElement? _selectedString;
  String _selectedType = 'bead';
  String? _selectedElementId;
  final _nameCtrl = TextEditingController(text: 'My Design');
  bool _loading = true;
  bool _saving = false;
  String? _savedDesignId;
  String? _error;
  bool _showStrut = true;

  static const _bg = Color(0xFF0A0A0A);
  static const _surface = Color(0xFF1A1A1A);
  static const _card = Color(0xFF222222);
  static const _gold = Color(0xFFC8A45C);
  static const _cream = Color(0xFFF5F0E8);
  static const _copper = Color(0xFF8B6F47);

  @override
  void initState() {
    super.initState();
    _loadElements();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadElements() async {
    final res = await _api.get(ApiConfig.elements);
    if (res.isOk && res.data != null) {
      _elements = (res.data as List)
          .map((j) => DesignElement.fromJson(j))
          .where((e) => e.isActive)
          .toList();
    }
    setState(() => _loading = false);
  }

  List<DesignElement> get _filteredElements {
    if (_selectedType == 'string') {
      return _elements.where((e) => e.type == 'string').toList();
    }
    return _elements.where((e) => e.type == _selectedType).toList();
  }

  List<DesignElement> get _availableStrings =>
      _elements.where((e) => e.type == 'string').toList();

  int get _totalCents =>
      _placed.fold(0, (s, e) => s + e.element.priceCents) +
      (_selectedString?.priceCents ?? 0);

  void _addElement(DesignElement element) {
    setState(() {
      if (element.type == 'string') {
        _selectedString = element;
      } else {
        _placed.add(_PlacedElement(element: element));
      }
    });
  }

  void _removeElement(int index) {
    setState(() => _placed.removeAt(index));
  }

  void _moveElement(int index, int delta) {
    final newIndex = index + delta;
    if (newIndex < 0 || newIndex >= _placed.length) return;
    setState(() {
      final e = _placed.removeAt(index);
      _placed.insert(newIndex, e);
    });
  }

  void _clearDesign() {
    setState(() {
      _placed.clear();
      _selectedString = null;
      _savedDesignId = null;
    });
  }

  Future<void> _saveDesign({bool publish = false}) async {
    if (_placed.isEmpty) {
      setState(() => _error = Translations.I.t('designer.addElement'));
      return;
    }
    setState(() => _saving = true);

    final designData = jsonEncode({
      'elements': _placed.map((e) => {
        'element_id': e.element.id,
        'name': e.element.name,
        'type': e.element.type,
        'color': e.element.color,
        'image_url': e.element.imageUrl,
        'price_cents': e.element.priceCents,
      }).toList(),
      'string': _selectedString != null ? {
        'element_id': _selectedString!.id,
        'name': _selectedString!.name,
        'type': _selectedString!.type,
        'color': _selectedString!.color,
        'image_url': _selectedString!.imageUrl,
        'price_cents': _selectedString!.priceCents,
      } : null,
      'layout': {'pattern': 'straight', 'length_cm': _placed.length * 1.2},
    });

    if (_savedDesignId != null) {
      await _api.put('${ApiConfig.designs}/$_savedDesignId', body: {
        'name': _nameCtrl.text,
        'design_data': designData,
        'price_cents': _totalCents,
      });
    } else {
      final res = await _api.post(ApiConfig.designs, body: {
        'name': _nameCtrl.text,
        'description': 'Custom designed bracelet',
        'design_data': designData,
        'price_cents': _totalCents,
      });
      if (res.isOk && res.data != null) {
        _savedDesignId = res.data['id'];
      }
    }

    if (publish && _savedDesignId != null) {
      await _api.post('${ApiConfig.designs}/$_savedDesignId/publish');
    }

    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TrText(publish
              ? 'designer.published'
              : 'designer.saved'),
          backgroundColor: _gold.withValues(alpha: 0.9),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: _bg,
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFC8A45C)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TrText(
          'designer.title',
          style: TextStyle(
            color: _gold,
            fontFamily: 'serif',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: _copper),
            onPressed: _placed.isEmpty ? null : _clearDesign,
            tooltip: Translations.I.t('designer.clear'),
          ),
        ],
      ),
      body: Column(
        children: [
          // === Bracelet Preview ===
          _buildPreview(),
          const Divider(color: _copper, height: 1),

          // === Design Name + Price ===
          _buildNamePriceBar(),

          // === String Selector ===
          _buildStringSelector(),

          // === Element Type Tabs ===
          _buildTypeTabs(),

          // === Element Grid ===
          Expanded(child: _buildElementGrid()),

          // === Action Buttons ===
          _buildActionButtons(),
        ],
      ),
    );
  }

  // ===================== PREVIEW =====================
  Widget _buildPreview() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _surface,
            Color(0xFF0D0D0D),
            _surface,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // String line
          CustomPaint(
            size: const Size(double.infinity, 140),
            painter: _StringLinePainter(
              color: _selectedString?.color.isNotEmpty == true
                  ? Color(int.tryParse(
                          '0xFF${_selectedString!.color.replaceAll('#', '')}') ??
                      0xFF8B6F47)
                  : _copper,
            ),
          ),
          // Elements on the string
          if (_placed.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: TrText(
                'designer.tapToStart',
                style: TextStyle(color: _cream.withValues(alpha: 0.4)),
              ),
            )
          else
            Positioned(
              top: 58,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _placed.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onLongPress: () => _removeElement(i),
                      child: Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _parseColor(_placed[i].element.color),
                              border: Border.all(
                                color: _placed[i].element.type == 'charm' ||
                                        _placed[i].element.type == 'pendant'
                                    ? _gold
                                    : _copper.withValues(alpha: 0.5),
                                width: _placed[i].element.type == 'charm' ||
                                        _placed[i].element.type == 'pendant'
                                    ? 2
                                    : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _placed[i].element.type == 'charm' ||
                                          _placed[i].element.type == 'pendant'
                                      ? _gold.withValues(alpha: 0.15)
                                      : Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: _placed[i].element.imageUrl.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      _placed[i].element.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Icon(
                                        _elementIcon(
                                            _placed[i].element.type),
                                        size: 16,
                                        color: _cream,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    _elementIcon(_placed[i].element.type),
                                    size: 16,
                                    color: _cream,
                                  ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: i > 0
                                    ? () => _moveElement(i, -1)
                                    : null,
                                child: Icon(Icons.chevron_left,
                                    size: 14,
                                    color: i > 0
                                        ? _gold
                                        : Colors.transparent),
                              ),
                              Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: _cream.withValues(alpha: 0.4),
                                  fontSize: 9,
                                ),
                              ),
                              InkWell(
                                onTap: i < _placed.length - 1
                                    ? () => _moveElement(i, 1)
                                    : null,
                                child: Icon(Icons.chevron_right,
                                    size: 14,
                                    color: i < _placed.length - 1
                                        ? _gold
                                        : Colors.transparent),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Clasp ends
          if (_placed.isNotEmpty) ...[
            Positioned(
              left: 8,
              top: 62,
              child: Icon(Icons.circle, size: 12, color: _copper),
            ),
            Positioned(
              right: 8,
              top: 62,
              child: Icon(Icons.circle, size: 12, color: _copper),
            ),
          ],
        ],
      ),
    );
  }

  // ===================== NAME + PRICE =====================
  Widget _buildNamePriceBar() {
    return Container(
      color: _surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameCtrl,
              style: TextStyle(color: _cream),
              decoration: InputDecoration(
                hintText: Translations.I.t('designer.designName'),
                hintStyle: TextStyle(color: _cream.withValues(alpha: 0.3)),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: _copper.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: _copper.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _gold),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(_totalCents / 100).toStringAsFixed(2)}',
                style: TextStyle(
                  color: _gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                ),
              ),
              Text(
                '${_placed.length} elements',
                style: TextStyle(
                    color: _cream.withValues(alpha: 0.4), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== STRING SELECTOR =====================
  Widget _buildStringSelector() {
    final strings = _availableStrings;
    if (strings.isEmpty) return const SizedBox.shrink();

    return Container(
      color: _surface,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrText(
            'designer.stringBand',
            style: TextStyle(
              color: _gold.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedString = null),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _selectedString == null
                            ? _gold
                            : _copper.withValues(alpha: 0.3),
                      ),
                      color: _selectedString == null
                          ? _gold.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: TrText(
                      'designer.none',
                      style: TextStyle(
                        color: _selectedString == null
                            ? _gold
                            : _cream.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                ...strings.map((s) => GestureDetector(
                      onTap: () {
                        setState(() => _selectedString = s);
                        _showStrut = false;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _selectedString?.id == s.id
                                ? _gold
                                : _copper.withValues(alpha: 0.3),
                          ),
                          color: _selectedString?.id == s.id
                              ? _gold.withValues(alpha: 0.1)
                              : Colors.transparent,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: s.color.isNotEmpty
                                    ? Color(int.tryParse(
                                            '0xFF${s.color.replaceAll('#', '')}') ??
                                        0xFF8B6F47)
                                    : _copper,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              s.name,
                              style: TextStyle(
                                color: _selectedString?.id == s.id
                                    ? _gold
                                    : _cream.withValues(alpha: 0.7),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== TYPE TABS =====================
  Widget _buildTypeTabs() {
    const types = ['bead', 'charm', 'pendant', 'spacer', 'clasp', 'string'];
    final labels = ['designer.beads', 'designer.charms', 'designer.pendants', 'designer.spacers', 'designer.clasps', 'designer.string'];

    return Container(
      color: _surface,
      padding: const EdgeInsets.only(top: 4),
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: List.generate(types.length, (i) {
            final active = _selectedType == types[i];
            final count = types[i] == 'string'
                ? _availableStrings.length
                : _filteredElements.length;
            // Recalc for this type
            final actualCount = _elements
                .where((e) => e.type == types[i])
                .length;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = types[i]),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: active ? _gold : Colors.transparent,
                    border: Border.all(
                      color: active ? _gold : _copper.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TrText(
                        labels[i],
                        style: TextStyle(
                          color: active ? Colors.black : _cream,
                          fontSize: 12,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.black.withValues(alpha: 0.2)
                              : _copper.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$actualCount',
                          style: TextStyle(
                            color: active ? Colors.black : _cream,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ===================== ELEMENT GRID =====================
  Widget _buildElementGrid() {
    final items = _filteredElements;
    // If string type, show strings
    final showing = _selectedType == 'string'
        ? _availableStrings
        : items;
    if (showing.isEmpty) {
      return Center(
        child: TrText(
          'designer.noElements',
          style: TextStyle(color: _cream.withValues(alpha: 0.4)),
        ),
      );
    }
    return Container(
      color: _bg,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: showing.length,
        itemBuilder: (_, i) {
          final e = showing[i];
          final inDesign = _placed.any((p) => p.element.id == e.id);
          return GestureDetector(
            onTap: () => _addElement(e),
            child: Container(
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: inDesign ? _gold : Colors.transparent,
                  width: inDesign ? 1.5 : 0,
                ),
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _parseColor(e.color),
                      border: Border.all(
                        color: _copper.withValues(alpha: 0.3),
                      ),
                    ),
                    child: e.imageUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              e.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                _elementIcon(e.type),
                                size: 18,
                                color: _cream.withValues(alpha: 0.7),
                              ),
                            ),
                          )
                        : Icon(
                            _elementIcon(e.type),
                            size: 18,
                            color: _cream.withValues(alpha: 0.7),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.name.length > 14
                        ? '${e.name.substring(0, 12)}...'
                        : e.name,
                    style: TextStyle(
                      color: _cream.withValues(alpha: 0.8),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${(e.priceCents / 100).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: _gold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (inDesign)
                    TrText(
                      'designer.inDesign',
                      style: TextStyle(
                        color: _gold.withValues(alpha: 0.6),
                        fontSize: 8,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===================== ACTION BUTTONS =====================
  Widget _buildActionButtons() {
    if (_placed.isEmpty && _selectedString == null) {
      return const SizedBox(height: 80);
    }
    return Container(
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => _saveDesign(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _copper,
                    side: BorderSide(color: _copper.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFC8A45C),
                          ),
                        )
                      : TrText(
                          _savedDesignId != null ? 'designer.update' : 'designer.save',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving ? null : () => _saveDesign(publish: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: TrText(
                    _saving ? 'designer.saving' : 'designer.publish',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          TrText(
            'designer.reorderHint',
            style:
                TextStyle(color: _cream.withValues(alpha: 0.25), fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ===================== HELPERS =====================
  Color _parseColor(String hex) {
    if (hex.isEmpty) return _copper;
    final h = hex.replaceAll('#', '');
    if (h.length != 6) return _copper;
    return Color(int.tryParse('0xFF$h') ?? 0xFF8B6F47);
  }

  IconData _elementIcon(String type) {
    switch (type) {
      case 'bead':
        return Icons.circle;
      case 'charm':
        return Icons.star;
      case 'pendant':
        return Icons.diamond;
      case 'spacer':
        return Icons.remove;
      case 'clasp':
        return Icons.link;
      case 'string':
        return Icons.swap_vert;
      default:
        return Icons.circle;
    }
  }
}

// ===================== CUSTOM PAINTER: STRING LINE =====================
class _StringLinePainter extends CustomPainter {
  final Color color;
  _StringLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2 + 8);
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 2 - 10,
      size.width,
      size.height / 2 + 8,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StringLinePainter old) => old.color != color;
}

class _PlacedElement {
  final DesignElement element;
  _PlacedElement({required this.element});
}
