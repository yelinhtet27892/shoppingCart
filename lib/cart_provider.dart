import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/database_helper/database_helper.dart';
import 'package:shopping/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getData() async {
    _cart = databaseHelper.getCartList();
    return _cart;
  }

  void _setPrefItem() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('cart_item', _counter);
    sharedPreferences.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItem() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getInt('cart_item');
    sharedPreferences.getDouble('total_price');
    notifyListeners();
  }

  double getDiscount(double discount) {
    double result = totalPrice * discount / 100;
    return result;
  }
   double getDiscountPrice(double discount) {
    double result =totalPrice - (totalPrice * discount / 100);
    return result;
  }


  void addCounter() {
    _counter++;
    _setPrefItem();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefItem();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItem();
    return _counter;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItem();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItem();
    notifyListeners();
  }
 
  double getTotalPrice() {
    _getPrefItem();
    return _totalPrice;
  }
}
