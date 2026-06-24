import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';
import '../../models/models.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  final _api = ApiService();
  late TabController _tabCtrl;

  // Data
  List<Product> _products = [];
  List<DesignElement> _elements = [];
  List<Order> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    await Future.wait([_loadProducts(), _loadElements(), _loadOrders()]);
    setState(() => _loading = false);
  }

  Future<void> _loadProducts() async {
    final res = await _api.get(ApiConfig.products, query: {'limit': '100'});
    if (res.isOk && res.data != null) {
      _products = (res.data as List).map((j) => Product.fromJson(j)).toList();
    }
  }

  Future<void> _loadElements() async {
    final res = await _api.get(ApiConfig.elements);
    if (res.isOk && res.data != null) {
      _elements =
          (res.data as List).map((j) => DesignElement.fromJson(j)).toList();
    }
  }

  Future<void> _loadOrders() async {
    final res = await _api.get(ApiConfig.orders);
    if (res.isOk && res.data != null) {
      _orders = (res.data as List).map((j) => Order.fromJson(j)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    if (!auth.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin')),
        body: const Center(child: Text('Admin access required')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Elements'),
            Tab(text: 'Orders'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabCtrl,
              children: [
                _ProductsTab(_products, _api, _loadAll),
                _ElementsTab(_elements, _api, _loadAll),
                _OrdersTab(_orders, _api, _loadAll),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final tab = _tabCtrl.index;
    if (tab == 0) _showProductForm(null);
    if (tab == 1) _showElementForm(null);
  }

  void _showProductForm(Product? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final slugCtrl =
        TextEditingController(text: existing?.slug ?? '');
    final descCtrl =
        TextEditingController(text: existing?.description ?? '');
    final priceCtrl =
        TextEditingController(text: existing != null ? '${existing.priceCents}' : '');
    final stockCtrl =
        TextEditingController(text: existing != null ? '${existing.stock}' : '');
    final imageCtrl = TextEditingController(
        text: existing?.images.isNotEmpty == true ? existing!.images.first : '');
    final categoryCtrl =
        TextEditingController(text: existing?.category ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add Product' : 'Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: slugCtrl,
                  decoration: const InputDecoration(labelText: 'Slug', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: priceCtrl,
                  decoration: const InputDecoration(labelText: 'Price (cents)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: stockCtrl,
                  decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: imageCtrl,
                  decoration: const InputDecoration(labelText: 'Image URL', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final body = {
                'name': nameCtrl.text,
                'slug': slugCtrl.text,
                'description': descCtrl.text,
                'price_cents': int.tryParse(priceCtrl.text) ?? 0,
                'stock': int.tryParse(stockCtrl.text) ?? 0,
                'images': [imageCtrl.text],
                'category': categoryCtrl.text,
                'tags': [],
                'materials': '{}',
              };
              if (existing != null) {
                await _api.put('${ApiConfig.adminProducts}/${existing.id}', body: body);
              } else {
                await _api.post(ApiConfig.adminProducts, body: body);
              }
              if (ctx.mounted) Navigator.pop(ctx);
              _loadAll();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showElementForm(DesignElement? existing) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final priceCtrl =
        TextEditingController(text: existing != null ? '${existing.priceCents}' : '');
    final stockCtrl =
        TextEditingController(text: existing != null ? '${existing.stock}' : '');
    final imageCtrl =
        TextEditingController(text: existing?.imageUrl ?? '');
    String type = existing?.type ?? 'bead';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add Element' : 'Edit Element'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration:
                    const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: type,
              decoration: const InputDecoration(
                  labelText: 'Type', border: OutlineInputBorder()),
              items: ['bead', 'charm', 'pendant', 'spacer', 'clasp']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => type = v ?? 'bead',
            ),
            const SizedBox(height: 8),
            TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(
                    labelText: 'Price (cents)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            TextField(
                controller: stockCtrl,
                decoration: const InputDecoration(
                    labelText: 'Stock', border: OutlineInputBorder()),
                keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(
                    labelText: 'Image URL', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final body = {
                'name': nameCtrl.text,
                'type': type,
                'price_cents': int.tryParse(priceCtrl.text) ?? 0,
                'stock': int.tryParse(stockCtrl.text) ?? 0,
                'image_url': imageCtrl.text,
                'color': '',
                'material': '',
                'shape': '',
                'size_mm': 0,
              };
              await _api.post(ApiConfig.adminElements, body: body);
              if (ctx.mounted) Navigator.pop(ctx);
              _loadAll();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// --- Product Tab ---
class _ProductsTab extends StatelessWidget {
  final List<Product> products;
  final ApiService api;
  final VoidCallback reload;
  const _ProductsTab(this.products, this.api, this.reload);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const Center(child: Text('No products'));
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: p.images.isNotEmpty
                ? Image.network(p.images.first, fit: BoxFit.cover)
                : const Icon(Icons.image, size: 20),
          ),
          title: Text(p.name, style: const TextStyle(fontSize: 14)),
          subtitle: Text('\$${(p.priceCents / 100).toStringAsFixed(2)} • ${p.stock} in stock • ${p.salesCount} sold'),
        );
      },
    );
  }
}

// --- Elements Tab ---
class _ElementsTab extends StatelessWidget {
  final List<DesignElement> elements;
  final ApiService api;
  final VoidCallback reload;
  const _ElementsTab(this.elements, this.api, this.reload);

  @override
  Widget build(BuildContext context) {
    if (elements.isEmpty) return const Center(child: Text('No elements'));
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: elements.length,
      itemBuilder: (_, i) {
        final e = elements[i];
        return ListTile(
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: e.color.isNotEmpty
                  ? Color(int.tryParse('0xFF${e.color.replaceAll('#', '')}') ?? 0xFFCCCCCC)
                  : Colors.grey.shade200,
            ),
          ),
          title: Text(e.name, style: const TextStyle(fontSize: 14)),
          subtitle: Text('${e.type} • \$${(e.priceCents / 100).toStringAsFixed(2)} • ${e.stock} left'),
        );
      },
    );
  }
}

// --- Orders Tab ---
class _OrdersTab extends StatelessWidget {
  final List<Order> orders;
  final ApiService api;
  final VoidCallback reload;
  const _OrdersTab(this.orders, this.api, this.reload);

  Color _statusColor(String status) {
    switch (status) {
      case 'paid': return Colors.green;
      case 'pending': return Colors.orange;
      case 'shipped': return Colors.blue;
      case 'delivered': return Colors.teal;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const Center(child: Text('No orders'));
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: orders.length,
      itemBuilder: (_, i) {
        final o = orders[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text('Order #${o.id.substring(0, 8)}'),
            subtitle: Text('${o.totalStr} • ${o.createdAt.substring(0, 10)}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(o.status).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(o.statusLabel,
                  style: TextStyle(
                      fontSize: 12,
                      color: _statusColor(o.status),
                      fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}
