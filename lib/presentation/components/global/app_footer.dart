// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../../views/accessibility_screen.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 1000;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
        ),
      ),
      child: Builder(
        builder: (context) {
          final copyright = Text(
            '© 2026 Euro Academy & Eurofarma - "Transformando talentos, impulsionando resultados" by EuroTrainers | FIAP',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          );

          final links = Wrap(
            spacing: 24,
            runSpacing: 12,
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.end,
            children: [
              _FooterLink(
                'Termos de Privacidade',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Termos de Privacidade'),
                      content: const SingleChildScrollView(
                        child: Text('Estes são os Termos de Privacidade da Euro Academy...'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fechar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _FooterLink(
                'Termos de Serviço',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Termos de Serviço'),
                      content: const SingleChildScrollView(
                        child: Text('Estes são os Termos de Serviço da Euro Academy...'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fechar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _FooterLink(
                'Acessibilidade',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccessibilityScreen()),
                  );
                },
              ),
              _FooterLink(
                'Contate o Suporte',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Suporte'),
                      content: const Text(
                        'Para entrar em contato com o suporte ou consultar o código fonte do projeto, visite nosso repositório no GitHub.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fechar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            html.window.open('https://github.com/CallmeKdu/eurotrainer-platform', '_blank');
                          },
                          child: const Text('Ir para o GitHub'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );

          if (isMobile) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [links, const SizedBox(height: 16), copyright],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              copyright,
              const SizedBox(width: 16),
              Expanded(child: links),
            ],
          );
        },
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _FooterLink(this.text, {required this.onTap});
  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) => setState(() => _isHovering = hovering),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _isHovering
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          decoration: _isHovering ? TextDecoration.underline : null,
          decorationColor: theme.colorScheme.primary,
        ),
        child: Text(widget.text),
      ),
    );
  }
}
