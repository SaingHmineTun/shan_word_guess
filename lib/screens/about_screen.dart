import 'package:dev_icons/dev_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Theme Colors to match Home
  final Color primaryMint = const Color(0xFF9AD7B3);
  final Color darkGreen = const Color(0xFF2D5A41);

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch link")),
        );
      }
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'tmk.muse@gmail.com');
    await launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F2), // Light mint-grey background
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: darkGreen), // Dark green back button
        backgroundColor: primaryMint,
        centerTitle: true,
        title: Text(
          "လွင်ႈၽူႈၶူင်ႊသၢင်ႈ",
          style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
        ),
      ),
      body: Column(
        children: [
          // Top Header Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryMint,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: darkGreen.withOpacity(0.1), width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/tmk.png'),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "ထုင်ႉမၢဝ်းၶမ်း",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "THUNG MAO KHAM ACADEMY",
                  style: TextStyle(
                    fontSize: 12,
                    color: darkGreen.withOpacity(0.6),
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
                    iconColor: Colors.lightGreen,
                    label: "DEVELOPER WEBSITE",
                    value: "www.saimao.top",
                    onTap: () => _launchUrl(context, "https://www.saimao.top"),
                  ),

                  const SizedBox(height: 40),
                  Text(
                    "VERSION 1.0.0",
                    style: TextStyle(
                      color: darkGreen.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "© 2026 THUNG MAO KHAM",
                    style: TextStyle(color: darkGreen.withOpacity(0.3), fontSize: 10),
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
            color: Colors.black.withOpacity(0.03),
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
                    color: iconColor.withOpacity(0.08),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: darkGreen.withOpacity(0.5),
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