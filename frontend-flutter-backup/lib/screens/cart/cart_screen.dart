import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/locale_provider.dart';
import '../../i18n/translations.dart';
import 'order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // ── Luxury dark-palette constants ──────────────────────────────────────
  static const Color _bg      = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF1A1A1A);
  static const Color _gold    = Color(0xFFC8A45C);
  static const Color _cream   = Color(0xFFF5F0E8);
  static const Color _copper  = Color(0xFF8B6F47);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TrText(
                  'cart.title',
                  style: const TextStyle(
                    color: _cream,
                    fontFamily: 'serif',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (cart.itemCount > 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _gold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          body: cart.items.isEmpty ? _buildEmptyState() : _buildCartBody(cart, context),
        );
      },
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.spa, size: 64, color: _gold),
          const SizedBox(height: 20),
          TrText(
            'cart.empty',
            style: const TextStyle(
              color: _gold,
              fontFamily: 'serif',
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          TrText(
            'cart.emptySubtitle',
            style: const TextStyle(color: _cream, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ── Cart body (list + bottom bar) ─────────────────────────────────────
  Widget _buildCartBody(CartProvider cart, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: cart.items.length,
            itemBuilder: (_, i) => _buildCartItemCard(cart, i),
          ),
        ),
        _buildBottomBar(cart, context),
      ],
    );
  }

  // ── Individual item card ──────────────────────────────────────────────
  Widget _buildCartItemCard(CartProvider cart, int i) {
    final item = cart.items[i];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _surface,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: const Color(0xFF2A2A2A),
                child: item.imageUrl.isNotEmpty
                    ? Image.network(item.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image, color: _copper, size: 28))
                    : const Icon(Icons.image, color: _copper, size: 28),
              ),
            ),
            const SizedBox(width: 12),

            // ── Name + type chip ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _cream,
                      fontFamily: 'serif',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Gold-bordered material chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: _gold, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.itemType == 'design'
                          ? Translations.I.cartCustom
                          : Translations.I.cartProduct,
                      style: const TextStyle(
                        color: _gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // ── Price / quantity / delete ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Price
                Text(
                  item.priceStr,
                  style: const TextStyle(
                    color: _gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 8),

                // Quantity selector (– / count / +)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: _gold.withValues(alpha: 0.6), width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          if (item.quantity > 1) {
                            cart.updateQuantity(i, item.quantity - 1);
                          } else {
                            cart.removeItem(i);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Icon(Icons.remove, size: 16, color: _gold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            color: _cream,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => cart.updateQuantity(i, item.quantity + 1),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Icon(Icons.add, size: 16, color: _gold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: _copper, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => cart.removeItem(i),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom bar (total + checkout) ─────────────────────────────────────
  Widget _buildBottomBar(CartProvider cart, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: _surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TrText(
                  'cart.total',
                  style: const TextStyle(
                    color: _cream,
                    fontSize: 16,
                    fontFamily: 'serif',
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (_, c, __) => Text(
                    c.totalStr,
                    style: const TextStyle(
                      color: _gold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Checkout button – full-width gold
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: TrText('cart.checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
