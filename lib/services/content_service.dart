import '../models/course_content_model.dart';

class ContentService {
  Future<CourseContent> getCourseContent() async {
    try {
      return CourseContent(
        success: true,
        message: "Content loaded successfully",
        activities: [
          // Fill in the blanks activity
          Activity(
            id: "1",
            type: "fill",
            question: "Fill in the blanks",
            options: ["blue", "green", "red", "yellow", "east", "north", "south", "west", "Mars", "Earth", "Jupiter", "Venus"],
            correctAnswer: "",
            questions: [
              {"question": "The color of the sky is _____.", "options": ["blue", "green", "red", "yellow"], "answer": "blue"},
              {"question": "The sun rises in the _____ and sets in the west.", "options": ["east", "north", "south", "west"], "answer": "east"},
              {"question": "The planet we live on is called _____.", "options": ["Mars", "Earth", "Jupiter", "Venus"], "answer": "Earth"},
              {"question": "Leaves are usually _____.", "options": ["blue", "green", "red", "yellow"], "answer": "green"}
            ]
          ),

          // Animal guessing activity
          Activity(
            id: "2",
            type: "animal_guessing",
            question: "Animal Guessing Game",
            options: [],
            correctAnswer: "",
            imageUrl: "",
            questions: [
              {
                "question": "Can you identify this animal?", 
                "imageUrl": "assets/images/cat.jpg", 
                "options": ["Dog", "Cat", "Bear", "Panda"], 
                "answer": "Cat"
              },
              {
                "question": "Which animal is shown in the picture?", 
                "imageUrl": "assets/images/bear.jpg", 
                "options": ["Cat", "Bear", "Panda", "Dog"], 
                "answer": "Bear"
              },
              {
                "question": "What animal is this?", 
                "imageUrl": "assets/images/panda.jpg", 
                "options": ["Bear", "Cat", "Panda", "Dog"], 
                "answer": "Panda"
              }
            ]
          ),

          // Audio activity
          Activity(
            id: "3",
            type: "audio",
            question: "Sound Identification",
            options: [],
            correctAnswer: "",
            audioUrl: "",
            questions: [
              {
                "question": "Listen to the sound and identify what animal makes it", 
                "audioUrl": "assets/audio/meow-1.mp3", 
                "options": ["Cat", "Dog", "Lion", "Bear"], 
                "answer": "Cat"
              },
              {
                "question": "Listen to the sound and identify what animal makes it", 
                "audioUrl": "assets/audio/dog-bark-sound-mp3.mp3", 
                "options": ["Cat", "Dog", "Lion", "Bear"], 
                "answer": "Dog"
              },
              {
                "question": "Listen and identify this animal sound", 
                "audioUrl": "assets/audio/lion-roar-sound-effect.mp3", 
                "options": ["Cat", "Dog", "Lion", "Bear"], 
                "answer": "Lion"
              }
            ]
          ),

          // Sentence formation activity
          Activity(
            id: "4",
            type: "sentence",
            question: "Sentence Formation",
            options: [],
            correctAnswer: "",
            questions: [
              {
                "question": "Arrange the words to form a complete sentence", 
                "options": ["I", "to", "school", "go", "every", "day"], 
                "answer": "I go to school every day"
              },
              {
                "question": "Form a sentence about eating breakfast", 
                "options": ["I", "eat", "breakfast", "in", "the", "morning"], 
                "answer": "I eat breakfast in the morning"
              },
              {
                "question": "Form a sentence about going to the park", 
                "options": ["I", "went", "to", "the", "park", "with", "my", "friends"], 
                "answer": "I went to the park with my friends"
              }
            ]
          )
        ],
      );
    } catch (e) {
      print('Error fetching course content: $e');
      throw Exception('Failed to load course content: $e');
    }
  }
}
