import 'package:flutter/material.dart';

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
            children: const [
              _FooterLink('Política de Privacidade'),
              _FooterLink('Termos de Serviço'),
              _FooterLink('Acessibilidade'),
              _FooterLink('Contate o Suporte'),
            ],
          );

          if (isMobile) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                links,
                const SizedBox(height: 16),
                copyright,
              ],
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
  const _FooterLink(this.text);
  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      onHover: (hovering) => setState(() => _isHovering = hovering),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _isHovering ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
          decoration: _isHovering ? TextDecoration.underline : null,
          decorationColor: theme.colorScheme.primary,
        ),
        child: Text(widget.text),
      ),
    );
  }
}