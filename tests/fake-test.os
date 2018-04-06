﻿#Использовать "../src"
#Использовать asserts

Перем ЮнитТест;
Перем АгентКластера;
Перем Кластер;

// Функция возвращает список тестов для выполнения
//
// Параметры:
//	Тестирование	
Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	ЮнитТест = Тестирование;
	
	СписокТестов = Новый Массив;
	СписокТестов.Добавить("ТестДолжен_СоздатьАгентКластера");
	СписокТестов.Добавить("ТестДолжен_СоздатьАдминистраторыАгента");
	СписокТестов.Добавить("ТестДолжен_СоздатьКластеры");
	СписокТестов.Добавить("ТестДолжен_СоздатьКластер");
	СписокТестов.Добавить("ТестДолжен_СоздатьОбъектыКластера");
	СписокТестов.Добавить("ТестДолжен_СоздатьАдминистраторыКластера");
	СписокТестов.Добавить("ТестДолжен_СоздатьСерверыКластера");
	СписокТестов.Добавить("ТестДолжен_СоздатьСервер");
	СписокТестов.Добавить("ТестДолжен_СоздатьМенеджерыКластера");
	СписокТестов.Добавить("ТестДолжен_СоздатьРабочиеПроцессы");
	СписокТестов.Добавить("ТестДолжен_СоздатьРабочийПроцесс");
	СписокТестов.Добавить("ТестДолжен_СоздатьСервисы");
	СписокТестов.Добавить("ТестДолжен_СоздатьСеансы");
	СписокТестов.Добавить("ТестДолжен_СоздатьСоединения");
	СписокТестов.Добавить("ТестДолжен_СоздатьБлокировки");
	СписокТестов.Добавить("ТестДолжен_СоздатьИнформационныеБазы");
	СписокТестов.Добавить("ТестДолжен_СоздатьИнформационнаяБаза");
	СписокТестов.Добавить("ТестДолжен_ВызватьСлужебный");
	СписокТестов.Добавить("ТестДолжен_ПолучитьПеречисления");
	СписокТестов.Добавить("ТестДолжен_СоздатьНазначенияФункциональности");
	СписокТестов.Добавить("ТестДолжен_СоздатьНазначениеФункциональности");

	Возврат СписокТестов;
	
КонецФункции

// Процедура выполняется после запуска теста
//
Процедура ПослеЗапускаТеста() Экспорт

	

КонецПроцедуры // ПослеЗапускаТеста()

// Процедура выполняется после запуска теста
//
Процедура ПередЗапускомТеста() Экспорт
	

КонецПроцедуры

// Процедура - тест
//
Процедура ТестДолжен_СоздатьАгентКластера() Экспорт
	
	АгентКластера = Новый АдминистрированиеКластера(Неопределено, Неопределено, "8.3");

КонецПроцедуры // ТестДолжен_ПодключитьсяКСерверуАдминистрирования()

Процедура ТестДолжен_СоздатьАдминистраторыАгента() Экспорт
	
	АдминистраторыАгента = Новый АдминистраторыАгента(АгентКластера);

КонецПроцедуры // ТестДолжен_ПодключитьсяКСерверуАдминистрирования()


Процедура ТестДолжен_СоздатьКластеры() Экспорт
	
	Кластеры = Новый Кластеры(АгентКластера);

КонецПроцедуры // ТестДолжен_СоздатьКластеры()


Процедура ТестДолжен_СоздатьКластер() Экспорт
	
	Кластер = Новый Кластер(Неопределено, "");

КонецПроцедуры // ТестДолжен_СоздатьКластер()


Процедура ТестДолжен_СоздатьОбъектыКластера() Экспорт
	
	ОбъектыКластера = Новый ОбъектыКластера(Неопределено);

КонецПроцедуры // ТестДолжен_СоздатьОбъектыКластера()


Процедура ТестДолжен_СоздатьАдминистраторыКластера() Экспорт
	
	АдминистраторыКластера = Новый АдминистраторыКластера(Неопределено, Неопределено);

КонецПроцедуры // ТестДолжен_СоздатьАдминистраторыКластера()


Процедура ТестДолжен_СоздатьСерверыКластера() Экспорт
	
	СерверыКластера = Новый СерверыКластера(Неопределено, Неопределено);

КонецПроцедуры // ТестДолжен_СоздатьСерверыКластера()


Процедура ТестДолжен_СоздатьСервер() Экспорт
	
	Сервер = Новый Сервер(Неопределено, Неопределено, "");

КонецПроцедуры // ТестДолжен_ПодключитьсяКСерверуАдминистрирования()

Процедура ТестДолжен_СоздатьМенеджерыКластера() Экспорт
	
	МенеджерыКластера = Новый МенеджерыКластера(Неопределено, неопределено);

КонецПроцедуры // ТестДолжен_СоздатьМенеджерыКластера()


Процедура ТестДолжен_СоздатьРабочиеПроцессы() Экспорт
	
	ТестДолжен_СоздатьРабочиеПроцессы = Новый РабочиеПроцессы(АгентКластера, Кластер);

КонецПроцедуры // ТестДолжен_СоздатьРабочиеПроцессы()


Процедура ТестДолжен_СоздатьРабочийПроцесс() Экспорт
	
	РабочийПроцесс = Новый РабочийПроцесс(АгентКластера, Кластер, "");

КонецПроцедуры // ТестДолжен_СоздатьРабочийПроцесс()

Процедура ТестДолжен_СоздатьСервисы() Экспорт
	
	Сервисы = Новый Сервисы(АгентКластера, Кластер);

КонецПроцедуры // ТестДолжен_СоздатьСервисы()


Процедура ТестДолжен_СоздатьСеансы() Экспорт
	
	Сеансы = Новый Сеансы(АгентКластера, Кластер, "");

КонецПроцедуры // ТестДолжен_СоздатьСеансы()


Процедура ТестДолжен_СоздатьСоединения() Экспорт
	
	Соединения = Новый Соединения(АгентКластера, Кластер);

КонецПроцедуры // ТестДолжен_СоздатьСоединения()


Процедура ТестДолжен_СоздатьБлокировки() Экспорт
	
	Блокировки = Новый Блокировки(АгентКластера, Кластер);

КонецПроцедуры // ТестДолжен_ПодключитьсяКСерверуАдминистрирования()


Процедура ТестДолжен_СоздатьИнформационныеБазы() Экспорт
	
	ИнформационныеБазы = Новый ИнформационныеБазы(АгентКластера, Кластер);

КонецПроцедуры // ТестДолжен_СоздатьИнформационныеБазы()


Процедура ТестДолжен_СоздатьИнформационнаяБаза() Экспорт
	
	ИнформационнаяБаза = Новый ИнформационнаяБаза(АгентКластера, Кластер, "");

КонецПроцедуры // ТестДолжен_СоздатьИнформационнаяБаза()


Процедура ТестДолжен_ВызватьСлужебный() Экспорт
	
	АВКавычках =  Служебный.ОбернутьВКавычки("А");

КонецПроцедуры // ТестДолжен_ВызватьСлужебный()


Процедура ТестДолжен_ПолучитьПеречисления() Экспорт
	
	ВариантыИспользованияРабочегоСервера = Перечисления.ВариантыИспользованияРабочегоСервера;

КонецПроцедуры // ТестДолжен_ПолучитьПеречисления()

Процедура ТестДолжен_СоздатьНазначенияФункциональности() Экспорт
	
	ИнформационныеБазы = Новый НазначенияФункциональности(АгентКластера, Кластер, Неопределено);

КонецПроцедуры // ТестДолжен_СоздатьНазначенияФункциональности()


Процедура ТестДолжен_СоздатьНазначениеФункциональности() Экспорт
	
	ИнформационнаяБаза = Новый НазначениеФункциональности(АгентКластера, Кластер, Неопределено, "");

КонецПроцедуры // ТестДолжен_СоздатьНазначениеФункциональности()

