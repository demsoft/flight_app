import 'package:flutter/material.dart';

class FlightDetailsPage extends StatelessWidget {
  final Map<String, dynamic> flight;

  const FlightDetailsPage({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Flight Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Continue to Book",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAirlineInfo(flight),
          const SizedBox(height: 16),
          _buildInfoTileWithImage(
            "assets/images/plane2.png",
            "Aircraft Type",
            flight['aircraft'] ?? "Boeing 737",
          ),
          _buildSectionHeader("Flight Information"),
          _buildInfoTile(
            Icons.event_seat,
            "Seat Class",
            flight['class'] ?? "Economy",
          ),
          _buildInfoTile(
            Icons.access_time,
            "Total Duration",
            flight['duration'] ?? "5h 30m",
          ),
          _buildInfoTile(
            Icons.location_on,
            "Layovers and Stops",
            flight['stops'] ?? "1 stop",
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              flight['map'] ??
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Oakland_Map.png/640px-Oakland_Map.png",
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Baggage Information"),
          _buildInfoTile(
            Icons.luggage,
            "Checked Baggage",
            flight['checkedBaggage'] ?? "1 checked bag",
          ),
          _buildInfoTile(
            Icons.backpack,
            "Carry-on Baggage",
            flight['carryOn'] ?? "1 carry-on",
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Policies"),
          _buildInfoTile(
            Icons.description,
            "Cancellation Policy",
            flight['cancellation'] ?? "",
          ),
          _buildInfoTile(
            Icons.description,
            "Refund Policy",
            flight['refund'] ?? "",
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Amenities"),
          _buildInfoTile(
            Icons.tv,
            "In-flight Entertainment",
            flight['entertainment'] ?? "",
          ),
          _buildInfoTile(Icons.wifi, "Wi-Fi", flight['wifi'] ?? ""),
          _buildInfoTile(Icons.restaurant, "Meals", flight['meals'] ?? ""),
        ],
      ),
    );
  }

  Widget _buildAirlineInfo(Map<String, dynamic> flight) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade100,
          backgroundImage:
              flight['logo'] != null && flight['logo'].toString().isNotEmpty
                  ? AssetImage(flight['logo']) as ImageProvider
                  : null,
          child:
              flight['logo'] == null || flight['logo'].toString().isEmpty
                  ? const Icon(Icons.flight, color: Colors.blue)
                  : null,
        ),

        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flight['airline'] ?? "Unknown Airline",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              "Flight Number: ${flight['flightNumber'] ?? 'N/A'}",
              style: const TextStyle(color: Color(0xFF4A739C)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title),
      subtitle:
          subtitle.isNotEmpty
              ? Text(subtitle, style: const TextStyle(color: Color(0xFF4A739C)))
              : null,
    );
  }

  Widget _buildInfoTileWithImage(String path, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(path),
      ),
      title: Text(title),
      subtitle:
          subtitle.isNotEmpty
              ? Text(subtitle, style: const TextStyle(color: Color(0xFF4A739C)))
              : null,
    );
  }
}
