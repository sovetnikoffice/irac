﻿///////////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ЗАПУСКОМ КОМАНД 1С:Предприятия 8
//

#Использовать logos
#Использовать tempfiles
#Использовать asserts
#Использовать strings
#Использовать 1commands
#Использовать v8runner
#Использовать "."

Перем Лог;

//////////////////////////////////////////////////////////////////////////////////
// Программный интерфейс

Процедура ОписаниеСерверов(Серверы)
	
	Сообщить("Всего серверов: " + Серверы.Список().Количество());
	Для Каждого Сервер Из Серверы.Список() Цикл
		Сообщить(Сервер.Имя() + " (" + Сервер.Сервер() + ":" + Сервер.Порт() + ")");
		Для Каждого ТекАтрибут Из Сервер.Параметры() Цикл
			Сообщить(ТекАтрибут.Ключ + " : " + ТекАтрибут.Значение);
		КонецЦикла;
		Сообщить("");
	КонецЦикла;
				
КонецПроцедуры

Процедура ОписаниеИБ(ИБ)
	
	Сообщить("Всего ИБ: " + ИБ.Список().Количество());
	Для Каждого ТекИБ Из ИБ.Список() Цикл
		Сообщить(ТекИБ.Имя() + " (" + ?(ТекИБ.ПолноеОписание(), "Полное", "Сокращенное") + " " + ТекИБ.Описание() + ")");
		Для Каждого ТекАтрибут Из ТекИБ.Параметры() Цикл
			Сообщить(ТекАтрибут.Ключ + " : " + ТекАтрибут.Значение);
		КонецЦикла;
		Сообщить("");
	КонецЦикла;
				
КонецПроцедуры

Процедура ВывестиСписокБаз()
	
	СерверРАК = "localhost";
	ПортРАК = 1545;
	ВерсияРАК = "8.3";

	Агент = Новый АгентКластера(СерверРАК, ПортРАК, ВерсияРАК);

	Сообщить(Агент.ОписаниеПодключения());

	АдминистраторыАгента = Агент.Администраторы().Список();

	Кластеры = Агент.Кластеры();

	СписокКластеров = Кластеры.Список();
	Для Каждого Кластер Из СписокКластеров Цикл

		АдминистраторыКластера = Кластер.Администраторы().Список();

		ВсеСеансы = Кластер.Сеансы().ИерархическийСписок("infobase,session-id");

		Отбор = Новый Соответствие();
		Отбор.Вставить("session-id", "2");
		Сеансы1 = Кластер.Сеансы().Список(Отбор);

		ВсеСоединения = Кластер.Соединения().Список();

		Сообщить(СтрШаблон("Кластер: %1", Кластер.Имя()));
		Для Каждого ТекПоле Из Кластер.Параметры() Цикл
			Сообщить(СтрШаблон("%1 : %2", ТекПоле.Ключ, ТекПоле.Значение));
		КонецЦикла;

		ОписаниеСерверов(Кластер.Серверы());
		ОписаниеИБ(Кластер.ИнформационныеБазы());

	КонецЦикла;

КонецПроцедуры // ВывестиСписокБаз()
	
//////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");

ВывестиСписокБаз();