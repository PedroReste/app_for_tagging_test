import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';

class AnalyticsService {
  // Singleton
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  late final FirebaseAnalytics _analytics;
  late final FirebaseAnalyticsObserver _observer;

  // Log local para debug
  final List<Map<String, dynamic>> _eventLog = [];

  /// Inicializa o serviço — chamar uma vez no main()
  Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);
    await _analytics.setAnalyticsCollectionEnabled(true);

    if (kDebugMode) {
      debugPrint('📊 [AnalyticsService] Firebase Analytics inicializado.');
    }
  }

  FirebaseAnalyticsObserver get routeObserver => _observer;

  // ─────────────────────────────────────────────
  // SCREEN VIEW
  // ─────────────────────────────────────────────

  Future<void> trackScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
    _log('screen_view', screenName, {'screen_name': screenName});
  }

  // ─────────────────────────────────────────────
  // E-COMMERCE EVENTS (padrão Firebase/GA4)
  // ─────────────────────────────────────────────

  /// view_item — Usuário visualizou um produto
  Future<void> trackViewItem({
    required Product product,
    required String screen,
  }) async {
    await _analytics.logViewItem(
      currency: 'BRL',
      value: product.price,
      items: [_toAnalyticsItem(product)],
    );
    _log('view_item', screen, {
      'item_id': product.id,
      'item_name': product.name,
      'price': product.price,
    });
  }

  /// add_to_cart — Produto adicionado ao carrinho
  Future<void> trackAddToCart({
    required Product product,
    required String screen,
  }) async {
    await _analytics.logAddToCart(
      currency: 'BRL',
      value: product.price,
      items: [_toAnalyticsItem(product)],
    );
    _log('add_to_cart', screen, {
      'item_id': product.id,
      'item_name': product.name,
      'price': product.price,
    });
  }

  /// remove_from_cart — Produto removido do carrinho
  Future<void> trackRemoveFromCart({
    required Product product,
    required String screen,
  }) async {
    await _analytics.logRemoveFromCart(
      currency: 'BRL',
      value: product.price,
      items: [_toAnalyticsItem(product)],
    );
    _log('remove_from_cart', screen, {
      'item_id': product.id,
      'item_name': product.name,
      'price': product.price,
    });
  }

  /// view_cart — Usuário abriu o carrinho
  Future<void> trackViewCart({
    required CartModel cart,
    required String screen,
  }) async {
    await _analytics.logEvent(
      name: 'view_cart',
      parameters: {
        'currency': 'BRL',
        'value': cart.totalPrice,
        'item_count': cart.itemCount,
      },
    );
    _log('view_cart', screen, {
      'total': cart.totalPrice,
      'item_count': cart.itemCount,
    });
  }

  /// begin_checkout — Usuário iniciou o checkout
  Future<void> trackBeginCheckout({
    required CartModel cart,
    required String screen,
  }) async {
    await _analytics.logBeginCheckout(
      currency: 'BRL',
      value: cart.totalPrice,
      items: cart.items.map((i) => _toAnalyticsItem(i.product)).toList(),
    );
    _log('begin_checkout', screen, {
      'total': cart.totalPrice,
      'item_count': cart.itemCount,
    });
  }

  /// purchase — Compra finalizada
  Future<void> trackPurchase({
    required CartModel cart,
    required String orderId,
    required String screen,
  }) async {
    await _analytics.logPurchase(
      currency: 'BRL',
      value: cart.totalPrice,
      transactionId: orderId,
      items: cart.items.map((i) => _toAnalyticsItem(i.product)).toList(),
    );
    _log('purchase', screen, {
      'order_id': orderId,
      'total': cart.totalPrice,
      'item_count': cart.itemCount,
    });
  }

  /// select_item — Usuário clicou em "detalhes" de um produto
  Future<void> trackSelectItem({
    required Product product,
    required String screen,
  }) async {
    await _analytics.logSelectItem(
      itemListId: 'home_product_list',
      itemListName: 'Home',
      items: [_toAnalyticsItem(product)],
    );
    _log('select_item', screen, {
      'item_id': product.id,
      'item_name': product.name,
    });
  }

  /// Evento customizado genérico
  Future<void> trackEvent({
    required String eventName,
    required String screen,
    Map<String, Object>? parameters,
  }) async {
    final params = <String, Object>{
      'screen': screen,
      ...?parameters,
    };
    await _analytics.logEvent(name: eventName, parameters: params);
    _log(eventName, screen, params);
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  AnalyticsEventItem _toAnalyticsItem(Product product) {
    return AnalyticsEventItem(
      itemId: product.id,
      itemName: product.name,
      itemCategory: product.category,
      currency: 'BRL',
      price: product.price,
      quantity: 1,
    );
  }

  void _log(
    String eventName,
    String screen,
    Map<String, dynamic> params,
  ) {
    final entry = {
      'event': eventName,
      'screen': screen,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': params,
    };
    _eventLog.add(entry);

    if (kDebugMode) {
      debugPrint(
        '📊 [ANALYTICS] $eventName | Screen: $screen | Params: $params',
      );
    }
  }

  List<Map<String, dynamic>> get eventLog => List.unmodifiable(_eventLog);
  void clearLog() => _eventLog.clear();

  Map<String, int> get eventSummary {
    final summary = <String, int>{};
    for (final e in _eventLog) {
      final name = e['event'] as String;
      summary[name] = (summary[name] ?? 0) + 1;
    }
    return summary;
  }
}
