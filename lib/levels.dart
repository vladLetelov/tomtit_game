import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/models/question_model.dart';
import 'package:tomtit_game/models/history_model.dart';

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
          variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
          rightAnswer: 2),
      QuestionModel(
          question: "Сколько рук у человека (по стандарту)",
          variants: ["1 рука", "0 рук", "5 рук", "2 руки"],
          rightAnswer: 3),
      QuestionModel(
          question: "Что есть у каждого человека",
          variants: ["Руки", "Ноги", "Сознание", "Статус человека"],
          rightAnswer: 3),
    ],
    history: [
      HistoryModel(
          title: 'КОНЕЦ 60-Х ГОДОВ',
          description:
              'На базе Ленинградского электротехнического института (ЛЭТИ) создана научная лаборатория.'),
      HistoryModel(
          title: 'ГЛАВНАЯ ЗАДАЧА',
          description:
              'Решение сложных проблем обработки, идентификации и распознавания сигналов в различных прикладных сферах.'),
      HistoryModel(
          title: 'ПЕРВЫЕ СОТРУДНИКИ',
          description:
              'Александр Владимирович Экало, Вениамин Викторович Романцев, Евгений Валентинович Постников – по настоящий день работают в НИЦ СПБ ЭТУ.'),
      HistoryModel(
          title: '2 АВГУСТА 1990 ГОДА',
          description: 'Зарегистрировано малое предприятие «НИЦ ЛЭТИ».'),
      HistoryModel(
          title: 'ПРОФИЛЬ ДЕЯТЕЛЬНОСТИ',
          description:
              'Оказание услуг в решении производственных и научно-технических проблем в области радиотехники, информатики, электроники и электротехники.'),
      HistoryModel(
          title: 'СТАНОВЛЕНИЕ И РАЗВИТИЕ',
          description:
              'Большой вклад в становление и развитие предприятия внес первый и бессменный на протяжении 18 лет директор НИЦ Олег Иванович Корнилов.'),
      HistoryModel(
          title: 'ЛИЧНЫЙ ВКЛАД',
          description:
              'А.В. Экало сформировал стратегические направления НИЦ и создал команды разработчиков.'),
      HistoryModel(
        title: "ВОПРОС",
        description: "",
        questions: [
          Question(
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
    ],
    historyButtonPath: 'assets/images/HistoryBtn1.png',
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
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько рук у человека (по стандарту)",
            variants: ["1 рука", "0 рук", "5 рук", "2 руки"],
            rightAnswer: 3),
        QuestionModel(
            question: "Что есть у каждого человека",
            variants: ["Руки", "Ноги", "Сознание", "Статус человека"],
            rightAnswer: 3),
      ],
      history: [
        HistoryModel(
            title: 'НИЦ СПб ЭТУ',
            description:
                'Динамично развивающаяся компания, объединяющая передовые IT-технологии, уникальные научные достижения и проверенные временем практики.'),
        HistoryModel(
            title: 'ЗА 35 ЛЕТ СО ДНЯ ОСНОВАНИЯ',
            description:
                'НИЦ заняло передовые позиции на рынке информационных технологий.'),
        HistoryModel(
            title: 'РАЗРАБОТКА',
            description:
                'НИЦ – системный интегратор и разработчик информационного и ПО вычислительных комплексов и автоматизированных систем обработки данных.'),
        HistoryModel(
            title: 'ЛИДЕРСТВО',
            description:
                'НИЦ – один из ведущих предприятий отрасли по разработке и сервисному обслуживанию информационных систем.'),
        HistoryModel(
            title: 'АВТОМАТИЗАЦИЯ И АНАЛИЗ',
            description:
                'НИЦ разработал и ввел в эксплуатацию целое поколение автоматизированных систем и комплексов сбора, обработки и анализа измерительной информации.'),
        HistoryModel(
            title: 'НАУКА',
            description:
                'Большое внимание уделяет инновационным разработкам и сотрудничеству в научно-технических направлениях.'),
        HistoryModel(
            title: 'СОТРУДНИЧЕСТВО',
            description:
                'НПО «СТАРЛАЙН»  – разработаны программные модули для системы технического зрения беспилотного тягача.'),
        HistoryModel(
            title: 'ИННОВАЦИЯ И РАЗВИТИЕ',
            description:
                'MVP – работа с БПЛА и применением средств искусственного интеллекта.'),
      ],
      historyButtonPath: 'assets/images/HistoryBtn2.png'),
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
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько рук у человека (по стандарту)",
            variants: ["1 рука", "0 рук", "5 рук", "2 руки"],
            rightAnswer: 3),
        QuestionModel(
            question: "Что есть у каждого человека",
            variants: ["Руки", "Ноги", "Сознание", "Статус человека"],
            rightAnswer: 3),
      ],
      history: [
        HistoryModel(
            title: 'НИЦ',
            description:
                'НИЦ гордится внутренними ресурсами и проектами, которые помогают каждому сотруднику развиваться и достигать успеха.'),
        HistoryModel(
            title: 'ЛОКАЛЬНЫЕ ИИ-ПЛАТФОРМЫ',
            description:
                '«НейроПоиск» и «ИИ-помощник» – поддерживают сотрудников в их ежедневной деятельности.'),
        HistoryModel(
            title: 'БИБЛИОТЕКА НИЦ',
            description:
                'Печатные и электронные материалы (книги, журналы, научные публикации и др.)'),
        HistoryModel(
            title: 'LMS-СИСТЕМА',
            description: 'Уникальные курсы для непрерывного развития.'),
        HistoryModel(
            title: 'БАЗА ЗНАНИЙ (WIKI)',
            description:
                'Актуальная информация и полезные материалы по ключевым проектам и направлениям НИЦ, справочные материалы для решения рабочих задач.'),
        HistoryModel(
            title: 'КАРЬЕРНОЕ РАЗВИТИЕ',
            description:
                'Система наставничества и кадрового резерва – помогаем расти внутри компании.'),
        HistoryModel(
            title: 'КОРПОРАТИВНЫЙ УНИВЕРСИТЕТ',
            description:
                'ЦРТРИС – уникальная возможность получить практический опыт работы в передовых областях и научных сферах.'),
      ],
      historyButtonPath: 'assets/images/HistoryBtn3.png'),
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
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько рук у человека (по стандарту)",
            variants: ["1 рука", "0 рук", "5 рук", "2 руки"],
            rightAnswer: 3),
        QuestionModel(
            question: "Что есть у каждого человека",
            variants: ["Руки", "Ноги", "Сознание", "Статус человека"],
            rightAnswer: 3),
      ],
      history: [
        HistoryModel(
            title: 'КОЛЛЕКТИВ НИЦ',
            description:
                'Основа научно-производственного коллектива – научные сотрудники, преподаватели, аспиранты и студенты ведущих кафедр университета: МО ЭВМ, ВМ-1, ВТ.'),
        HistoryModel(
            title: 'ДЕЯТЕЛЬНОСТЬ',
            description:
                'НИЦ занимается проектированием, разработкой, реинжинирингом, мониторингом и сервисным обслуживанием IT-систем.'),
        HistoryModel(
            title: 'ОСНОВНОЕ НАПРАВЛЕНИЕ',
            description:
                'Разработка средств автоматического сбора и обработки измерительной информации.'),
        HistoryModel(
            title: 'КОНСТРУКТОРСКОЕ НАПРАВЛЕНИЕ',
            description:
                'Проектирование и разработка автоматизированных систем.'),
        HistoryModel(
            title: 'ПРОГРАММИРОВАНИЕ',
            description:
                'Разработчиком информационного и программного обеспечения, создание обучающих систем и программных тренажеров.'),
        HistoryModel(
            title: 'НАУЧНОЕ НАПРАВЛЕНИЕ',
            description:
                'Разработка интеллектуальных транспортных систем на основе ГЛОНАСС/GPS, систем видеонаблюдения и анализа изображений.'),
        HistoryModel(
            title: 'АНАЛИТИЧЕСКОЕ НАПРАВЛЕНИЕ',
            description:
                'Разработка систем планирования, документооборота и поддержки принятия управленческих решений.'),
        HistoryModel(
            title: 'СОПРОВОЖДЕНИЕ И СЕРВИС',
            description:
                'Эксплуатация и обслуживание программного обеспечения и IT-систем.'),
        HistoryModel(
            title: 'СОБСТВЕННОЕ ПРОИЗВОДСТВО',
            description:
                'Сборка и изготовление продуктов НИЦ, испытания изделий, отгрузка готовой продукции заказчикам.'),
      ],
      historyButtonPath: 'assets/images/HistoryBtn4.png'),
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
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько пальцев на руке человека",
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько пальцев на руке человека",
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
      ],
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
      videoPath: "zaglushkaVideo.mp4",
      questions: [
        QuestionModel(
            question: "Сколько пальцев на руке человека",
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько пальцев на руке человека",
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько пальцев на руке человека",
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
      ],
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
      videoPath: "zaglushkaVideo.mp4",
      questions: [
        QuestionModel(
            question: "Сколько пальцев на руке человека",
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько пальцев на руке человека",
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
        QuestionModel(
            question: "Сколько пальцев на руке человека",
            variants: ["1 Палец", "2 Пальца", "5 Пальцев", "4 Пальца"],
            rightAnswer: 2),
      ],
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
