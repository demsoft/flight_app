import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final flightResultsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final jsonStr = await rootBundle.loadString('assets/mock_flights.json');
  final data = json.decode(jsonStr) as List;
  return data.cast<Map<String, dynamic>>();
});

final searchFlightsProvider = FutureProvider.autoDispose.family<
  List<Map<String, dynamic>>,
  FlightSearchParams
>((ref, params) async {
  try {
    final jsonStr = await rootBundle.loadString('assets/mock_flights.json');
    final data = json.decode(jsonStr) as List;
    final flights = data.cast<Map<String, dynamic>>();

    final filtered =
        flights.where((flight) {
          final fromMatch =
              flight['from']?.toLowerCase() == params.from.toLowerCase();
          final toMatch =
              flight['to']?.toLowerCase() == params.to.toLowerCase();

          final dateMatch =
              params.date == null
                  ? true
                  : flight['date']?.toString()?.trim() ==
                      DateFormat('yyyy-MM-dd').format(params.date!);

          return fromMatch && toMatch && dateMatch;
        }).toList();

    // print(
    //   "Filtered ${filtered.length} flights for ${params.from} → ${params.to} on ${params.date}",
    // );

    return filtered;
  } catch (e) {
    print("ERROR: $e");
    throw Exception("Failed to load flights: $e");
  }
});

class FlightSearchParams {
  final String from;
  final String to;
  final DateTime? date;

  FlightSearchParams({required this.from, required this.to, this.date});

  @override
  bool operator ==(Object other) {
    return other is FlightSearchParams &&
        other.from == from &&
        other.to == to &&
        other.date == date;
  }

  @override
  int get hashCode => Object.hash(from, to, date);
}
