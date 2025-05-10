import 'package:flutter/material.dart';
import '../../models/course_content_model.dart';

class AnimalGuessingScreen extends StatefulWidget {
  final Activity activity;
  
  const AnimalGuessingScreen({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  State<AnimalGuessingScreen> createState() => _AnimalGuessingScreenState();
}

class _AnimalGuessingScreenState extends State<AnimalGuessingScreen> with SingleTickerProviderStateMixin {
  String? _selectedOption;
  bool _isAnswerSubmitted = false;
  bool _isCorrect = false;
  int _currentQuestionIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  Map<String, dynamic> get _currentQuestion => 
      widget.activity.questions?[_currentQuestionIndex] as Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_selectedOption != null) {
      setState(() {
        _isAnswerSubmitted = true;
        _isCorrect = _selectedOption == _currentQuestion['answer'];
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
        _selectedOption = null;
        _isAnswerSubmitted = false;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionCount = widget.activity.questions?.length ?? 0;
    final List<String> options = List<String>.from(_currentQuestion['options'] ?? []);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Guessing Game'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: ((_currentQuestionIndex + 1) / questionCount),
                backgroundColor: Colors.grey.shade200,
                color: Colors.orange,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of $questionCount',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            
              Text(
                _currentQuestion['question'] ?? 'Which animal is this?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // Animal image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    _currentQuestion['imageUrl'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              const Text(
                'Choose the correct animal:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Answer options
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = _selectedOption == option;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MouseRegion(
                        onEnter: (_) => _animationController.forward(),
                        onExit: (_) => _animationController.reverse(),
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: isSelected ? _scaleAnimation.value : 1.0,
                              child: child,
                            );
                          },
                          child: Card(
                            elevation: isSelected ? 8 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                color: isSelected ? Colors.orange : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: _isAnswerSubmitted ? null : () {
                                setState(() {
                                  _selectedOption = option;
                                });
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                                      color: isSelected ? Colors.orange : Colors.grey,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected ? Colors.orange : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Results section
              if (_isAnswerSubmitted)
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 20, top: 10),
                  decoration: BoxDecoration(
                    color: _isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (_isCorrect ? Colors.green : Colors.red).withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.cancel,
                        color: _isCorrect ? Colors.green : Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isCorrect
                            ? 'Great job! That\'s correct!'
                            : 'Oops! That\'s not right. The correct answer is ${_currentQuestion['answer']}',
                        style: TextStyle(
                          fontSize: 18,
                          color: _isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              
              // Action button
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isAnswerSubmitted ? _nextQuestion : _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  _isAnswerSubmitted 
                      ? (_currentQuestionIndex < (widget.activity.questions?.length ?? 0) - 1
                          ? 'Next Question'
                          : 'Finish')
                      : 'Check Answer',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
