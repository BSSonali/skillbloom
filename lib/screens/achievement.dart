import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  bool firstSkill = false;
  bool sevenDayStreak = false;
  bool tenHours = false;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    // 🔹 Check if at least 1 skill exists
    final skillsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('skills')
        .get();
    if (skillsSnapshot.docs.isNotEmpty) {
      firstSkill = true;
    }

    // 🔹 Check daily logs for streak + hours
    final logsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('daily_logs')
        .orderBy('date', descending: false)
        .get();

    int totalHours = 0;
    int streak = 1;

    if (logsSnapshot.docs.isNotEmpty) {
      DateTime? prevDate;

      for (var doc in logsSnapshot.docs) {
        final data = doc.data();
        DateTime logDate = (data['date'] as Timestamp).toDate();
        int hours = data['hours'] ?? 0;
        totalHours += hours;

        if (prevDate != null) {
          if (logDate.difference(prevDate).inDays == 1) {
            streak++;
          } else if (logDate.difference(prevDate).inDays > 1) {
            streak = 1; // reset streak
          }
        }
        prevDate = logDate;
      }
    }

    if (streak >= 7) {
      sevenDayStreak = true;
    }

    if (totalHours >= 10) {
      tenHours = true;
    }

    setState(() {});
  }

  Widget _buildAchievement(String title, String description, bool unlocked) {
    return Card(
      color: unlocked ? Colors.green[100] : Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(
          unlocked ? Icons.star : Icons.lock,
          color: unlocked ? Colors.orange : Colors.grey,
          size: 36,
        ),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: unlocked ? Colors.black : Colors.grey,
            )),
        subtitle: Text(description),
        trailing: unlocked
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor:const  Color.fromARGB(255, 240, 231, 219),
      appBar: AppBar(
        title: const Text("Achievements"),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAchievement(
              "First Skill Added",
              "Unlock this by adding your first skill.",
              firstSkill),
          _buildAchievement(
              "7-Day Streak",
              "Unlock this by learning for 7 days in a row.",
              sevenDayStreak),
          _buildAchievement(
              "10 Hours Logged",
              "Unlock this by logging 10 total hours of learning.",
              tenHours),
        ],
      ),
    );
  }
}
