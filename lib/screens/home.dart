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

  // Initialized with empty strings to prevent LateInitializationError
  String correctWord = "";
  String shuffleWord = "";

  final random = Random();

  // For visual feedback (Border turns green/red)
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    _refreshGame();
  }

  Future<void> _refreshGame() async {
    // Ensure we have data if it's the very first run
    await DBHelper.checkAndSeed();

    final dynamicData = await DBHelper.getData('sentences');

    if (dynamicData.isNotEmpty) {
      // Pick exclusively from the Database
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
      // If user deleted EVERYTHING, show a message
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
        const SnackBar(
          content: Text(
            "လၢမ်းပႆႇမႅၼ်ႈၶႃႈ။ ၶတ်းၸႂ်တူၺ်းထႅင်ႈၶႃႈ",
            style: TextStyle(fontFamily: 'NamKhone'),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
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
                  backgroundColor: Colors.indigo,
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
    // Show a loading indicator if data isn't ready yet
    if (shuffleWord.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    bool showCheckButton = contents.isEmpty && guessedWords.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "လၢမ်းလိၵ်ႈတႆး",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshGame,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const ManageSentencesScreen(),
                ),
              );

              // 2. This line runs ONLY after the user returns
              _refreshGame();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
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
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Rearrange these syllables:",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  shuffleWord,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
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
                                  : Colors.indigo.withOpacity(0.1)),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
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

          // 3. Conditional Check Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: showCheckButton
                ? Padding(
                    key: const ValueKey("btn"),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          "CHECK ANSWER",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(key: ValueKey("empty"), height: 85),
          ),

          // 4. Syllable Selection Palette
          Container(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 45),
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
              children: contents
                  .map(
                    (str) => _buildChip(
                      text: str,
                      isSelected: false,
                      onTap: () => setState(() {
                        guessedWords.add(str);
                        contents.remove(str);
                      }),
                    ),
                  )
                  .toList(),
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
          color: isSelected ? Colors.indigo.shade50 : Colors.amber.shade400,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected
              ? null
              : [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.indigo : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
