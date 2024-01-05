class Note{
  final int? id;
  final String title;
  final String description;
  final String timestamp;
  final int hidden;

  const Note({
    this.id, 
    required this.title, 
    required this.description, 
    required this.timestamp,
    required this.hidden
  });

  // To convert Map Object to Note Object.
  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'], 
    description: json['description'],
    timestamp: json['timestamp'],
    hidden : json['hidden']
  );

  // To convert Note object to Map object.
  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'description' : description,
    'timestamp' : timestamp,
    'hidden' : hidden
  };
}
