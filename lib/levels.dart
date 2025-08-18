import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/models/history_model.dart';

final Map<int, LevelModel> levels = {
  1: LevelModel(
    levelNumber: 1,
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
    scoreForNextLevel: 1,
    timeLimit: 60,
    history: [
      HistoryModel(
          title: '',
          isImageOnly: true,
          pathImg: 'assets/images/modulesImages/Module1Btn.png'),
      HistoryModel(
          title: 'ПРОРЫВ',
          description: 'Эпоха прорывов в космосе и вычислительной технике.'),
      HistoryModel(
          title: 'СТАРТ',
          description:
              'В это время СИНиЦА НИЦа начинает свое космическое путешествие.'),
    ],
    historyButtonPath: 'assets/images/modulesImages/Module1Btn.png',
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
      scoreForNextLevel: 5,
      timeLimit: 30,
      history: [
        HistoryModel(
            title: '',
            pathImg: 'assets/images/modulesImages/Module2Btn.png',
            isImageOnly: true),
        HistoryModel(
          title: '',
          pathImg: 'assets/images/modulesImages/Module2Image1.png',
          isImageOnly: true,
        ),
        HistoryModel(
            title: 'РОЖДЕНИЕ',
            description:
                'Преодолевая время и пространство синица попала в момент зарождения компании'),
        HistoryModel(
          title: "ВОПРОС",
          description: "",
          questions: [
            Question(
              id: "level2_question1",
              questionText: "Помоги СИНИЦЕ разобраться, что это за место?",
              answers: [
                Answer(answerText: "НИИ телевидения (ВНИИТ)", isCorrect: false),
                Answer(
                    answerText: "НИИ радиотехники и телекоммуникаций (НИИРТ)",
                    isCorrect: false),
                Answer(answerText: "ЛЭТИ", isCorrect: true),
              ],
            ),
          ],
        ),
        HistoryModel(
            title: 'НИЦИКИ',
            description:
                'Отвечай на вопросы правильно и зарабатывай НИЦИКИ, внутреннюю валюту в игре.'),
        HistoryModel(
            title: 'ПЕРВЫЕ СОТРУДНИКИ',
            description:
                'Здесь Синица познакомилась с первыми сотрудниками организации Александром Владимировичем Экало, Вениамином Викторовичем Романцевым, Евгением Валентиновичем Постниковым, которые по настоящее время продолжают работают в НИЦ.'),
        HistoryModel(
            title: '',
            pathImg: 'assets/images/modulesImages/Module2Image2.png',
            isImageOnly: true),
      ],
      correctCard: HistoryModel(
        title: 'ПРАВИЛЬНО',
        description:
            'Синица угадала место! Первым шагом в истории предприятии стало создание научной лаборатории в Ленинградском электротехническом институте (ЛЭТИ) под руководством проректора В.И. Тимохина.',
        isResultCard: true,
        isCorrect: true,
      ),
      incorrectCard: HistoryModel(
        title: 'НЕПРАВИЛЬНО',
        description:
            'На самом деле Синица оказалась в стенах Ленинградского электротехнического университета (ЛЭТИ), именно здесь родилась лаборатория под руководством проректора В.И. Тимохина, которая стала отправной точкой в жизни компании.',
        isResultCard: true,
        isCorrect: false,
      ),
      historyButtonPath: 'assets/images/modulesImages/Module2Btn.png'),
  3: LevelModel(
      levelNumber: 3,
      background: 'background.jpg',
      bulletSpeed: 380,
      meteorSpeed: 170,
      nicikSpeed: 220,
      bulletFrequency: 0.37,
      meteorFrequency: 1.2,
      nicikFrequency: 2.0,
      angryBirdBuffChance: 0.07,
      bulletFrequencyBuffChance: 0.07,
      extraLifeBuffChance: 0.05,
      threeBulletsBuffChance: 0.06,
      scoreForNextLevel: 7,
      timeLimit: 60,
      sinicaSize: 70.0,
      history: [
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: 'assets/images/modulesImages/Module3Btn.png'),
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: 'assets/images/modulesImages/Module3Image1.png'),
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: 'assets/images/modulesImages/Module3Image2.png'),
        HistoryModel(
          title: "ВОПРОС",
          description: "",
          questions: [
            Question(
              id: "level3_question1",
              questionText:
                  "Помоги Синице правильно определить основную сферу деятельности компании",
              answers: [
                Answer(
                    answerText:
                        "Производство инструментов и приборов для измерения, тестирования и навигации",
                    isCorrect: false),
                Answer(
                    answerText:
                        "Научные исследования и разработки в области естественных и технических наук",
                    isCorrect: true),
                Answer(
                    answerText:
                        "Деятельность, связанная с использованием вычислительной техники и информационных технологий",
                    isCorrect: false),
              ],
            ),
          ],
        ),
        HistoryModel(
            title: 'Стратегические направления компании',
            description:
                'Под руководством главного конструктора и основателя компании Александра Владимировича Экало были сформированы стратегические направления деятельности и созданы первые команды разработчиков.'),
        HistoryModel(
            title: '',
            pathImg: 'assets/images/modulesImages/Module2Image2.png',
            isImageOnly: true),
      ],
      correctCard: HistoryModel(
        title: 'ПРАВИЛЬНО',
        description:
            'Ура! Регистрация пройдена, теперь НИЦ СПб ЭТУ независимая коммерческая компания, которая помогает решать сложные проблемы обработки, идентификации и распознавания сигналов.',
        isResultCard: true,
        isCorrect: true,
      ),
      incorrectCard: HistoryModel(
        title: 'НЕПРАВИЛЬНО',
        description:
            'На самом деле основной сферой деятельности компании стали «Научные исследования и разработки в области естественных и технических наук». ',
        isResultCard: true,
        isCorrect: false,
      ),
      historyButtonPath: 'assets/images/modulesImages/Module3Btn.png'),
  4: LevelModel(
      levelNumber: 4,
      background: 'background.jpg',
      bulletSpeed: 360,
      meteorSpeed: 180,
      nicikSpeed: 200,
      bulletFrequency: 0.5,
      meteorFrequency: 0.2,
      nicikFrequency: 2.0,
      angryBirdBuffChance: 0.05,
      bulletFrequencyBuffChance: 0.05,
      extraLifeBuffChance: 0.03,
      threeBulletsBuffChance: 0.04,
      scoreForNextLevel: 15,
      hasNiciks: false,
      hasColoredSinicis: true,
      coloredSinicaFrequency: 0.2,
      coloredSinicaSpeed: 200,
      timeLimit: 120,
      history: [
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: 'assets/images/modulesImages/Module4Btn.png'),
        HistoryModel(
            title: 'КОМПАНИЯ',
            description:
                'Синица всегда присматривает за своей любимой компанией, тем временем компания НИЦ СПБ ЭТУ выросла, набрала команду, проекты и активно покоряет рынок информационных технологий.'),
        HistoryModel(
            title: 'ГЕОГРАФИЯ КОМПАНИИ',
            description:
                'Компания НИЦ СПб ЭТУ охватила космодромы и полигоны Плесецк, Байконур, Копьяр и др. География проекта развернулась от Калининграда до Камчатки.'),
        HistoryModel(
          title: "ВОПРОС",
          description: "",
          questions: [
            Question(
              id: "level4_question1",
              questionText:
                  "Вопрос, как назывался один из первых, фундаментально значимых проектов компании?",
              answers: [
                Answer(answerText: "ОКР Обработка", isCorrect: true),
                Answer(answerText: "Практика СЗИ", isCorrect: false),
                Answer(answerText: "Указчик КВ", isCorrect: false),
              ],
            ),
          ],
        ),
        HistoryModel(
            title: '35 ЛЕТ',
            description:
                '35 лет – целая эпоха в мире технологий. От первых автоматизированных систем до искусственного интеллекта – НИЦ СПб ЭТУ не просто шел в ногу со временем. Компания создавала это время.'),
        HistoryModel(
          title: "ВОПРОС",
          description: "",
          questions: [
            Question(
              id: "level4_question2",
              questionText: "На каких ценностях базируется работа компании?",
              answers: [
                Answer(answerText: "Результативность", isCorrect: true),
                Answer(answerText: "Сотрудники", isCorrect: true),
                Answer(answerText: "Ответственность", isCorrect: true),
                Answer(answerText: "Клиентоориентированность", isCorrect: true),
                Answer(answerText: "Устойчивое развитие", isCorrect: true),
              ],
            ),
          ],
        ),
        HistoryModel(
            title: 'ИСТОРИЯ НИЦ СПб ЭТУ',
            description:
                'История НИЦ СПб ЭТУ – это история людей, идей и важных решений, ведущих в будущее.'),
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: 'assets/images/modulesImages/Module4Image1.png'),
      ],
      correctCard: HistoryModel(
        title: 'ПРАВИЛЬНО',
        description:
            'Верно! Одним из первых фундаментальных проектов компании стал ОКР «Обработка» (обработка и анализ измерительной информации).',
        isResultCard: true,
        isCorrect: true,
      ),
      incorrectCard: HistoryModel(
        title: 'НЕПРАВИЛЬНО',
        description:
            'Зафиксируем важное уточнение, именно ОКР «Обработка» стал отправной точкой: с анализа и обработки измерительных данных начался наш путь в отрасли.',
        isResultCard: true,
        isCorrect: false,
      ),
      historyButtonPath: 'assets/images/modulesImages/Module4Btn.png'),
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
      scoreForNextLevel: 17,
      tripleSinicaMode: true,
      timeLimit: 120,
      history: [
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: 'assets/images/modulesImages/Module5Btn.png'),
        HistoryModel(
            title: 'ЧИСЛЕННОСТЬ',
            description:
                'За последние три года численность сотрудников компании выросла более чем в два раза.'),
        HistoryModel(
          title: "ВОПРОС",
          description: "",
          questions: [
            Question(
              id: "level5_question1",
              questionText: "Что Синица может предложить сотрудникам?",
              answers: [
                Answer(
                    answerText: "Программы заботы о здоровье сотрудников",
                    isCorrect: true),
                Answer(
                    answerText:
                        "Программы роста, развития и построения карьеры",
                    isCorrect: true),
                Answer(
                    answerText: "Семейные бонусные программы", isCorrect: true),
                Answer(
                    answerText:
                        "Гибкий подход организации работы, функционалу и бонусированию.",
                    isCorrect: true),
              ],
            ),
          ],
        ),
        HistoryModel(
            title: 'ЛЮДИ',
            description:
                'Талантливые люди – главный актив НИЦ. Мы создаем среду, где каждый специалист может раскрыть свой потенциал и расти вместе с компанией.'),
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: 'assets/images/modulesImages/Module5Image1.png'),
      ],
      correctCard: HistoryModel(
        title: 'ПРАВИЛЬНО',
        description:
            'Построение справедливой системы мотивации. Удержание ключевых специалистов и развитие научно-технического потенциала – приоритет для компании. Мы создаем индивидуальную корпоративную культуру, повышающую вовлеченность сотрудников в работу, при которой стратегически важными направлениями являются программы профессионального роста, корпоративного обучения.',
        isResultCard: true,
        isCorrect: true,
      ),
      incorrectCard: HistoryModel(
        title: 'НЕПРАВИЛЬНО',
        description:
            'Построение справедливой системы мотивации. Удержание ключевых специалистов и развитие научно-технического потенциала – приоритет для компании. Мы создаем индивидуальную корпоративную культуру, повышающую вовлеченность сотрудников в работу, при которой стратегически важными направлениями являются программы профессионального роста, корпоративного обучения.',
        isResultCard: true,
        isCorrect: false,
      ),
      historyButtonPath: 'assets/images/modulesImages/Module5Btn.png'),
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
    scoreForNextLevel: 20,
    timeLimit: 80,
    history: [
      HistoryModel(
          title: '',
          isImageOnly: true,
          pathImg: 'assets/images/modulesImages/Module6Btn.png'),
      HistoryModel(
          title: 'ВЕКТОР ДВИЖЕНИЯ',
          description:
              'Наш вектор движения—развивать государственный и коммерческий рынок, создавать качественные продукты и решения, помогать клиентам добиваться целей, продвигать существующие продукты внедрять инновации, развивать команду и оставаться лидерами в технологиях. Это залог нашего успеха и роста.'),
      HistoryModel(
          title: 'ИННОВАЦИИ',
          description:
              'Компания разрабатываем и внедряем новейшие технологии: искусственный интеллект, машинное обучение, компьютерное зрение, комплексная безопасность, обработку Big Data, связь и передача данных, беспилотные системы и многое другое.'),
      HistoryModel(
          title: 'УНИКАЛЬНОСТЬ',
          description:
              'Постоянные инновации, сбалансированное управление финансами, выращивание и удержание талантов, гибкость и управление изменениями, клиенториентированность – то, что делает НИЦ уникальной организацией.'),
      HistoryModel(
          title: 'СТРАТЕГИЯ',
          description:
              'НИЦ вступает в новый этап своего развития, утверждая стратегию на 2025–2030 годы. Это не просто документ - это философия будущего. В её основе лежит концепция «стратегия ментальных перемен».'),
      HistoryModel(
        title: "ВОПРОС",
        description: "",
        questions: [
          Question(
            id: "level6_question1",
            questionText:
                "Что из перечисленного относится к стратегическим целям компании?",
            answers: [
              Answer(
                  answerText: "Пунктуальность как стандарт", isCorrect: true),
              Answer(
                  answerText: "Внедрение дресс-кода по пятницам",
                  isCorrect: false),
              Answer(
                  answerText: "Ежегодный рост собственного объема работ (СОР)",
                  isCorrect: true),
              Answer(answerText: "Возврат на инвестиции", isCorrect: true),
              Answer(answerText: "Ежегодная рентабельность", isCorrect: true),
              Answer(answerText: "HR-прорыв", isCorrect: true),
              Answer(
                  answerText: "Победить в конкурсе на лучший Telegram чат.",
                  isCorrect: false),
            ],
          ),
        ],
      ),
    ],
    correctCard: HistoryModel(
      title: 'ПРАВИЛЬНО',
      description:
          'К стратегическим целям компании относятся пунктуальность как стандарт, ежегодный рост собственного объема работ, возврат на инвестиции, ежегодная рентабельность и HR-прорыв.',
      isResultCard: true,
      isCorrect: true,
    ),
    incorrectCard: HistoryModel(
      title: 'НЕПРАВИЛЬНО',
      description:
          'К стратегическим целям компании относятся пунктуальность как стандарт, ежегодный рост собственного объема работ, возврат на инвестиции, ежегодная рентабельность и HR-прорыв.',
      isResultCard: true,
      isCorrect: false,
    ),
    historyButtonPath: 'assets/images/modulesImages/Module6Btn.png',
    victorySlideshowImages: [
      'assets/images/EndSlideShow/FinalImage1.png',
      'assets/images/EndSlideShow/FinalImage2.png',
      'assets/images/EndSlideShow/FinalImage3.png',
    ],
    victorySlideshowBackground:
        'assets/images/EndSlideShow/SlideShowBackground.png',
  ),
};
