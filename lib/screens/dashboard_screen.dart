import 'package:flutter/material.dart';
import 'timer_screen.dart';
import 'daily_log_screen.dart';
import 'add_skill_screen.dart';
import 'myskill_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';
import 'achievement.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Bottom navigation handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AchievementsScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
    // index 0 = Home → stay on dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // Beige background
      appBar: AppBar(
        title: const Text("SkillBloom"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        automaticallyImplyLeading: false, // 🚀 removes back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome to SkillBloom",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Track your growth and bloom your skills",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // 4 Buttons in Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildMenuCard(Icons.book, "My Skills",
                      const Color.fromARGB(255, 172, 145, 109), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MySkillsScreen(),
                      ),
                    );
                  }),
                  _buildMenuCard(Icons.edit_note, "Daily Logs",
                      const Color.fromARGB(255, 102, 152, 194), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DailyLogsScreen(),
                      ),
                    );
                  }),
                  _buildMenuCard(Icons.bar_chart, "Progress",
                      const Color.fromARGB(255, 191, 127, 32), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProgressScreen(),
                      ),
                    );
                  }),
                  _buildMenuCard(Icons.timer, "Timer",
                      const Color.fromARGB(255, 138, 111, 143), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimerScreen(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button → Add Skill
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddSkillScreen()),
            );
          },
          backgroundColor: const Color(0xFF8D6E63),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Achievements"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF8D6E63),
        ),
      ),
    );
  }

  // Reusable Menu Card Widget
  Widget _buildMenuCard(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
