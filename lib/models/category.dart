class Category {
  int? categoryId;
  String? categoryPicture;
  String? categoryName;
  bool? status;

  Category(
      {this.categoryId, this.categoryPicture, this.categoryName, this.status});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryPicture = json['categoryPicture'];
    categoryName = json['categoryName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryPicture'] = this.categoryPicture;
    data['categoryName'] = this.categoryName;
    data['status'] = this.status;
    return data;
  }
}
