class Product {
  int id = 0;
  String name = "";
  String price = "";
  int quantity = 0;

  // Product(
  //     {required this.id,
  //     required this.name,
  //     required this.price,
  //     required this.quantity});

  // from map Map => Product object
  static Product fromMap(Map<String, dynamic> query) {
    // Product product = Product(id: 0, name: '', price: '', quantity: 0);
    Product product = Product();

    product.id = query['id'];
    product.name = query['name'];
    product.price = query['price'];
    product.quantity = query['quantity'];

    return product;
  }

  // to map ------ product => Map
  static Map<String, dynamic> toMap(Product product) {
    return <String, dynamic>{
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': product.quantity,
    };
  }

  // from map list ----- Map List => Product List
  static List<Product> fromMapList(List<Map<String, dynamic>> query) {
    List<Product> products = [];

    for (Map mp in query) {
      products.add(fromMap(mp));
    }

    return products;
  }
}
