class Note {
  final String id;
  final String subtitle;
  final String time;
  final int image;
  final String title;
  final bool isDon;
  final DateTime dueDate;

  // Constructor with named parameters
  Note({
    required this.id,
    required this.subtitle,
    required this.time,
    required this.image,
    required this.title,
    required this.isDon,
    required this.dueDate,
  });
}
