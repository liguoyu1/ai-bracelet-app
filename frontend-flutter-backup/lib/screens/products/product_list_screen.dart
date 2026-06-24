import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/locale_provider.dart';
import '../../i18n/translations.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  static const _filterValues = ['All', 'Crystal', 'Jade', 'Amber', 'Lava'];

  String _filterLabel(String value) {
    switch (value) {
      case 'All': return Translations.I.productsAll;
      case 'Crystal': return Translations.I.homeCrystal;
      case 'Jade': return Translations.I.homeJade;
      case 'Amber': return Translations.I.homeAmber;
      case 'Lava': return Translations.I.homeLava;
      default: return value;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    context.read<ProductProvider>().setSearch(value.trim());
  }

  void _onClearSearch() {
    _searchController.clear();
    context.read<ProductProvider>().setSearch('');
  }

  void _onFilterSelected(String filter) {
    setState(() => _selectedFilter = filter);
    if (filter == 'All') {
      context.read<ProductProvider>().setCategory('');
    } else {
      context.read<ProductProvider>().setCategory(filter);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5F0E8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrText(
                    'products.title',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontFamily: 'Cormorant Garamond',
                      color: const Color(0xFFC8A45C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TrText(
                    'products.subtitle',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Raleway',
                      color: const Color(0xFFF5F0E8).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: Translations.I.productsSearch,
                  hintStyle: TextStyle(
                    fontFamily: 'Raleway',
                    color: const Color(0xFFF5F0E8).withValues(alpha: 0.4),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFC8A45C), size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: const Color(0xFFF5F0E8).withValues(alpha: 0.6),
                              size: 18),
                          onPressed: _onClearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFF1A1A1A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFF1A1A1A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFFC8A45C), width: 1.5),
                  ),
                ),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Raleway',
                  color: const Color(0xFFF5F0E8),
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: _onSearchSubmitted,
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _filterValues.map((filter) {
                  final selected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(
                      _filterLabel(filter),
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: selected
                            ? const Color(0xFFC8A45C)
                            : const Color(0xFFF5F0E8),
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    selected: selected,
                    onSelected: (_) => _onFilterSelected(filter),
                    backgroundColor: const Color(0xFF1A1A1A),
                    selectedColor: const Color(0xFF1A1A1A),
                    side: BorderSide(
                      color: selected
                          ? const Color(0xFFC8A45C)
                          : const Color(0xFFF5F0E8).withValues(alpha: 0.2),
                      width: selected ? 1.5 : 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  );
                }).toList(),
              ),
            ),
          ),

          // Product grid or states
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              if (provider.loading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Color(0xFFC8A45C))),
                );
              }

              if (provider.error != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: TrText(
                      provider.error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Raleway',
                        color: const Color(0xFFF5F0E8).withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                      translate: false,
                    ),
                  ),
                );
              }

              final products = provider.products;

              if (products.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: TrText(
                      'products.empty',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Color(0xFFF5F0E8),
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.64,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      final imageUrl = product.images.isNotEmpty ? product.images[0] : '';
                      return Consumer<FavoriteProvider>(
                        builder: (context, favProvider, _) {
                          final isFav = favProvider.isFavorite(product.id);
                          return _ProductCard(
                            name: product.name,
                            material: product.tags.join(', '),
                            price: product.priceStr,
                            imageUrl: imageUrl,
                            productId: product.id,
                            priceCents: product.priceCents,
                            isFavorite: isFav,
                            onFavoriteToggle: () => favProvider.toggle(product.id),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
          ),

          // Load More button
          Consumer<ProductProvider>(
            builder: (context, p, _) {
              if (p.loading || p.products.isEmpty || !p.hasMore) return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: p.loadingMore ? null : () => p.loadMore(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC8A45C),
                        side: const BorderSide(color: Color(0xFFC8A45C)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: p.loadingMore
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFC8A45C)))
                          : Text('Load More (${p.loadedCount}/${p.total})',
                              style: const TextStyle(fontFamily: 'Raleway', fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final String name;
  final String material;
  final String price;
  final String imageUrl;
  final String productId;
  final int priceCents;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _ProductCard({
    required this.name,
    required this.material,
    required this.price,
    required this.imageUrl,
    required this.productId,
    required this.priceCents,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFC8A45C).withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              SizedBox(
                width: double.infinity,
                height: 180,
                child: Stack(
                  children: [
                    // Real product image with fallback
                    Image.network(
                      widget.imageUrl,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1A1A1A),
                        child: Center(child: Icon(Icons.broken_image, color: const Color(0xFFC8A45C).withValues(alpha: 0.3))),
                      ),
                      loadingBuilder: (_, child, progress) => progress == null ? child : Container(color: const Color(0xFF1A1A1A)),
                    ),
                    // Favorite icon top-right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.onFavoriteToggle,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.isFavorite
                                ? Colors.red
                                : const Color(0xFFF5F0E8).withValues(alpha: 0.8),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    // Add to cart overlay on hover
                    if (_isHovered)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFF0A0A0A).withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              final cart = context.read<CartProvider>();
                              cart.addItem(CartItem(
                                itemType: 'product',
                                itemId: widget.productId,
                                name: widget.name,
                                imageUrl: widget.imageUrl,
                                unitPriceCents: widget.priceCents,
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: TrText('products.addedToCart'),
                                  backgroundColor: const Color(0xFFC8A45C),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFC8A45C),
                              side: const BorderSide(color: Color(0xFFC8A45C)),
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: TrText(
                              'products.addToCart',
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Product info
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        color: Color(0xFFF5F0E8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.material,
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: const Color(0xFFF5F0E8).withValues(alpha: 0.45),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Color(0xFFC8A45C),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
