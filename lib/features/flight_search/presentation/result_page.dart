import 'package:flightapp/features/flight_search/presentation/flight_detail.dart';
import 'package:flightapp/features/flight_search/provider/flight_results_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FlightResultsPage extends ConsumerStatefulWidget {
  final String from;
  final String to;
  final DateTime date;

  const FlightResultsPage({
    super.key,
    required this.from,
    required this.to,
    required this.date,
  });

  @override
  ConsumerState<FlightResultsPage> createState() => _FlightResultsPageState();
}

class _FlightResultsPageState extends ConsumerState<FlightResultsPage> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.80,
  );
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final flightsAsync = ref.watch(
      searchFlightsProvider(
        FlightSearchParams(from: widget.from, to: widget.to, date: widget.date),
      ),
    );

    final formattedDate = DateFormat('EEE, dd MMM').format(widget.date);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Flights",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: flightsAsync.when(
        loading: () {
          //print("UI is still loading...");
          return const Center(child: CircularProgressIndicator());
        },
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (flights) {
          print("UI got ${flights.length} flights.");
          if (flights.isEmpty) {
            return const Center(
              child: Text("No flights found for selected route/date."),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildRouteSummary(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "${formattedDate} · 1 Adult",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildSortFilter(),
              const SizedBox(height: 12),
              SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: _pageController,
                  padEnds: false,
                  itemCount: flights.length,
                  onPageChanged:
                      (index) => setState(() => _currentIndex = index),
                  itemBuilder: (context, index) {
                    final flight = flights[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: 10,
                        left: index == 0 ? 16 : 8,
                      ),
                      child: GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => FlightDetailsPage(flight: flight),
                              ),
                            ),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Align(
                                //   alignment: Alignment.topLeft,
                                //   child: Container(
                                //     padding: const EdgeInsets.symmetric(
                                //       horizontal: 10,
                                //       vertical: 6,
                                //     ),
                                //     decoration: BoxDecoration(
                                //       color: Colors.grey.shade200,
                                //       borderRadius: BorderRadius.circular(20),
                                //     ),
                                //     child: Text(
                                //       "${flight['price']} · ${flight['class']}",
                                //       style: const TextStyle(fontSize: 12),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(height: 8),
                                flight['logo'] != null &&
                                        flight['logo'].toString().isNotEmpty
                                    ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.asset(
                                            flight['logo'],
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              "${flight['price']} · ${flight['class']}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                    : Container(
                                      height: 40,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.teal.shade600,
                                      child: Text(
                                        flight['airline'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                const SizedBox(height: 12),
                                Text(
                                  flight['stops'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  flight['airline'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${widget.from} ${flight['fromTime']} → ${widget.to} ${flight['toTime']} • ${flight['duration']}",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildPageIndicator(flights.length),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRouteSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAirportInfo("JFK", widget.from),
          Image.asset("assets/images/plane1.png"),
          _buildAirportInfo("LAX", widget.to),
        ],
      ),
    );
  }

  Widget _buildAirportInfo(String code, String city) {
    return Column(
      children: [
        Text(
          code,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(city, style: const TextStyle(color: Color(0xFF4A739C))),
      ],
    );
  }

  Widget _buildSortFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Sort & Filter", style: TextStyle(fontWeight: FontWeight.w500)),
          Icon(Icons.tune),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.blue : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
