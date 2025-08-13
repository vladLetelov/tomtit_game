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
          pathImg: '/images/modulesImages/Module1Btn.png'),
      HistoryModel(
          title: 'ПРОРЫВ',
          description: 'Эпоха прорывов в космосе и вычислительной технике.'),
      HistoryModel(
          title: 'СТАРТ',
          description:
              'В это время СИНиЦА НИЦа начинает свое космическое путешествие.'),
    ],
    historyButtonPath: '/images/modulesImages/Module1Btn.png',
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
            pathImg: '/images/modulesImages/Module2Btn.png',
            isImageOnly: true),
        HistoryModel(
          title: '',
          pathImg: '/images/modulesImages/Module2Image1.png',
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
            pathImg: '/images/modulesImages/Module2Image2.png',
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
      historyButtonPath: '/images/modulesImages/Module2Btn.png'),
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
      scoreForNextLevel: 7,
      timeLimit: 60,
      sinicaSize: 100.0,
      history: [
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: 'assets/images/modulesImages/Module3Btn.png'),
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: '/images/modulesImages/Module3Image1.png'),
        HistoryModel(
            title: '',
            isImageOnly: true,
            pathImg: '/images/modulesImages/Module3Image2.png'),
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
            pathImg: '/images/modulesImages/Module2Image2.png',
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
            pathImg: '/images/modulesImages/Module4Btn.png'),
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
            pathImg: '/images/modulesImages/Module4Image1.png'),
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
      historyButtonPath: '/images/modulesImages/Module4Btn.png'),
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
      tripleSinicaMode: true,
      history: [
        HistoryModel(
            title: 'ЦЕННОСТЬ НИЦ',
            description:
                'НИЦ стремится к открытости и доступности информации.'),
        HistoryModel(
            title: 'ЭФФЕКТИВНАЯ КОММУНИКАЦИЯ',
            description:
                'Внедряются проекты по взаимодействию с руководителями, специалистами департаментов и подразделений.'),
        HistoryModel(
            title: 'ОТКРЫТОСТЬ',
            description:
                '2021 год – запущен проект «Есть вопрос!». Здесь можно задать интересующий вопрос руководству или линейному специалисту.'),
        HistoryModel(
            title: 'АКТУАЛЬНАЯ ИНФОРМАЦИЯ',
            description:
                '2024 год – запущен телеграм-канал СиНИЦа. Важные объявлениям, новости из жизни НИЦ, юмор и полезная информация теперь всегда под рукой!'),
        HistoryModel(
            title: 'КОРПОРАТИВНЫЕ МЕРОПРИЯТИЯ',
            description:
                'Гендерные и профессиональные праздники, День космонавтики, День программиста, Новый год для сотрудников и их детей.'),
        HistoryModel(
            title: 'ПОДДЕРЖКА',
            description:
                'Welcome-тренинги и адаптационные встречи – помощь и поддержка для новых сотрудников НИЦ.'),
        HistoryModel(
            title: 'LikeНИЦ',
            description:
                'Сервис благодарности и учета личной активности. Проявляйте инициативу и собирайте НИЦики – корпоративную валюту!'),
        HistoryModel(
            title: 'ниЦУМ',
            description:
                'Корпоративный онлайн-магазин. Обменивайте НИЦики на корпоративный мерч!'),
      ],
      historyButtonPath: 'assets/images/HistoryBtn5.png'),
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
      history: [
        HistoryModel(
            title: 'ИНДИВИДУАЛЬНЫЙ ПОДХОД',
            description:
                'В НИЦ ценят каждого сотрудника и стремятся создавать комфортные условия для работы и жизни.'),
        HistoryModel(
            title: 'БОНУСЫ И ЛЬГОТЫ',
            description: 'Значимая составляющая корпоративной политики НИЦ.'),
        HistoryModel(
            title: 'ПРОГРАММА ДМС',
            description:
                'Позволяет сотрудникам заботиться о своем здоровье и получать необходимую медицинскую помощь.'),
        HistoryModel(
            title: 'ПРОГРАММА ЦЕЛЕВОГО ОБУЧЕНИЯ',
            description:
                'Молодые сотрудники и дети сотрудников могут поступить на целевое обучение в высшие учебные заведения Санкт-Петербурга.'),
        HistoryModel(
            title: 'КОРПОРАТИВНЫЙ СПОРТ',
            description:
                'Возможность приобрести абонемент в любой спортивный клуб с компенсацией от компании.'),
        HistoryModel(
            title: 'КОМФОРТНЫЙ ОФИС',
            description:
                'Кофе-поинт, помещение для приема пищи для перерыва, настольный теннис.'),
      ],
      historyButtonPath: 'assets/images/HistoryBtn6.png'),
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
      history: [
        HistoryModel(
            title: 'СТРАТЕГИЧЕСКАЯ ЦЕЛЬ НИЦ',
            description:
                'Устойчивое развитие Общества как надежного партнера с уникальными наукоемкими технологиями и социально-ориентированного работодателя.'),
        HistoryModel(
            title: 'КОМПЛЕКСНЫЕ РЕШЕНИЯ',
            description:
                'НИЦ – клиентоориентированная компания, предлагающая комплексные программно-аппаратные решения на всех этапах жизненного цикла.'),
        HistoryModel(
            title: 'КВАЛИФИЦИРОВАННЫЕ СПЕЦИАЛИСТЫ',
            description:
                'Обладают уникальными знаниями и большим спектром научно-технических разработок.'),
        HistoryModel(
            title: 'НОВЕЙШИЕ ТЕХНОЛОГИИ',
            description:
                'ИИ, машинное обучение, компьютерное зрение, комплексная безопасность, обработку Big Data, связь и передача данных, БПЛА-системы и многое другое.'),
        HistoryModel(
            title: 'ДОЛГОСРОЧНЫЕ КОНТРАКТЫ',
            description:
                'Прочные деловые отношения с государственными структурами и возможность получения долгосрочных контрактов.'),
        HistoryModel(
            title: 'ВЫСОКИЙ УРОВЕНЬ РАБОТЫ',
            description:
                'Отлаженные бизнес-процессы, система менеджмента качества и гибкость к изменениям, гарантирующие высокий уровень работы.'),
        HistoryModel(
            title: 'ДОЛГОСРОЧНЫЕ ПЕРСПЕКТИВЫ',
            description:
                'Одно из приоритетных направлений развития в 2025 году станет внедрение искусственного интеллекта во все процессы компании.'),
      ],
      historyButtonPath: 'assets/images/HistoryBtn7.png'),
};
