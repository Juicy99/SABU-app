import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sateiv2_app/provider/order_notify.dart';
import 'package:sateiv2_app/screens/Item_page.dart';
import 'package:sateiv2_app/screens/cart_page.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();

  var _nameController = TextEditingController();
  var _priceController2 = TextEditingController();
  var _messageController3 = TextEditingController();

  int qty = 1;

  String newItemTitle;
  String newItemMessage;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderNotify>(context);
    double newItemPrice;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.camera, imageQuality: 10);
                    order.setImage(File(pickedFile.path));
                  },
                  child: SizedBox(
                    width: 100,
                    height: 160,
                    child: order.imageFile != null
                        ? Image.file(order.imageFile)
                        : Container(
                            color: Colors.grey,
                          ),
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '商品名を記入'),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    order.newItemTitle = value;
                  },
                  validator: (value) {
                    // 入力内容が空でないかチェック
                    if (value.isEmpty) {
                      return '商品名を入力してください。';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController2,
                  decoration: InputDecoration(labelText: '査定金額を記入してください'),
                  obscureText: false,
                  maxLines: 1,
                  maxLength: 10,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newItemPrice.toString();
                  },
                  validator: (value) {
                    if (value.length == 0 || double.parse(value) <= 0) {
                      return ('金額を記入してください');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _messageController3,
                  decoration: InputDecoration(
                      hintText: '例（限定品）', labelText: '何かメモがあれば記入してください'),
                  onChanged: (value) {
                    newItemMessage = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton.icon(
                      // 送信ボタンクリック時の処理
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartPage()),
                        );
                      },
                      label: Text(
                        order.items.length.toString() + '点を見る',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      splashColor: Colors.black,
                      color: Colors.teal,
                    ),
                    RaisedButton(
                      // 送信ボタンクリック時の処理
                      onPressed: () {
                        // バリデーションチェック
                        if (_formKey.currentState.validate()) {
                          newItemPrice = double.parse(_priceController2.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ItemPage()),
                          );
                          Provider.of<OrderNotify>(context, listen: false)
                              .addItem(
                            _nameController.text,
                            _messageController3.text,
                            double.parse(_priceController2.text),
                          );
                          _nameController.clear();
                          _priceController2.clear();
                          _messageController3.clear();
                          Navigator.pop(context);
                          return Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ItemPage()),
                          );
                        }
                      },
                      child: Text(
                        '査定結果を記録',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      splashColor: Colors.teal,
                      color: Colors.black,
                    ),
                  ],
                ),
                Consumer<OrderNotify>(builder: (context, model, child) {
                  return model.isLoading
                      ? Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
