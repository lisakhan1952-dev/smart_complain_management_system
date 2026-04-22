import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D1C43);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // উপরের ছোট স্ট্যাটিক সেকশন (ঐচ্ছিক কিন্তু সুন্দর দেখায়)
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Active History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Filter", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTrackTile(
                    "Dorm AC Maintenance",
                    "#CMS-90421",
                    "In Progress",
                    Colors.teal,
                    Icons.build_circle_outlined,
                    "Updated 2 hours ago"
                ),
                _buildTrackTile(
                    "Grade Revision Request",
                    "#CMS-88120",
                    "Pending",
                    Colors.orange,
                    Icons.history_edu_outlined,
                    "Submitted Yesterday"
                ),
                _buildTrackTile(
                    "Wifi Connectivity Issues",
                    "#CMS-87002",
                    "Resolved",
                    Colors.blueGrey,
                    Icons.wifi_off_outlined,
                    "Solved 3 days ago"
                ),
                _buildTrackTile(
                    "Library Seating Issue",
                    "#CMS-86554",
                    "Resolved",
                    Colors.blueGrey,
                    Icons.menu_book_outlined,
                    "Solved 1 week ago"
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackTile(String title, String id, String status, Color color, IconData icon, String time) {
    const Color primaryColor = Color(0xFF0D1C43);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // বাম পাশের কালার বার
              Container(color: color, width: 6),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 20, color: primaryColor.withOpacity(0.6)),
                          const SizedBox(width: 8),
                          Text(
                            id,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          // কাস্টম স্ট্যাটাস ব্যাজ
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}