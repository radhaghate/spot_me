// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// //import 'package:spot_me/questionnaire_page.dart';
// import 'package:spot_me/home_screen.dart';


// class LogInPage extends StatelessWidget {
//   const LogInPage({super.key});

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Log In",
//           style: GoogleFonts.montserrat(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.blueGrey[900],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.black, Colors.blueGrey.shade900],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Log In to Your Account",
//                 style: GoogleFonts.montserrat(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildTextField("NetID"),
//               const SizedBox(height: 20),
//               _buildTextField("Password", isPassword: true),
//               const SizedBox(height: 30),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const HomeScreen()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueGrey[700],
//                     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text("Log In", style: TextStyle(fontSize: 18, color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, {bool isPassword = false}) {
//     return TextField(
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white70),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         filled: true,
//         fillColor: Colors.blueGrey[800],
//       ),
//       style: const TextStyle(color: Colors.white),
//     );
//   }
// }



import 'dart:convert';  // For jsonEncode
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;  // Import the http package
import 'package:spot_me/home_screen.dart'; // Assuming you have a home screen

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _netIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to make the login request to Flask backend
  Future<void> _login() async {
    final String apiUrl = "http://127.0.0.1:50001/login"; // Your Flask server URL
    
    // Get the input values from controllers
    String netID = _netIDController.text.trim();
    String password = _passwordController.text.trim();

    if (netID.isEmpty || password.isEmpty) {
      // Show an error if the input fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both NetID and Password')),
      );
      return;
    }

    try {
      // Send the POST request to Flask backend
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': netID,
          'password': password,
        }),
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Login successful, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Handle login failure (e.g., invalid credentials)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid login credentials')),
        );
      }
    } catch (e) {
      // Handle error (e.g., network error)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Log In",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Log In to Your Account",
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("NetID", controller: _netIDController),
              const SizedBox(height: 20),
              _buildTextField("Password", isPassword: true, controller: _passwordController),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _login,  // Call the _login function when pressed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Log In", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the text fields
  Widget _buildTextField(String label, {bool isPassword = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blueGrey[800],
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}



