import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatComponent extends StatefulWidget {
  @override
  _ChatComponentState createState() => _ChatComponentState();
}

class _ChatComponentState extends State<ChatComponent> {
  String _response = '';
  final _textFieldController = TextEditingController();
  final _focusNode = FocusNode();

  void _submitQuestion(String question) async {
    var apiUrl = Uri.parse('\${API_URL}/v1/prompt');

    var body = json.encode({
      'message': question
    });

    var headers = {
      'Content-Type': 'application/json',
    };

    var result = await http.post(apiUrl, body: body, headers: headers);
    var response = json.decode(result.body);

    setState(() async {
      _response = 'Answer: ${response['response'][0]}';
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
      body: Container(
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
            Text(_response, style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
          ],
        ),
      ),
    );
  }
}
