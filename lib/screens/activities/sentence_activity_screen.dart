import 'package:flutter/material.dart';
import '../../models/course_content_model.dart';

class SentenceActivityScreen extends StatefulWidget {
  final Activity activity;
  
  const SentenceActivityScreen({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  State<SentenceActivityScreen> createState() => _SentenceActivityScreenState();
}

class _SentenceActivityScreenState extends State<SentenceActivityScreen> {  final List<String> _arrangedWords = [];
  List<String> _availableWords = [];
  bool _isAnswerSubmitted = false;
  bool _isCorrect = false;
  int _currentQuestionIndex = 0;
  
  Map<String, dynamic> get _currentQuestion => 
      widget.activity.questions?[_currentQuestionIndex] as Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
    _loadCurrentQuestion();
  }
  
  void _loadCurrentQuestion() {
    if (_currentQuestion['options'] != null) {
      _availableWords = List<String>.from(_currentQuestion['options'] ?? []);
      _availableWords.shuffle(); // Randomize the order
    }
  }

  void _addWord(String word) {
    setState(() {
      _arrangedWords.add(word);
      _availableWords.remove(word);
    });
  }

  void _removeWord(int index) {
    setState(() {
      _availableWords.add(_arrangedWords[index]);
      _arrangedWords.removeAt(index);
    });
  }
  void _checkAnswer() {
    final userSentence = _arrangedWords.join(' ');
    final correctSentence = _currentQuestion['answer'];
    
    setState(() {
      _isAnswerSubmitted = true;
      _isCorrect = userSentence == correctSentence;
    });
  }

  void _resetSentence() {
    setState(() {
      _arrangedWords.clear();
      _isAnswerSubmitted = false;
      _loadCurrentQuestion();
    });
  }
  
  void _nextQuestion() {
    if (_currentQuestionIndex < (widget.activity.questions?.length ?? 0) - 1) {
      setState(() {
        _currentQuestionIndex++;
        _arrangedWords.clear();
        _isAnswerSubmitted = false;
        _loadCurrentQuestion();
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget _buildAnswerArea() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Form a sentence using these words:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _availableWords.map<Widget>((word) {
                  return ActionChip(
                    label: Text(word),
                    backgroundColor: _arrangedWords.contains(word) 
                        ? Colors.blue.shade100 
                        : Colors.white,
                    onPressed: () => _addWord(word),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            children: [
              Text(
                'Your Sentence:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _arrangedWords.isEmpty ? 'Select words to form a sentence' : _arrangedWords.join(' '),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final questionCount = widget.activity.questions?.length ?? 0;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentence Formation'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: ((_currentQuestionIndex + 1) / questionCount),
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1} of $questionCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Form a Sentence',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _currentQuestion['question'] ?? 'Arrange the words to form a complete sentence',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 2),
              ),
              constraints: const BoxConstraints(minHeight: 100),
              child: _arrangedWords.isEmpty
                  ? const Center(
                      child: Text(
                        'Drag words here to form a sentence',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        _arrangedWords.length,
                        (index) => ActionChip(
                          label: Text(_arrangedWords[index]),
                          onPressed: () => _removeWord(index),
                          backgroundColor: Colors.green.shade200,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Words:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableWords.map((word) {
                return ActionChip(
                  label: Text(word),
                  onPressed: () => _addWord(word),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.green.shade300),
                );
              }).toList(),
            ),
            const Spacer(),
            if (_isAnswerSubmitted)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isCorrect
                      ? 'Correct! Well done!'
                      : 'Incorrect. Try again!',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (!_isAnswerSubmitted)
              ElevatedButton(
                onPressed: _arrangedWords.isNotEmpty ? _checkAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Check Answer',
                  style: TextStyle(fontSize: 18),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetSentence,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        _currentQuestionIndex < questionCount - 1
                            ? 'Next Question'
                            : 'Finish',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
