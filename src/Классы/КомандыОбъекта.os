// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/irac/
// ----------------------------------------------------------

// Класс хранящий структуру свойств и команд объекта указанного типа

Перем ТипОбъекта;                  // структура описания типа объектов (Кластер, Сервер, ИБ и т.п.)
Перем ОписаниеСвойств;             // структура описания свойств объекта
Перем ОписаниеКоманд;              // структура описания команд объекта
Перем ПараметрыЗапуска;            // массив параметров запуска команды утилиты RAC
Перем ЗначенияПараметров;          // значения именованых параметров объекта

Перем Лог;

#Область ПрограммныйИнтерфейс

// Конструктор
//   
// Параметры:
//   ИмяТипаОбъекта                 - Строка        - имя типа объекта для которого создается структура параметров
//   ЗначенияПараметровКоманд       - Структура     - список параметров команд:
//                                                       Ключ - имя параметра
//                                                       Значение - значение параметра
//
Процедура ПриСозданииОбъекта(ИмяТипаОбъекта, ЗначенияПараметровКоманд = Неопределено)

	ТипОбъекта = ТипыОбъектовКластера.ТипОбъекта(ИмяТипаОбъекта);

	ОписаниеСвойств = ТипыОбъектовКластера.СвойстваОбъекта(ИмяТипаОбъекта);

	ОписаниеКоманд = ТипыОбъектовКластера.КомандыОбъекта(ИмяТипаОбъекта);

	УстановитьЗначенияПараметровКоманд(ЗначенияПараметровКоманд);

КонецПроцедуры // ПриСозданииОбъекта()

// Процедура устанавливает значения параметров команд
//   
// Параметры:
//   ЗначенияПараметровКоманд       - Структура     - список параметров команд:
//       *<имя параметра>           - Произвольный  - значение параметра команды
//   Очистить                       - Булево        - Истина - очистить значения параметров перед заполнением
//                                                    Ложь - добавить параметры к существующим
//                                                          (одноименные будут перезаполнены)
//
Процедура УстановитьЗначенияПараметровКоманд(Знач ЗначенияПараметровКоманд, Знач Очистить = Ложь) Экспорт

	Если НЕ ТипЗнч(ЗначенияПараметров) = Тип("Соответствие") ИЛИ Очистить Тогда
		ЗначенияПараметров = Новый Соответствие();
	КонецЕсли;

	Если ТипЗнч(ЗначенияПараметровКоманд) = Тип("Соответствие") Тогда
		Для Каждого ТекЭлемент Из ЗначенияПараметровКоманд Цикл
			ЗначенияПараметров.Вставить(ТекЭлемент.Ключ, ТекЭлемент.Значение);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры // УстановитьЗначенияПараметровКоманд()

// Функция возвращает коллекцию описаний свойств объекта
//   
// Параметры:
//   ИмяПоляКлюча         - Строка    - имя поля, значение которого будет использовано
//                                      в качестве ключа возвращаемого соответствия
//   
// Возвращаемое значение:
//    Соответствие - коллекция описаний свойств объекта, для получения/изменения значений
//
Функция ОписаниеСвойств(Знач ИмяПоляКлюча = "Имя") Экспорт
	
	СтруктураОписаний = Новый Соответствие();

	Если НЕ ТипЗнч(ОписаниеСвойств) = Тип("Массив") Тогда
		Возврат СтруктураОписаний;
	КонецЕсли;

	Для Каждого ТекОписание Из ОписаниеСвойств Цикл
		СтруктураОписаний.Вставить(ТекОписание[ИмяПоляКлюча], ТекОписание);
	КонецЦикла;

	Возврат СтруктураОписаний;

КонецФункции // ОписаниеСвойств()

// Функция выполняет заполнение массива параметров запуска команды
// и возвращает результирующий массив
//   
// Параметры:
//   ИмяКоманды         - Строка    - имя команды для которой выпоняется заполнение
//   
// Возвращаемое значение:
//    Массив - параметры запуска команды
//
Функция ПараметрыКоманды(Знач ИмяКоманды) Экспорт
	
	Если ТипЗнч(ПараметрыЗапуска) = Тип("Массив") Тогда
		ПараметрыЗапуска.Очистить();
	КонецЕсли;

	Команда = ОписаниеКоманд[ИмяКоманды];

	ДобавитьПараметрПоИмени("СтрокаПодключенияАгента");

	Если ТипОбъекта.Свойство("Владелец") Тогда
		ДобавитьПараметрСтроку(ТипОбъекта.Владелец.РежимАдминистрирования);
	Иначе
		ДобавитьПараметрСтроку(ТипОбъекта.РежимАдминистрирования);
	КонецЕсли;

	АвторизацияАгента = Ложь;
	Если Команда.Свойство("АвторизацияАгента") Тогда
		АвторизацияАгента = Команда.АвторизацияАгента;
	КонецЕсли;
	
	Если АвторизацияАгента Тогда
	 	ДобавитьПараметрПоИмени("СтрокаАвторизацииАгента");
	КонецЕсли;

	Если Команда.Кластер Тогда
	 	ДобавитьПараметрПоШаблону("--cluster=%1", "ИдентификаторКластера", Истина);
	 	ДобавитьПараметрПоИмени("СтрокаАвторизацииКластера");
	КонецЕсли;
	
	Если ТипОбъекта.Свойство("Владелец") Тогда
		ДобавитьПараметрСтроку(ТипОбъекта.РежимАдминистрирования);
	КонецЕсли;

	Для Каждого ТекПараметр Из Команда.ОбщиеПараметры Цикл
		ДобавитьПараметрКоманды(ТекПараметр);
	КонецЦикла;

	ДобавитьПараметрСтроку(Команда.ИмяРАК);

	Для Каждого ТекПараметр Из Команда.ПараметрыКоманды Цикл
		ДобавитьПараметрКоманды(ТекПараметр);
	КонецЦикла;

	Если Команда.ЗначенияПолей Тогда
		ДобавитьПрочиеПараметрыКоманды(Команда.Имя);
	КонецЕсли;

	Возврат ПараметрыЗапуска;

КонецФункции // ПараметрыКоманды()

// Функция возвращает описание текущего типа объекта
//   
// Возвращаемое значение:
//   Структура                                 - описание типа объектов
//       *Имя                      - Строка        - имя типа объектов
//       *РежимАдминистрирования   - Строка        - режим утилиты RAC (agent, cluster, infobase и т.п.)
//       *Владелец                 - Струткура     - описание типа объекта, владельца 
//                                                   (например: для типа "Кластер.Администратор"
//                                                   будет содержать описание типа "Кластер")
//   
Функция ТипОбъекта() Экспорт

	Возврат ТипОбъекта;

КонецФункции // ТипОбъекта()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедуры

// Процедура добавляет параметр указанный параметр команды
//   
// Параметры:
//   Параметр       - Строка, Структура   - строковый параметр или структура с описанием параметра
//       *Флаг          - Строка              - имя параметра-флага разрешающего добавление параметра
//       *Шаблон        - Строка              - строка шаблона добавления параметра (например: "--cluster=%1")
//       *Параметр      - Строка              - имя добавляемого параметра или подстановки в шаблон
//       *Обязательный  - Булево              - Истина - при заполнении будет проверено наличие параметра
//   
Процедура ДобавитьПараметрКоманды(Знач Параметр)

	Если ТипЗнч(Параметр) = Тип("Структура") Тогда

		Флаг = Истина;
		Если Параметр.Свойство("Флаг") Тогда
			Флаг = ЗначениеФлага(Параметр.Флаг);
		КонецЕсли;
	
		Если НЕ Флаг Тогда
			Возврат;
		КонецЕсли;
	
		Обязательный = Ложь;
		Если Параметр.Свойство("Обязательный") Тогда
			Обязательный = Параметр.Обязательный;
		КонецЕсли;

		Если Параметр.Свойство("Шаблон") Тогда
			ДобавитьПараметрПоШаблону(Параметр.Шаблон, Параметр.Параметр, Обязательный);
		Иначе
			ДобавитьПараметрПоИмени(Параметр.Параметр);
		КонецЕсли;

	Иначе
		ДобавитьПараметрСтроку(Параметр);
	КонецЕсли;

КонецПроцедуры // ДобавитьПараметрКоманды()

// Процедура добавляет параметры команды из описания свойств объекта
// проверяя флаг использования свойства для различных операций
//   
// Параметры:
//   ИмяФлагаРазрешения           - Строка          - имя проверяемого флага разрешения
//                                                 (Чтение, Добавление, Изменение и т.п.)
//   ВключаяПараметры           - Строка          - список добавляемых параметров, разделенных ","
//   ИсключаяПараметры           - Строка          - список исключаемых параметров, разделенных ","
//   
Процедура ДобавитьПрочиеПараметрыКоманды(Знач ИмяФлагаРазрешения
	                                   , Знач ВключаяПараметры = ""
	                                   , Знач ИсключаяПараметры = "")

	ВключаяПараметры = СтрРазделить(ВключаяПараметры, ",", Ложь);
	Для й = 0 По ВключаяПараметры.ВГраница() Цикл
		ВключаяПараметры[й] = СокрЛП(ВключаяПараметры[й]);
	КонецЦикла;

	ИсключаяПараметры = СтрРазделить(ИсключаяПараметры, ",", Ложь);
	Для й = 0 По ИсключаяПараметры.ВГраница() Цикл
		ИсключаяПараметры[й] = СокрЛП(ИсключаяПараметры[й]);
	КонецЦикла;

	ВсеПараметры = ОписаниеСвойств();

	Для Каждого ТекЭлемент Из ВсеПараметры Цикл
		
		Если ВключаяПараметры.Количество() > 0 
		   И ВключаяПараметры.Найти(ТекЭлемент.Ключ) = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если ИсключаяПараметры.Количество() > 0
		   И НЕ ИсключаяПараметры.Найти(ТекЭлемент.Ключ) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
	    
		Если ЗначениеЗаполнено(ИмяФлагаРазрешения) И НЕ ТекЭлемент.Значение[ИмяФлагаРазрешения] Тогда
			Продолжить;
		КонецЕсли;

		Если ЗначенияПараметров.Получить(ТекЭлемент.Ключ) = Неопределено
		   И ЗначениеЗаполнено(ТекЭлемент.Значение.ПоУмолчанию) Тогда
			ЗначенияПараметров.Вставить(ТекЭлемент.Ключ, ТекЭлемент.Значение.ПоУмолчанию);
		КонецЕсли;

		ДобавитьПараметрПоШаблону(ТекЭлемент.Значение.ПараметрКоманды + "=%1", ТекЭлемент.Ключ);
		
	КонецЦикла;

КонецПроцедуры // ДобавитьПрочиеПараметрыКоманды()

// Процедура добавляет переданное значение в массив параметров запуска команды
//   
// Параметры:
//   Параметр                - Строка           - добавляемое значение
//   Обязательный           - Булево            - Истина - если параметр не заполнен будет выдано исключение
//   ДобавлятьПустой        - Булево            - Истина - если параметр не заполнен будет добавлена пустая строка
//   
Процедура ДобавитьПараметрСтроку(Знач Параметр, Обязательный = Ложь, ДобавлятьПустой = Истина)

	Если НЕ ТипЗнч(ПараметрыЗапуска) = Тип("Массив") Тогда
		ПараметрыЗапуска = Новый Массив();
	КонецЕсли;
	
	Если НЕ ТипЗнч(Параметр) = Тип("Строка") Тогда
		Параметр = "";
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Параметр) И Обязательный Тогда
		ВызватьИсключение "Не заполнен обязательный параметр!";
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметр) ИЛИ ДобавлятьПустой Тогда
		ПараметрыЗапуска.Добавить(Параметр);
	КонецЕсли;

КонецПроцедуры // ДобавитьПараметрСтроку()

// Процедура добавляет значение параметра из структуры значений параметров в массив параметров запуска команды
//   
// Параметры:
//   Имя                    - Строка            - имя параметра в структуре значений параметров
//   Обязательный           - Булево            - Истина - если значение параметра не найдено
//                                                         или не заполнено будет выдано исключение
//   ДобавлятьПустой        - Булево            - Истина - если значение параметра не найдено
//                                                         или не заполнено будет добавлена пустая строка
//   
Процедура ДобавитьПараметрПоИмени(Знач Имя, Обязательный = Ложь, ДобавлятьПустой = Истина)

	Если НЕ ТипЗнч(ПараметрыЗапуска) = Тип("Массив") Тогда
		ПараметрыЗапуска = Новый Массив();
	КонецЕсли;
	
	Параметр = ЗначенияПараметров.Получить(Имя);
	Если Параметр = Неопределено Тогда
		Параметр = "";
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Параметр) И Обязательный Тогда
		ВызватьИсключение СтрШаблон("Не заполнен обязательный параметр %1!", Имя);
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметр) ИЛИ ДобавлятьПустой Тогда
		ПараметрыЗапуска.Добавить(Параметр);
	КонецЕсли;

КонецПроцедуры // ДобавитьПараметрПоИмени()

// Процедура выполняет подстановку значения параметра из структуры значений параметров в шаблон
// и добавляет результат в массив параметров запуска команды
//   
// Параметры:
//   ШаблонПараметра        - Строка            - шаблон, в который будет выполнена подстановка
//   Имя                    - Строка            - имя параметра в структуре значений параметров
//   Обязательный           - Булево            - Истина - если значение параметра не найдено
//                                                         или не заполнено будет выдано исключение
//   
Процедура ДобавитьПараметрПоШаблону(Знач ШаблонПараметра, Знач Имя, Знач Обязательный = Ложь)

	Если НЕ ТипЗнч(ПараметрыЗапуска) = Тип("Массив") Тогда
		ПараметрыЗапуска = Новый Массив();
	КонецЕсли;
	
	ЗначениеПараметра = ЗначенияПараметров.Получить(Имя);

	Если НЕ ЗначениеЗаполнено(ЗначениеПараметра) Тогда
		Если Обязательный Тогда
			ВызватьИсключение СтрШаблон("Не заполнен обязательный параметр %1!", Имя);
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ПараметрыЗапуска.Добавить(СтрШаблон(ШаблонПараметра, ЗначениеПараметра));

КонецПроцедуры // ДобавитьПараметрПоШаблону()

// Функция возвращает значение параметра-флага из структуры значений параметров
//   
// Параметры:
//   Имя              - Строка            - имя параметра в структуре значений параметров
//   
// Возвращаемое значение:
//    Булево          - значение флага, если параметр отсутствует в структуре значений параметров,
//                    возвращается Ложь
//
Функция ЗначениеФлага(Знач Имя)

	Параметр = ЗначенияПараметров.Получить(Имя);
	Если Параметр = Неопределено Тогда
		Параметр = Ложь;
	КонецЕсли;

	Возврат Параметр;

КонецФункции // ЗначениеФлага()

#КонецОбласти // СлужебныеПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.irac");
