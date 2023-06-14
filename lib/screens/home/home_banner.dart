import 'package:flutter/material.dart';
import 'package:partner_mobile/helpers/asset_helper.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage(AssetHelper.imageBanner),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
