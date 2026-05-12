import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../db/db_helper.dart';
import 'add_task_page.dart';
import 'task_list_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _done = 0;
  int _notDone = 0;
  List<Map<String, dynamic>> _chartData = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await DbHelper().getStats();
    final chart = await DbHelper().getDonePerDay();
    if (mounted) {
      setState(() {
        _done = stats['done']!;
        _notDone = stats['notDone']!;
        _chartData = chart;
      });
    }
  }

  String get _todayLabel {
    final now = DateTime.now();
    final days = [
      'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
    ];
    return '${days[now.weekday % 7]}, ${DateFormat('d MMMM yyyy', 'id').format(now)}';
  }

  void _navigate(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page))
        .then((_) => _loadStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Beranda'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting ──
              Text(
                'Halo, ${widget.username}! 🎯',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              Text(
                _todayLabel,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              // ── Stats cards ──
              Row(
                children: [
                  _StatCard(
                    label: 'TUGAS SELESAI',
                    value: _done,
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'BELUM SELESAI',
                    value: _notDone,
                    color: const Color(0xFFC62828),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Chart (BONUS) ──
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TUGAS SELESAI / HARI [BONUS]',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: _chartData.isEmpty
                            ? const Center(
                                child: Text(
                                  'Belum ada data',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : _BarChart(data: _chartData),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Navigation buttons (2×2 grid) ──
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  _NavButton(
                    icon: Icons.priority_high_rounded,
                    label: 'Tambah Tugas\nPenting',
                    color: const Color(0xFFC62828),
                    onTap: () => _navigate(
                      const AddTaskPage(category: 'penting'),
                    ),
                  ),
                  _NavButton(
                    icon: Icons.add_task_rounded,
                    label: 'Tambah Tugas\nBiasa',
                    color: const Color(0xFF2E7D32),
                    onTap: () => _navigate(
                      const AddTaskPage(category: 'biasa'),
                    ),
                  ),
                  _NavButton(
                    icon: Icons.list_alt_rounded,
                    label: 'Daftar\nTugas',
                    color: const Color(0xFF1565C0),
                    onTap: () => _navigate(const TaskListPage()),
                  ),
                  _NavButton(
                    icon: Icons.settings_rounded,
                    label: 'Pengaturan',
                    color: const Color(0xFF6A1B9A),
                    onTap: () => _navigate(const SettingsPage()),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Simple bar chart dengan CustomPainter ──
class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter(data: data),
      child: const SizedBox.expand(),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  _BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxCount = data.fold<int>(
      1,
      (prev, e) => (e['count'] as int) > prev ? e['count'] as int : prev,
    );

    final barPaint = Paint()..color = const Color(0xFF2E7D32);
    final axisPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    final textStyle = const TextStyle(fontSize: 10, color: Colors.grey);

    final barWidth = (size.width / data.length) * 0.55;
    final gap = (size.width / data.length) * 0.45;
    final chartH = size.height - 24;

    // Draw bars in chronological order (oldest first)
    final sorted = List<Map<String, dynamic>>.from(data.reversed);

    for (int i = 0; i < sorted.length; i++) {
      final count = sorted[i]['count'] as int;
      final day = sorted[i]['day'] as String? ?? '';

      final barH = (count / maxCount) * chartH;
      final x = i * (barWidth + gap) + gap / 2;
      final y = chartH - barH;

      // Bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barH),
          const Radius.circular(4),
        ),
        barPaint,
      );

      // Baseline
      canvas.drawLine(
        Offset(0, chartH),
        Offset(size.width, chartH),
        axisPaint,
      );

      // Label (day short)
      String label = day.length >= 10 ? day.substring(8) : day;
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x + barWidth / 2 - tp.width / 2, chartH + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.data != data;
}
