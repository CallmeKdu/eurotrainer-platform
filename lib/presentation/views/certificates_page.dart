import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:intl/intl.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../core/injection.dart';

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({super.key});

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  bool _isGenerating = false;

  Future<void> _gerarPdfCertificado(String studentName, String courseName) async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdf = pw.Document();
      final dateStr = DateFormat('dd/MM/yyyy').format(DateTime.now());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: const PdfColor.fromInt(0xFFFAFAFA),
                border: pw.Border.all(color: const PdfColor.fromInt(0xFF1E3A8A), width: 12),
              ),
              child: pw.Container(
                padding: const pw.EdgeInsets.all(30),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: const PdfColor.fromInt(0xFFD4AF37), width: 3), // Borda fina dourada interna
                ),
                child: pw.Center(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      // Cabeçalho
                      pw.Text(
                        'CERTIFICADO DE CONCLUSÃO',
                        style: pw.TextStyle(
                          fontSize: 42,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFF1E3A8A),
                          letterSpacing: 2,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Container(
                        width: 200,
                        height: 2,
                        color: const PdfColor.fromInt(0xFFD4AF37),
                      ),
                      pw.SizedBox(height: 40),
                      
                      // Corpo
                      pw.Text(
                        'A EuroAcademy certifica orgulhosamente que',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontStyle: pw.FontStyle.italic,
                          color: const PdfColor.fromInt(0xFF4B5563),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        studentName.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 38,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        'concluiu com êxito todos os requisitos do treinamento:',
                        style: pw.TextStyle(
                          fontSize: 18,
                          color: const PdfColor.fromInt(0xFF4B5563),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        courseName,
                        style: pw.TextStyle(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFF1E3A8A),
                        ),
                      ),
                      pw.SizedBox(height: 60),
                      
                      // Rodapé
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          // Esquerda: Data
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Text(
                                dateStr,
                                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                              ),
                              pw.SizedBox(height: 5),
                              pw.Container(width: 150, height: 1, color: PdfColors.black),
                              pw.SizedBox(height: 5),
                              pw.Text('Data de Conclusão', style: const pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                          // Centro: Selo / Badge Dourado
                          pw.Container(
                            width: 70,
                            height: 70,
                            decoration: pw.BoxDecoration(
                              color: const PdfColor.fromInt(0xFFD4AF37),
                              shape: pw.BoxShape.circle,
                              border: pw.Border.all(color: const PdfColor.fromInt(0xFF1E3A8A), width: 2)
                            ),
                            child: pw.Center(
                              child: pw.Text(
                                'EA',
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 28,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Direita: Assinatura
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Text(
                                'EuroAcademy',
                                style: pw.TextStyle(fontSize: 24, fontStyle: pw.FontStyle.italic, color: const PdfColor.fromInt(0xFF1E3A8A)),
                              ),
                              pw.SizedBox(height: 5),
                              pw.Container(width: 200, height: 1, color: PdfColors.black),
                              pw.SizedBox(height: 5),
                              pw.Text('Diretoria de Treinamento', style: const pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

      final Uint8List bytes = await pdf.save();

      // Create a Blob from the bytes
      final blob = html.Blob([bytes], 'application/pdf');
      
      // Create a URL for the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Open the URL in a new tab
      html.window.open(url, "_blank");
      
      // Revoke the URL to free up memory
      html.Url.revokeObjectUrl(url);

    } catch (e) {
      debugPrint('Erro ao gerar certificado: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar certificado: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeViewModel = sl<HomeViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meus Certificados',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Visualize e baixe os certificados dos treinamentos que você concluiu.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Lista de Certificados
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildCertificateItem(
                  context,
                  title: 'EuroAcademy: Bem-vindo!',
                  date: 'Concluído em: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                  studentName: homeViewModel.nomeFormatado,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateItem(BuildContext context, {required String title, required String date, required String studentName}) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.workspace_premium,
            size: 32,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        ElevatedButton.icon(
          onPressed: _isGenerating ? null : () => _gerarPdfCertificado(studentName, title),
          icon: _isGenerating 
              ? const SizedBox(
                  width: 16, height: 16, 
                  child: CircularProgressIndicator(strokeWidth: 2)
                ) 
              : const Icon(Icons.download),
          label: Text(_isGenerating ? 'Gerando...' : 'Gerar certificado'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
