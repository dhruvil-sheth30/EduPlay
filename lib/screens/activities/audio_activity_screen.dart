import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/course_content_model.dart';

class AudioActivityScreen extends StatefulWidget {
  final Activity activity;
  
  const AudioActivityScreen({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  State<AudioActivityScreen> createState() => _AudioActivityScreenState();
}

class _AudioActivityScreenState extends State<AudioActivityScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _selectedAnswer;
  bool _isAnswerSubmitted = false;
  bool _isCorrect = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _currentQuestionIndex = 0;
  
  Map<String, dynamic> get _currentQuestion => 
      widget.activity.questions?[_currentQuestionIndex] as Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    if (_currentQuestion['audioUrl'] != null) {
      _loadAudio();
      
      _audioPlayer.onDurationChanged.listen((Duration d) {
        setState(() => _duration = d);
      });
      
      _audioPlayer.onPositionChanged.listen((Duration p) {
        setState(() => _position = p);
      });
      
      _audioPlayer.onPlayerComplete.listen((_) {
        setState(() => _isPlaying = false);
      });
    }
  }
  
  void _loadAudio() {
    if (_currentQuestion['audioUrl'] != null) {
      _audioPlayer.setSource(AssetSource(_currentQuestion['audioUrl'].replaceFirst('assets/', '')));
    }
  }
  void _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.resume();
      setState(() => _isPlaying = true);
    }
  }

  void _checkAnswer() {
    if (_selectedAnswer != null) {
      setState(() {
        _isAnswerSubmitted = true;
        _isCorrect = _selectedAnswer == _currentQuestion['answer'];
      });
      
      // Stop the audio when checking answer
      if (_isPlaying) {
        _audioPlayer.pause();
        setState(() => _isPlaying = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer')),
      );
    }
  }
  
  void _nextQuestion() {
    // Stop the current audio
    if (_isPlaying) {
      _audioPlayer.pause();
    }
    
    if (_currentQuestionIndex < (widget.activity.questions?.length ?? 0) - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswerSubmitted = false;
        _isPlaying = false;
        _duration = Duration.zero;
        _position = Duration.zero;
      });
      
      // Load the new audio
      _loadAudio();
    } else {
      Navigator.of(context).pop();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final questionCount = widget.activity.questions?.length ?? 0;
    final List<String> options = List<String>.from(_currentQuestion['options'] ?? []);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Activity'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: ((_currentQuestionIndex + 1) / questionCount),
              backgroundColor: Colors.grey.shade200,
              color: Colors.purple,
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
            
            const Text(
              'Listen and Choose',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _currentQuestion['question'] ?? 'Listen to the sound',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.hearing,
                    size: 60,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 16),
                  // Audio player controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _playPauseAudio,
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          size: 50,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  // Audio progress bar
                  Column(
                    children: [
                      Slider(
                        min: 0,
                        max: _duration.inSeconds.toDouble(),
                        value: _position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await _audioPlayer.seek(position);
                        },
                        activeColor: Colors.purple,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(_position)),
                            Text(_formatDuration(_duration)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select the correct answer:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: _selectedAnswer == option ? 5 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: _selectedAnswer == option ? Colors.purple : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          fontWeight: _selectedAnswer == option ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      tileColor: _selectedAnswer == option
                          ? Colors.purple.shade50
                          : null,
                      leading: Radio<String>(
                        value: option,
                        groupValue: _selectedAnswer,
                        onChanged: _isAnswerSubmitted
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedAnswer = value;
                                });
                              },
                        activeColor: Colors.purple,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isAnswerSubmitted)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isCorrect
                          ? 'Correct! You have a good ear!'
                          : 'That\'s not right. The correct answer is "${_currentQuestion['answer']}"',
                      style: TextStyle(
                        fontSize: 16,
                        color: _isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_currentQuestionIndex < (widget.activity.questions?.length ?? 0) - 1) ...[                      const SizedBox(height: 12),
                      Text(
                        'Next Question: ${widget.activity.questions?[_currentQuestionIndex + 1]['question'] ?? 'Listen to the next sound'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.yellow.shade100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: _isAnswerSubmitted
                  ? _nextQuestion
                  : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                _isAnswerSubmitted 
                    ? (_currentQuestionIndex < (widget.activity.questions?.length ?? 0) - 1
                        ? 'Next Question'
                        : 'Finish')
                    : 'Submit Answer',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
