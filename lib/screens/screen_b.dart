import 'package:flutter/material.dart';
import '../analytics/analytics_service.dart';
import '../widgets/tracked_button.dart';
import 'screen_a.dart' show _ProgressIndicator;
import 'screen_c.dart';

class ScreenB extends StatefulWidget {
  const ScreenB({super.key});

  @override
  State<ScreenB> createState() => _ScreenBState();
}

class _ScreenBState extends State<ScreenB> {
  String _selectedOption = '';

  // Opções disponíveis para seleção
  static const _options = [
    (id: 'option_alpha', label: 'Opção Alpha', icon: Icons.star),
    (id: 'option_beta', label: 'Opção Beta', icon: Icons.favorite),
    (id: 'option_gamma', label: 'Opção Gamma', icon: Icons.bolt),
  ];

  @override
  void initState() {
    super.initState();
    // 🏷️ Registra visualização da tela no Firebase
    AnalyticsService().trackScreenView(
      screenName: 'screen_b',
      screenClass: 'ScreenB',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF4),
      appBar: AppBar(
        title: const Text('Tela B'),
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Header ──────────────────────────────
              const Icon(
                Icons.looks_two,
                size: 80,
                color: Color(0xFF388E3C),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tela B',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tela intermediária com seleção de opções',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // ── Card de Seleção ──────────────────────
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
                        'Selecione uma opção',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Opções tagueadas
                      ..._options.map(
                        (opt) => _OptionTile(
                          label: opt.label,
                          value: opt.id,
                          icon: opt.icon,
                          isSelected: _selectedOption == opt.id,
                          onTap: () async {
                            setState(() => _selectedOption = opt.id);

                            // 🏷️ Registra seleção no Firebase
                            await AnalyticsService().trackOptionSelected(
                              screen: 'screen_b',
                              optionId: opt.id,
                              optionLabel: opt.label,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Status de seleção
                      AnimatedOpacity(
                        opacity: _selectedOption.isEmpty ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Selecionado: $_selectedOption',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botão para Tela C
                      TrackedButton(
                        label: 'Ir para Tela C →',
                        eventName: 'navigation_click',
                        screen: 'screen_b',
                        color: _selectedOption.isEmpty
                            ? Colors.grey
                            : const Color(0xFF388E3C),
                        icon: Icons.arrow_forward,
                        parameters: {
                          'button_id': 'btn_navigate_to_c',
                          'destination': 'screen_c',
                          'selected_option': _selectedOption,
                        },
                        onPressed: () {
                          if (_selectedOption.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '⚠️ Selecione uma opção primeiro!',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScreenC(
                                selectedOption: _selectedOption,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _ProgressIndicator(
                currentStep: 2,
                activeColor: const Color(0xFF388E3C),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Option Tile ───────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF388E3C).withOpacity(0.08)
              : Colors.grey[100],
          border: Border.all(
            color: isSelected
                ? const Color(0xFF388E3C)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF388E3C)
                  : Colors.grey[500],
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF388E3C)
                    : Colors.black87,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      key: ValueKey('checked'),
                      color: Color(0xFF388E3C),
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      key: ValueKey('unchecked'),
                      color: Colors.grey[400],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
