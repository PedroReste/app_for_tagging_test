import 'package:flutter/material.dart';
import '../analytics/analytics_service.dart';
import '../widgets/tracked_button.dart';
import 'screen_b.dart';

class ScreenA extends StatefulWidget {
  const ScreenA({super.key});

  @override
  State<ScreenA> createState() => _ScreenAState();
}

class _ScreenAState extends State<ScreenA> {
  int _clickCount = 0;

  @override
  void initState() {
    super.initState();
    // 🏷️ Registra visualização da tela no Firebase
    AnalyticsService().trackScreenView(
      screenName: 'screen_a',
      screenClass: 'ScreenA',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Tela A'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Ver Log de Eventos',
            onPressed: () => _showEventLog(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Header ──────────────────────────────
              const Icon(
                Icons.looks_one,
                size: 80,
                color: Color(0xFF3F51B5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tela A',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F51B5),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tela inicial do fluxo de tagueamento',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // ── Card de Interações ───────────────────
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Interações disponíveis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Botão de clique simples
                      TrackedButton(
                        label: 'Clique aqui ($_clickCount)',
                        eventName: 'button_click',
                        screen: 'screen_a',
                        color: const Color(0xFF7986CB),
                        icon: Icons.ads_click,
                        parameters: {
                          'button_id': 'btn_click_a',
                          'click_count': _clickCount + 1,
                        },
                        onPressed: () {
                          setState(() => _clickCount++);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Botão de navegação para Tela B
                      TrackedButton(
                        label: 'Ir para Tela B →',
                        eventName: 'navigation_click',
                        screen: 'screen_a',
                        color: const Color(0xFF3F51B5),
                        icon: Icons.arrow_forward,
                        parameters: {
                          'button_id': 'btn_navigate_to_b',
                          'destination': 'screen_b',
                          'click_count_before_navigate': _clickCount,
                        },
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ScreenB(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Indicador de progresso ───────────────
              _ProgressIndicator(currentStep: 1),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventLog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EventLogSheet(
        events: AnalyticsService().eventLog,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// WIDGETS COMPARTILHADOS (usados nas 3 telas)
// ─────────────────────────────────────────────────────────────────

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;

  const _ProgressIndicator({
    required this.currentStep,
    this.totalSteps = 3,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final step = index + 1;
        final isActive = step == currentStep;
        final isCompleted = step < currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 32 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: (isActive || isCompleted) ? color : const Color(0xFFBBBBBB),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}

// ── Event Log Bottom Sheet ────────────────────────────────────────

class _EventLogSheet extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  const _EventLogSheet({required this.events});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      expand: false,
      builder: (_, controller) {
        return Column(
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

            // Título
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.analytics, color: Color(0xFF3F51B5)),
                  const SizedBox(width: 8),
                  Text(
                    'Log de Eventos (${events.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('Firebase ✓'),
                    backgroundColor: Colors.green[50],
                    labelStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Lista de eventos
            Expanded(
              child: events.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Nenhum evento registrado',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: controller,
                      itemCount: events.length,
                      itemBuilder: (_, index) {
                        // Mostra do mais recente para o mais antigo
                        final reversedIndex = events.length - 1 - index;
                        return _EventTile(
                          event: events[reversedIndex],
                          index: reversedIndex + 1,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _EventTile extends StatelessWidget {
  final Map<String, dynamic> event;
  final int index;

  const _EventTile({required this.event, required this.index});

  Color get _dotColor {
    switch (event['event']) {
      case 'screen_view':
        return Colors.green;
      case 'navigation_click':
        return Colors.blue;
      case 'button_click':
        return Colors.orange;
      case 'option_selected':
        return Colors.purple;
      case 'flow_completed':
        return Colors.teal;
      case 'flow_restart':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = event['parameters'] as Map<String, dynamic>? ?? {};
    final time = event['timestamp'].toString();
    final timeFormatted = time.length >= 19 ? time.substring(11, 19) : time;

    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: _dotColor,
        child: Text(
          '$index',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        event['event'] as String,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        'Screen: ${event['screen']}\n'
        'Params: $params',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Text(
        timeFormatted,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      isThreeLine: true,
    );
  }
}
