class MoMoResponse {
  String? partnerCode;
  String? orderId;
  String? requestId;
  int? amount;
  int? responseTime;
  String? message;
  int? resultCode;
  String? payUrl;

  MoMoResponse(
      {this.partnerCode,
        this.orderId,
        this.requestId,
        this.amount,
        this.responseTime,
        this.message,
        this.resultCode,
        this.payUrl});

  MoMoResponse.fromJson(Map<String, dynamic> json) {
    partnerCode = json['partnerCode'];
    orderId = json['orderId'];
    requestId = json['requestId'];
    amount = json['amount'];
    responseTime = json['responseTime'];
    message = json['message'];
    resultCode = json['resultCode'];
    payUrl = json['payUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partnerCode'] = this.partnerCode;
    data['orderId'] = this.orderId;
    data['requestId'] = this.requestId;
    data['amount'] = this.amount;
    data['responseTime'] = this.responseTime;
    data['message'] = this.message;
    data['resultCode'] = this.resultCode;
    data['payUrl'] = this.payUrl;
    return data;
  }
}