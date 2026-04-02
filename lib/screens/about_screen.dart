import 'package:dev_icons/dev_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Helper to launch URLs (Facebook, Website, etc.)
  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not launch link")));
    }
  }

  // Helper to send Email
  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'tmk.muse@gmail.com',
    );
    await launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          "လွင်ႈၽူႈၶူင်ႊသၢင်ႈ", // About Developer
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Top Header Section
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile/Logo Container
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/tmk.png'),
                    // backgroundColor: Colors.white10,
                    // child: Icon(Icons.person, size: 60, color: Colors.white70),
                    // If you have a photo, use: backgroundImage: AssetImage('assets/your_profile.png'),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "ထုင်ႉမၢဝ်းၶမ်း",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  "THUNG MAO KHAM ACADEMY",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Contact Cards List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  _buildContactCard(
                    icon: DevIcons.googlePlain,
                    iconColor: Colors.redAccent,
                    label: "EMAIL ADDRESS",
                    value: "tmk.muse@gmail.com",
                    onTap: _sendEmail,
                  ),
                  _buildContactCard(
                    icon: DevIcons.facebookPlain,
                    iconColor: const Color(0xFF1877F2),
                    label: "FACEBOOK PAGE",
                    value: "ထုင်ႉမၢဝ်းၶမ်း",
                    onTap: () => _launchUrl(
                      context,
                      "https://www.facebook.com/profile.php?id=61569069823862",
                    ),
                  ),
                  _buildContactCard(
                    icon: DevIcons.githubOriginal,
                    iconColor: Colors.black87,
                    label: "SOURCE CODE",
                    value: "Get GitHub Repository",
                    onTap: () => _launchUrl(
                      context,
                      "https://github.com/SaingHmineTun/shan_word_guess",
                    ),
                  ),
                  _buildContactCard(
                    icon: DevIcons.chromePlain,
                    iconColor: Colors.blue,
                    label: "DEVELOPER WEBSITE",
                    value: "www.saimao.top",
                    onTap: () => _launchUrl(context, "https://www.saimao.top"),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    "VERSION 1.0.0",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "© 2026 THUNG MAO KHAM",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.indigo,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
