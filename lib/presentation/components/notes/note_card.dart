import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../domain/models/note_model.dart';
import 'note_editor_dialog.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => NoteEditorDialog(
            note: note, // Passa a nota atual
            initialReadOnly:
                true, // Bloqueia tudo (some barra de ferramentas, botões e não deixa digitar)
          ),
        );
      },
      child: Container(
        height: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFE3E3DF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            _buildAvatar(),
            const SizedBox(height: 16),
            // Title & Summary
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.summary,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF4A4731),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFE3E3DF), height: 32),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note.date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A4731),
                  ),
                ),
                if (note.iconType == NoteIconType.pin)
                  const Icon(
                    LucideIcons.pin,
                    size: 18,
                    color: Color(0xFF7B785F),
                  ),
                if (note.iconType == NoteIconType.alert)
                  const Icon(
                    LucideIcons.alertCircle,
                    size: 18,
                    color: Color(0xFFBA1A1A),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (note.avatarType == NoteAvatarType.image) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(note.avatarContent),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: note.avatarBg ?? const Color(0xFFE5EDFF),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          note.avatarContent,
          style: TextStyle(
            color: note.avatarColor ?? const Color(0xFF436CA5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
