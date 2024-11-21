import 'package:flutter/material.dart';

class DemoSilverappbar extends StatefulWidget {
  const DemoSilverappbar({super.key});

  @override
  State<DemoSilverappbar> createState() => _DemoSilverappbarState();
}

class _DemoSilverappbarState extends State<DemoSilverappbar> {
  final ScrollController _scrollController = ScrollController();

  bool isAppBarExpanded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double expandedHeight = 200.0; // The expanded height of the SliverAppBar
      if (_scrollController.hasClients) {
        double offset = _scrollController.offset;
        bool isExpanded = offset < expandedHeight - kToolbarHeight;

        if (isExpanded != isAppBarExpanded) {
          setState(() {
            isAppBarExpanded = isExpanded;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: null,
              title: Text(
                'Floating Nested SliverAppBar',
                style: TextStyle(
                  color: isAppBarExpanded ? Colors.white : Colors.black,
                ),
              ),
              floating: true,
              expandedHeight: 200.0,
              forceElevated: innerBoxIsScrolled,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Colors.black
                          .withOpacity(0.3), // Overlay for readability
                      child: const Text(
                        'Expanded Content',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            height: 100,
            color: Colors.teal,
            child: Center(
              child: Text(isAppBarExpanded
                  ? 'SliverAppBar is Expanded'
                  : 'SliverAppBar is Collapsed'),
            ),
          ),
        ),
      ),
    );
  }
}
