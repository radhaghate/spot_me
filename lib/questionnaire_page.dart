import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnairePage> {
  String? selectedGym;
  String? genderPreference;
  String? gradePreference;
  String? experienceLevel;
  String? workoutDependency;
  String? workoutStyle;

  final List<String> gymOptions = [
    "Sonny Werblin Recreation Center",
    "College Ave Gym",
    "Livingston Recreation Center",
    "Rutgers Fitness Center At Easton Ave",
    "Cook Douglass Recreation Center"
  ];

  final List<String> genderOptions = ["Male", "Female", "No Preference"];
  final List<String> gradeOptions = ["Freshman", "Sophomore", "Junior", "Senior"];
  final List<String> experienceOptions = ["0-3 months", "3-6 months", "6-12 months", "1 year +"];
  final List<String> workoutDependencyOptions = ["Individual workouts", "Spotter"];
  final List<String> workoutStyleOptions = ["Pilates", "Strength", "HIIT/Cardio", "Yoga", "Swimming"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Questionnaire",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _buildDropdown("Choose your preferred gym", selectedGym, gymOptions, (value) {
                setState(() {
                  selectedGym = value;
                });
              }),
              _buildDropdown("Gender Preference", genderPreference, genderOptions, (value) {
                setState(() {
                  genderPreference = value;
                });
              }),
              _buildDropdown("Grade Preference", gradePreference, gradeOptions, (value) {
                setState(() {
                  gradePreference = value;
                });
              }),
              _buildDropdown("Experience Level", experienceLevel, experienceOptions, (value) {
                setState(() {
                  experienceLevel = value;
                });
              }),
              _buildDropdown("Workout Dependency", workoutDependency, workoutDependencyOptions, (value) {
                setState(() {
                  workoutDependency = value;
                });
              }),
              _buildDropdown("Workout Style", workoutStyle, workoutStyleOptions, (value) {
                setState(() {
                  workoutStyle = value;
                });
              }),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedValue,
            dropdownColor: Colors.blueGrey[800],
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blueGrey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
