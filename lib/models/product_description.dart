class ProductDescription {
  int? productDescriptionId;
  String? keycap;
  String? switchKeyBoard;
  String? typeKeyboard;
  String? connect;
  String? led;
  String? freigh;
  String? itemDimension;
  String? cpu;
  String? ram;
  String? operatingSystem;
  String? battery;
  String? hardDisk;
  String? graphicCard;
  String? keyBoard;
  String? audio;
  String? wifi;
  String? bluetooth;
  String? color;
  String? frameRate;
  String? screenSize;
  String? screenType;
  int? productId;

  ProductDescription(
      {this.productDescriptionId,
      this.keycap,
      this.switchKeyBoard,
      this.typeKeyboard,
      this.connect,
      this.led,
      this.freigh,
      this.itemDimension,
      this.cpu,
      this.ram,
      this.operatingSystem,
      this.battery,
      this.hardDisk,
      this.graphicCard,
      this.keyBoard,
      this.audio,
      this.wifi,
      this.bluetooth,
      this.color,
      this.frameRate,
      this.screenSize,
      this.screenType,
      this.productId});

  ProductDescription.fromJson(Map<String, dynamic> json) {
    productDescriptionId = json['productDescriptionId'];
    keycap = json['keycap'];
    switchKeyBoard = json['switchKeyBoard'];
    typeKeyboard = json['typeKeyboard'];
    connect = json['connect'];
    led = json['led'];
    freigh = json['freigh'];
    itemDimension = json['itemDimension'];
    cpu = json['cpu'];
    ram = json['ram'];
    operatingSystem = json['operatingSystem'];
    battery = json['battery'];
    hardDisk = json['hardDisk'];
    graphicCard = json['graphicCard'];
    keyBoard = json['keyBoard'];
    audio = json['audio'];
    wifi = json['wifi'];
    bluetooth = json['bluetooth'];
    color = json['color'];
    frameRate = json['frameRate'];
    screenSize = json['screenSize'];
    screenType = json['screenType'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productDescriptionId'] = this.productDescriptionId;
    data['keycap'] = this.keycap;
    data['switchKeyBoard'] = this.switchKeyBoard;
    data['typeKeyboard'] = this.typeKeyboard;
    data['connect'] = this.connect;
    data['led'] = this.led;
    data['freigh'] = this.freigh;
    data['itemDimension'] = this.itemDimension;
    data['cpu'] = this.cpu;
    data['ram'] = this.ram;
    data['operatingSystem'] = this.operatingSystem;
    data['battery'] = this.battery;
    data['hardDisk'] = this.hardDisk;
    data['graphicCard'] = this.graphicCard;
    data['keyBoard'] = this.keyBoard;
    data['audio'] = this.audio;
    data['wifi'] = this.wifi;
    data['bluetooth'] = this.bluetooth;
    data['color'] = this.color;
    data['frameRate'] = this.frameRate;
    data['screenSize'] = this.screenSize;
    data['screenType'] = this.screenType;
    data['productId'] = this.productId;
    return data;
  }
}
