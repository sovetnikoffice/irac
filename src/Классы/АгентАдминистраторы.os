Перем Кластер_Агент;
Перем ПараметрыОбъекта;
Перем Элементы;

Перем Лог;

// Конструктор
//   
// Параметры:
//   АгентКластера			- АгентКластера	- ссылка на родительский объект агента кластера
//
Процедура ПриСозданииОбъекта(АгентКластера)

	Кластер_Агент = АгентКластера;
	
	ПараметрыОбъекта = Новый ПараметрыОбъекта("admin");

	Элементы = Новый ОбъектыКластера(ЭтотОбъект);

КонецПроцедуры // ПриСозданииОбъекта()

// Процедура получает данные от сервиса администрирования кластера 1С
// и сохраняет в локальных переменных
//   
// Параметры:
//   ОбновитьПринудительно 		- Булево	- Истина - принудительно обновить данные (вызов RAC)
//											- Ложь - данные будут получены если истекло время актуальности
//													или данные не были получены ранее
//   
Процедура ОбновитьДанные(ОбновитьПринудительно = Ложь) Экспорт

	Если НЕ Элементы.ТребуетсяОбновление(ОбновитьПринудительно) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("agent");
	ПараметрыЗапуска.Добавить("admin");
	ПараметрыЗапуска.Добавить("list");

	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаАвторизации());

	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Элементы.Заполнить(Кластер_Агент.ВыводКоманды());

	Элементы.УстановитьАктуальность();

КонецПроцедуры // ОбновитьДанные()

// Функция возвращает коллекцию параметров объекта
//   
// Параметры:
//   ИмяПоляКлюча 		- Строка	- имя поля, значение которого будет использовано
//									  в качестве ключа возвращаемого соответствия
//   
// Возвращаемое значение:
//	Соответствие - коллекция параметров объекта, для получения/изменения значений
//
Функция ПараметрыОбъекта(ИмяПоляКлюча = "ИмяПараметра") Экспорт

	Возврат ПараметрыОбъекта.Получить(ИмяПоляКлюча);

КонецФункции // ПараметрыОбъекта()

// Функция возвращает количество администраторов агента в списке
//   
// Возвращаемое значение:
//	Число - количество администраторов агента
//
Функция Количество() Экспорт

	Если Элементы = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат Элементы.Количество();

КонецФункции // Количество()

// Функция возвращает список администраторов агента кластера
//   
// Параметры:
//   Отбор					 	- Структура	- Структура отбора администраторов (<поле>:<значение>)
//   ОбновитьПринудительно 		- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Массив - список администраторов агента кластера 1С
//
Функция Список(Отбор = Неопределено, ОбновитьПринудительно = Ложь) Экспорт

	АдминистраторыАгента = Элементы.Список(Отбор, ОбновитьПринудительно);
	
	Возврат АдминистраторыАгента;

КонецФункции // Список()

// Функция возвращает список администраторов агента кластеров 1С
//   
// Параметры:
//   ПоляИерархии 			- Строка		- Поля для построения иерархии списка администраторов, разделенные ","
//   ОбновитьПринудительно 	- Булево		- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - список администраторов агента кластеров 1С
//		<имя поля объекта>	- Массив(Соответствие), Соответствие	- список администраторов или следующий уровень
//
Функция ИерархическийСписок(Знач ПоляИерархии, ОбновитьПринудительно = Ложь) Экспорт

	АдминистраторыАгента = Элементы.ИерархическийСписок(ПоляИерархии, ОбновитьПринудительно);
	
	Возврат АдминистраторыАгента;

КонецФункции // ИерархическийСписок()

// Функция возвращает описание администратора агента кластеров 1С
//   
// Параметры:
//   Имя				 	- Строка	- Имя администраторов агента
//   ОбновитьПринудительно 	- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - описание администратора агента кластеров 1С
//
Функция Получить(Знач Имя, Знач ОбновитьПринудительно = Ложь) Экспорт

	Отбор = Новый Соответствие();
	Отбор.Вставить("name", Имя);

	АдминистраторыАгента = Элементы.Список(Отбор, ОбновитьПринудительно);
	
	Если АдминистраторыАгента.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат АдминистраторыАгента[0];

КонецФункции // Получить()

// Процедура добавляет нового администратора агента кластеров
//   
// Параметры:
//	Имя							- Строка		- имя администратора агента кластеров 1С
//	ПараметрыАдминАгента		- Структура		- параметры создаваемого администратора
//		- Пароль					- Строка		- пароль администратора агента кластеров 1С
//		- Описание					- Строка		- описание администратора агента кластеров 1С
//		- СпособАвторизации			- Строка		- Пароль / пользователь ОС
//		- ПользовательОС			- Строка	- пользователь ОС, соответствующий администратору
//	УстановитьТекущим 			- Булево		- Истина - сделать добавленного администратора
//												  текущим для агента кластеров
//
Процедура Добавить(Знач Имя, Знач ПараметрыАдминАгента = Неопределено, УстановитьТекущим = Ложь) Экспорт

	Если НЕ ТипЗнч(ПараметрыАдминАгента) = Тип("Структура") Тогда
		ПараметрыАдминАгента = Новый Структура();
	КонецЕсли;

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("agent");
	ПараметрыЗапуска.Добавить("admin");
	ПараметрыЗапуска.Добавить("register");
	
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаАвторизации());

	ПараметрыЗапуска.Добавить(СтрШаблон("--name=%1", Имя));

	Если ПараметрыАдминАгента.Свойство("Пароль") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--pwd=%1", ПараметрыАдминАгента.Пароль));
	Иначе
		ПараметрыАдминАгента.Вставить("Пароль", "");
	КонецЕсли;
	Если ПараметрыАдминАгента.Свойство("Описание") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--descr=%1", ПараметрыАдминАгента.Описание));
	КонецЕсли;
	Если ПараметрыАдминАгента.Свойство("СпособАвторизации") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--auth=%1", ПараметрыАдминАгента.СпособАвторизации));
	Иначе
		ПараметрыЗапуска.Добавить(СтрШаблон("--auth=%1", Перечисления.СпособыАвторизации.Пароль));
	КонецЕсли;
	Если ПараметрыАдминАгента.Свойство("ПользовательОС") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--os-user=%1", ПараметрыАдминАгента.ПользовательОС));
	КонецЕсли;
	
	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Если УстановитьТекущим Тогда
		Кластер_Агент.УстановитьАдминистратора(Имя, ПараметрыАдминАгента.Пароль);
	КонецЕсли;

	Лог.Информация(Кластер_Агент.ВыводКоманды());

	Элементы = Неопределено;

КонецПроцедуры // Добавить()

// Процедура удаляет администратора агента кластеров
//   
// Параметры:
//   Имя			 	- Строка		- имя администратора агента кластеров 1С
//
Процедура Удалить(Имя) Экспорт

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("agent");
	ПараметрыЗапуска.Добавить("admin");
	ПараметрыЗапуска.Добавить("remove");
	
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаАвторизации());

	ПараметрыЗапуска.Добавить(СтрШаблон("--name=%1", Имя));
	
	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Лог.Информация(Кластер_Агент.ВыводКоманды());

	Элементы = Неопределено;

КонецПроцедуры // Удалить()

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
