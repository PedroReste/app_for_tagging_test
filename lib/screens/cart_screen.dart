import 'package:flutter/material.dart';
import '../analytics/analytics_service.dart';
import '../models/cart_model.dart';
import '../widgets/cart_item_tile.dart';
import 'success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cart = CartModel();
  final _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView(
      screenName: 'cart',
      screenClass: 'CartScreen',
    );
    _analytics.trackViewCart(cart: _cart, screen: 'cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Carrinho (${_cart.itemCount} '
          '${_cart.itemCount == 1 ? 'item' : 'itens'})',
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: _cart.isEmpty ? _buildEmptyCart() : _buildCartContent(),
    );
  }

  // ── Carrinho vazio ───────────────────────────────

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🛒', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text(
            'Seu carrinho está vazio',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione produtos para continuar',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.storefront),
            label: const Text(
              'Voltar para a loja',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ── Conteúdo do carrinho ─────────────────────────

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            children: [
              // Itens do carrinho
              ..._cart.items.map(
                (item) => CartItemTile(
                  item: item,
                  onRemove: () => _onRemoveItem(item),
                ),
              ),

              const SizedBox(height: 16),

              // Resumo do pedido
              _buildOrderSummary(),

              const SizedBox(height: 8),

              // Informações de entrega
              _buildShippingInfo(),

              const SizedBox(height: 16),
            ],
          ),
        ),

        // Rodapé com total e checkout
        _buildCheckoutBar(),
      ],
    );
  }

  // ── Resumo do pedido ─────────────────────────────

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo do pedido',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Subtotal por item
          ..._cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          item.product.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.product.name,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${item.totalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.quantity > 1)
                        Text(
                          '${item.quantity}x '
                          '${item.product.formattedPrice}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 20),

          // Frete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🚚 Frete',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                _cart.totalPrice >= 299.0 ? 'Grátis' : 'R\$ 19,90',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _cart.totalPrice >= 299.0
                      ? Colors.green
                      : Colors.black87,
                ),
              ),
            ],
          ),

          const Divider(height: 20),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _cart.formattedTotal,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Info de entrega ──────────────────────────────

  Widget _buildShippingInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: Colors.blue, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Entrega estimada: 5 a 7 dias úteis\n'
              'Frete grátis em compras acima de R\$ 299,00',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // ── Checkout Bar ─────────────────────────────────

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total da compra:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                _cart.formattedTotal,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.lock_outline, size: 20),
              label: const Text(
                'Prosseguir para o Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _onCheckout,
            ),
          ),
        ],
      ),
    );
  }

  // ── Ações ────────────────────────────────────────

  void _onRemoveItem(CartItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Remover item'),
        content: Text(
          'Deseja remover "${item.product.name}" do carrinho?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);

              // 🏷️ Tag: produto removido do carrinho
              _analytics.trackRemoveFromCart(
                product: item.product,
                screen: 'cart',
              );

              _cart.removeProduct(item.product.id);
              setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${item.product.name} removido do carrinho',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  void _onCheckout() {
    // 🏷️ Tag: início do checkout
    _analytics.trackBeginCheckout(cart: _cart, screen: 'cart');

    // Simula confirmação de pagamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Color(0xFF1565C0)),
            SizedBox(width: 8),
            Text('Confirmar Pagamento'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo do pedido:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            ..._cart.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.product.emoji} ${item.product.name}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'R\$ ${item.totalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _cart.formattedTotal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Pagamento 100% seguro',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.check, size: 18),
            label: const Text(
              'Confirmar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
              _confirmPurchase();
            },
          ),
        ],
      ),
    );
  }

  void _confirmPurchase() {
    // Gera código do pedido
    final orderId = _generateOrderId();

    // 🏷️ Tag: compra finalizada
    _analytics.trackPurchase(
      cart: _cart,
      orderId: orderId,
      screen: 'cart',
    );

    // Navega para tela de sucesso e limpa a pilha
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          orderId: orderId,
          cartItems: List.from(_cart.items),
          totalPrice: _cart.totalPrice,
        ),
      ),
      (route) => route.isFirst,
    );

    // Limpa o carrinho após navegar
    _cart.clear();
  }

  String _generateOrderId() {
    final now = DateTime.now();
    final timestamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}';
    final random = (1000 + (now.millisecond * 9) % 9000).toString();
    return 'SHP-$timestamp-$random';
  }
}
