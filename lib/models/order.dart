class Order {
  int? orderId;
  String? userName;
  String? date;
  double? total;
  int? status;

  Order({this.orderId, this.userName, this.date, this.total, this.status});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userName = json['userName'];
    date = json['date'];
    total = json['total'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['userName'] = this.userName;
    data['date'] = this.date;
    data['total'] = this.total;
    data['status'] = this.status;
    return data;
  }
}
