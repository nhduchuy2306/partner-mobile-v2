import 'package:flutter/material.dart';
import 'package:partner_mobile/models/customer_membership.dart';

class PaymentWalletProvider extends ChangeNotifier {

  List<Wallet> _selectedPaymentWalletIds = [];

  List<Wallet> get selectedPaymentWalletIds => _selectedPaymentWalletIds;

  void addPaymentWalletId(Wallet wallet) {
    _selectedPaymentWalletIds.add(wallet);
    notifyListeners();
  }

  void removePaymentWalletId(Wallet wallet) {
    _selectedPaymentWalletIds.remove(wallet);
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    for (var wallet in _selectedPaymentWalletIds) {
      total += wallet.balance!;
    }
    return total;
  }
}