import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, int> skillCount = {}; // skill name -> count
  int totalLogs = 0;

  @override
  void initState() {
    super.initState();
    fetchProgressData();
  }

  void fetchProgressData() async {
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('daily_logs')
        .get();

    Map<String, int> tempCount = {};
    for (var doc in snapshot.docs) {
      String skill = doc['skill'];
      tempCount[skill] = (tempCount[skill] ?? 0) + 1;
    }

    setState(() {
      skillCount = tempCount;
      totalLogs = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Progress")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Total Daily Logs: $totalLogs",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Skills Practiced:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            skillCount.isEmpty
                ? const Text("No progress yet")
                : Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (skillCount.values.isNotEmpty
                                ? skillCount.values.reduce((a, b) => a > b ? a : b)
                                : 1)
                            .toDouble() +
                            1,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= skillCount.keys.length) return const Text('');
                                return Text(skillCount.keys.elementAt(index));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: skillCount.entries
                            .map((e) => BarChartGroupData(x: skillCount.keys.toList().indexOf(e.key), barRods: [
                                  BarChartRodData(toY: e.value.toDouble(), color: const Color.fromARGB(255, 241, 137, 25))
                                ]))
                            .toList(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
