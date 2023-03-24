import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatComponent extends StatefulWidget {
  @override
  _ChatComponentState createState() => _ChatComponentState();
}

class _ChatComponentState extends State<ChatComponent> {
  final _textFieldController = TextEditingController();
  final _textQuestionController = TextEditingController();
  final _textResponseController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isVisible = false;

  void _submitQuestion(String question) async {
    _textQuestionController.text = question;
    _textResponseController.text = 'Computing the answer...';
    _textFieldController.clear();
    setState(() {
      _isVisible = true;
    });

    var apiUrl = Uri.parse('\${API_URL}/v1/prompt');

    var body = json.encode({
      'message': question
    });

    var headers = {
      'Content-Type': 'application/json',
    };

    var result = await http.post(apiUrl, body: body, headers: headers);
    var response = json.decode(result.body);

    _textResponseController.text = response['response'][0];
    _focusNode.requestFocus();
  }

  void _regenerateResponse() async {
    _submitQuestion(_textQuestionController.text);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _textQuestionController.dispose();
    _textResponseController.dispose();
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
                hintText: 'Write your question here...',
              ),
              onSubmitted: (String question) {
                _submitQuestion(question);
              },
              autofocus: true,
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _isVisible,
              child: TextField(
                controller: _textQuestionController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Your question will be kept here...',
                  filled: true,
                  fillColor: Color(0xFFDEDEDE),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Color(0xFFEFEFEF),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Color(0xFF114575),
                      width: 2.0,
                    ),
                  ),
                ),
                maxLines: null
              )
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _isVisible,
              child: TextField(
                controller: _textResponseController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'The answer will appear here...',
                  filled: true,
                  fillColor: Color(0xFFDEDEDE),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Color(0xFFEFEFEF),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Color(0xFF114575),
                      width: 2.0,
                    ),
                  ),
                ),
                maxLines: null
              )
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _isVisible,
              child: ElevatedButton(
                onPressed: _regenerateResponse,
                child: Text('Regenerate response'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF114575)), 
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
