import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../analytics/analytics_service.dart';
import '../models/cart_model.dart';

class SuccessScreen extends StatefulWidget {
  final String orderId;
  final List<CartItem> cartItems;
  final double totalPrice;

  const SuccessScreen({
    super.key,
    required this.orderId,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  bool _codeCopied = false;

  @override
  void initState() {
    super.initState();

    // Animação de entrada
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();

    // 🏷️ Tag: visualização da tela de sucesso
    AnalyticsService().trackScreenView(
      screenName: 'purchase_success',
      screenClass: 'SuccessScreen',
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String get _formattedTotal =>
      'R\$ ${widget.totalPrice.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF4),

      // Remove o botão de voltar — fluxo concluído
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: const Text(
          'Pedido Confirmado',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Ícone de sucesso animado ─────────────
              _buildSuccessIcon(),

              const SizedBox(height: 24),

              // ── Título e subtítulo ───────────────────
              const Text(
                '🎉 Parabéns pela compra!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Seu pedido foi confirmado e\nestá sendo preparado para envio.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // ── Card do código do pedido ─────────────
              _buildOrderCodeCard(),

              const SizedBox(height: 20),

              // ── Card de itens comprados ──────────────
              _buildPurchasedItemsCard(),

              const SizedBox(height: 20),

              // ── Card de informações de entrega ───────
              _buildDeliveryCard(),

              const SizedBox(height: 28),

              // ── Botão voltar para a loja ─────────────
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
                  icon: const Icon(Icons.storefront, size: 20),
                  label: const Text(
                    'Voltar para a Loja',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _onBackToStore,
                ),
              ),

              const SizedBox(height: 12),

              // ── Botão ver log de analytics ───────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.analytics_outlined, size: 20),
                  label: Text(
                    'Ver eventos Firebase '
                    '(${AnalyticsService().eventLog.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _showAnalyticsReport(context),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Ícone animado ────────────────────────────────

  Widget _buildSuccessIcon() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 64,
        ),
      ),
    );
  }

  // ── Card do código do pedido ─────────────────────

  Widget _buildOrderCodeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                'Código do Pedido',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Código
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FFF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2E7D32).withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.orderId,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Color(0xFF1B5E20),
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _copyOrderId,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _codeCopied
                        ? const Icon(
                            Icons.check_circle,
                            key: ValueKey('copied'),
                            color: Colors.green,
                            size: 22,
                          )
                        : const Icon(
                            Icons.copy_outlined,
                            key: ValueKey('copy'),
                            color: Color(0xFF2E7D32),
                            size: 22,
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Text(
            _codeCopied
                ? '✓ Código copiado!'
                : 'Toque no ícone para copiar o código',
            style: TextStyle(
              fontSize: 12,
              color: _codeCopied ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card de itens comprados ──────────────────────

  Widget _buildPurchasedItemsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF1565C0),
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                'Itens comprados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lista de itens
          ...widget.cartItems.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    item.product.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          item.product.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
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
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      if (item.quantity > 1)
                        Text(
                          '${item.quantity}x ${item.product.formattedPrice}',
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

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total pago',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                _formattedTotal,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Card de entrega ──────────────────────────────

  Widget _buildDeliveryCard() {
    final estimatedDate = DateTime.now().add(const Duration(days: 7));
    final day = estimatedDate.day.toString().padLeft(2, '0');
    final month = estimatedDate.month.toString().padLeft(2, '0');
    final year = estimatedDate.year;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Informações de Entrega',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DeliveryRow(
            icon: Icons.calendar_today_outlined,
            label: 'Previsão de entrega',
            value: '$day/$month/$year',
          ),
          const SizedBox(height: 6),
          _DeliveryRow(
            icon: Icons.inventory_2_outlined,
            label: 'Status do pedido',
            value: 'Em preparação',
          ),
          const SizedBox(height: 6),
          _DeliveryRow(
            icon: Icons.email_outlined,
            label: 'Confirmação',
            value: 'Enviada por e-mail',
          ),
        ],
      ),
    );
  }

  // ── Ações ────────────────────────────────────────

  void _copyOrderId() {
    Clipboard.setData(ClipboardData(text: widget.orderId));
    setState(() => _codeCopied = true);

    // 🏷️ Tag: código copiado
    AnalyticsService().trackEvent(
      eventName: 'order_id_copied',
      screen: 'purchase_success',
      parameters: {'order_id': widget.orderId},
    );

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted) setState(() => _codeCopied = false);
      },
    );
  }

  void _onBackToStore() {
    // 🏷️ Tag: usuário voltou para a loja após compra
    AnalyticsService().trackEvent(
      eventName: 'back_to_store',
      screen: 'purchase_success',
      parameters: {'order_id': widget.orderId},
    );

    // Volta para a HomeScreen (raiz da pilha)
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _showAnalyticsReport(BuildContext context) {
    final analytics = AnalyticsService();
    final summary = analytics.eventSummary;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Cabeçalho
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.analytics, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 8),
                  const Text(
                    'Relatório Firebase Analytics',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: const Text('Firebase ✓'),
                    backgroundColor: Colors.green[50],
                    labelStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const Divider(),

            // Resumo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SummaryCard(
                    title: 'Total de eventos disparados',
                    value: '${analytics.eventLog.length}',
                    icon: Icons.bar_chart,
                    color: const Color(0xFF1565C0),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: summary.entries.map((e) {
                      return _EventChip(name: e.key, count: e.value);
                    }).toList(),
                  ),
                ],
              ),
            ),

            const Divider(height: 20),

            // Lista de eventos
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: analytics.eventLog.length,
                itemBuilder: (_, index) {
                  final reversed =
                      analytics.eventLog.length - 1 - index;
                  final event = analytics.eventLog[reversed];
                  return _EventLogTile(
                    event: event,
                    index: reversed + 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// WIDGETS AUXILIARES
// ─────────────────────────────────────────────────────────────────

class _DeliveryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DeliveryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue[400]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: Colors.blue[700]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(title, style: TextStyle(color: color, fontSize: 13)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventChip extends StatelessWidget {
  final String name;
  final int count;

  const _EventChip({required this.name, required this.count});

  Color get _color {
    switch (name) {
      case 'screen_view':
        return Colors.green;
      case 'view_item':
        return Colors.blue;
      case 'add_to_cart':
        return Colors.orange;
      case 'remove_from_cart':
        return Colors.red;
      case 'view_cart':
        return Colors.purple;
      case 'begin_checkout':
        return Colors.indigo;
      case 'purchase':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$name ($count)',
            style: TextStyle(
              fontSize: 11,
              color: _color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventLogTile extends StatelessWidget {
  final Map<String, dynamic> event;
  final int index;

  const _EventLogTile({required this.event, required this.index});

  Color get _color {
    switch (event['event']) {
      case 'screen_view':
        return Colors.green;
      case 'view_item':
        return Colors.blue;
      case 'add_to_cart':
        return Colors.orange;
      case 'remove_from_cart':
        return Colors.red;
      case 'view_cart':
        return Colors.purple;
      case 'begin_checkout':
        return Colors.indigo;
      case 'purchase':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = event['parameters'] as Map<String, dynamic>? ?? {};
    final time = event['timestamp'].toString();
    final timeStr = time.length >= 19 ? time.substring(11, 19) : time;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: _color,
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event['event'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _color,
                      ),
                    ),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'screen: ${event['screen']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                if (params.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    params.entries
                        .map((e) => '${e.key}: ${e.value}')
                        .join(' | '),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
