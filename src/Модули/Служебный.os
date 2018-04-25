#Использовать logos
#Использовать tempfiles
#Использовать asserts
#Использовать strings
#Использовать 1commands
#Использовать v8runner

Перем Лог;

// Функция добавляет кавычки в начале и в конце переданной строки
//   
// Параметры:
//   Строка	 	- Строка		- Строка для добавления кавычек
//
// Возвращаемое значение:
//	Строка - строка с добавленными кавычками
//
Функция ОбернутьВКавычки(Знач Строка) Экспорт
	Если Лев(Строка, 1) = """" И Прав(Строка, 1) = """" Тогда
		Возврат Строка;
	Иначе
		Возврат """" + Строка + """";
	КонецЕсли;
КонецФункции // ОбернутьВКавычки()

// Функция возвращает значение указанного поля структуры/соответствия или значение по умолчанию
//   
// Параметры:
//   ПарамСтруктура			- Структура, Соответствие	- коллекция из которой возвращается значение
//   Ключ		 			- Произвольный				- значение ключа коллекции для получения значения
//   ЗначениеПоУмолчанию	- Произвольный				- значение, возвращаемое в случае,
//														  когда ключ отсутствует в коллекции
//   
// Возвращаемое значение:
//	Произвольный - значение элемента коллекции или значение по умолчанию
//
Функция ПолучитьЗначениеИзСтруктуры(ПарамСтруктура, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт

	Если ТипЗнч(ПарамСтруктура) = Тип("Структура") Тогда
		Если ПарамСтруктура.Свойство("Ключ") Тогда
			Возврат ПарамСтруктура[Ключ];
		КонецЕсли;
	ИначеЕсли ТипЗнч(ПарамСтруктура) = Тип("Соответствие") Тогда
		Если НЕ ПарамСтруктура.Получить(Ключ) = Неопределено Тогда
			Возврат ПарамСтруктура.Получить(Ключ);
		КонецЕсли;
	КонецЕсли;

	Возврат ЗначениеПоУмолчанию;
			
КонецФункции // ПолучитьЗначениеИзСтруктуры()

// Функция преобразует массив соответствий в иерархию соответствий в соответствии с указанным порядком полей
// копирования данных не происходят, в результирующее соответствие помещаются исходные элементы массива
//   
// Параметры:
//   МассивСоответствий		- Массив(Соответствие)		- Данные для преобразования
//			<имя поля>			- Произвольный				- Значение элемента соответствия
//   ПоляИерархии			- Строка					- Поля для построения иерархии списка объектов, разделенные ","
//
// Возвращаемое значение:
//	Соответствие - иерархия соответствий по значениям полей упорядочивания
//		<значение поля упорядочивания>	- Соответствие,			- подчиненные данные по значениям
//										Массив(Соответствие)	следующего поля упорядочивания
//																или элементы исходного массива
//																на последнем уровне иерархии
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
//   МассивСоответствий	 	- Массив(Соответствие)		- Обрабатываемый массив
//   Отбор				 	- Соответствие				- Структура отбора вида <поле>:<значение>
//
// Возвращаемое значение:
//	Массив(Соответствие) - массив описание сеанса или массив описаний сеансов, соответствующие отбору
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
			Если НЕ ТекЭлемент.Получить(ТекЭлементОтбора.Ключ) = ТекЭлементОтбора.Значение Тогда
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

// Функция признак необходимости обновления данных
//   
// Параметры:
//   ОбъектДанных		 	- Произвольный	- данные для обновления
//   МоментАктуальности	 	- Число			- момент актуальности данных (мсек)
//   ПериодОбновления	 	- Число			- периодичность обновления (мсек)
//   ОбновитьПринудительно 	- Булево		- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Булево - Истина - требуется обновитьданные
//
Функция ТребуетсяОбновление(ОбъектДанных, МоментАктуальности, ПериодОбновления, ОбновитьПринудительно = Ложь) Экспорт

	Возврат (ОбновитьПринудительно
		ИЛИ ОбъектДанных = Неопределено
		ИЛИ (ПериодОбновления < (ТекущаяУниверсальнаяДатаВМиллисекундах() - МоментАктуальности)));

КонецФункции // ТребуетсяОбновление()

// Диагностическая процедура для вывода списка полей объекта
//   
// Параметры:
//   ОбъектДанных		 	- Произвольный	- объект, поля которого требуется вывести
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

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
