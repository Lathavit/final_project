// POJO (Plain Old Java Object)
class Faculty {
  final String? name;
  final String? campus;
  final String? guildline;

  Faculty({
    required this.name,
    required this.campus,
    required this.guildline,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      name: json['name'],
      campus: json['campus'],
      guildline: json['guildline'],
    );
  }
}
