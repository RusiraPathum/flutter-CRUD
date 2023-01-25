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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Center(
        child: Column(
          children: [
            // Expanded(child: child)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showProductDialogBox(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  showProductDialogBox(BuildContext context) {
    Widget saveButton = TextButton(
      onPressed: () {
        if (_nameController.text.isNotEmpty &&
            _priceController.text.isNotEmpty &&
            _quantityController.text.isNotEmpty) {
          Product product = Product();

          product.name = _nameController.text;
          product.price = _priceController.text;
          product.quantity = int.parse(_quantityController.text);

          DBHelper.instance.insertProduct(product).then((value) {});
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
      title: Text('Add new Product'),
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
}
