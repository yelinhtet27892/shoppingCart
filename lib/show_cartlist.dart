import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:provider/provider.dart';
import 'package:shopping/cart_provider.dart';
import 'package:shopping/database_helper/database_helper.dart';
import 'package:shopping/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';

class ShowCartList extends StatefulWidget {
  const ShowCartList({super.key});

  @override
  State<ShowCartList> createState() => _ShowCartListState();
}

class _ShowCartListState extends State<ShowCartList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('My Product'),
        centerTitle: true,
        actions: [
          Center(
            child: badge.Badge(
              badgeContent: Consumer<CartProvider>(builder: (context, c, w) {
                return Text(
                  c.getCounter().toString(),
                  style: TextStyle(color: Colors.white),
                );
              }),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<List<Cart>>(
              future: cart.getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Image.asset(
                      'images/1.jpg',
                      width: 200,
                      height: 200,
                    ));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          snapshot.data![index].image!,
                                          width: 100,
                                          height: 100,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          .productName!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    IconButton(
                                                        onPressed: () async {
                                                          await databaseHelper
                                                              .deleteData(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id!);

                                                          cart.removeCounter();
                                                          cart.removeTotalPrice(
                                                              double.parse(snapshot
                                                                  .data![index]
                                                                  .productPrice
                                                                  .toString()));
                                                        },
                                                        icon:
                                                            Icon(Icons.delete))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  snapshot.data![index]
                                                          .unitTag! +
                                                      " " +
                                                      r"$" +
                                                      snapshot.data![index]
                                                          .initialPrice!
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                                onTap:
                                                                    () async {
                                                                  int quantity = snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!;

                                                                  quantity--;
                                                                  int newPrice =
                                                                      price *
                                                                          quantity;
                                                                  if (quantity >
                                                                      0) {
                                                                    Cart cartdetail = Cart(
                                                                        id: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id,
                                                                        productId: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productId,
                                                                        productName: snapshot
                                                                            .data![
                                                                                index]
                                                                            .productName,
                                                                        initialPrice: snapshot
                                                                            .data![
                                                                                index]
                                                                            .initialPrice,
                                                                        productPrice:
                                                                            newPrice,
                                                                        quantity:
                                                                            quantity,
                                                                        unitTag: snapshot
                                                                            .data![
                                                                                index]
                                                                            .unitTag,
                                                                        image: snapshot
                                                                            .data![index]
                                                                            .image);

                                                                    await databaseHelper
                                                                        .updateData(
                                                                            cartdetail)
                                                                        .then(
                                                                            (value) {
                                                                      int newPrice =
                                                                          0;
                                                                      int quantity =
                                                                          0;
                                                                      cart.addTotalPrice(double.parse(snapshot
                                                                          .data![
                                                                              index]
                                                                          .initialPrice
                                                                          .toString()));
                                                                    }).onError((error,
                                                                            stackTrace) {
                                                                      print(error
                                                                          .toString());
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.remove,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            InkWell(
                                                                onTap:
                                                                    () async {
                                                                  int quantity = snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!;

                                                                  quantity++;
                                                                  int newPrice =
                                                                      price *
                                                                          quantity;

                                                                  Cart cartdetail = Cart(
                                                                      id: snapshot
                                                                          .data![
                                                                              index]
                                                                          .id,
                                                                      productId: snapshot
                                                                          .data![
                                                                              index]
                                                                          .productId,
                                                                      productName: snapshot
                                                                          .data![
                                                                              index]
                                                                          .productName,
                                                                      initialPrice: snapshot
                                                                          .data![
                                                                              index]
                                                                          .initialPrice,
                                                                      productPrice:
                                                                          newPrice,
                                                                      quantity:
                                                                          quantity,
                                                                      unitTag: snapshot
                                                                          .data![
                                                                              index]
                                                                          .unitTag,
                                                                      image: snapshot
                                                                          .data![
                                                                              index]
                                                                          .image);

                                                                  await databaseHelper
                                                                      .updateData(
                                                                          cartdetail)
                                                                      .then(
                                                                          (value) {
                                                                    int newPrice =
                                                                        0;
                                                                    int quantity =
                                                                        0;
                                                                    cart.addTotalPrice(double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice
                                                                        .toString()));
                                                                  }).onError((error,
                                                                          stackTrace) {
                                                                    print(error
                                                                        .toString());
                                                                  });
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ]),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              )),
                    );
                  }
                }
                return Center(
                  child: Text(''),
                );
              }),
          Consumer<CartProvider>(builder: (context, v, w) {
            return Visibility(
              visible: v.getTotalPrice().toStringAsFixed(2) == '0.00' ||
                      v.getDiscount(5).toStringAsFixed(2) == '0.00' ||
                      v.getDiscountPrice(5).toStringAsFixed(2) == '0.00'
                  ? false
                  : true,
              child: Column(
                children: [
                  ResuableCode(
                      title: "SubPrice",
                      value: r"$" + v.getTotalPrice().toStringAsFixed(2)),
                  ResuableCode(
                      title: 'Discount 5%',
                      value: r"$" + v.getDiscount(5).toStringAsFixed(2)),
                  ResuableCode(
                      title: 'TotalPrice',
                      value: r"$" + v.getDiscountPrice(5).toStringAsFixed(2)),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class ResuableCode extends StatelessWidget {
  ResuableCode({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
