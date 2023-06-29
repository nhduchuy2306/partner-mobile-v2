class TransactionHistoryModel {
  int? id;
  double? amount;
  String? dateCreated;
  String? dateUpdated;
  String? description;
  bool? state;
  bool? status;
  int? partnerId;
  String? partnerName;
  int? typeId;
  String? type;
  List<Transaction>? transactionList;

  TransactionHistoryModel(
      {this.id,
      this.amount,
      this.dateCreated,
      this.dateUpdated,
      this.description,
      this.state,
      this.status,
      this.partnerId,
      this.partnerName,
      this.typeId,
      this.type,
      this.transactionList});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
    description = json['description'];
    state = json['state'];
    status = json['status'];
    partnerId = json['partnerId'];
    partnerName = json['partnerName'];
    typeId = json['typeId'];
    type = json['type'];
    if (json['transactionList'] != null) {
      transactionList = <Transaction>[];
      json['transactionList'].forEach((v) {
        transactionList!.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['dateCreated'] = this.dateCreated;
    data['dateUpdated'] = this.dateUpdated;
    data['description'] = this.description;
    data['state'] = this.state;
    data['status'] = this.status;
    data['partnerId'] = this.partnerId;
    data['partnerName'] = this.partnerName;
    data['typeId'] = this.typeId;
    data['type'] = this.type;
    if (this.transactionList != null) {
      data['transactionList'] =
          this.transactionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
  int? id;
  double? amount;
  String? dateCreated;
  String? dateUpdated;
  String? description;
  bool? state;
  bool? status;
  int? typeId;
  String? type;
  int? walletId;
  String? wallet;
  int? requestId;

  Transaction(
      {this.id,
      this.amount,
      this.dateCreated,
      this.dateUpdated,
      this.description,
      this.state,
      this.status,
      this.typeId,
      this.type,
      this.walletId,
      this.wallet,
      this.requestId});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
    description = json['description'];
    state = json['state'];
    status = json['status'];
    typeId = json['typeId'];
    type = json['type'];
    walletId = json['walletId'];
    wallet = json['wallet'];
    requestId = json['requestId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['dateCreated'] = this.dateCreated;
    data['dateUpdated'] = this.dateUpdated;
    data['description'] = this.description;
    data['state'] = this.state;
    data['status'] = this.status;
    data['typeId'] = this.typeId;
    data['type'] = this.type;
    data['walletId'] = this.walletId;
    data['wallet'] = this.wallet;
    data['requestId'] = this.requestId;
    return data;
  }
}
