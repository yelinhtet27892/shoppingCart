import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:shopping/cart_provider.dart';
import 'package:shopping/database_helper/database_helper.dart';
import 'package:shopping/model/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:shopping/show_cartlist.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Penapple',
    'Banana',
    'Melon',
    'Peach',
    'Mixed fruit Basket'
  ];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];

  List<int> productPrice = [33, 33, 45, 56, 23, 89, 100];
  List<String> productImage = [
    'https://clipart-library.com/image_gallery2/Mango-Transparent.png',
    'https://clipart-library.com/new_gallery/71-714754_orange-fruit-transparent-background.png',
    //'https://www.jiomart.com/images/product/original/590000452/sharad-seedless-grapes-1-kg-product-images-o590000452-p590116963-0-202203171004.jpg?im=Resize=(1000,1000)',
    'https://5.imimg.com/data5/YD/VM/MY-27568370/fresh-pine-apple-500x500.jpg',
    'https://freepngimg.com/thumb/banana/22-banana-png-image.png',
    'https://buymassry.com/images/thumbnails/400/400/detailed/22/000320934-removebg-preview.jpg',
    'https://www.pngarts.com/files/4/Peach-PNG-Image-Background.png',
    'https://i.pinimg.com/564x/0d/88/62/0d88626a422b24ea390e7c4eea6d1ecd--fruit-flowers-gift-baskets.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Product List'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ShowCartList())),
              child: Center(
                child: badge.Badge(
                  badgeContent:
                      Consumer<CartProvider>(builder: (context, c, w) {
                    return Text(
                      c.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  }),
                  child: Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  productImage[index],
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productName[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          productUnit[index] +
                                              " " +
                                              r"$" +
                                              productPrice[index].toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                Cart cartdetail = Cart(
                                                    id: index,
                                                    productId: index.toString(),
                                                    productName:
                                                        productName[index]
                                                            .toString(),
                                                    initialPrice:
                                                        productPrice[index],
                                                    productPrice:
                                                        productPrice[index],
                                                    quantity: 1,
                                                    unitTag: productUnit[index]
                                                        .toString(),
                                                    image: productImage[index]
                                                        .toString());
                                              
                                                  await databaseHelper
                                                      .insertData(cartdetail)
                                                      .then((value) {
                                                    print(
                            'Product add to the cart');
                                                    cart.addTotalPrice(
                                                        double.parse(
                                                            productPrice[index]
                                                                .toString()));
                                                    cart.addCounter();
                                                  }).onError((error, stackTrace) {
                                                    print(error.toString());
                                                  });
                                              
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  )),
                                              child: Text('Add to Cart')),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      )),
            ),
          ],
        ));
  }
}
