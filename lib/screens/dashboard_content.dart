import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smart_complain_management_system/services/mongodb_service.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final PageController _pageController = PageController();
  int _currentNoticeIndex = 0;
  Timer? _timer;
  
  List<Map<String, dynamic>> _notices = [];
  Map<String, int> _stats = {"total": 0, "pending": 0, "solved": 0};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_notices.isNotEmpty) {
        _currentNoticeIndex = (_currentNoticeIndex + 1) % _notices.length;
        if (_pageController.hasClients) {
          _pageController.animateToPage(_currentNoticeIndex, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutQuart);
        }
      }
    });
  }

  Future<void> _fetchData() async {
    final notices = await MongoDatabase.getNotices();
    final user = MongoDatabase.currentUser;
    final stats = await MongoDatabase.getStats(
      user?['email'], 
      role: user?['role'], 
      dept: user?['department']
    );
    
    if (mounted) {
      setState(() {
        _notices = notices;
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A1F36); // Deep Navy
    const Color accentColor = Color(0xFF6366F1); // Indigo

    if (_isLoading) return const Center(child: CircularProgressIndicator(color: accentColor));

    return RefreshIndicator(
      onRefresh: _fetchData,
      color: accentColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumHeader(primaryColor, accentColor),
            const SizedBox(height: 25),
            
            if (_notices.isNotEmpty) ...[
              const Text("Latest News", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              _buildModernNoticeSlider(accentColor),
              const SizedBox(height: 30),
            ],

            _buildGlassStats(primaryColor, accentColor),
            
            const SizedBox(height: 35),
            const Text("Service Hub", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 15),
            _buildResponsiveActionGrid(MongoDatabase.currentUser?['role'] ?? "Student"),

            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Activity Stream", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                TextButton(
                  onPressed: () {}, 
                  child: const Text("View All", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold))
                )
              ],
            ),
            const SizedBox(height: 10),
            _buildRecentActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(Color primaryColor, Color accentColor) {
    final user = MongoDatabase.currentUser;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [accentColor, Colors.blueAccent]),
          ),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Text(
              user?['name']?[0] ?? "U", 
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 26)
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,", 
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)
              ),
              Text(
                user?['name'] ?? "User", 
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Color(0xFF1E293B)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: Colors.grey.shade800),
          ),
        )
      ],
    );
  }

  Widget _buildGlassStats(Color primaryColor, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
        image: DecorationImage(
          image: const NetworkImage("https://www.transparenttextures.com/patterns/carbon-fibre.png"),
          opacity: 0.1,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.srcATop)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildModernStatItem(_stats['total'].toString(), "Total", Icons.analytics_outlined),
          _buildModernStatItem(_stats['pending'].toString(), "Active", Icons.pending_actions_outlined),
          _buildModernStatItem(_stats['solved'].toString(), "Solved", Icons.task_alt_rounded),
        ],
      ),
    );
  }

  Widget _buildModernStatItem(String val, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildModernNoticeSlider(Color accentColor) {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentNoticeIndex = i),
        itemCount: _notices.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [accentColor.withOpacity(0.08), Colors.blue.withOpacity(0.05)]),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentColor.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Icon(Icons.auto_awesome, color: accentColor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_notices[index]['title'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    Text(_notices[index]['body'], maxLines: 2, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveActionGrid(String role) {
    List<Map<String, dynamic>> actions = [];
    if (role == "Student") {
      actions = [
        {"icon": Icons.add_circle_rounded, "label": "Lodge", "color": Colors.blue},
        {"icon": Icons.radar_rounded, "label": "Track", "color": Colors.indigo},
        {"icon": Icons.support_agent_rounded, "label": "Staff", "color": Colors.teal},
        {"icon": Icons.menu_book_rounded, "label": "Guide", "color": Colors.orange},
      ];
    } else {
      actions = [
        {"icon": Icons.dashboard_customize_rounded, "label": "Panel", "color": Colors.deepPurple},
        {"icon": Icons.people_rounded, "label": "Users", "color": Colors.blue},
        {"icon": Icons.send_time_extension_rounded, "label": "Global", "color": Colors.pink},
        {"icon": Icons.settings_rounded, "label": "Admin", "color": Colors.blueGrey},
      ];
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.8
      ),
      itemCount: actions.length,
      itemBuilder: (context, i) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: actions[i]['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(actions[i]['icon'], color: actions[i]['color'], size: 28),
          ),
          const SizedBox(height: 10),
          Text(actions[i]['label'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList() {
    final user = MongoDatabase.currentUser;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: (user?['role'] == 'Admin') 
        ? MongoDatabase.getAllComplaints() 
        : (user?['role'] == 'Student' 
           ? MongoDatabase.getMyComplaints(user!['email'])
           : MongoDatabase.getAllComplaints(dept: user?['department'])),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: LinearProgressIndicator());
        if (snapshot.data!.isEmpty) return const Text("No recent updates.");
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.take(5).length,
          itemBuilder: (context, index) {
            final c = snapshot.data![index];
            return _buildModernActivityItem(c);
          },
        );
      },
    );
  }

  Widget _buildModernActivityItem(Map<String, dynamic> c) {
    Color statusColor = c['status'] == 'Resolved' ? const Color(0xFF10B981) : (c['status'] == 'Pending' ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6));
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.article_rounded, color: statusColor, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c['category'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(c['description'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(
              c['status'], 
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)
            ),
          ),
        ],
      ),
    );
  }
}
