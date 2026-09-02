class Habit {
  final int? id;
  final String name;
  final String description;
  final String icon; // emoji o nombre de icono
  final DateTime createdAt;

  Habit({
    this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}