import 'package:flutter/material.dart';
import 'package:partner_mobile/models/customer_membership.dart';

class PaymentWalletProvider extends ChangeNotifier {

  final List<Wallet> _selectedPaymentWalletIds = [];

  List<Wallet> get selectedPaymentWalletIds => _selectedPaymentWalletIds;

  void addPaymentWalletId(Wallet wallet) {
    _selectedPaymentWalletIds.add(wallet);
    notifyListeners();
  }

  bool isSelectedWallet(Wallet wallet) {
    for (var item in _selectedPaymentWalletIds) {
      if (item.id == wallet.id) {
        notifyListeners();
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  void removePaymentWalletId(Wallet wallet) {
    for (var item in _selectedPaymentWalletIds) {
      if (item.id == wallet.id) {
        _selectedPaymentWalletIds.remove(item);
        notifyListeners();
        return;
      }
    }
  }

  double get totalAmount {
    double total = 0;
    for (var wallet in _selectedPaymentWalletIds) {
      total += wallet.balance!;
    }
    return total;
  }
}