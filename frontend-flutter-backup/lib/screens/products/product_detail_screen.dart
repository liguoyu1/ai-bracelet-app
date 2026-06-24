import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/cart_provider.dart';
import '../../providers/locale_provider.dart';
import '../../i18n/translations.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorited = false;

  final List<Map<String, String>> _reviews = [
    {
      'name': 'Sophia M.',
      'text': 'Absolutely stunning quality. The craftsmanship is unmatched — every detail tells a story.',
      'rating': '5',
    },
    {
      'name': 'James K.',
      'text': 'Bought this as a gift and she hasn\'t taken it off since. Truly one of a kind.',
      'rating': '5',
    },
    {
      'name': 'Elena R.',
      'text': 'Beautiful energy. I feel centered and grounded every time I wear it.',
      'rating': '4',
    },
  ];

  final List<Map<String, String>> _relatedProducts = [
    {'name': 'Amethyst Dream', 'price': '\$89.00'},
    {'name': 'Jade Harmony', 'price': '\$129.00'},
    {'name': 'Amber Glow', 'price': '\$74.00'},
    {'name': 'Lava Essence', 'price': '\$59.00'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC8A45C)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFFC8A45C)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? Colors.red : const Color(0xFFC8A45C),
            ),
            onPressed: () => setState(() => _isFavorited = !_isFavorited),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image carousel from product.images
            SizedBox(
              height: 350,
              width: double.infinity,
              child: product.images.isEmpty
                  ? Container(color: const Color(0xFF1A1A1A))
                  : PageView.builder(
                      itemCount: product.images.length,
                      itemBuilder: (_, i) => Image.network(
                        product.images[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A1A1A)),
                      ),
                    ),
            ),

            // Product info section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontFamily: 'Cormorant Garamond',
                      color: const Color(0xFFF5F0E8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating row
                  Row(
                    children: [
                      ...List.generate(4, (_) => const Icon(
                        Icons.star,
                        color: Color(0xFFC8A45C),
                        size: 18,
                      )),
                      const Icon(
                        Icons.star_half,
                        color: Color(0xFFC8A45C),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.8 (128 reviews)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'Raleway',
                          color: const Color(0xFFF5F0E8).withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(
                    product.priceStr,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFFC8A45C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Material & size chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildChip('8mm ${product.tags.isNotEmpty ? product.tags.first : 'Crystal'}', theme),
                      _buildChip('Round Beads', theme),
                      _buildChip('18K Gold Clasp', theme),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : Translations.I.t('products.defaultDescription'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Raleway',
                      color: const Color(0xFFF5F0E8).withValues(alpha: 0.6),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quantity selector
                  Row(
                    children: [
                      TrText(
                        'products.quantity',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontFamily: 'Raleway',
                          color: const Color(0xFFF5F0E8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFC8A45C).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Color(0xFFC8A45C), size: 18),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Color(0xFFC8A45C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Color(0xFFC8A45C), size: 18),
                              onPressed: () => setState(() => _quantity++),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Add to Cart button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        final cart = context.read<CartProvider>();
                        cart.addItem(CartItem(
                          itemType: 'product',
                          itemId: product.id,
                          name: product.name,
                          imageUrl:
                              product.images.isNotEmpty ? product.images[0] : '',
                          unitPriceCents: product.priceCents,
                          quantity: _quantity,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: TrText('products.addedToCart'),
                            backgroundColor: const Color(0xFFC8A45C),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A45C),
                        foregroundColor: const Color(0xFF0A0A0A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '${Translations.I.productsAddToCart} — ${product.priceStr}',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Designer info section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFC8A45C).withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFC8A45C).withValues(alpha: 0.2),
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: const Color(0xFFC8A45C),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${Translations.I.productsDesignedBy} Aurélie',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'Raleway',
                                  color: const Color(0xFFF5F0E8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              TrText(
                                'products.designerCommission',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'Raleway',
                                  color: const Color(0xFFF5F0E8).withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reviews section
                  TrText(
                    'products.reviews',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: 'Cormorant Garamond',
                      color: const Color(0xFFF5F0E8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._reviews.map((r) => _ReviewCard(
                    name: r['name']!,
                    text: r['text']!,
                    rating: int.parse(r['rating']!),
                  )),
                  const SizedBox(height: 24),

                  // Related products
                  TrText(
                    'products.youMayLike',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: 'Cormorant Garamond',
                      color: const Color(0xFFF5F0E8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: _relatedProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final rp = _relatedProducts[index];
                        return _RelatedProductCard(
                          name: rp['name']!,
                          price: rp['price']!,
                          index: index,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC8A45C).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: const Color(0xFFF5F0E8).withValues(alpha: 0.7),
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String text;
  final int rating;

  const _ReviewCard({
    required this.name,
    required this.text,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF5F0E8).withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFC8A45C).withValues(alpha: 0.15),
            child: Text(
              name[0],
              style: const TextStyle(
                fontFamily: 'Raleway',
                color: Color(0xFFC8A45C),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Color(0xFFF5F0E8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(rating, (_) => const Icon(
                      Icons.star,
                      color: Color(0xFFC8A45C),
                      size: 14,
                    )),
                    ...List.generate(5 - rating, (_) => Icon(
                      Icons.star_border,
                      color: const Color(0xFFC8A45C).withValues(alpha: 0.3),
                      size: 14,
                    )),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: const Color(0xFFF5F0E8).withValues(alpha: 0.6),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  final String name;
  final String price;
  final int index;

  static const List<Color> _relatedColors = [
    Color(0xFF4A148C),
    Color(0xFF00695C),
    Color(0xFF800020),
    Color(0xFF0D1B2A),
  ];

  const _RelatedProductCard({
    required this.name,
    required this.price,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final color = _relatedColors[index % _relatedColors.length];

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFC8A45C).withValues(alpha: 0.1),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Solid color thumbnail (static UX content)
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: color,
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      color: Color(0xFFF5F0E8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      color: Color(0xFFC8A45C),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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
