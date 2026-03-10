import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  // Singleton
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // Instância do Firebase Analytics
  late final FirebaseAnalytics _analytics;
  late final FirebaseAnalyticsObserver _observer;

  // Log local de eventos (útil para debug e testes)
  final List<Map<String, dynamic>> _eventLog = [];

  /// Inicializa o serviço — chamar uma vez no main()
  Future<void> initialize() async {
    _analytics = FirebaseAnalytics.instance;
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);

    // Habilita coleta de dados
    await _analytics.setAnalyticsCollectionEnabled(true);

    // Ativa o modo debug em desenvolvimento
    if (kDebugMode) {
      debugPrint('📊 [AnalyticsService] Inicializado com sucesso.');
      debugPrint('📊 [AnalyticsService] Debug Mode ativo.');
    }
  }

  /// Observador de rotas para o MaterialApp
  FirebaseAnalyticsObserver get routeObserver => _observer;

  /// Retorna a instância do FirebaseAnalytics (uso avançado)
  FirebaseAnalytics get instance => _analytics;

  // ─────────────────────────────────────────────
  // MÉTODOS PÚBLICOS DE TAGUEAMENTO
  // ─────────────────────────────────────────────

  /// Registra visualização de tela
  Future<void> trackScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );

    _addToLog(
      eventName: 'screen_view',
      screen: screenName,
      parameters: {
        'screen_name': screenName,
        'screen_class': screenClass ?? screenName,
      },
    );
  }

  /// Registra um evento customizado
  Future<void> trackEvent({
    required String eventName,
    required String screen,
    Map<String, Object>? parameters,
  }) async {
    // Parâmetros enriquecidos com dados padrão
    final enrichedParams = <String, Object>{
      'screen': screen,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?parameters,
    };

    await _analytics.logEvent(
      name: eventName,
      parameters: enrichedParams,
    );

    _addToLog(
      eventName: eventName,
      screen: screen,
      parameters: enrichedParams,
    );
  }

  /// Registra clique em botão
  Future<void> trackButtonClick({
    required String buttonId,
    required String screen,
    Map<String, Object>? extraParams,
  }) async {
    await trackEvent(
      eventName: 'button_click',
      screen: screen,
      parameters: {
        'button_id': buttonId,
        ...?extraParams,
      },
    );
  }

  /// Registra navegação entre telas
  Future<void> trackNavigation({
    required String from,
    required String to,
    String? buttonId,
    Map<String, Object>? extraParams,
  }) async {
    await trackEvent(
      eventName: 'navigation_click',
      screen: from,
      parameters: {
        'origin': from,
        'destination': to,
        if (buttonId != null) 'button_id': buttonId,
        ...?extraParams,
      },
    );
  }

  /// Registra seleção de opção
  Future<void> trackOptionSelected({
    required String screen,
    required String optionId,
    required String optionLabel,
    Map<String, Object>? extraParams,
  }) async {
    await trackEvent(
      eventName: 'option_selected',
      screen: screen,
      parameters: {
        'option_id': optionId,
        'option_label': optionLabel,
        ...?extraParams,
      },
    );
  }

  /// Registra conclusão de fluxo
  Future<void> trackFlowCompleted({
    required String screen,
    required Map<String, Object> flowData,
  }) async {
    await trackEvent(
      eventName: 'flow_completed',
      screen: screen,
      parameters: flowData,
    );
  }

  /// Registra reinício de fluxo
  Future<void> trackFlowRestart({
    required String screen,
    int? totalEvents,
  }) async {
    await trackEvent(
      eventName: 'flow_restart',
      screen: screen,
      parameters: {
        'total_events_before_restart': totalEvents ?? _eventLog.length,
      },
    );
  }

  /// Define propriedades do usuário (útil para segmentação)
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);

    if (kDebugMode) {
      debugPrint('📊 [AnalyticsService] UserProperty: $name = $value');
    }
  }

  // ─────────────────────────────────────────────
  // LOG LOCAL
  // ─────────────────────────────────────────────

  void _addToLog({
    required String eventName,
    required String screen,
    required Map<String, Object> parameters,
  }) {
    final event = {
      'event': eventName,
      'screen': screen,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': parameters,
    };

    _eventLog.add(event);

    if (kDebugMode) {
      debugPrint(
        '📊 [ANALYTICS] ${event['event']} | '
        'Screen: ${event['screen']} | '
        'Params: ${event['parameters']}',
      );
    }
  }

  /// Retorna cópia imutável do log local
  List<Map<String, dynamic>> get eventLog => List.unmodifiable(_eventLog);

  /// Limpa o log local (não afeta o Firebase)
  void clearLog() => _eventLog.clear();

  /// Retorna contagem por tipo de evento
  Map<String, int> get eventSummary {
    final summary = <String, int>{};
    for (final event in _eventLog) {
      final name = event['event'] as String;
      summary[name] = (summary[name] ?? 0) + 1;
    }
    return summary;
  }
}
