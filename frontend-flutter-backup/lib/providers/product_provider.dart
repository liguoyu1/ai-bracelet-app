import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> _products = [];
  List<Product> _featured = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  String? _error;
  String _searchQuery = '';
  String _activeCategory = '';
  int _total = 0;

  List<Product> get products => _products;
  List<Product> get featured => _featured;
  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get activeCategory => _activeCategory;
  int get total => _total;
  int get loadedCount => _products.length;

  Future<void> fetchProducts({String? category, String? q, int page = 1, bool append = false}) async {
    if (page == 1) {
      _loading = true;
      _products = [];
      _page = 1;
    }
    _error = null;
    notifyListeners();

    try {
      final query = <String, String>{
        if (category != null && category.isNotEmpty) 'category': category,
        if (q != null && q.isNotEmpty) 'q': q,
        'page': page.toString(),
      };
      final res = await _api.get(ApiConfig.products, query: query);

      if (res.isOk && res.data != null) {
        final list = res.data as List<dynamic>;
        final items = list
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
        if (page == 1) {
          _products = items;
        } else {
          _products.addAll(items);
        }
        _total = res.total ?? items.length;
        _hasMore = _products.length < _total;
        _page = page;
      } else {
        if (page == 1) _error = res.error ?? 'Failed to fetch products';
      }
    } catch (e) {
      if (page == 1) _error = e.toString();
    }

    _loading = false;
    _loadingMore = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore) return;
    _loadingMore = true;
    notifyListeners();
    await fetchProducts(
      category: _activeCategory.isNotEmpty ? _activeCategory : null,
      q: _searchQuery.isNotEmpty ? _searchQuery : null,
      page: _page + 1,
      append: true,
    );
  }

  Future<void> fetchFeatured() async {
    _error = null;
    notifyListeners();

    try {
      final res = await _api.get(ApiConfig.products, query: {
        'limit': '4',
        'sort': 'sales',
      });

      if (res.isOk && res.data != null) {
        final list = res.data as List<dynamic>;
        _featured = list
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
    }

    notifyListeners();
  }

  Future<Product?> fetchProduct(String id) async {
    try {
      final res = await _api.get('${ApiConfig.products}/$id');
      if (res.isOk && res.data != null) {
        return Product.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  void setSearch(String q) {
    _searchQuery = q;
    fetchProducts(q: q, category: _activeCategory.isNotEmpty ? _activeCategory : null);
  }

  void setCategory(String cat) {
    _activeCategory = cat;
    fetchProducts(category: cat.isNotEmpty ? cat : null, q: _searchQuery.isNotEmpty ? _searchQuery : null);
  }
}
