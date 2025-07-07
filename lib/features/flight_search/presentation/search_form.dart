import 'package:flightapp/features/flight_search/presentation/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFlightsPage extends ConsumerStatefulWidget {
  const SearchFlightsPage({super.key});

  @override
  ConsumerState<SearchFlightsPage> createState() => _SearchFlightsPageState();
}

class _SearchFlightsPageState extends ConsumerState<SearchFlightsPage> {
  String? selectedFrom;
  String? selectedTo;
  DateTime? departureDate;
  bool directFlightsOnly = false;
  bool includeNearbyAirports = false;
  String tripType = "One way";
  int passengers = 1;
  String travelClass = "Economy";

  final List<String> locations = ['Lagos', 'Abuja', 'London', 'New York'];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Search Flights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Navigator.canPop(context) ? const BackButton() : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown("From", selectedFrom, (val) {
                setState(() => selectedFrom = val);
              }),
              const SizedBox(height: 12),
              _buildDropdown("To", selectedTo, (val) {
                setState(() => selectedTo = val);
              }),
              const SizedBox(height: 20),
              _buildTripTypeSelector(),
              const SizedBox(height: 12),
              _buildDatePicker(context),
              const SizedBox(height: 24),
              const Text(
                "Optional Filters",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text("Direct Flights Only"),
                value: directFlightsOnly,
                onChanged: (val) => setState(() => directFlightsOnly = val),
              ),
              SwitchListTile(
                title: const Text("Include Nearby Airports"),
                value: includeNearbyAirports,
                onChanged: (val) => setState(() => includeNearbyAirports = val),
              ),
              ListTile(
                title: const Text("Travel Class"),
                trailing: Text(travelClass),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Passengers"),
                trailing: Text(passengers.toString()),
                onTap: () {},
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (departureDate != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => FlightResultsPage(
                                  from: selectedFrom!,
                                  to: selectedTo!,
                                  date: departureDate!,
                                ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a departure date"),
                          ),
                        );
                      }
                    }
                  },

                  child: const Text(
                    "Search Flights",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      value: value,
      hint: Text(hint),
      validator: (val) => val == null ? 'Please select $hint' : null,
      onChanged: onChanged,
      items:
          locations
              .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
              .toList(),
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  Widget _buildTripTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          ["One way", "Round trip", "Multi-City"].map((type) {
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => tripType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:
                        tripType == type ? Colors.blue : Colors.grey.shade200,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    type,
                    style: TextStyle(
                      color: tripType == type ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() => departureDate = date);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              departureDate == null
                  ? 'Select Departure Date'
                  : "${departureDate!.year}-${departureDate!.month.toString().padLeft(2, '0')}-${departureDate!.day.toString().padLeft(2, '0')}",
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
