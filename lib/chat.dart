import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatComponent extends StatefulWidget {
  @override
  _ChatComponentState createState() => _ChatComponentState();
}

class _ChatComponentState extends State<ChatComponent> {
  final _textFieldController = TextEditingController();
  final _textQuestionController = TextEditingController();
  final _textResponseController = TextEditingController();
  final _focusNode = FocusNode();
  final _apiUrl = "\${API_URL}";
  final _apiUsername = "\${API_USERNAME}";
  final _apiPassword = "\${API_PASSWORD}";
  bool _isVisible = false;
  String? _model = null;
  List<String> _models = [];

  Future<void> _initModelsList() async {
    var modelsUrl = Uri.parse('${_apiUrl}/v1/models');

    var headers = {};
    if (_apiUsername && _apiPassword) {
      headers = {
        HttpHeaders.authorizationHeader: 'Basic ' + base64Encode('$_apiUsername:$_apiPassword');
      }
    }

    var result = await http.get(modelsUrl, headers: headers);
    if (result.statusCode != 200) {
      throw Exception('API request failed with status code ${result.statusCode}');
    }

    var response = json.decode(result.body);
    setState(() {
      _models = List<String>.from(response['models']);
      _model = _models[0];
    });
  }

  void _switchModel(String? model) {
    setState(() {
      _model = model;
    });
  }

  Future<void> _submitQuestion(String question) async {
    _textQuestionController.text = question;
    _textResponseController.text = 'Computing the answer...';
    _textFieldController.clear();
    setState(() {
      _isVisible = true;
    });

    var promptUrl = Uri.parse('${_apiUrl}/v2/prompt/${_model}');

    var body = json.encode({
      'message': question
    });

    var headers = {
      'Content-Type': 'application/json',
    };

    if (_apiUsername && _apiPassword) {
      headers = {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Basic ' + base64Encode('$_apiUsername:$_apiPassword')
      };
    }

    var result = await http.post(promptUrl, body: body, headers: headers);
    if (result.statusCode != 200) {
      throw Exception('API request failed with status code ${result.statusCode}');
    }

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
  void initState() {
    super.initState();
    _initModelsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _model,
                  items: _models.map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (String? model) {
                    _switchModel(model);
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Write your question here...',
                    ),
                    onSubmitted: (String question) {
                      _submitQuestion(question);
                    },
                    autofocus: true,
                  )
                )
              ]
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.refresh), 
                    SizedBox(width: 10),
                    Text('Regenerate response')
                  ],
                ),
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
