class TaskModel {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  final String category; // 'penting' atau 'biasa'
  final bool isDone;
  final String createdAt;
  final String? completedAt;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
    this.isDone = false,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'due_date': dueDate,
        'category': category,
        'is_done': isDone ? 1 : 0,
        'created_at': createdAt,
        'completed_at': completedAt,
      };

  factory TaskModel.fromMap(Map<String, dynamic> m) => TaskModel(
        id: m['id'] as int?,
        title: m['title'] as String,
        description: m['description'] as String? ?? '',
        dueDate: m['due_date'] as String,
        category: m['category'] as String,
        isDone: (m['is_done'] as int) == 1,
        createdAt: m['created_at'] as String,
        completedAt: m['completed_at'] as String?,
      );
}
