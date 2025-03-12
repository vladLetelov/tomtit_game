import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/models/question_model.dart';

final Map<int, LevelModel> levels = {
  1: LevelModel(
    levelNumber: 1,
    background: 'background.jpg',
    bulletSpeed: 300,
    meteorSpeed: 150,
    nicikSpeed: 200,
    bulletFrequency: 0.5,
    meteorFrequency: 0.2,
    nicikFrequency: 2.0,
    angryBirdBuffChance: 0.05,
    bulletFrequencyBuffChance: 0.05,
    extraLifeBuffChance: 0.03,
    threeBulletsBuffChance: 0.04,
    scoreForNextLevel: 1,
    videoPath: "zaglushkaVideo.mp4",
    questions: [
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько рук у человека (по стандарту)",
          variants: [
            "1 рука",
            "0 рук",
            "5 рук",
            "2 руки"
          ],
          rightAnswer: 3
      ),
      QuestionModel(
          question: "Что есть у каждого человека",
          variants: [
            "Руки",
            "Ноги",
            "Сознание",
            "Статус человека"
          ],
          rightAnswer: 3
      ),
    ]
  ),
  2: LevelModel(
    levelNumber: 2,
    background: 'background.jpg',
    bulletSpeed: 320,
    meteorSpeed: 160,
    nicikSpeed: 210,
    bulletFrequency: 0.45,
    meteorFrequency: 0.15,
    nicikFrequency: 2.0,
    angryBirdBuffChance: 0.06,
    bulletFrequencyBuffChance: 0.06,
    extraLifeBuffChance: 0.04,
    threeBulletsBuffChance: 0.05,
    scoreForNextLevel: 12,
    videoPath: "zaglushkaVideo.mp4",
    questions: [
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько рук у человека (по стандарту)",
          variants: [
            "1 рука",
            "0 рук",
            "5 рук",
            "2 руки"
          ],
          rightAnswer: 3
      ),
      QuestionModel(
          question: "Что есть у каждого человека",
          variants: [
            "Руки",
            "Ноги",
            "Сознание",
            "Статус человека"
          ],
          rightAnswer: 3
      ),
    ]
  ),
  3: LevelModel(
    levelNumber: 3,
    background: 'background.jpg',
    bulletSpeed: 340,
    meteorSpeed: 170,
    nicikSpeed: 220,
    bulletFrequency: 0.37,
    meteorFrequency: 0.13,
    nicikFrequency: 2.0,
    angryBirdBuffChance: 0.07,
    bulletFrequencyBuffChance: 0.07,
    extraLifeBuffChance: 0.05,
    threeBulletsBuffChance: 0.06,
    scoreForNextLevel: 15,
    videoPath: "zaglushkaVideo.mp4",
    questions: [
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько рук у человека (по стандарту)",
          variants: [
            "1 рука",
            "0 рук",
            "5 рук",
            "2 руки"
          ],
          rightAnswer: 3
      ),
      QuestionModel(
          question: "Что есть у каждого человека",
          variants: [
            "Руки",
            "Ноги",
            "Сознание",
            "Статус человека"
          ],
          rightAnswer: 3
      ),
    ]
  ),
  4: LevelModel(
    levelNumber: 4,
    background: 'background.jpg',
    bulletSpeed: 360,
    meteorSpeed: 180,
    nicikSpeed: 230,
    bulletFrequency: 0.35,
    meteorFrequency: 1.4,
    nicikFrequency: 3.5,
    angryBirdBuffChance: 0.08,
    bulletFrequencyBuffChance: 0.08,
    extraLifeBuffChance: 0.06,
    threeBulletsBuffChance: 0.07,
    scoreForNextLevel: 17,
    videoPath: "zaglushkaVideo.mp4",
    questions: [
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько рук у человека (по стандарту)",
          variants: [
            "1 рука",
            "0 рук",
            "5 рук",
            "2 руки"
          ],
          rightAnswer: 3
      ),
      QuestionModel(
          question: "Что есть у каждого человека",
          variants: [
            "Руки",
            "Ноги",
            "Сознание",
            "Статус человека"
          ],
          rightAnswer: 3
      ),
    ]
  ),
  5: LevelModel(
    levelNumber: 5,
    background: 'background.jpg',
    bulletSpeed: 380,
    meteorSpeed: 190,
    nicikSpeed: 240,
    bulletFrequency: 0.3,
    meteorFrequency: 1.2,
    nicikFrequency: 3.0,
    angryBirdBuffChance: 0.09,
    bulletFrequencyBuffChance: 0.09,
    extraLifeBuffChance: 0.07,
    threeBulletsBuffChance: 0.08,
    scoreForNextLevel: 20,
    videoPath: "zaglushkaVideo.mp4",
    questions: [
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
    ]
  ),
  6: LevelModel(
    levelNumber: 6,
    background: 'background.jpg',
    bulletSpeed: 400,
    meteorSpeed: 200,
    nicikSpeed: 250,
    bulletFrequency: 0.25,
    meteorFrequency: 1.0,
    nicikFrequency: 2.5,
    angryBirdBuffChance: 0.10,
    bulletFrequencyBuffChance: 0.10,
    extraLifeBuffChance: 0.08,
    threeBulletsBuffChance: 0.09,
    scoreForNextLevel: 25,
    videoPath: "zaglushkaVideo.mp4",
    questions: [
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
    ]
  ),
  7: LevelModel(
    levelNumber: 7,
    background: 'background.jpg',
    bulletSpeed: 420,
    meteorSpeed: 210,
    nicikSpeed: 260,
    bulletFrequency: 0.2,
    meteorFrequency: 0.8,
    nicikFrequency: 2.0,
    angryBirdBuffChance: 0.11,
    bulletFrequencyBuffChance: 0.11,
    extraLifeBuffChance: 0.09,
    threeBulletsBuffChance: 0.10,
    scoreForNextLevel: 30,
    videoPath: "zaglushkaVideo.mp4",
    questions: [
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
      QuestionModel(
          question: "Сколько пальцев на руке человека",
          variants: [
            "1 Палец",
            "2 Пальца",
            "5 Пальцев",
            "4 Пальца"
          ],
          rightAnswer: 2
      ),
    ]
  ),
};