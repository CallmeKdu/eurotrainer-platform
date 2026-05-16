class TrainingModel {
  final String id;
  final String title;
  final String description;
  final String deadline;
  final String scormUrl;
  final String tagText;
  final int tagColorHex;

  TrainingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.scormUrl,
    required this.tagText,
    required this.tagColorHex,
  });
}