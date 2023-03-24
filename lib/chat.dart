import 'dart:async';
import 'package:flutter/material.dart';

class ChatComponent extends StatefulWidget {
  @override
  _ChatComponentState createState() => _ChatComponentState();
}

class _ChatComponentState extends State<ChatComponent> {
  String _barcode = '';
  final _textFieldController = TextEditingController();
  final _focusNode = FocusNode();

  void _submitQuestion(String question) async {
    final answer = question;
    
    setState(() {
      _barcode = 'Answer: ${answer}';
    });

    _textFieldController.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              controller: _textFieldController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Write your question...',
              ),
              onSubmitted: (String question) {
                _submitQuestion(question);
              },
              autofocus: true,
            ),
            SizedBox(height: 10),
            Text(_barcode, style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
