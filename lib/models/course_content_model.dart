class CourseContent {
  final bool success;
  final String message;
  final List<Activity> activities;

  CourseContent({
    required this.success,
    required this.message,
    required this.activities,
  });

  factory CourseContent.fromJson(Map<String, dynamic> json) {
    return CourseContent(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      activities: (json['data'] as List?)
          ?.map((activity) => Activity.fromJson(activity))
          .toList() ?? [],
    );
  }
}

class Activity {
  final String id;
  final String type;
  final String question;
  final List<String>? options;
  final String? correctAnswer;
  final String? audioUrl;
  final String? imageUrl;
  final List<Map<String, dynamic>>? questions;
  
  Activity({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    this.correctAnswer,
    this.audioUrl,
    this.imageUrl,
    this.questions,
  });
  
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      question: json['question'] ?? '',
      options: (json['options'] as List?)?.map((e) => e.toString()).toList(),
      correctAnswer: json['correctAnswer'],
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      questions: (json['questions'] as List?)?.map((q) => q as Map<String, dynamic>).toList(),
    );
  }
}
