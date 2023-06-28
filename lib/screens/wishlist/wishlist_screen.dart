import 'package:flutter/material.dart';
import 'package:partner_mobile/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    var favoriteList = context.watch<FavoriteProvider>().favoriteList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favoriteList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Image.network(
                favoriteList[index].picture!,
                width: 100,
                height: 100,
              ),
              title: Text(favoriteList[index].productName!),
              subtitle: Text('\$${favoriteList[index].price!.toStringAsFixed(0)}'),
              trailing: Consumer<FavoriteProvider>(builder:(context, favoriteProvider, child){
                return IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: favoriteProvider.isFavorite(favoriteList[index])
                        ? Colors.red
                        : Colors.grey,
                    size: 20,
                  ),
                  onPressed: ()  {
                    favoriteProvider.addFavorite(favoriteList[index]);
                  },
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
