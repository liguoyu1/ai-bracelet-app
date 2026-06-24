import 'package:flutter/material.dart';
import '../../providers/locale_provider.dart';
import '../../i18n/translations.dart';
import 'dart:html' show window;

class OrderStatusScreen extends StatefulWidget {
  final String? orderId;

  const OrderStatusScreen({super.key, this.orderId});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  String _status = '';

  @override
  void initState() {
    super.initState();
    _parseStatus();
  }

  void _parseStatus() {
    try {
      final search = window.location.search;
      if (search != null && search.isNotEmpty) {
        final query = search.startsWith('?') ? search.substring(1) : search;
        final params = Uri.splitQueryString(query);
        _status = params['status'] ?? '';
      }
    } catch (_) {
      _status = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSuccess = _status == 'succeeded';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSuccess
                      ? const Color(0xFFC8A45C).withValues(alpha: 0.15)
                      : Colors.red.withValues(alpha: 0.15),
                ),
                child: Icon(
                  isSuccess ? Icons.check_rounded : Icons.cancel_rounded,
                  color: isSuccess
                      ? const Color(0xFFC8A45C)
                      : Colors.red,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              TrText(
                isSuccess ? 'order.paymentSuccess' : 'order.paymentCancelled',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Cormorant Garamond',
                  color: const Color(0xFFF5F0E8),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              TrText(
                isSuccess ? 'order.paymentSuccessSub' : 'order.paymentCancelledSub',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Raleway',
                  color: const Color(0xFFF5F0E8).withValues(alpha: 0.6),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Order ID
              if (widget.orderId != null || _status.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFC8A45C).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    widget.orderId != null
                        ? '${Translations.I.orderOrderId} #${widget.orderId}'
                        : 'Status: ${_status.isEmpty ? 'unknown' : _status}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Raleway',
                      color: const Color(0xFFC8A45C),
                    ),
                  ),
                ),
              const SizedBox(height: 40),

              // Back to Shop button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC8A45C),
                    foregroundColor: const Color(0xFF0A0A0A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: TrText(
                    'order.backToShop',
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
