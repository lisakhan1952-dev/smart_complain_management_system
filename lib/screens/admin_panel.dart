import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _isPosting = false;
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic> _analytics = {"users": 0, "complaints": 0, "resolutionRate": "0.0", "dbLatency": "..."};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() async {
    final users = await MongoDatabase.getAllUsers();
    final analytics = await MongoDatabase.getAdvancedAnalytics();
    if (mounted) {
      setState(() {
        _users = users;
        _analytics = analytics;
        _isLoading = false;
      });
    }
  }

  void _postNotice() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) return;
    setState(() => _isPosting = true);
    await MongoDatabase.addNotice(_titleController.text, _bodyController.text);
    setState(() => _isPosting = false);
    _titleController.clear();
    _bodyController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Announcement Propagated Successfully")));
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A1F36);
    const Color accentColor = Color(0xFF6366F1);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text("Management OS", style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
          elevation: 0.5,
          bottom: TabBar(
            tabs: const [Tab(text: "Core Analytics"), Tab(text: "User Database")],
            labelColor: accentColor,
            indicatorColor: accentColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            _buildAnalyticsSection(accentColor),
            _buildUserSection(primaryColor, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection(Color accentColor) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("REAL-TIME METRICS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.blueAccent, letterSpacing: 1.5)),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildMetricCard("Network Users", _analytics['users'].toString(), Icons.people_outline_rounded, Colors.blue),
              const SizedBox(width: 15),
              _buildMetricCard("Resolution", "${_analytics['resolutionRate']}%", Icons.auto_graph_rounded, Colors.green),
            ],
          ),
          const SizedBox(height: 15),
          _buildWideMetricCard("Database Health", _analytics['dbLatency'], Icons.storage_rounded, Colors.orange),
          const SizedBox(height: 40),
          const Text("SYSTEM ANNOUNCEMENT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.blueAccent, letterSpacing: 1.5)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey.shade100)),
            child: Column(
              children: [
                TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Broadcast Subject", border: OutlineInputBorder())),
                const SizedBox(height: 15),
                TextField(controller: _bodyController, maxLines: 4, decoration: const InputDecoration(labelText: "Payload Content", border: OutlineInputBorder(), alignLabelWithHint: true)),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isPosting ? null : _postNotice,
                    style: ElevatedButton.styleFrom(backgroundColor: accentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: const Text("Deploy Notification", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWideMetricCard(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          ]),
          const Spacer(),
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
        ],
      ),
    );
  }

  Widget _buildUserSection(Color primaryColor, Color accentColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final u = _users[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: accentColor.withOpacity(0.05), child: Text(u['name'][0], style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold))),
            title: Text(u['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${u['role']} | ${u['department']}"),
            trailing: const Icon(Icons.more_horiz_rounded),
          ),
        );
      },
    );
  }
}
