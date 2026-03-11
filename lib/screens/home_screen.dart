import 'package:flutter/material.dart';
import '../analytics/analytics_service.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../widgets/product_card.dart';
import 'product_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cart = CartModel();
  final _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView(
      screenName: 'home',
      screenClass: 'HomeScreen',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: CustomScrollView(
          slivers: [
            // ── Banner promocional ───────────────────
            SliverToBoxAdapter(child: _buildHeroBanner()),

            // ── Título da seção ──────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 22),
                    SizedBox(width: 6),
                    Text(
                      'Produtos em Destaque',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Lista de produtos ────────────────────
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = kProducts[index];
                  return ProductCard(
                    product: product,
                    onDetails: () => _onDetails(product),
                    onBuyNow: () => _onBuyNow(product),
                  );
                },
                childCount: kProducts.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),

      // ── FAB do carrinho ──────────────────────────
      floatingActionButton: _buildCartFAB(),
    );
  }

  // ── AppBar ──────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1565C0),
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Row(
        children: [
          Icon(Icons.storefront, size: 24),
          SizedBox(width: 8),
          Text(
            'ShopFlutter',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        // Ícone do carrinho na AppBar
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: _goToCart,
              tooltip: 'Carrinho',
            ),
            if (_cart.itemCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${_cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Hero Banner ─────────────────────────────────

  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🔥 Oferta especial',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Os melhores\nprodutos para você!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Frete grátis em compras\nacima de R\$ 299,00',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Text('🛍️', style: TextStyle(fontSize: 64)),
        ],
      ),
    );
  }

  // ── FAB Carrinho ─────────────────────────────────

  Widget _buildCartFAB() {
    if (_cart.isEmpty) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: _goToCart,
      backgroundColor: const Color(0xFF2E7D32),
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
      label: Text(
        'Carrinho (${_cart.itemCount}) • ${_cart.formattedTotal}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ── Ações ────────────────────────────────────────

  void _onDetails(Product product) {
    // 🏷️ Tag: usuário clicou em detalhes
    _analytics.trackSelectItem(product: product, screen: 'home');
    _analytics.trackViewItem(product: product, screen: 'home');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductScreen(product: product),
      ),
    ).then((_) => setState(() {})); // Atualiza badge do carrinho ao voltar
  }

  void _onBuyNow(Product product) {
    // 🏷️ Tag: adicionado ao carrinho pela home
    _analytics.trackAddToCart(product: product, screen: 'home');

    _cart.addProduct(product);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(product.emoji),
            const SizedBox(width: 8),
            Expanded(
              child: Text('${product.name} adicionado ao carrinho!'),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Ver carrinho',
          onPressed: _goToCart,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _goToCart() {
    // 🏷️ Tag: visualização do carrinho
    _analytics.trackViewCart(cart: _cart, screen: 'home');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    ).then((_) => setState(() {}));
  }
}
