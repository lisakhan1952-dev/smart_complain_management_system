import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final user = MongoDatabase.currentUser;
  late bool _canManage;
  String _searchQuery = "";
  String _filterStatus = "All";
  final TextEditingController _remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _canManage = user?['role'] == 'Admin' || user?['role'] == 'Staff' || user?['role'] == 'Teacher';
  }

  void _showUpdateDialog(Map<String, dynamic> c) {
    String currentStatus = c['status'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text("Resolution Hub", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1F36))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: currentStatus,
              items: ["Pending", "In Progress", "Resolved", "Rejected"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => currentStatus = val!,
              decoration: InputDecoration(
                labelText: "Update Progress",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _remarksController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Action Taken / Note",
                hintText: "Enter a professional response...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Discard")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              await MongoDatabase.updateComplaintStatus(c['_id'], currentStatus, remarks: _remarksController.text.trim());
              _remarksController.clear();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Commit Change"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A1F36);
    const Color accentColor = Color(0xFF6366F1);
    final String role = user?['role'] ?? "Student";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildSearchAndFilterHeader(primaryColor, accentColor),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: (role == 'Admin') 
                ? MongoDatabase.getAllComplaints() 
                : (role == 'Student' 
                   ? MongoDatabase.getMyComplaints(user!['email'])
                   : MongoDatabase.getAllComplaints(dept: user?['department'])),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: accentColor));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                var list = snapshot.data!.where((c) {
                  bool matchesSearch = c['category'].toLowerCase().contains(_searchQuery) || 
                                     c['description'].toLowerCase().contains(_searchQuery);
                  bool matchesFilter = _filterStatus == "All" || c['status'] == _filterStatus;
                  return matchesSearch && matchesFilter;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) => _buildAdvancedTrackingCard(list[index], primaryColor, accentColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterHeader(Color primaryColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            decoration: InputDecoration(
              hintText: "Search logs...",
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "Pending", "In Progress", "Resolved", "Rejected"].map((status) {
                bool isSelected = _filterStatus == status;
                return GestureDetector(
                  onTap: () => setState(() => _filterStatus = status),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? accentColor : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: isSelected ? accentColor : Colors.grey.shade200),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedTrackingCard(Map<String, dynamic> c, Color primaryColor, Color accentColor) {
    Color statusColor = _getStatusColor(c['status']);
    
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.grey.shade50),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(_getStatusIcon(c['status']), color: statusColor, size: 24),
          ),
          title: Text(c['category'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1E293B))),
          subtitle: Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(c['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          trailing: _canManage 
            ? IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () => _showUpdateDialog(c)) 
            : const Icon(Icons.keyboard_arrow_down_rounded),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const Divider(),
            const SizedBox(height: 10),
            _buildTimelineRow("Logged", c['createdAt'].split('T')[0], true),
            const SizedBox(height: 15),
            Text("Issue Statement:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800, fontSize: 13)),
            const SizedBox(height: 5),
            Text(c['description'], style: const TextStyle(color: Color(0xFF475569), height: 1.4)),
            const SizedBox(height: 20),
            
            if (c['adminRemarks'] != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user_rounded, color: Color(0xFF6366F1), size: 16),
                        const SizedBox(width: 8),
                        const Text("Management Response", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF6366F1))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(c['adminRemarks'], style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF334155))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallInfo("ID", c['_id'].toString().substring(18).toUpperCase()),
                _buildSmallInfo("Dept", c['department'] ?? "General"),
                _buildSmallInfo("Priority", c['priority'] ?? "Medium"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineRow(String label, String date, bool isDone) {
    return Row(
      children: [
        Icon(Icons.check_circle, size: 16, color: isDone ? Colors.green : Colors.grey),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSmallInfo(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text("No logs found matching your criteria", style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getStatusColor(String s) {
    switch (s) {
      case 'Resolved': return const Color(0xFF10B981);
      case 'In Progress': return const Color(0xFF6366F1);
      case 'Rejected': return const Color(0xFFEF4444);
      default: return const Color(0xFFF59E0B);
    }
  }

  IconData _getStatusIcon(String s) {
    switch (s) {
      case 'Resolved': return Icons.verified_rounded;
      case 'In Progress': return Icons.published_with_changes_rounded;
      case 'Rejected': return Icons.cancel_rounded;
      default: return Icons.hourglass_top_rounded;
    }
  }
}
