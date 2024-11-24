class Incident {
  final String title;
  final String description;
  final DateTime date;
  bool isResolved;

  Incident({
    required this.title,
    required this.description,
    required this.date,
    this.isResolved = false,
  });
}
