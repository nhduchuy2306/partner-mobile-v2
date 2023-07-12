class WalletModel {
  int? id;
  String? type;
  String? description;
  bool? status;

  WalletModel({this.id, this.type, this.description, this.status});

  WalletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}
