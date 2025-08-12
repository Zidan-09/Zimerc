library products_screen;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/product_service.dart';
import '../../../services/session.dart';
import 'widgets/products_cards.dart';
import 'widgets/add_product_form.dart';

part 'products_screen_state.dart';
part 'product_builders.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}