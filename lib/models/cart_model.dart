import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartModel {
  // Singleton
  static final CartModel _instance = CartModel._internal();
  factory CartModel() => _instance;
  CartModel._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  String get formattedTotal =>
      'R\$ ${totalPrice.toStringAsFixed(2).replaceAll('.', ',')}';

  bool get isEmpty => _items.isEmpty;

  /// Adiciona produto ao carrinho
  void addProduct(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  /// Remove produto do carrinho
  void removeProduct(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  /// Limpa o carrinho
  void clear() => _items.clear();

  /// Verifica se produto está no carrinho
  bool containsProduct(String productId) =>
      _items.any((item) => item.product.id == productId);
}
