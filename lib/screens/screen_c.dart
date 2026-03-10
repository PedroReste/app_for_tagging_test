import 'package:flutter/material.dart';
import '../analytics/analytics_service.dart';
import '../widgets/tracked_button.dart';
import 'screen_a.dart' show _ProgressIndicator, _EventLogSheet;

class ScreenC extends StatefulWidget {
  final String selectedOption;

  const ScreenC({super.key, required this.selectedOption});

  @override
  State<ScreenC> createState() => _ScreenCState();
}

class _ScreenCState extends State<ScreenC> {
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    // 🏷️ Registra visualização da tela no Firebase
    AnalyticsService().trackScreenView(
      screenName: 'screen_c',
      screenClass: 'ScreenC',
    );
  }

  @override
  Widget build(BuildContext context) {
    final analytics = AnalyticsService();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text('Tela C'),
        backgroundColor: const Color(0xFFE65100),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: 'Ver Log',
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
              // ── Header animado ───────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: _completed
                    ? const Icon(
                        Icons.check_circle,
                        key: ValueKey('check'),
                        size: 80,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.looks_3,
                        key: ValueKey('three'),
                        size: 80,
                        color: Color(0xFFE65100),
                      ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tela C',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tela final do fluxo',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 32),

              // ── Card Principal ───────────────────────
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
                      // Resumo da jornada
                      _InfoBanner(
                        icon: Icons.info_outline,
                        color: Colors.orange,
                        text:
                            'Opção selecionada: ${widget.selectedOption}',
                      ),

                      const SizedBox(height: 16),

                      // Resumo de eventos
                      _InfoBanner(
                        icon: Icons.analytics_outlined,
                        color: Colors.blue,
                        text:
                            '${analytics.eventLog.length} eventos registrados no Firebase',
                      ),

                      const SizedBox(height: 24),

                      // Botão de conclusão
                      TrackedButton(
                        label: _completed ? '✓ Concluído!' : 'Concluir Fluxo',
                        eventName: 'flow_completed',
                        screen: 'screen_c',
                        color: _completed
                            ? Colors.green
                            : const Color(0xFFE65100),
                        icon: _completed ? Icons.check : Icons.flag,
                        parameters: {
                          'button_id': 'btn_complete',
                          'selected_option': widget.selectedOption,
                          'already_completed': _completed,
                        },
                        onPressed: () {
                          if (!_completed) {
                            setState(() => _completed = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '🎉 Fluxo concluído com sucesso!',
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      // Botão de reiniciar
                      TrackedButton(
                        label: 'Reiniciar Fluxo',
                        eventName: 'flow_restart',
                        screen: 'screen_c',
                        color: Colors.grey[700],
                        icon: Icons.refresh,
                        parameters: {
                          'button_id': 'btn_restart',
                          'total_events': analytics.eventLog.length,
                          'selected_option': widget.selectedOption,
                        },
                        onPressed: () {
                          analytics.clearLog();
                          Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Botão de relatório
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.bar_chart),
                        label: Text(
                          'Ver relatório completo '
                          '(${analytics.eventLog.length} eventos)',
                        ),
                        onPressed: () => _showReport(context),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _ProgressIndicator(
                currentStep: 3,
                activeColor: const Color(0xFFE65100),
              ),
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

  void _showReport(BuildContext context) {
    final analytics = AnalyticsService();
    final summary = analytics.eventSummary;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.analytics, color: Color(0xFFE65100)),
            SizedBox(width: 8),
            Text('Relatório Final'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            _ReportRow(
              label: 'Total de eventos',
              value: '${analytics.eventLog.length}',
              highlight: true,
            ),
            const Divider(),
            ...summary.entries.map(
              (e) => _ReportRow(label: e.key, value: '${e.value}'),
            ),
            const Divider(),
            _ReportRow(
              label: 'Opção escolhida',
              value: widget.selectedOption,
            ),
            _ReportRow(
              label: 'Fluxo concluído',
              value: _completed ? 'Sim ✓' : 'Não',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _InfoBanner({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: color.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _ReportRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: highlight ? 15 : 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: highlight ? 15 : 13,
            ),
          ),
        ],
      ),
    );
  }
}
