import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flightapp/features/flight_search/provider/flight_results_provider.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    rootBundle.loadString('assets/mock_flights.json');
  });

  test('filters flights by from, to, and date', () async {
    final container = ProviderContainer();

    final result = await container.read(
      searchFlightsProvider(
        FlightSearchParams(
          from: 'Lagos',
          to: 'London',
          date: DateTime(2025, 7, 10),
        ),
      ).future,
    );

    expect(result.length, 2);
    expect(result.first['airline'], 'Alaska Airlines');
  });

  test('returns empty if no flights match', () async {
    final container = ProviderContainer();

    final result = await container.read(
      searchFlightsProvider(
        FlightSearchParams(
          from: 'Abuja',
          to: 'Paris',
          date: DateTime(2025, 8, 1),
        ),
      ).future,
    );

    expect(result, isEmpty);
  });

  test('filters only by from and to if date is null', () async {
    final container = ProviderContainer();

    final result = await container.read(
      searchFlightsProvider(
        FlightSearchParams(from: 'Lagos', to: 'New York', date: null),
      ).future,
    );

    expect(result.length, 1);
    expect(result.first['airline'], 'Indian Airlines');
  });
}
