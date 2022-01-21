class Food {
  int? id;
  String? name;
  String? catName;
  int? quantity;
  int? price;
  String? status;
  String? img;
  String? createdAt;
  String? updatedAt;

  Food(
      {this.id,
        this.name,
        this.catName,
        this.quantity,
        this.price,
        this.status,
        this.img,
        this.createdAt,
        this.updatedAt});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    catName = json['cat_name'];
    quantity = json['quantity'];
    price = json['price'];
    status = json['status'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cat_name'] = this.catName;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['status'] = this.status;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}