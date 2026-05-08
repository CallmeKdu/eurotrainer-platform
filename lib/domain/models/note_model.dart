import 'package:flutter/material.dart';

enum NoteAvatarType { text, image, icon }
enum NoteIconType { pin, alert }

class NoteModel {
  final String id;
  final String title;
  final String summary;
  final String date;
  final DateTime dateTime; // Para ordenação
  final NoteAvatarType avatarType;
  final String avatarContent;
  final Color? avatarBg;
  final Color? avatarColor;
  final NoteIconType? iconType;

  NoteModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.date,
    required this.dateTime,
    required this.avatarType,
    required this.avatarContent,
    this.avatarBg,
    this.avatarColor,
    this.iconType,
  });
}