import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import LoginScreen
import 'chat_screen.dart'; // Import ChatScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2FC), // Light purple background
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 187, 112, 0),
                  Color(0xFFF2F2FC)
                ], // Blue Travel Theme
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Space at the top

                // "MaizbaanAI" Title
                Text(
                  "MaizbaanAI",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 20), // Space below the title

                // AI Welcome Message
                Text(
                  "Plan Your Next Adventure!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Get personalized travel recommendations with AI-powered suggestions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),

                // Featured Travel AI Section
                _buildFeaturedTravelAI(),

                const SizedBox(height: 20),

                // Travel Category Cards (Full Height)
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75, // Adjusted for full height
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      List<Map<String, dynamic>> travelItems = [
                        {
                          "title": "Hotels",
                          "icon": Icons.hotel,
                          "subtitle": "Find best stays"
                        },
                        {
                          "title": "Flights",
                          "icon": Icons.flight_takeoff,
                          "subtitle": "Compare fares"
                        },
                        {
                          "title": "Destinations",
                          "icon": Icons.location_on,
                          "subtitle": "Discover places"
                        },
                        {
                          "title": "Car Rentals",
                          "icon": Icons.car_rental,
                          "subtitle": "Explore easily"
                        },
                      ];
                      return _buildTravelCard(
                        travelItems[index]["title"],
                        travelItems[index]["icon"],
                        travelItems[index]["subtitle"],
                      );
                    },
                  ),
                ),

                // Space before the button
                const SizedBox(height: 30),

                // Continue Exploring Button (Navigates to ChatScreen)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 190, 116, 6),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen()), // Navigate to ChatScreen
                      );
                    },
                    child: Text("Continue Exploring",
                        style: TextStyle(fontSize: 18)),
                  ),
                ),

                const SizedBox(height: 20), // Space below the button
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Featured Travel AI Section
  Widget _buildFeaturedTravelAI() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(Icons.star,
              color: const Color.fromARGB(255, 228, 158, 7), size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "AI Travel Guide: Get personalized travel plans & deals!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Travel Category Cards (Now Full Height)
  Widget _buildTravelCard(String title, IconData icon, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.blue),
          const SizedBox(height: 10),
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
