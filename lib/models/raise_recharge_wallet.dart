class RaiseWallet {
  String? customerId;
  double? amount;
  String? description;
  String? token;
  int? walletId;

  RaiseWallet(
      {this.customerId,
        this.amount,
        this.description,
        this.token,
        this.walletId});

  RaiseWallet.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    amount = json['amount'];
    description = json['description'];
    token = json['token'];
    walletId = json['walletId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['token'] = this.token;
    data['walletId'] = this.walletId;
    return data;
  }
}

class ReduceWallet {
  String? customerId;
  double? amount;
  String? description;
  String? token;
  List<int>? walletIds;

  ReduceWallet(
      {this.customerId,
        this.amount,
        this.description,
        this.token,
        this.walletIds});

  ReduceWallet.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    amount = json['amount'];
    description = json['description'];
    token = json['token'];
    walletIds = json['walletIds'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['token'] = this.token;
    data['walletIds'] = this.walletIds;
    return data;
  }
}