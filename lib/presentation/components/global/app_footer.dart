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
                        child: Text(
                          'Política de Privacidade da EuroAcademy\n\n'
                          '1. Coleta de Dados: Coletamos informações de perfil e desempenho nos treinamentos para personalizar sua experiência.\n'
                          '2. Uso das Informações: Seus dados são utilizados exclusivamente para fins de treinamento corporativo e avaliação de desempenho.\n'
                          '3. Compartilhamento: Não compartilhamos seus dados com terceiros sem consentimento explícito, salvo exigências legais da Eurofarma.\n'
                          '4. Segurança: Empregamos as melhores práticas de segurança da informação para proteger seus dados.\n\n'
                          'Dúvidas? Entre em contato com o suporte da plataforma.',
                        ),
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
                        child: Text(
                          'Termos de Serviço da EuroAcademy\n\n'
                          '1. Aceitação: Ao acessar a plataforma, você concorda com estes termos de uso corporativo.\n'
                          '2. Uso da Plataforma: O sistema é de uso exclusivo para colaboradores e parceiros da Eurofarma. É proibido o compartilhamento de credenciais.\n'
                          '3. Propriedade Intelectual: Todo o conteúdo (vídeos, SCORMs, PDFs) é de propriedade exclusiva da Eurofarma.\n'
                          '4. Responsabilidades: O usuário compromete-se a concluir os treinamentos designados nos prazos estabelecidos pela gestão.\n'
                          '5. Atualizações: Estes termos podem ser modificados a qualquer momento, sendo sua responsabilidade revisá-los periodicamente.',
                        ),
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
