import 'package:flutter/material.dart';
import 'package:tomtit_game/theme/colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepDarkPurple,
        title: const Text('Справка'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Фон на всю страницу
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: backgroundGradient),
          ),
          // Контент с прокруткой
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Как играть:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHelpItem('1. Изучите историю',
                    'Читайте карточки с историей и отвечайте на вопросы'),
                _buildHelpItem('2. Пройдите игру',
                    'Уклоняйтесь от метеоритов и собирайте монетки'),
                _buildHelpItem('3. Открывайте новые уровни',
                    'Набирайте достаточно очков для перехода на следующий уровень'),
                const SizedBox(height: 24),
                const Text(
                  'Управление на компьютере:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHelpItem('← →', 'Перемещение между карточками истории'),
                _buildHelpItem('Мышь', 'Выбор ответов'),
                _buildHelpItem(
                    'Зажать и двигать мышью', 'Управление игровым персонажем'),
                const SizedBox(height: 24),
                const Text(
                  'Управление на телефоне:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHelpItem('Пролистывание вправо/влево',
                    'Перемещение между карточками истории'),
                _buildHelpItem('Нажать', 'Выбор ответов'),
                _buildHelpItem('Зажать и двигать пальцем',
                    'Управление игровым персонажем'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
