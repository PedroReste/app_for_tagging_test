import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../analytics/analytics_service.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDetails;
  final VoidCallback onBuyNow;

  const ProductCard({
    super.key,
    required this.product,
    required this.onDetails,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final inCart = CartModel().containsProduct(product.id);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cabeçalho do produto ─────────────────
            Row(
              children: [
                // Emoji / imagem do produto
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 38),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Nome, categoria e preço
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge de categoria
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ── Preço ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Por apenas',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                if (inCart)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check, size: 14, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'No carrinho',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Botões ───────────────────────────────
            Row(
              children: [
                // Detalhes do produto
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1565C0),
                      side: const BorderSide(color: Color(0xFF1565C0)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text(
                      'Detalhes',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: onDetails,
                  ),
                ),
                const SizedBox(width: 10),

                // Comprar agora
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                    label: const Text(
                      'Comprar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: onBuyNow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
