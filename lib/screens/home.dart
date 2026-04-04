import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shan_word_guess/screens/manage_sentences_screen.dart';
import 'package:shan_word_guess/tools/data.dart';
import 'package:shan_word_guess/tools/shan_syllable_breaker.dart';

import '../tools/db_helper.dart';
import 'about_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> contents = [];
  List<String> guessedWords = [];

  String correctWord = "";
  String shuffleWord = "";

  final random = Random();
  bool? isCorrect;

  // New Theme Color
  final Color primaryMint = const Color(0xFF9AD7B3);
  final Color darkGreen = const Color(
    0xFF2D5A41,
  ); // A darker shade for text contrast

  @override
  void initState() {
    super.initState();
    _refreshGame();
  }

  Future<void> _refreshGame() async {
    await DBHelper.checkAndSeed();
    final dynamicData = await DBHelper.getData('sentences');

    if (dynamicData.isNotEmpty) {
      String selectedWord =
          dynamicData[random.nextInt(dynamicData.length)]['text'];
      final brokenWords = syllableBreakAsList(selectedWord);
      List<String> shuffledList = List.from(brokenWords)..shuffle();

      setState(() {
        correctWord = selectedWord;
        shuffleWord = shuffledList.join(" ");
        isCorrect = null;
        contents = List.from(brokenWords)..shuffle();
        guessedWords.clear();
      });
    } else {
      setState(() {
        shuffleWord = "No sentences found. Add some!";
      });
    }
  }

  void _checkAnswer() {
    var userGuess = guessedWords.join("");
    if (userGuess == correctWord) {
      setState(() => isCorrect = true);
      _showCorrectDialog();
    } else {
      setState(() => isCorrect = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "လၢမ်းပႆႇမႅၼ်ႈၶႃႈ။ ၶတ်းၸႂ်တူၺ်းထႅင်ႈၶႃႈ",
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
          // Increase the bottom margin to sit above your bottom container
          margin: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
        ),
      );
    }
  }

  void _showCorrectDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 80,
        ),
        content: const Text(
          "လၢမ်းမႅၼ်ႈယဝ်ႉၶႃႈ!\nYou guessed it right!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _refreshGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen, // Use Dark Green for buttons
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "NEXT",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (shuffleWord.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryMint)),
      );
    }

    bool showCheckButton = contents.isEmpty && guessedWords.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F2), // Slightly tinted background
      appBar: AppBar(
        title: Text(
          "လၢမ်းလိၵ်ႈတႆး",
          style: TextStyle(fontWeight: FontWeight.w900, color: darkGreen),
        ),
        centerTitle: true,
        backgroundColor: primaryMint,
        elevation: 0,
        iconTheme: IconThemeData(color: darkGreen),
        // Dark green icons for contrast
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshGame),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const ManageSentencesScreen(),
                ),
              );
              _refreshGame();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Shuffled Reference Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            decoration: BoxDecoration(
              color: primaryMint,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Rearrange these syllables:",
                  style: TextStyle(
                    color: darkGreen.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  shuffleWord,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // 2. Guessing Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    " YOUR ANSWER",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 140,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCorrect == true
                            ? Colors.green
                            : (isCorrect == false
                                  ? Colors.redAccent
                                  : primaryMint.withOpacity(0.3)),
                        width: 2,
                      ),
                    ),
                    child: guessedWords.isEmpty
                        ? const Center(
                            child: Text(
                              "Tap words from below",
                              style: TextStyle(color: Colors.black26),
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: guessedWords
                                .map(
                                  (str) => _buildChip(
                                    text: str,
                                    isSelected: true,
                                    onTap: () => setState(() {
                                      isCorrect = null;
                                      guessedWords.remove(str);
                                      contents.add(str);
                                    }),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
// 3 & 4. Integrated Action Area
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 25, 20, MediaQuery.of(context).padding.bottom + 20),
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: contents.isNotEmpty
                  ? Wrap(
                key: const ValueKey("wrap_chips"),
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: contents.map((str) => _buildChip(
                  text: str,
                  isSelected: false,
                  onTap: () => setState(() {
                    guessedWords.add(str);
                    contents.remove(str);
                  }),
                )).toList(),
              )
                  : Column(
                key: const ValueKey("check_btn_area"),
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("CHECK ANSWER", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildChip({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryMint.withOpacity(0.1) : primaryMint,
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: primaryMint) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: darkGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
