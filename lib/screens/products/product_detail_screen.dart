import 'package:flutter/material.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/models/product_description.dart';
import 'package:partner_mobile/models/product_picture.dart';
import 'package:partner_mobile/screens/widgets/carousel_loading.dart';
import 'package:partner_mobile/screens/widgets/item_counter_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen(
      {super.key,
      required this.product,
      this.productDescription,
      this.productPictures});

  Product product;
  Future<ProductDescription>? productDescription;
  Future<List<ProductPicture>>? productPictures;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _amount = 1;
  int _pageViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getImageHeaderWidget(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      widget.product.productName ?? "",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      ItemCounterWidget(
                        onAmountChanged: (newAmount) {
                          setState(() {
                            _amount = newAmount;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${getTotalPrice().toStringAsFixed(0)} VNĐ",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(thickness: 1),
                  getDetailOfProductWidget("Product Details"),
                  const Divider(thickness: 1),
                  getProductDataRowWidget(
                    "Review",
                    customWidget: ratingWidget(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.maxFinite, 50),
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text("Add to Cart"),
        ),
      ),
    );
  }

  Widget getImageHeaderWidget() {
    return FutureBuilder<List<ProductPicture>>(
      future: widget.productPictures,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 250,
                  child: PageView(
                    onPageChanged: (index) {
                      setState(() {
                        _pageViewIndex = index;
                      });
                    },
                    children: snapshot.data!
                        .map<Widget>(
                          (e) => Container(
                            margin: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image.network(
                                e.pictureUrl ??
                                    "https://firebasestorage.googleapis.com/v0/b/gadgetzone-49cd4.appspot.com/o/headphones-14672.png?alt=media&token=74f5ed8f-df69-403e-b402-a3006afc919c",
                                fit: BoxFit.cover,
                                width: 1000,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => Container(
                      margin: const EdgeInsets.all(3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            index == _pageViewIndex ? Colors.blue : Colors.grey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: Text("No image"),
            );
          }
        } else {
          return const CarouselLoading();
        }
      },
    );
  }

  Widget getProductDataRowWidget(String label, {Widget? customWidget}) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (customWidget != null) ...[
            customWidget,
            const SizedBox(
              width: 20,
            )
          ],
        ],
      ),
    );
  }

  Widget ratingWidget() {
    Widget starIcon() {
      return const Icon(
        Icons.star,
        color: Color(0xffF3603F),
        size: 20,
      );
    }

    return Row(
      children: [
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
        starIcon(),
      ],
    );
  }

  Widget getDetailOfProductWidget(String label) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<ProductDescription>(
            future: widget.productDescription,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Table(
                    border: TableBorder.all(
                        color: Colors.grey,
                        width: 1,
                    ),
                    children: [
                      buildRow(["Information", "Value"], isHeader: true),
                      if(snapshot.data!.keycap != null)
                        buildRow(["KeyCap", snapshot.data!.keycap ?? ""]),
                      if(snapshot.data!.switchKeyBoard != null)
                        buildRow(["Switch Key Board", snapshot.data!.switchKeyBoard ?? ""]),
                      if(snapshot.data!.typeKeyboard != null)
                        buildRow(["Type Key board", snapshot.data!.typeKeyboard ?? ""]),
                      if(snapshot.data!.connect != null)
                        buildRow(["Connect", snapshot.data!.connect ?? ""]),
                      if(snapshot.data!.led != null)
                        buildRow(["Led", snapshot.data!.led ?? ""]),
                      if(snapshot.data!.freigh != null)
                        buildRow(["Freigh", snapshot.data!.freigh ?? ""]),
                      if(snapshot.data!.itemDimension != null)
                        buildRow(["Item Dimension", snapshot.data!.itemDimension ?? ""]),
                      if(snapshot.data!.ram != null)
                        buildRow(["Ram", snapshot.data!.ram ?? ""]),
                      if(snapshot.data!.operatingSystem != null)
                        buildRow(["Operating System", snapshot.data!.operatingSystem ?? ""]),
                      if(snapshot.data!.battery != null)
                        buildRow(["Battery", snapshot.data!.battery ?? ""]),
                      if(snapshot.data!.hardDisk != null)
                        buildRow(["Hard Disk", snapshot.data!.hardDisk ?? ""]),
                      if(snapshot.data!.graphicCard != null)
                        buildRow(["Graphic Card", snapshot.data!.graphicCard ?? ""]),
                      if(snapshot.data!.keyBoard != null)
                        buildRow(["Key Board", snapshot.data!.keyBoard ?? ""]),
                      if(snapshot.data!.audio != null)
                        buildRow(["Audio", snapshot.data!.audio ?? ""]),
                      if(snapshot.data!.wifi != null)
                        buildRow(["Wifi", snapshot.data!.wifi ?? ""]),
                      if(snapshot.data!.bluetooth != null)
                        buildRow(["Bluetooth", snapshot.data!.bluetooth ?? ""]),
                      if(snapshot.data!.color != null)
                        buildRow(["Color", snapshot.data!.color ?? ""]),
                      if(snapshot.data!.frameRate != null)
                        buildRow(["Frame Rate", snapshot.data!.frameRate ?? ""]),
                      if(snapshot.data!.screenSize != null)
                        buildRow(["Screen Size", snapshot.data!.screenSize ?? ""]),
                      if(snapshot.data!.screenType != null)
                        buildRow(["Screen Type", snapshot.data!.screenType ?? ""]),
                    ],
                  );
                } else {
                  return const Text(
                    "No description",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  );
                }
              } else {
                return const Center(
                  child: Text("No description"),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((e) {
        if (isHeader) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                e,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              e,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  double getTotalPrice() {
    return widget.product.price! * _amount;
  }
}
