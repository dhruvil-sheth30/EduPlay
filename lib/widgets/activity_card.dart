import 'package:flutter/material.dart';
import '../models/course_content_model.dart';
import '../screens/activities/fill_activity_screen.dart';
import '../screens/activities/audio_activity_screen.dart';
import '../screens/activities/sentence_activity_screen.dart';
import '../screens/activities/animal_guessing_screen.dart' as animal_screen;

class ActivityCard extends StatefulWidget {
  final Activity activity;
  
  const ActivityCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToActivity(BuildContext context) {
    Widget screen;
    
    switch (widget.activity.type) {
      case 'fill':
        screen = FillActivityScreen(activity: widget.activity);
        break;
      case 'audio':
        screen = AudioActivityScreen(activity: widget.activity);
        break;
      case 'sentence':
        screen = SentenceActivityScreen(activity: widget.activity);
        break;
      case 'animal_guessing':
        screen = animal_screen.AnimalGuessingScreen(activity: widget.activity);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown activity type: ${widget.activity.type}')),
        );
        return;
    }
    
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
  IconData _getActivityIcon() {
    switch (widget.activity.type) {
      case 'fill':
        return Icons.edit;
      case 'audio':
        return Icons.hearing;
      case 'sentence':
        return Icons.text_fields;
      case 'animal_guessing':
        return Icons.pets;
      default:
        return Icons.question_mark;
    }
  }

  Color _getActivityColor() {
    switch (widget.activity.type) {
      case 'fill':
        return Colors.blue;
      case 'audio':
        return Colors.purple;
      case 'sentence':
        return Colors.green;
      case 'animal_guessing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getActivityColor();
    final icon = _getActivityIcon();
    final activityType = widget.activity.type.replaceAll('_', ' ').toUpperCase();
    
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5,
          shadowColor: color.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: () => _navigateToActivity(context),
            splashColor: color.withOpacity(0.3),
            highlightColor: color.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withRed((color.red + 30) % 256).withGreen((color.green + 20) % 256),
                      ],
                    ),
                  ),
                  height: 120,
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: color.withOpacity(0.3)),
                          ),
                          child: Text(
                            activityType,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: color.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            widget.activity.question,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: color,
                            ),
                            Text(
                              'Start Activity',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
