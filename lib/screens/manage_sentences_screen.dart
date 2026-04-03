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

  void _refreshList() async {
    final data = await DBHelper.getData('sentences');
    if (!mounted) return; // Stop if the user already closed this screen
    setState(() {
      _sentences = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshList(); // This is the "Engine Start" button for your data
  }

  // Dangerous Action: Confirmation Dialog
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear All Data?"),
        content: const Text(
          "This will delete all Shan sentences from your database. This action cannot be undone.",
          style: TextStyle(color: Colors.redAccent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DBHelper.deleteAll();
              Navigator.of(ctx).pop();
              _refreshList();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("All data cleared successfully."),
                  ),
                );
              }
            },
            child: const Text(
              "CLEAR EVERYTHING",
              style: TextStyle(color: Colors.white),
            ),
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
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter Shan Sentence',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await DBHelper.insert('sentences', {
                    'text': _textController.text,
                  });
                } else {
                  await DBHelper.update(id, _textController.text);
                }
                _textController.clear();
                if (mounted) Navigator.of(context).pop();
                _refreshList();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
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
      appBar: AppBar(
        title: const Text("Manage Data",  style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          // Clear All Button
          if (_sentences.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              tooltip: "Clear All Data",
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: _sentences.isEmpty
          ? const Center(
              child: Text(
                "No data found.\nTap + to add a new sentence.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _sentences.length,
              itemBuilder: (ctx, i) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(_sentences[i]['text']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showForm(
                          _sentences[i]['id'],
                          _sentences[i]['text'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
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
        backgroundColor: Colors.amber,
        onPressed: () {
          _textController.clear();
          _showForm(null, null);
        },
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}
