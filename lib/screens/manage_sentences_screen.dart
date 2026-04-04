import 'package:flutter/material.dart';
import '../tools/db_helper.dart';

class ManageSentencesScreen extends StatefulWidget {
  const ManageSentencesScreen({super.key});

  @override
  State<ManageSentencesScreen> createState() => _ManageSentencesScreenState();
}

class _ManageSentencesScreenState extends State<ManageSentencesScreen> {
  List<Map<String, dynamic>> _sentences = [];
  final _textController = TextEditingController();

  // Theme Colors
  final Color primaryMint = const Color(0xFF9AD7B3);
  final Color darkGreen = const Color(0xFF2D5A41);

  void _refreshList() async {
    final data = await DBHelper.getData('sentences');
    if (!mounted) return;
    setState(() {
      _sentences = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Clear All Data?"),
        content: const Text(
          "This will delete all Shan sentences from your database. This action cannot be undone.",
          style: TextStyle(color: Colors.redAccent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("CANCEL", style: TextStyle(color: darkGreen)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DBHelper.deleteAll();
              if (mounted) Navigator.of(ctx).pop();
              _refreshList();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All data cleared successfully.")),
                );
              }
            },
            child: const Text("CLEAR EVERYTHING", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showForm(int? id, String? currentText) {
    if (id != null) _textController.text = currentText!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20, left: 20, right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              cursorColor: darkGreen,
              decoration: InputDecoration(
                hintText: 'Enter Shan Sentence',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: darkGreen)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await DBHelper.insert('sentences', {'text': _textController.text});
                } else {
                  await DBHelper.update(id, _textController.text);
                }
                _textController.clear();
                if (mounted) Navigator.of(context).pop();
                _refreshList();
              },
              style: ElevatedButton.styleFrom(backgroundColor: darkGreen),
              child: Text(
                id == null ? 'Create New' : 'Update',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F2),
      appBar: AppBar(
        title: Text("Manage Data", style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold)),
        backgroundColor: primaryMint,
        elevation: 0,
        iconTheme: IconThemeData(color: darkGreen),
        actions: [
          if (_sentences.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_forever, color: darkGreen),
              tooltip: "Clear All Data",
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: _sentences.isEmpty
          ? Center(
        child: Text(
          "No data found.\nTap + to add a new sentence.",
          textAlign: TextAlign.center,
          style: TextStyle(color: darkGreen.withOpacity(0.5)),
        ),
      )
          : ListView.builder(
        itemCount: _sentences.length,
        itemBuilder: (ctx, i) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          color: Colors.white,
          child: ListTile(
            title: Text(_sentences[i]['text'], style: TextStyle(color: darkGreen, fontWeight: FontWeight.w500)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => _showForm(_sentences[i]['id'], _sentences[i]['text']),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () async {
                    await DBHelper.delete(_sentences[i]['id']);
                    _refreshList();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryMint,
        elevation: 2,
        onPressed: () {
          _textController.clear();
          _showForm(null, null);
        },
        child: Icon(Icons.add, color: darkGreen),
      ),
    );
  }
}