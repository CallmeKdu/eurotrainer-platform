import 'dart:convert';
import 'package:flutter/material.dart';

ImageProvider? getImageProvider(String? url) {
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('data:image')) {
    final base64String = url.split(',').last;
    try {
      return MemoryImage(base64Decode(base64String));
    } catch (e) {
      debugPrint('Erro ao decodificar imagem base64: $e');
      return null;
    }
  }
  if (url.startsWith('https://firebasestorage')) {
    // Evita erro de CORS poluindo o console web para imagens antigas do Storage
    return null;
  }
  return NetworkImage(url);
}
