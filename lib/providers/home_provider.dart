import 'package:flutter/material.dart';
import '../models/tailor_model.dart';
import '../models/product_model.dart';
import '../services/mock_data_service.dart';
import '../services/tailor_service.dart';

class HomeProvider extends ChangeNotifier {
  List<TailorModel> _allTailors = [];
  final List<ProductModel> _allProducts = MockDataService.getProducts();

  List<TailorModel> _filteredTailors = [];
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  List<TailorModel> get tailors => _filteredTailors;
  List<ProductModel> get featuredProducts => _allProducts;
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HomeProvider() {
    _loadTailors();
  }

  Future<void> _loadTailors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allTailors = await TailorService.fetchTailors();
      _filteredTailors = List.from(_allTailors);
    } catch (e) {
      _errorMessage = 'Could not load tailors. Check your connection.';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Lets the UI retry after a failed fetch (e.g. a "Retry" button).
  Future<void> refreshTailors() => _loadTailors();

  void search(String query) {
    _searchQuery = query.trim();
    if (_searchQuery.isEmpty) {
      _filteredTailors = List.from(_allTailors);
    } else {
      _filteredTailors = _allTailors
          .where(
            (t) =>
                t.shopName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                t.address.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredTailors = List.from(_allTailors);
    notifyListeners();
  }
}
