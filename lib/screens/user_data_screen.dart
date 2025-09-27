// screens/user_name_screen.dart
import 'package:flutter/material.dart';
import 'package:tomtit_game/storage/user_data.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';
import 'package:tomtit_game/theme/colors.dart';

class UserNameScreen extends StatefulWidget {
  final VoidCallback? onNameSaved;
  const UserNameScreen({super.key, this.onNameSaved});

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitName() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await UserDataManager.saveUserName(_nameController.text.trim());

        if (mounted) {
          // Вызываем callback если он предоставлен
          widget.onNameSaved?.call();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка сохранения: $e')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Пожалуйста, введите ваше ФИО!';
    }

    final nameParts =
        value.trim().split(' ').where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      return 'Пожалуйста, введите фамилию, имя и отчество (полностью)!';
    }

    if (nameParts.length < 3) {
      return 'Рекомендуем ввести фамилию, имя и отчество для получения нициков!';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Заголовок
                Text(
                  'Добро пожаловать в игру!',
                  style: TextStyles.defaultStyle.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Иконка или изображение
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Форма ввода
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Для участия в игре и получения нициков необходимо ввести ФИО ПОЛНОСТЬЮ',
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Фамилия Имя Отчество',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: _validateName,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitName,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: deepDarkPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Начать игру',
                                      style: TextStyles.defaultStyle.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '* Ваши данные будут использоваться только для отправки нициков.',
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
