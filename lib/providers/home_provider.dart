import 'package:flutter/material.dart';
import '../models/tailor_model.dart';
import '../models/product_model.dart';
import '../services/mock_data_service.dart';

class HomeProvider extends ChangeNotifier {
  final List<TailorModel> _allTailors = MockDataService.getTailors();
  final List<ProductModel> _allProducts = MockDataService.getProducts();

  List<TailorModel> _filteredTailors = [];
  String _searchQuery = '';

  List<TailorModel> get tailors => _filteredTailors;
  List<ProductModel> get featuredProducts => _allProducts;
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.isNotEmpty;

  HomeProvider() {
    _filteredTailors = List.from(_allTailors);
  }

  void search(String query) {
    _searchQuery = query.trim();
    if (_searchQuery.isEmpty) {
      _filteredTailors = List.from(_allTailors);
    } else {
      _filteredTailors = _allTailors
          .where(
            (t) =>
                t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                t.location.toLowerCase().contains(_searchQuery.toLowerCase()),
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
