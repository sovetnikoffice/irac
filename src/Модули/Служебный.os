// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/irac/
// ----------------------------------------------------------

#Использовать logos
#Использовать tempfiles
#Использовать asserts
#Использовать strings
#Использовать 1commands
#Использовать v8runner
#Использовать 1connector

Перем ЭтоПриложениеEXE;
Перем Лог;

// Функция - читает указанный макет JSON и возвращает содержимое в виде структуры/массива
//
// Параметры:
//	ИмяМакета    - Строка   - имя макета (файла) json
//
// Возвращаемое значение:
//	Структура, Массив       - прочитанные данные из макета 
//
Функция ПрочитатьДанныеИзМакетаJSON(ИмяМакета) Экспорт

	Если ЭтоСборкаEXE() Тогда
	    КаталогЗапуска = КаталогПрограммы();
	Иначе
	    КаталогЗапуска = ТекущийСценарий().Каталог;
	КонецЕсли;

	Чтение = Новый ЧтениеJSON();
	
	Чтение.ОткрытьФайл(СтрШаблон("%1/../Макеты/%2.json", КаталогЗапуска, ИмяМакета),
	                   КодировкаТекста.UTF8);

	Возврат ПрочитатьJSON(Чтение, Ложь);

КонецФункции // ПрочитатьДанныеИзМакетаJSON()

// Функция добавляет кавычки в начале и в конце переданной строки
//   
// Параметры:
//   Строка         - Строка        - Строка для добавления кавычек
//
// Возвращаемое значение:
//    Строка - строка с добавленными кавычками
//
Функция ОбернутьВКавычки(Знач Строка) Экспорт
	Если Лев(Строка, 1) = """" И Прав(Строка, 1) = """" Тогда
		Возврат Строка;
	Иначе
		Возврат """" + Строка + """";
	КонецЕсли;
КонецФункции // ОбернутьВКавычки()

// Процедура заполняет значения свойств объ)екта кластера 1С
//   
// Параметры:
//   ОбъектКластера          - Произвольный        - объект, свойства которого будут заполнены
//   Свойства                - Соответствие        - переменная, которая будет заполнена свойствами объекта
//   ДанныеЗаполнения        - Соответствие        - данные, из которых будут заполнены значения свойств объекта
//   
Процедура ЗаполнитьСвойстваОбъекта(ОбъектКластера, Свойства, ДанныеЗаполнения) Экспорт

	СтруктураПараметров = ОбъектКластера.ПараметрыОбъекта();

	Свойства = Новый Соответствие();

	Для Каждого ТекЭлемент Из СтруктураПараметров Цикл
		ЗначениеПараметра = Служебный.ПолучитьЗначениеИзСтруктуры(ДанныеЗаполнения,
	                                                              ТекЭлемент.Значение.ИмяРАК,
	                                                              ТекЭлемент.Значение.ПоУмолчанию); 
		Свойства.Вставить(ТекЭлемент.Ключ, ЗначениеПараметра);
	КонецЦикла;

КонецПроцедуры // ЗаполнитьСвойстваОбъекта()

// Функция возвращает значение указанного поля структуры/соответствия или значение по умолчанию
//   
// Параметры:
//   ПарамСтруктура      - Структура, Соответствие    - коллекция из которой возвращается значение
//   Ключ                - Произвольный               - значение ключа коллекции для получения значения
//   ПоУмолчанию         - Произвольный               - значение, возвращаемое в случае,
//                                                      когда ключ отсутствует в коллекции
//   
// Возвращаемое значение:
//    Произвольный - значение элемента коллекции или значение по умолчанию
//
Функция ПолучитьЗначениеИзСтруктуры(ПарамСтруктура, Ключ, ПоУмолчанию = Неопределено) Экспорт

	Если ТипЗнч(ПарамСтруктура) = Тип("Структура") Тогда
		Если ПарамСтруктура.Свойство(Ключ) Тогда
			Возврат ПарамСтруктура[Ключ];
		КонецЕсли;
	ИначеЕсли ТипЗнч(ПарамСтруктура) = Тип("Соответствие") Тогда
		Если НЕ ПарамСтруктура.Получить(Ключ) = Неопределено Тогда
			Возврат ПарамСтруктура.Получить(Ключ);
		КонецЕсли;
	Иначе
		Возврат ПоУмолчанию;
	КонецЕсли;

КонецФункции // ПолучитьЗначениеИзСтруктуры()

// Функция преобразует массив соответствий в иерархию соответствий в соответствии с указанным порядком полей
// копирования данных не происходят, в результирующее соответствие помещаются исходные элементы массива
//   
// Параметры:
//   МассивСоответствий      - Массив(Соответствие)        - Данные для преобразования
//            <имя поля>         - Произвольный                - Значение элемента соответствия
//   ПоляИерархии            - Строка                    - Поля для построения иерархии списка объектов, разделенные ","
//
// Возвращаемое значение:
//    Соответствие - иерархия соответствий по значениям полей упорядочивания
//        <значение поля упорядочивания>   - Соответствие,         - подчиненные данные по значениям
//                                           Массив(Соответствие)    следующего поля упорядочивания
//                                                                   или элементы исходного массива
//                                                                   на последнем уровне иерархии
//
Функция ИерархическоеПредставлениеМассиваСоответствий(МассивСоответствий, ПоляИерархии) Экспорт

	МассивУпорядочивания = СтрРазделить(ПоляИерархии, ",", Ложь);

	Если МассивУпорядочивания.Количество() = 0 Тогда
		Возврат МассивСоответствий;
	КонецЕсли;

	Результат = Новый Соответствие();

	Для Каждого ТекЭлемент Из МассивСоответствий Цикл
		ЗаполняемыйСписок = Результат;
		ТекСписок = Неопределено;
		Для Каждого ИмяПоля Из МассивУпорядочивания Цикл
			Если ТипЗнч(ТекСписок) = Тип("Соответствие") Тогда
				ЗаполняемыйСписок = ТекСписок;
			КонецЕсли;
			ЗначениеПоля = ТекЭлемент.Получить(ИмяПоля);
			ТекСписок = ЗаполняемыйСписок.Получить(ЗначениеПоля);
			Если ТекСписок = Неопределено Тогда
				ЗаполняемыйСписок.Вставить(ЗначениеПоля, Новый Соответствие());
				ТекСписок = ЗаполняемыйСписок[ЗначениеПоля];
			КонецЕсли;
		КонецЦикла;
		Если НЕ ТипЗнч(ЗаполняемыйСписок[ЗначениеПоля]) = Тип("Массив") Тогда
			ЗаполняемыйСписок[ЗначениеПоля] = Новый Массив();
		КонецЕсли;
		ЗаполняемыйСписок[ЗначениеПоля].Добавить(ТекЭлемент);
	КонецЦикла;

	Возврат Результат;

КонецФункции // ИерархическоеПредставлениеМассиваСоответствий()

// Функция возвращает массив элементов (соответствий), отвечающих заданному отбору
//   
// Параметры:
//   МассивСоответствий        - Массив(Соответствие)        - Обрабатываемый массив
//   Отбор                     - Соответствие                - Структура отбора вида <поле>:<значение>
//
// Возвращаемое значение:
//    Массив(Соответствие) - массив соответствий, соответствующих отбору
//
Функция ПолучитьЭлементыИзМассиваСоответствий(МассивСоответствий, Отбор) Экспорт

	Если НЕ ТипЗнч(Отбор) = Тип("Соответствие") Тогда
		Возврат МассивСоответствий;
	КонецЕсли;

	Если Отбор.Количество() = 0 Тогда
		Возврат МассивСоответствий;
	КонецЕсли;

	Результат = Новый Массив();

	Для Каждого ТекЭлемент Из МассивСоответствий Цикл
		ЭлементСоответствуетОтбору = Истина;
		Для Каждого ТекЭлементОтбора Из Отбор Цикл
			ПроверяемоеЗначение = ТекЭлемент.Получить(ТекЭлементОтбора.Ключ);
			Если НЕ ПроверяемоеЗначение = ТекЭлементОтбора.Значение Тогда
				ЭлементСоответствуетОтбору = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НЕ ЭлементСоответствуетОтбору Тогда
			Продолжить;
		КонецЕсли;
		Результат.Добавить(ТекЭлемент);
	КонецЦикла;

	Возврат Результат;

КонецФункции // ПолучитьЭлементыИзМассиваСоответствий()

// Функция преобразует все элементы-объекты массива в соответствия с аналогичным набором полей
//   
// Параметры:
//   МассивЭлементов     - Массив(Произвольный)     - Обрабатываемый массив
//   ПоляЭлемента        - Соответствие             - Описания полей элементов
//
// Возвращаемое значение:
//    Массив(Соответствие) - массив элементов-соответствий
//
Функция МассивОбъектовВМассивСоответствий(МассивЭлементов, ПоляЭлемента) Экспорт

	Если ТипЗнч(МассивЭлементов[0]) = Тип("Соотвествие") Тогда
		Возврат МассивЭлементов;
	КонецЕсли;

	Результат = Новый Массив();

	Для Каждого ТекЭлемент Из МассивЭлементов Цикл
		ЭлементДляДобавления = ОбъектВСоответствие(ТекЭлемент, ПоляЭлемента);
		Результат.Добавить(ЭлементДляДобавления);
	КонецЦикла;

	Возврат Результат;

КонецФункции // МассивОбъектовВМассивСоответствий()

// Функция преобразует все объект кластера в соответствия с аналогичным набором полей
//   
// Параметры:
//   Объект           - Произвольный     - Обрабатываемый объект
//   ПоляОбъекта      - Соответствие     - Описания полей объекта
//
// Возвращаемое значение:
//    Соответствие - объект для преобразования
//
Функция ОбъектВСоответствие(Объект, ПоляОбъекта) Экспорт

	Если ТипЗнч(Объект) = Тип("Соотвествие") Тогда
		Возврат Объект;
	КонецЕсли;

	Результат = Новый Соответствие();

	Для Каждого ТекПоле Из ПоляОбъекта Цикл
		Результат.Вставить(ТекПоле.Ключ, Объект.Получить(ТекПоле.Ключ));
	КонецЦикла;

	Возврат Результат;

КонецФункции // ОбъектВСоответствие()

// Функция преобразует переданный текст вывода команды в массив соответствий
// элементы массива создаются по блокам текста, разделенным пустой строкой
// пары <ключ, значение> структуры получаются для каждой строки с учетом разделителя ":"
//   
// Параметры:
//   ВыводКоманды            - Строка            - текст для разбора
//   
// Возвращаемое значение:
//    Массив (Соответствие) - результат разбора
//
Функция РазобратьВыводКоманды(Знач ВыводКоманды) Экспорт
	
	Текст = Новый ТекстовыйДокумент();
	Текст.УстановитьТекст(ВыводКоманды);

	МассивРезультатов = Новый Массив();
	Описание = Новый Соответствие();

	Для й = 1 По Текст.КоличествоСтрок() Цикл

		ТекстСтроки = Текст.ПолучитьСтроку(й);
		
		ПозРазделителя = СтрНайти(ТекстСтроки, ":");
		
		Если НЕ ЗначениеЗаполнено(ТекстСтроки) Тогда
			Если й = 1 Тогда
				Продолжить;
			КонецЕсли;
			МассивРезультатов.Добавить(Описание);
			Описание = Новый Соответствие();
			Продолжить;
		КонецЕсли;

		Если ПозРазделителя = 0 Тогда
			Описание.Вставить(СокрЛП(ТекстСтроки), "");
		Иначе
			Описание.Вставить(СокрЛП(Лев(ТекстСтроки, ПозРазделителя - 1)), СокрЛП(Сред(ТекстСтроки, ПозРазделителя + 1)));
		КонецЕсли;
		
	КонецЦикла;

	Если Описание.Количество() > 0 Тогда
		МассивРезультатов.Добавить(Описание);
	КонецЕсли;
	
	Если МассивРезультатов.Количество() = 1 И ТипЗнч(МассивРезультатов[0]) = Тип("Строка") Тогда
		Возврат МассивРезультатов[0];
	КонецЕсли;

	Возврат МассивРезультатов;

КонецФункции // РазобратьВыводКоманды()

// Функция признак необходимости обновления данных
//   
// Параметры:
//   ОбъектДанных             - Произвольный  - данные для обновления
//   МоментАктуальности       - Число         - момент актуальности данных (мсек)
//   ПериодОбновления         - Число         - периодичность обновления (мсек)
//   ОбновитьПринудительно    - Булево        - Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//    Булево - Истина - требуется обновитьданные
//
Функция ТребуетсяОбновление(ОбъектДанных, МоментАктуальности, ПериодОбновления, ОбновитьПринудительно = Ложь) Экспорт

	Возврат (ОбновитьПринудительно
		ИЛИ ОбъектДанных = Неопределено
		ИЛИ (ПериодОбновления < (ТекущаяУниверсальнаяДатаВМиллисекундах() - МоментАктуальности)));

КонецФункции // ТребуетсяОбновление()

// Диагностическая процедура для вывода списка полей объекта
//   
// Параметры:
//   ОбъектДанных        - Произвольный    - объект, поля которого требуется вывести
//
Процедура ВывестиПоляОбъекта(Знач ОбъектДанных) Экспорт

	Коллекция = "";
	Если ТипЗнч(ОбъектДанных) = Тип("Массив") Тогда
		Если ОбъектДанных.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;

		Коллекция = СокрЛП(ТипЗнч(ОбъектДанных)) + "\";
		ОбъектДанных = ОбъектДанных[0];
	КонецЕсли;

	Лог.Информация("Поля объекта ""%1%2"":", Коллекция, СокрЛП(ТипЗнч(ОбъектДанных)));

	Для Каждого ТекПоле Из ОбъектДанных Цикл
		Сообщить(СокрЛП(ТекПоле.Ключ) + ":" + СокрЛП(ТекПоле.Значение));
	КонецЦикла;

КонецПроцедуры // ВывестиПоляОбъекта()

// Функция признак того, что выполняется скрипт, собранный в приложение
//   
// Возвращаемое значение:
//    Булево - Истина - выполняется скрипт, собранный в приложение
//
Функция ЭтоСборкаEXE() Экспорт

	Если ЭтоПриложениеEXE = Неопределено Тогда
	    ЭтоПриложениеEXE = ВРег(Прав(ТекущийСценарий().Источник, 3)) = "EXE";
	КонецЕсли;

	Возврат ЭтоПриложениеEXE;

КонецФункции // ЭтоСборкаEXE()

// Функция возвращает лог библиотеки
//   
// Возвращаемое значение:
//    Логгер - лог библиотеки
//
Функция Лог() Экспорт
	
	Если Лог = Неопределено Тогда
		Лог = Логирование.ПолучитьЛог(ИмяЛога());
	КонецЕсли;

	Возврат Лог;

КонецФункции // Лог()

// Функция возвращает имя лога библиотеки
//   
// Возвращаемое значение:
//    Строка - имя лога библиотеки
//
Функция ИмяЛога() Экспорт

	Возврат "oscript.lib.irac";
	
КонецФункции // ИмяЛога()
