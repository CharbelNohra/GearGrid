import 'package:flutter/material.dart';
import 'package:geargrid/common/widgets/custom_app_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Cart",
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Text(
          'Cart Screen',
          style: TextStyle(
            fontSize: 32,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}