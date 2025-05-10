import 'package:flutter/material.dart';
import '../models/course_content_model.dart';
import '../services/content_service.dart';
import '../widgets/activity_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _contentService = ContentService();
  bool _isLoading = false;
  List<Activity> _activities = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCourseContent();
  }

  Future<void> _fetchCourseContent() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final courseContent = await _contentService.getCourseContent();

      setState(() {
        _activities = courseContent.activities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load activities. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'EduPlay Activities',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple.shade800,
                      Colors.purple.shade500,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchCourseContent,
                tooltip: 'Refresh Activities',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: _fetchCourseContent,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _activities.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text(
                                'No activities available',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: _activities.isEmpty || _isLoading || _errorMessage.isNotEmpty
                ? const SliverToBoxAdapter(child: SizedBox.shrink())
                : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final activity = _activities[index];
                        return ActivityCard(activity: activity);
                      },
                      childCount: _activities.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
