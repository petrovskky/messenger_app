import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TranslateDialog extends StatefulWidget {
  final String originText;
  final Language? lang;
  final Future<String> Function(String text) onTranslate;

  const TranslateDialog({
    super.key,
    required this.originText,
    required this.lang,
    required this.onTranslate,
  });

  @override
  TranslateDialogState createState() => TranslateDialogState();
}

class TranslateDialogState extends State<TranslateDialog> {
  late Language _selectedLanguage;
  String? _translatedText;

  @override
  void initState() {
    _selectedLanguage = widget.lang ?? Language.English;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<Language>(
                  value: _selectedLanguage,
                  onChanged: (Language? newValue) async {
                    _translatedText = await widget.onTranslate(widget.originText);
                    setState(() {
                      _selectedLanguage = newValue ?? _selectedLanguage;
                    });
                  },
                  items: Language.values.map((Language language) {
                    return DropdownMenuItem<Language>(
                      value: language,
                      child: Text(
                        language.name.tr(),
                      ),
                    );
                  }).toList(),
                ),
                Text(_translatedText ?? widget.originText),
              ],
            ),
          ),
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.close,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
