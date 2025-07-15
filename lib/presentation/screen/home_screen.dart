import 'package:flutter/material.dart';
import 'chatlistscreen.dart'; // Your existing chat list
import 'updates_screen.dart'; // Status screen
import 'groups_screen.dart'; // Groups screen

/// HomeScreen with *bottom navigation bar* **and** swipe (TabBarView) support
/// ────────────────────────────────────────────────────────────────────────────
/// • BottomNavigationBar at the bottom like WhatsApp (Chats / Updates / Groups)
/// • Swipe left/right to change pages – the selected bottom tab updates too
/// • AppBar shows your logo and app name on top, with a small “Chats/Updates/…”.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Widget> _pages = const [
    ChatListScreen(),
    UpdatesScreen(),
    GroupsScreen(),
  ];

  final List<String> _subTitles = const ['Chats', 'Updates', 'Groups'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    // 👉 when user swipes pages, update bottom nav selection
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return; // skip mid‑swipe
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _tabController.index;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 2,
                      ), // ⬅️ Adjust here
                      child: CircleAvatar(
                        radius: 23.5,
                        backgroundImage: AssetImage('assets/logo2.png'),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ), // Optional: Reduce spacing if needed
                    const Text(
                      'Vartalap',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              _subTitles[currentIndex],
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        // No top TabBar because we are using bottom nav
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(), // nice swipe
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          _tabController.animateTo(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Updates'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
        ],
      ),
    );
  }
}
