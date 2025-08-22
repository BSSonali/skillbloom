import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final TextEditingController skillController = TextEditingController();
  bool isLoading = false;

  void addSkill() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final skillName = skillController.text.trim();
    if (skillName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a skill name")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('skills')
          .add({
        'skill': skillName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Skill added successfully!")),
      );

      skillController.clear();
      Navigator.pop(context); // Close page after adding
    } catch (e) {
      print("Error adding skill: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add skill: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Skill"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Nice header icon
            const Icon(
              Icons.star_border_rounded,
              size: 80,
              color: Color(0xFF8D6E63),
            ),
            const SizedBox(height: 20),

            const Text(
              "What skill do you want to add?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Skill input
            TextField(
              controller: skillController,
              decoration: InputDecoration(
                hintText: "Enter skill name",
                prefixIcon: const Icon(Icons.edit, color: Color(0xFF8D6E63)),
                filled: true,
                fillColor: const Color.fromARGB(255, 242, 217, 187),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Add button
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: addSkill,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Skill",
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8D6E63),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
