import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahan wajib untuk format tanggal
import 'pages/login_page.dart';

void main() async {
  // Baris di bawah ini adalah perbaikannya
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); 
  
  runApp(const AgendaNusantaraApp());
}

class AgendaNusantaraApp extends StatelessWidget {
  const AgendaNusantaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Nusantara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: false,
        ),
      ),
      home: const LoginPage(),
    );
  }
}