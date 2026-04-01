import 'dart:math';

import 'package:flutter/material.dart';

import '../tools/shan_syllable_breaker.dart';

List<String> shanWords = [
  "သူယူႇတီႈလႂ်",
  "ၵိၼ်ၶဝ်ႈၵပ်းၽၵ်းသင်",
  "ၵႂႃႇၵိၼ်ၼိူဝ်ႉၵႆႇ",
  "သွၼ်လိၵ်ႈတႆးဝႆႉယူႇ",
  "သိုပ်ႇၽူၼ်းပၼ်တႆးၵေႃႉ",
  "ၼင်ႈလီလီလႄႈသူ",
  "ႁႂ်ႈယူႇလီမီးငိုၼ်း",
  "ႁဝ်းၵႂႃႇၵိၼ်ၶဝ်ႈသွႆး",
  "ဢမ်ႇမီးငိုၼ်းသေပေး",
  "သိုပ်ႇၽူၼ်းၸူးၵေႃႉႁၵ်ႉ"
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> contents = [];
  List<String> guessedWords = [];
  late String correctWord;
  late String shuffleWord;
  late int correctWordLength;
  final random = Random();

  @override
  void initState() {
    super.initState();
    _refreshGame();
  }

  void _refreshGame() {
    setState(() {
      // Logic remained the same, just encapsulated
      correctWord = shanWords[random.nextInt(shanWords.length)];
      final brokenWords = syllableBreakAsList(correctWord);
      brokenWords.shuffle();
      correctWordLength = brokenWords.length;
      shuffleWord = brokenWords.join(" "); // Space for readability
      contents = brokenWords;
      guessedWords = [];
    });
  }

  // --- UI Components ---

  Widget _buildChip({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    bool isElevated = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isElevated
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isComplete = guessedWords.length == correctWordLength;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "လၢမ်းလိၵ်ႈတႆးႁႂ်ႈမႅၼ်ႈ",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshGame,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Rearrange the syllables",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    shuffleWord,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Guessing Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    " YOUR GUESS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 120,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.indigo.withOpacity(0.1)),
                    ),
                    child: guessedWords.isEmpty
                        ? const Center(
                            child: Text(
                              "Tap syllables below...",
                              style: TextStyle(color: Colors.black26),
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: guessedWords.map((str) {
                              return _buildChip(
                                text: str,
                                color: Colors.indigo.shade50,
                                textColor: Colors.indigo,
                                isElevated: false,
                                onTap: () => setState(() {
                                  guessedWords.remove(str);
                                  contents.add(str);
                                }),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  AnimatedScale(
                    scale: isComplete ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _checkAnswer,
                        child: const Text(
                          "CHECK ANSWER",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Selection Palette
          Container(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 50),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: contents.map((str) {
                return _buildChip(
                  text: str,
                  color: Colors.amber.shade400,
                  textColor: Colors.black87,
                  onTap: () => setState(() {
                    guessedWords.add(str);
                    contents.remove(str);
                  }),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _checkAnswer() {
    if (guessedWords.join("") == correctWord) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: const Text(
            "တူၵ်းမႅၼ်ႈယဝ်ႉၶႃႈ!\nYou guessed it correctly!",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _refreshGame();
                },
                child: const Text("Play Next", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("လၢမ်းပႆႇမႅၼ်ႈၶႃႈ။ ၶတ်းၸႂ်တူၺ်းထႅင်ႈၶႃႈ"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
