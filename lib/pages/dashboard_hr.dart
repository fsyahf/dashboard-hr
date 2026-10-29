import 'package:flutter/material.dart';

class DashboardHR extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const DashboardHR({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.apartment_rounded, color: colors.onPrimaryContainer),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PT Maju Bersama',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Human Resources',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDarkMode ? 'Aktifkan mode terang' : 'Aktifkan mode gelap',
            onPressed: onToggleTheme,
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () {},
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: colors.secondaryContainer,
              foregroundColor: colors.onSecondaryContainer,
              child: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 600;
            final pagePadding = wide ? 24.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(pagePadding, 12, pagePadding, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _GreetingBanner(),
                      const SizedBox(height: 24),
                      const _SectionTitle(
                        title: 'Ringkasan Karyawan',
                        subtitle: 'Informasi terbaru perusahaan',
                      ),
                      const SizedBox(height: 14),
                      _StatsGrid(isWide: wide),
                      const SizedBox(height: 24),
                      const _AttendanceChart(),
                      const SizedBox(height: 24),
                      const _SectionTitle(
                        title: 'Aktivitas Terbaru',
                        subtitle: 'Absensi dan pengajuan cuti terbaru',
                      ),
                      const SizedBox(height: 14),
                      _LatestActivityCards(isWide: wide),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GreetingBanner extends StatelessWidget {
  const _GreetingBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 38),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? [colors.primaryContainer, colors.secondaryContainer]
                : [colors.primary, colors.tertiary],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Pagi, Admin!',
              style: TextStyle(
                color: dark ? colors.onPrimaryContainer : Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pantau informasi karyawan hari ini.',
              style: TextStyle(
                color: dark ? colors.onPrimaryContainer : Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16,
                    color: dark ? colors.onPrimaryContainer : Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Senin, 7 Oktober 2024',
                  style: TextStyle(
                    color: dark ? colors.onPrimaryContainer : Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 22)
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height + 8,
        size.width * 0.45,
        size.height - 8,
      )
      ..quadraticBezierTo(
        size.width * 0.20,
        size.height - 25,
        0,
        size.height - 4,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final bool isWide;
  const _StatsGrid({required this.isWide});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData('Karyawan', '248', Icons.groups_rounded, Colors.blue),
      _StatData('Kehadiran', '95%', Icons.fact_check_rounded, Colors.green),
      _StatData('Cuti', '12', Icons.event_busy_rounded, Colors.orange),
      _StatData('Rekrutmen', '3', Icons.person_add_alt_1_rounded, Colors.purple),
    ];

    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isWide ? 1.55 : 1.35,
      ),
      itemBuilder: (context, index) => _StatCard(data: stats[index]),
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatData(this.label, this.value, this.icon, this.color);
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(data.icon, color: data.color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 2),
                Text(data.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceChart extends StatelessWidget {
  const _AttendanceChart();

  @override
  Widget build(BuildContext context) {
    const divisions = [
      _DivisionData('Engineering', 92),
      _DivisionData('Sales', 85),
      _DivisionData('HR', 97),
      _DivisionData('Finance', 90),
    ];
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kehadiran per Divisi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 6),
            Text('Persentase kehadiran karyawan',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 18),
            for (final division in divisions) ...[
              Row(
                children: [
                  SizedBox(
                    width: 94,
                    child: Text(division.name,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 12,
                        color: colors.surfaceContainerHighest,
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: division.percent / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 42,
                    child: Text('${division.percent}%',
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _DivisionData {
  final String name;
  final int percent;
  const _DivisionData(this.name, this.percent);
}

class _LatestActivityCards extends StatelessWidget {
  final bool isWide;
  const _LatestActivityCards({required this.isWide});

  @override
  Widget build(BuildContext context) {
    final attendance = _ActivityCard(
      title: 'Terbaru Absen',
      icon: Icons.access_time_rounded,
      items: const [
        _ActivityItem('Budi Santoso', 'Masuk • 08.02', Icons.check_circle, Colors.green),
        _ActivityItem('Citra Dewi', 'Masuk • 08.10', Icons.check_circle, Colors.green),
        _ActivityItem('Eko Wahyudi', 'Terlambat • 08.35', Icons.warning_rounded, Colors.orange),
      ],
    );

    final leave = _ActivityCard(
      title: 'Terbaru Cuti',
      icon: Icons.event_note_rounded,
      items: const [
        _ActivityItem('Dina Putri', 'Cuti tahunan • 2 hari', Icons.pending_actions, Colors.orange),
        _ActivityItem('Rizky Pratama', 'Cuti sakit • 1 hari', Icons.check_circle, Colors.green),
        _ActivityItem('Siti Amelia', 'Cuti tahunan • 3 hari', Icons.pending_actions, Colors.orange),
      ],
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: attendance),
          const SizedBox(width: 14),
          Expanded(child: leave),
        ],
      );
    }

    return Column(
      children: [
        attendance,
        const SizedBox(height: 14),
        leave,
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_ActivityItem> items;

  const _ActivityCard({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final item in items) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: item.color.withOpacity(0.14),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                title: Text(item.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(item.detail),
                dense: true,
              ),
              if (item != items.last) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActivityItem {
  final String name;
  final String detail;
  final IconData icon;
  final Color color;

  const _ActivityItem(this.name, this.detail, this.icon, this.color);
}
