//
//  File.swift
//  
//
//  Created by Arnold Jvsvy on 18.09.2022.
//

import Foundation
import Vapor
import telegram_vapor_bot
//MARK:- Extension for String
extension String {
    func appendLineToURL(fileURL: URL) throws {
         try (self + "\n").appendToURL(fileURL: fileURL)
     }

     func appendToURL(fileURL: URL) throws {
         let data = self.data(using: String.Encoding.utf8)!
         try data.append(fileURL: fileURL)
     }
 }
//MARK:- Extension for File data
extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
final class DefaultBotHandlers {
    
    
    static func addHandlers(app: Vapor.Application, bot: TGBotPrtcl) {
        defaultHandler(app: app, bot: bot)
        commandPingHandler(app: app, bot: bot)
        commandShowButtonsHandler(app: app, bot: bot)
        buttonsActionHandler(app: app, bot: bot)    
    }
    
    private static func defaultHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGMessageHandler(filters: (.all && !.command.names(["/ping", "/show_buttons"]))) { update, bot in
            let date = Date()
            let format = DateFormatter()
            
            format.timeZone = TimeZone(identifier: "UTC +6")
            format.timeStyle = .long
            format.dateStyle = .short
            
            
          
            if update.message?.text != nil {
               // print("\(format.string(from: date)); litl nis bot:   \(update.message?.text ?? "Error")")
                do {
                    let workPath = DirectoryConfiguration.detect().workingDirectory
                    let workPathURL = URL(fileURLWithPath: workPath)
                    
                  //  let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
                     let url = workPathURL.appendingPathComponent("logFile.txt")

                    try "\(format.string(from: date)); litl nis bot:   \(update.message?.text ?? "Error")".appendLineToURL(fileURL: url.standardized as URL)
                 }
                 catch {
                     print("Something went wrong:  \(error)")
                 }
//                func workingDirectoryURL(with components: [String] = []) throws -> URL {
//
//                    components.forEach { component in workPathURL = workPathURL.appendingPathComponent(component) }
//                    return workPathURL
//                }
            } else {
                print("Error")
            }
            
        }
        bot.connection.dispatcher.add(handler)
        
    }
    
    private static func commandPingHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/start"]) { update, bot in
            try update.message?.reply(text: """
Приветствую вас, \(update.message?.from?.firstName ?? "anonymous") ! 🙋‍♂️

Я Телеграм-Бот самоуправления НИШ Талдыкорган.


Я могу ответить на любые интересующие вас вопросы, выберите что вы хотите спросить:

1.    Популярные вопросы. ✨

2.   Книга жалоб и предложений / Написать нам. 📪

3.   Структура самоуправления. 🌊

4.   Список клубов. 📋

5.   Что делает парламент? 🔎

6.   TG членов самоуправления. 🪬

7.   Хочу записаться
      на профориентацию! 🔭

8.  Какие экзамены пишут в НИШе? 📝

9.  Что делать если появились
      трудности в учёбе? 🙇🏻‍♂️
""", bot: bot)}
        let handlerBella = TGMessageHandler(filters: .regexp(pattern: "/start")) {update, bot in
            try update.message?.reply(text: """
Материалы по подготовке экзаменам: SAT 🇺🇸 x IELTS 📚   🧞‍♂️
👇
@Bellanicas_bot
""", bot: bot)
        }
        
        let handler3 = TGMessageHandler(filters: .regexp(pattern: "^2$")) {update, bot in
            try update.message?.reply(text: "2. Следующие ваши сообщения будут обязательно рассмотрены и приняты ! 😇", bot: bot)
        }
        let handler9 = TGMessageHandler(filters: .regexp(pattern: "^9$")) {update, bot in
            try update.message?.reply(text: """
                                                                     1️⃣ Причина: ❌

 Для того чтобы справиться с трудностями в учебе, необходимо выявить причину их возникновения. Подумайте, что мешает вашему обучению. Возможно, вы недостаточно внимания уделяете самостоятельной подготовке, надеясь на то, что сможете усвоить материал без этого. Может быть, вы устали и поэтому плохо воспринимаете новый материал. Помните, что не разобравшись в сути проблемы, вы не сможете ее решить. 

                                                                     2️⃣ Помощь: 🙇🏻‍♂️ 📖

 Обратитесь за помощью к преподавателю, попросив позаниматься с вами индивидуально. На сегодняшний день репетиторство достаточно распространено, и это не составит труда. Работая с преподавателем наедине, вы будете иметь возможность задавать вопросы по ходу объяснения материала, а ему будет проще контролировать процесс. Если вы что-то не поймете, педагог сразу же узнает об этом, поскольку «отсидеться» не получится.

                                                                     3️⃣ Самообразование: 📚 📝 🔍

 Больше времени уделяйте самообразованию. Читайте книги, причем, не только по предмету, с изучением которого возникли сложности. Чем шире будет ваш кругозор, тем проще будет учиться. Тем не менее, специальную литературу читать тоже необходимо. Нужно заметить, что научные работы кажутся скучными только вначале.

                                                                     4️⃣ Питание: 🍌 🥚 🍼

 Следите за своим рационом. Особенно эта рекомендация актуальна в осенний и весенний периоды, когда люди получают с пищей недостаточное количество витаминов. Помните, что для нормального функционирования мозга, организм должен получать необходимые ему вещества. Ешьте орехи, овощи и фрукты, богатые антиоксидантами, защищающими мозг. Не стоит забывать и о продуктах с высоким содержанием белка – молоке, мясе и яйцах.

                                                                     5️⃣ Сон: 😴 🛌 ✅

 Помните, что лучше прочитать на сто страниц меньше, но вовремя лечь спать. Уставший человек все равно плохо понимает прочитанное. Хотя запомнить материал легче именно в вечерние часы. Найдите оптимальное время для отхода ко сну, чтобы всегда высыпаться. Мозгу необходим полноценный отдых. Не спешите. Если не лениться, то все можно успеть.

""", bot: bot)
        }
        let handler11 = TGMessageHandler(filters: .regexp(pattern: "^7$")) {update, bot in
            try update.message?.reply(text: """
7. Школьный Профориентатор
 - Айгерим Шаймерденова

Обращаться сюда 👇
                                  +7 778 100 3250

Для записи ко мне на личную консультацию:

https://calendly.com/a-shajmerdenova/onsultation-with-a-career-counselor
""", bot: bot)}
        let handler4 = TGMessageHandler(filters: .regexp(pattern: "^1$"), options: .Element(rawValue: 1)) { update, bot in
            try update.message?.reply(text: """
1. Популярные вопросы:

❓ Q1: Что такое школьное самоуправление?

✅ A1: Основной целью деятельности ученического самоуправления является реализация прав учащихся на участие в управлении школой, воспитание личности с яркими организаторскими качествами, лидера, способного принимать решения, ответственного и дисциплинированного, готового самостоятельно сделать выбор и обладающего активной жизненной позицией.

Основными направлениями организуемых мероприятий являются спорт, социальная сфера, культура, повышение ответственности, устранение потребительских отношений. Каждый член нашей команды является лучшим в своем направлении. В ходе работы мы учимся отстаивать интересы учащихся, а также учитываем мнения всех

Интересная школьная жизни напрямую связана с активной деятельностью ученического самоуправления. Мы обещаем, трудиться в этом направлении и будем  постоянно стремимся к новаторству!
----------------------------------------
❓ Q2: В чем отличия Вице-президента и Премьер-Министра?

✅ A2: Обязанности Премьер Министра:
1. Создание необходимых условий для сплочения коллектива министров;
2. Следит за исполнительной частью министерства.

Вице-Президент:
1. Организует и координирует работу школьных органов ученического самоуправления;
2. Заменяет президента в случае отсутствия  – заместитель Президента;
3. Обладает теми же привилегиями что и президент.


""", bot: bot)}
        let handler8 = TGMessageHandler(filters: .regexp(pattern: "^6$")) {update, bot in
            try update.message?.reply(text: """
6.  Амирлан Кайнарбеков (президент)
@memerlain

Әбілмәжін Аяулым (вице-президент)
@meowayau
    
Алишер Бекмустафаев (спикер парламента)
@sher_fon_gertzen
    
Емберген Арнур (премьер-министр)
@arnie808
    
Шылбы Жания (министр культуры)
@zhaneeek
    
Әбділдің Әмір (министр образования)
@notamirabdildin
    
Курманбаева Инкар (медиа министр)
@kuramokadze
    
Дунгенбай Ерали (министр спорта)
@yeerali
    
Садыкова Рамиля (министр внутр. дел)
@inowrez
    
Ерланқызы Дарина (министр внешн. дел)
@darinayerlan

""", bot: bot)}
        let handler5 = TGMessageHandler(filters: .regexp(pattern: "^4$")) {update, bot in
            try update.message?.reply(text: """
5.1 ORNEKDIY 🎨 🪢 🪡

    ORNEK -  это узор, DIY - сделай сам. Наша цель показать особенному ребенку, что каждый может создать свой узор, рисунок.

    Ерланқызы Дарина:
    +7(747)-795-43-87

5.2 PJC 👩🏻‍💻 ⚙️ 💻

    Предоставить возможность беспрепятственно обучиться языкам программирования, с нужной поддержкой и обратной связью.

    Шокобалинов Даниал:
    +7(708)-313-92-42

5.3 Юные психологи 🌄

    Помочь ученикам развить их знания в психологической сфере, предоставлять поддержку учащимся.

    Жуматай Жания:
    +7(707)-818-11-00

5.4 Жас қаламгер 🇰🇿 📚 🔍
    
    Совершенствование языковых и литературных способностей детей, вклад в развитие казахского языка.

    Кенжебек Жәнібек:
    +7(776)-288-75-52

5.5 Dubclub 🗣 🌎 📊

    Развитие Казахского языках в Казахстанском медиапространстве.

    Арпабаев Алинур.

5.6 Bala Dausy 👼🏻 💙 🫂

    Продвижение идей о защите прав детей через содействие в распространение информации о правах детей на просторах социальных сетей и участие в движениях направленных на защиту прав детей.

    Туркебай Мадина:
    +7(707)-320-32-92

5.7 Bookmate 📚

    Волонтерство в  библиотеке, объяснение учащимся школы ценность книг.
    Құрманқұл Нұрислам.

5.8 Red Carpet 🧵 🪡

    Увеличить интерес молодежи на дизайн и шитье
    - создать общество с интересами дизайна, где люди могут найти общие интересы и подружиться.
    - обогащать молодежь знанием основ дизайна и шитья.

    Төлеген Зейнеп:
    +7(700)-992-97-85

5.9 Self-Defense 🤼

    Научить учеников приемам по самообороне, чтобы они смогли защищать себя в непредвиденных обстоятельствах.

    Тұрсынхан Аяжан:
    +7(776)-967-69-40

5.10 Wikipedia 🌎

    Увеличение достоверных и качественных статей на казахском языке в свободной энциклопедии «Википедия».

    Енсебаева Айсана:
    +7(747)-202-10-05

5.11 Cube Club 🧩 🎲

    Популяризировать сферу «спидкубинг», то есть решение разных головомок на скорость. Наряду с этим, обучать учащихся сборке головоломок различных уровней сложности, а также развитию навыков мелкой моторики, памяти, логики и реакции.

    Пусырманов Абай:
    +7(700)-200-61-94

5.12 Literature club 📖 🔍 🤩

    Формирование навыков в литературной сфере, увеличить интерес к литературным произведениям.

    Қалияс Алихан.

5.13 Клуб волонтеров НИШ Талдыкорган 🌱 🌿 🎋

    Развитие волонтерского движения в школе через привлечение учащихся в проекты, мероприятия, акции и ярмарки по служению обществу.

    Тынысхан Айғаным:
    +7(702)-098-84-62

5.14 TEDx 👩🏻‍🎓

    Расширение кругозора всех слушателей и спикера; предоставление новых идей и вдохновения для размышления; обсуждение актуальных и интересных тем.

    Жеңіснұр Айбол:
    +7(708)-190-21-60

    Енсебаева Айсана:
    +7(747)-202-10-05

5.15 SM dance club 💃 🕺

    Развитие танцевальных навыков в разных жанрах среди учащихся. Улучшение физической активности и креативности в повседневной жизни.

    Макетаева Айгуль:
    +7(776)-713-56-36

5.16 Delicado ✍️ 🖼

    Способствовать развитию творческого потенциала у учащихся и расширению территории современного искусства.

    Іңкәр Мейірхан:
    +7(778)-798-53-33

5.17 Bookdragons 📚 🐉

    Увеличить интерес учащихся к чтению книг через проведение активити и акции.

    Асантай Нигара:
    +7(708)-025-26-93

5.18 Debate Club 🧠 🗣

    Формировать лидеров, умеющих аргументировать свою позицию и мыслить критически, способствовать повышению уровня английского языка.

    Сурин Максим:
    +7(708)-958-65-70

5.19 letwik. 🌳 🍃 🧤

    Проект направлен на очищение и переработку мусора нашего зелёного города - Талдыкорган. Проект успел провести несколько выходов в город, где успешно провели свою операцию.

    Емберген Арнұр:
    +7(775)-937-08-89

    Ерланұлы Нұрсұлтан:
    +7(775)-584-31-51

5.20 Planticom 🪴 🌱

    Развивать интерес учащихся к комнатным растениям и создать условия по благоустройству и озеленению школы.

    Нұрмахан Анар:
    +7(747)-774-47-35
""", bot: bot)}
     
        let handler15 = TGMessageHandler(filters: .regexp(pattern: "^3$")) {update, bot in
            if let id = update.message?.chat.id {
                let chatId: TGChatId = .chat(id)
                let file: TGFileInfo = .url("https://imgur.com/a/mFDSsVH")
                let params: TGSendPhotoParams = .init(chatId: chatId, photo: file)
                try bot.sendPhoto(params: params)
                try update.message?.reply(text: "Структура Самоуправления.", bot: bot)
            }
        }

        let handlerArnie = TGMessageHandler(filters: .regexp(pattern: "Арнур гений")) {update, bot in
            if let id = update.message?.chat.id {
                let chatId: TGChatId = .chat(id)
                let file: TGFileInfo = .url("https://imgur.com/a/9MPSas0")
                let params: TGSendPhotoParams = .init(chatId: chatId, photo: file)
                try bot.sendPhoto(params: params)
                try update.message?.reply(text: "салам", bot: bot)
            }
        }
        let handlerPorn = TGMessageHandler(filters: .regexp(pattern: "Порно")) {update, bot in
            if let id = update.message?.chat.id {
                let chatId: TGChatId = .chat(id)
                let file: TGFileInfo = .url("https://imgur.com/a/Mgf9Q87")
                let params: TGSendPhotoParams = .init(chatId: chatId, photo: file)
                try bot.sendPhoto(params: params)
            }
        }
        let handlerPorn1 = TGMessageHandler(filters: .regexp(pattern: "порно")) {update, bot in
            if let id = update.message?.chat.id {
                let chatId: TGChatId = .chat(id)
                let file: TGFileInfo = .url("https://imgur.com/a/Mgf9Q87")
                let params: TGSendPhotoParams = .init(chatId: chatId, photo: file)
                try bot.sendPhoto(params: params)
            }
        }
        let handler10 = TGMessageHandler(filters: .regexp(pattern: "^8$")){update, bot in
            try update.message?.reply(text: """
Многие 10 классники в начале года не понимают зачем им Кембриджский экзамен, что он им дает, что он из себя представляет и как к нему готовится. Еще многие просто забивают на него, думая что аттестат 10 класса им абсолютно не нужен.

1)Ведущие университеты мира не просят аттестат средней школы, однако он на прямую влияет на ваш GPA.

2) Экзамен 10 класса не такой уж сложный, но при подготовке можно увидеть какие способы подготовки к экзамену для вас самые удобные, какой режим сна помогает сохранять баланс в течении дня и т.д. 10 класс время экспериментов, ведь начиная с 11 класса все мы начинаем готовится к IELTS/SAT/NUET/ Cambridge examination A levels и т.д. В течении 10 класса вы сможете попробовать разные методики подготовки, выбрать для себя фирменный стиль и применять его в дальнейшем в 11-12 классах или в университете. Таким образом пробуя разные методы подготовки вы найдете то что вам удобно и может помочь в старшей школе.

3) Результаты 10 класса влияют на Predicted Scores. Так как многие университеты включая НУ, просят отправить Predicted scores в первой половине 12 класса учителя ставят оценку в зависимости от того сколько вы набрали в 10 классе и как изменились ваши оценки после этого.

Экзамены внешнего суммативного оценивания проводятся после 5, 10, 11 и 12 классов. Экзаменационный материал разрабатывается и оценивается внешним по отношению к школе органом.

–––––––––––––––––

10-ые классы:

Экзамены в 10 классе сдают учащиеся в возрасте 15-16 лет по окончании основной школы. Предметы, оцениваемые ЦПИ:
1. Первый язык
2. Интегрированный второй язык и литература
3. Английский язык
4. Математика
5. История Казахстана

    2 выборочных предмета из:
1. Биология (Выборочный)
2. Физика (Выборочный)
3. Химия (Выборочный)
4. Информатика (Выборочный)

–––––––––––––––––

11-ые классы:

Экзамены в 11 классе сдают учащиеся в возрасте 16-17 лет после завершения изучения отдельных предметов старшей школы. Предметы, оцениваемые ЦПИ:
1. Первый язык (русский/казахский)
2. Второй язык (русский/казахский)

–––––––––––––––––

12-ые классы:

Согласно Закону РК «О статусе «Назарбаев Университет», «Назарбаев Интеллектуальные школы» и «Назарбаев Фонд» выпускники Интеллектуальных школ освобождены от единого национального тестирования (ЕНТ). Вместо этого они проходят итоговую аттестацию в форме экзамена МЭСК-а.

Экзамены в 12 классе сдают учащиеся в возрасте 17-18 лет после завершения старшей школы. Предметы, оцениваемые внешним органом:

1. Английский язык
2. Математика
3. Биология (Выборочный)
4. Физика (Выборочный)
5. Химия (Выборочный)
6. Казахстан в современном мире
7. Информатика (Выборочный)
8. География (Выборочный)

При организации курсовых, практических или лабораторных работ на экзамене содержание разрабатывается независимым органом, но проводится учителями в школах. Оценки, выставленные учителями по таким формам оценивания, модерируются филиалом «Центр педагогических измерений» автономной организации образования «Назарбаев Интеллектуальные школы» (ЦПИ).

Другие экзамены, разработанные и проведенные учителями Интеллектуальных школ, будут относиться к формативному и внутреннему суммативному оцениваниям.

""", bot: bot)}
        let handler6 = TGMessageHandler(filters: .regexp(pattern: "^5$")) {update, bot in
            try update.message?.reply(text: """
5. Задача Парламента заключается в том, что данный орган будучи независимым от министров и Президента играет роль противовеса.

 Парламент играет ключевую роль в назначении и снятии с должностей министров(в случае неудовлетворительной работы членов самоуправления).

Так же, поскольку Парламент состоит из лидеров классов, он является репрезентативным органом который отражает мнение, просьбы и предложения школьного сообщества.
""", bot: bot)}
//        let handler16 = TGMessageHandler(filters: .regexp(pattern: "^11$")) {update, bot in
//            let fileManager = FileManager.default
//
//            let path = fileManager.currentDirectoryPath
//            let currentDir = URL(fileURLWithPath: path, isDirectory: true)
//            let fileUrl = URL(fileURLWithPath: "Копия tarih мэск.docx", relativeTo: currentDir)
//
//            var data: Data
//                do {
//                    let data = try Data(contentsOf: fileUrl)
//                } catch{
//                    print(error)
//                }
//
//                let tgInputFile = TGInputFile(filename: "Копия tarih мэск.docx", data: data, mimeType: "application/docx") //file info
//                let tgFileInfo = TGFileInfo.file(tgInputFile)
//                let chatId: TGChatId = Int(.chat(id))
//                let tgSendDocumentParams = TGSendDocumentParams(chatId: chatId, document: tgFileInfo)
//
//                bot.sendDocument(params: tgSendDocumentParams)
//            }
        
        bot.connection.dispatcher.add(handler)
        bot.connection.dispatcher.add(handler3)
        bot.connection.dispatcher.add(handler11)
        bot.connection.dispatcher.add(handler4)
        bot.connection.dispatcher.add(handler5)
        bot.connection.dispatcher.add(handler8)
        bot.connection.dispatcher.add(handler15)
        bot.connection.dispatcher.add(handler10)
        bot.connection.dispatcher.add(handler6)
        bot.connection.dispatcher.add(handler9)
        bot.connection.dispatcher.add(handlerArnie)
        bot.connection.dispatcher.add(handlerPorn)
        bot.connection.dispatcher.add(handlerPorn1)
     //   bot.connection.dispatcher.add(handler16)
        bot.connection.dispatcher.add(handlerBella)
    }

    private static func commandShowButtonsHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: ["/buttons"]) { update, bot in
            guard let userId = update.message?.from?.id else { fatalError("user id not found") }
            let buttons: [[TGInlineKeyboardButton]] = [
                [.init(text: "Материалы по подготовке Мэск", callbackData: "Мэск"), .init(text: "Button 2", callbackData: "press 2")]
            ]
            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
            let params: TGSendMessageParams = .init(chatId: .chat(userId), text: "Next:", replyMarkup: .inlineKeyboardMarkup(keyboard))
            try bot.sendMessage(params: params)
        }
        bot.connection.dispatcher.add(handler)
    }

    private static func buttonsActionHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCallbackQueryHandler(pattern: "Мэск") { update, bot in
            
            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                            text: update.callbackQuery?.data  ?? "data not exist",
                                                            showAlert: nil,
                                                            url: nil,
                                                            cacheTime: nil)
                try update.message?.reply(text: "2. Следующие ваши сообщения будут обязательно рассмотрены и приняты ! 😇", bot: bot)
            try bot.answerCallbackQuery(params: params)
        }

        let handler2 = TGCallbackQueryHandler(pattern: "press 2") { update, bot in
            let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                                            text: update.callbackQuery?.data  ?? "data not exist",
                                                            showAlert: nil,
                                                            url: nil,
                                                            cacheTime: nil)
            try bot.answerCallbackQuery(params: params)
        }

        bot.connection.dispatcher.add(handler)
        bot.connection.dispatcher.add(handler2)
    }

}
