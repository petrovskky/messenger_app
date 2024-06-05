import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:messenger/data/data_sources/interfaces/i_preference_data_source.dart';
import 'package:messenger/domain/entities/language.dart';
import 'package:messenger/presentation/di/injector.dart';
import 'package:messenger/data/utils/translator.dart';

class TranslateDialog extends StatefulWidget {
  final String originText;

  const TranslateDialog({
    super.key,
    required this.originText,
  });

  @override
  TranslateDialogState createState() => TranslateDialogState();
}

class TranslateDialogState extends State<TranslateDialog> {
  late Language _selectedLanguage;
  String? _translatedText;

  @override
  void initState() {
    _selectedLanguage = getIt.get<IPreferenceDataSource>().messageLanguage;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _translatedText = await Translator.translate(
        widget.originText,
        _selectedLanguage,
      );
      setState(() {});
    });
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<Language>(
                  value: _selectedLanguage,
                  onChanged: (Language? newValue) async {
                    _selectedLanguage = newValue ?? _selectedLanguage;
                    _translatedText = await Translator.translate(
                      widget.originText,
                      _selectedLanguage,
                    );
                    setState(() {
                      getIt.get<IPreferenceDataSource>().messageLanguage = _selectedLanguage;
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
