import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _loadPersistedUser();
  }

  Future<void> _loadPersistedUser() async {
    _isLoading = true;
    notifyListeners();
    _user = await StorageService.getUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 650)); // Realistic UX feedback

    // Basic authentication simulation with credential validation
    if (email.trim().isEmpty || !email.contains('@')) {
      _errorMessage = 'Please provide a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final name = email.split('@').first;
    final formattedName = name.isNotEmpty
        ? name[0].toUpperCase() + name.substring(1)
        : 'User';

    _user = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: formattedName,
      email: email.trim(),
      role: 'Industrial Engineer / Buyer',
      company: 'Sankar Group Partner',
    );

    if (rememberMe) {
      await StorageService.saveUser(_user!);
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    String? company,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    if (name.trim().isEmpty) {
      _errorMessage = 'Full Name is required.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _errorMessage = 'Please enter a valid work email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: name.trim(),
      email: email.trim(),
      role: 'Operations & Procurement',
      company: company?.trim().isNotEmpty == true ? company!.trim() : 'Sankar Group',
    );

    await StorageService.saveUser(_user!);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> loginAsGuest() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));

    _user = UserModel(
      id: 'GUEST-001',
      name: 'Guest Engineer',
      email: 'guest@sankargroup.com',
      role: 'Guest Visitor',
      company: 'Sankar Showcase',
      isGuest: true,
    );

    await StorageService.saveUser(_user!);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await StorageService.clearAuth();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

