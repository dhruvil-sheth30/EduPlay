import 'package:flutter/material.dart';
import '../../models/course_content_model.dart';

class FillActivityScreen extends StatefulWidget {
  final Activity activity;
  
  const FillActivityScreen({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  State<FillActivityScreen> createState() => _FillActivityScreenState();
}

class _FillActivityScreenState extends State<FillActivityScreen> {
  String? _selectedAnswer;
  bool _isAnswerSubmitted = false;
  bool _isCorrect = false;
  final TextEditingController _answerController = TextEditingController();
  int _currentQuestionIndex = 0;
  Map<String, dynamic>? get _currentQuestion => 
      widget.activity.questions != null && _currentQuestionIndex < widget.activity.questions!.length 
          ? widget.activity.questions![_currentQuestionIndex] 
          : null;

  @override
  void initState() {
    super.initState();
  }

  void _checkAnswer() {
    if (_selectedAnswer != null) {
      setState(() {
        _isAnswerSubmitted = true;
        _isCorrect = _selectedAnswer == _currentQuestion?['answer'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer')),
      );
    }
  }
  
  void _nextQuestion() {
    if (_currentQuestionIndex < (widget.activity.questions?.length ?? 0) - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswerSubmitted = false;
        _selectedAnswer = null;
        _answerController.clear();
      });
    } else {
      // Last question, go back to the home screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Fill in the Blanks'),
        ),
        body: const Center(
          child: Text('No questions available'),
        ),
      );
    }
    
    final question = _currentQuestion!['question'];
    final options = _currentQuestion!['options'] as List;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fill in the Blanks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fill in the Blanks',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Question ${_currentQuestionIndex + 1}/${widget.activity.questions?.length ?? 0}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type your answer',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value;
                        _isAnswerSubmitted = false;
                      });
                    },
                    enabled: !_isAnswerSubmitted,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: options.map((option) {
                return ElevatedButton(
                  onPressed: _isAnswerSubmitted
                      ? null
                      : () {
                          setState(() {
                            _selectedAnswer = option;
                            _answerController.text = option;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAnswer == option
                        ? Colors.blue
                        : Colors.grey.shade300,
                    foregroundColor: _selectedAnswer == option
                        ? Colors.white
                        : Colors.black,
                  ),
                  child: Text(option),
                );
              }).toList(),
            ),
            const Spacer(),
            if (_isAnswerSubmitted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isCorrect
                      ? 'Correct! Well done!'
                      : 'Incorrect. The correct answer is "${_currentQuestion!['answer']}"',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isAnswerSubmitted
                  ? _nextQuestion
                  : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                _isAnswerSubmitted 
                    ? (_currentQuestionIndex < (widget.activity.questions?.length ?? 0) - 1 
                        ? 'Next Question' 
                        : 'Finish')
                    : 'Check Answer',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
