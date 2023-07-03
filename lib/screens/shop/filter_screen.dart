import 'package:flutter/material.dart';
import 'package:partner_mobile/models/brand.dart';
import 'package:partner_mobile/models/category.dart';
import 'package:partner_mobile/provider/brand_provider.dart';
import 'package:partner_mobile/provider/category_provider.dart';
import 'package:partner_mobile/styles/app_colors.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({super.key, this.brands, this.categories});

  Future<List<Category>>? categories;
  Future<List<Brand>>? brands;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var minPriceEditingController = TextEditingController();
  var maxPriceEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var categoryIds = context.watch<CategoryProvider>().selectedCategoryIds;
    var brandIds = context.watch<BrandProvider>().selectedBrandIds;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Filter",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            getLabel("Categories"),
            FutureBuilder<List<Category>>(
              future: widget.categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final list = snapshot.data!;
                  return ListBody(
                    children: list.map((category) {
                      return CheckboxListTile(
                        title: Text(category.categoryName!),
                        value: categoryIds.contains(category.categoryId),
                        onChanged: (value) {
                          if (value!) {
                            context
                                .read<CategoryProvider>()
                                .addCategoryId(category.categoryId!);
                          } else {
                            context
                                .read<CategoryProvider>()
                                .removeCategoryId(category.categoryId!);
                          }
                        },
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(height: 10),
            getLabel("Brand"),
            const SizedBox(height: 15),
            FutureBuilder<List<Brand>>(
              future: widget.brands,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final list = snapshot.data!;
                  return ListBody(
                    children: list.map((brand) {
                      return CheckboxListTile(
                        title: Text(brand.brandName!),
                        value: brandIds.contains(brand.brandId),
                        onChanged: (value) {
                          if (value!) {
                            context
                                .read<BrandProvider>()
                                .addBrandId(brand.brandId!);
                          } else {
                            context
                                .read<BrandProvider>()
                                .removeBrandId(brand.brandId!);
                          }
                        },
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            getLabel("Price"),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "\$",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: minPriceEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Min",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "\$",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: maxPriceEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Max",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: double.maxFinite,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              "categories": categoryIds,
              "brands": brandIds,
              "minPrice": minPriceEditingController.text,
              "maxPrice": maxPriceEditingController.text,
            });
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            "Apply",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class OptionItem extends StatefulWidget {
  final String text;

  const OptionItem({Key? key, required this.text}) : super(key: key);

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          checked = !checked;
        });
      },
      child: Row(
        children: [
          getCheckBox(),
          const SizedBox(
            width: 12,
          ),
          getTextWidget(),
        ],
      ),
    );
  }

  Widget getTextWidget() {
    return Text(
      widget.text,
      style: TextStyle(
        color: checked ? AppColors.primaryColor : Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget getCheckBox() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: SizedBox(
        width: 25,
        height: 25,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: checked ? 0 : 1.5, color: const Color(0xffB1B1B1)),
              borderRadius: BorderRadius.circular(8),
              color: checked ? AppColors.primaryColor : Colors.transparent),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.transparent,
            ),
            child: Checkbox(
              value: checked,
              onChanged: (state) => setState(() => checked = !checked),
              activeColor: Colors.transparent,
              checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
          ),
        ),
      ),
    );
  }
}
