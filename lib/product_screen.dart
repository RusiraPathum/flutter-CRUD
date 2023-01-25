import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud/db_helper.dart';
import 'package:flutter_crud/product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  List<Product> productList = [];

  Product _selectedProduct = Product();

  @override
  void initState() {
    // DBHelper.instance.getProductList().then(
    //   (value) {
    //     setState(() {
    //       productList = value;
    //     });
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (BuildContext context, index) {
                  if (productList.isNotEmpty) {
                    return GestureDetector(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                spreadRadius: 3,
                                color: Colors.grey.withOpacity(0.2),
                              )
                            ]),
                        child: ListTile(
                          leading: Icon(Icons.all_inbox),
                          title: Text(
                            productList[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            'LKR $productList[index].price',
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: Container(
                            width: 100,
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedProduct = productList[index];
                                        showProductDialogBox(
                                            context, InputType.UpdateProduct);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.update,
                                      color: Colors.green,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Text('List is emty'),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showProductDialogBox(context, InputType.AddProduct);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  showProductDialogBox(BuildContext context, InputType type) {
    bool isUpdateProduct = false;

    isUpdateProduct = (type == InputType.UpdateProduct) ? true : false;

    if (isUpdateProduct) {
      _nameController.text = _selectedProduct.name;
      _priceController.text = _selectedProduct.price;
      _quantityController.text = _selectedProduct.quantity.toString();
    }

    Widget saveButton = TextButton(
      onPressed: () {
        if (_nameController.text.isNotEmpty &&
            _priceController.text.isNotEmpty &&
            _quantityController.text.isNotEmpty) {
          Product product = Product();

          product.name = _nameController.text;
          product.price = _priceController.text;
          product.quantity = int.parse(_quantityController.text);

          DBHelper.instance.insertProduct(product).then((value) {
            DBHelper.instance.getProductList().then(
              (value) {
                setState(() {
                  productList = value;
                });
              },
            );

            Navigator.pop(context);
            _emtyTextFields();
          });
        }
      },
      child: Text('Save'),
    );
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('Cancel'),
    );

    AlertDialog productDetailsBox = AlertDialog(
      title: Text(!isUpdateProduct ? 'Add new Product' : 'Update Product'),
      content: Container(
        child: Wrap(
          children: [
            Container(
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
            ),
            Container(
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Product Pricr'),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              child: TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Product Quantity'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
      actions: [saveButton, cancelButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return productDetailsBox;
        });
  }

  void _emtyTextFields() {
    _nameController.text = '';
    _priceController.text = '';
    _quantityController.text = '';
  }
}

enum InputType { AddProduct, UpdateProduct }
