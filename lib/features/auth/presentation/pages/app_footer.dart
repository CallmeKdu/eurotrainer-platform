import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Usamos MediaQuery no lugar de LayoutBuilder para evitar o erro de 'intrinsic dimensions'
    // ao ser colocado dentro do SliverFillRemaining no Dashboard.
    final isMobile = MediaQuery.sizeOf(context).width < 1000;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.surfaceVariant),
        ),
      ),
      child: Builder(
        builder: (context) {
          final copyright = Text(
            '© 2026 EuroAcademy Compliance Systems',
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
              _FooterLink('Política de Privacidade', underline: true),
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
              Expanded(
                child: links,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final bool underline;

  const _FooterLink(this.text, {this.underline = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurfaceVariant,
          decoration: underline ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}