import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cancha_tennis/presentation/pages/home_page.dart';
import 'package:cancha_tennis/presentation/pages/add_agendamiento_page.dart';

void main() {
  group('HomePage', () {
    testWidgets('renders HomePage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Realice sus aserciones de prueba de widgets aqui
      expect(find.text('Tennis App'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    // Agregue más casos de prueba para diferentes escenarios en HomePage
  });

  group('AddAgendamientoPage', () {
    testWidgets('renders AddAgendamientoPage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddAgendamientoPage()));

      // Realice sus aserciones de prueba de widgets aquí
      expect(find.text('Agregar Agendamiento'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    // Agregue más casos de prueba para diferentes escenarios en AddAgendamientoPage
  });
}
