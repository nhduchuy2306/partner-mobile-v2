class CustomerMemberShip {
  Customer? customer;
  Membership? membership;
  Level? nextLevel;
  List<Level>? levelList;
  List<Wallet>? walletList;

  CustomerMemberShip(
      {this.customer,
      this.membership,
      this.nextLevel,
      this.levelList,
      this.walletList});

  CustomerMemberShip.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    membership = json['membership'] != null
        ? new Membership.fromJson(json['membership'])
        : null;
    nextLevel = json['nextLevel'] != null
        ? new Level.fromJson(json['nextLevel'])
        : null;
    if (json['levelList'] != null) {
      levelList = <Level>[];
      json['levelList'].forEach((v) {
        levelList!.add(new Level.fromJson(v));
      });
    }
    if (json['walletList'] != null) {
      walletList = <Wallet>[];
      json['walletList'].forEach((v) {
        walletList!.add(new Wallet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.membership != null) {
      data['membership'] = this.membership!.toJson();
    }
    if (this.nextLevel != null) {
      data['nextLevel'] = this.nextLevel!.toJson();
    }
    if (this.levelList != null) {
      data['levelList'] = this.levelList!.map((v) => v.toJson()).toList();
    }
    if (this.walletList != null) {
      data['walletList'] = this.walletList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? customerId;
  String? fullName;
  String? email;
  String? dob;
  String? image;
  String? phone;
  bool? state;
  bool? status;
  int? partnerId;
  String? partnerName;

  Customer(
      {this.id,
      this.customerId,
      this.fullName,
      this.email,
      this.dob,
      this.image,
      this.phone,
      this.state,
      this.status,
      this.partnerId,
      this.partnerName});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    fullName = json['fullName'];
    email = json['email'];
    dob = json['dob'];
    image = json['image'];
    phone = json['phone'];
    state = json['state'];
    status = json['status'];
    partnerId = json['partnerId'];
    partnerName = json['partnerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['state'] = this.state;
    data['status'] = this.status;
    data['partnerId'] = this.partnerId;
    data['partnerName'] = this.partnerName;
    return data;
  }
}

class Membership {
  int? id;
  String? dateCreated;
  double? totalReceipt;
  double? totalExpenditure;
  bool? state;
  bool? status;
  int? levelId;
  String? level;
  int? customerId;
  String? customerName;
  int? programId;
  String? programName;

  Membership(
      {this.id,
      this.dateCreated,
      this.totalReceipt,
      this.totalExpenditure,
      this.state,
      this.status,
      this.levelId,
      this.level,
      this.customerId,
      this.customerName,
      this.programId,
      this.programName});

  Membership.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['dateCreated'];
    totalReceipt = json['totalReceipt'];
    totalExpenditure = json['totalExpenditure'];
    state = json['state'];
    status = json['status'];
    levelId = json['levelId'];
    level = json['level'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    programId = json['programId'];
    programName = json['programName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateCreated'] = this.dateCreated;
    data['totalReceipt'] = this.totalReceipt;
    data['totalExpenditure'] = this.totalExpenditure;
    data['state'] = this.state;
    data['status'] = this.status;
    data['levelId'] = this.levelId;
    data['level'] = this.level;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['programId'] = this.programId;
    data['programName'] = this.programName;
    return data;
  }
}

class Level {
  int? id;
  String? level;
  double? condition;
  String? description;
  bool? status;

  Level({this.id, this.level, this.condition, this.description, this.status});

  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    condition = json['condition'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['level'] = this.level;
    data['condition'] = this.condition;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class Wallet {
  int? id;
  double? balance;
  double? totalReceipt;
  double? totalExpenditure;
  String? dateCreated;
  String? dateUpdated;
  bool? state;
  bool? status;
  int? membershipId;
  int? typeId;
  String? type;

  Wallet(
      {this.id,
      this.balance,
      this.totalReceipt,
      this.totalExpenditure,
      this.dateCreated,
      this.dateUpdated,
      this.state,
      this.status,
      this.membershipId,
      this.typeId,
      this.type});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
    totalReceipt = json['totalReceipt'];
    totalExpenditure = json['totalExpenditure'];
    dateCreated = json['dateCreated'];
    dateUpdated = json['dateUpdated'];
    state = json['state'];
    status = json['status'];
    membershipId = json['membershipId'];
    typeId = json['typeId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['balance'] = this.balance;
    data['totalReceipt'] = this.totalReceipt;
    data['totalExpenditure'] = this.totalExpenditure;
    data['dateCreated'] = this.dateCreated;
    data['dateUpdated'] = this.dateUpdated;
    data['state'] = this.state;
    data['status'] = this.status;
    data['membershipId'] = this.membershipId;
    data['typeId'] = this.typeId;
    data['type'] = this.type;
    return data;
  }
}
