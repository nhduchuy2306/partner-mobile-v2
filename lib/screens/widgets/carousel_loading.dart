import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CarouselLoading extends StatelessWidget {
  const CarouselLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: Colors.grey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.all(3),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
