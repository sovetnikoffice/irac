Перем Кластер_Агент;
Перем Кластер_Владелец;
Перем ПараметрыОбъекта;
Перем Элементы;

Перем Лог;

// Конструктор
//   
// Параметры:
//   АгентКластера		- АгентКластера	- ссылка на родительский объект агента кластера
//   Кластер			- Кластер		- ссылка на родительский объект кластера
//
Процедура ПриСозданииОбъекта(АгентКластера, Кластер)

	Кластер_Агент = АгентКластера;
	Кластер_Владелец = Кластер;

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

	ПараметрыЗапуска.Добавить("cluster");
	ПараметрыЗапуска.Добавить("admin");
	ПараметрыЗапуска.Добавить("list");

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));
	ПараметрыЗапуска.Добавить(Кластер_Владелец.СтрокаАвторизации());

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

// Функция возвращает количество администраторов кластера в списке
//   
// Возвращаемое значение:
//	Число - количество администраторов кластера
//
Функция Количество() Экспорт

	Если Элементы = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат Элементы.Количество();

КонецФункции // Количество()

// Функция возвращает список администраторов кластера
//   
// Параметры:
//   Отбор					 	- Структура	- Структура отбора администраторов (<поле>:<значение>)
//   ОбновитьПринудительно 		- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Массив - список администраторов кластера 1С
//
Функция Список(Отбор = Неопределено, ОбновитьПринудительно = Ложь) Экспорт

	АдминистраторыКластера = Элементы.Список(Отбор, ОбновитьПринудительно);
	
	Возврат АдминистраторыКластера;

КонецФункции // Список()

// Функция возвращает список администраторов кластера 1С
//   
// Параметры:
//   ПоляИерархии 			- Строка		- Поля для построения иерархии списка администраторов, разделенные ","
//   ОбновитьПринудительно 	- Булево		- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - список администраторов кластеров 1С
//		<имя поля объекта>	- Массив(Соответствие), Соответствие	- список администраторов или следующий уровень
//
Функция ИерархическийСписок(Знач ПоляИерархии, ОбновитьПринудительно = Ложь) Экспорт

	АдминистраторыКластера = Элементы.ИерархическийСписок(ПоляИерархии, ОбновитьПринудительно);
	
	Возврат АдминистраторыКластера;

КонецФункции // ИерархическийСписок()

// Функция возвращает описание администратора кластера 1С
//   
// Параметры:
//   Имя				 	- Строка	- Имя администраторов кластера
//   ОбновитьПринудительно 	- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - описание администратора кластера 1С
//
Функция Получить(Знач Имя, Знач ОбновитьПринудительно = Ложь) Экспорт

	Отбор = Новый Соответствие();
	Отбор.Вставить("name", Имя);
	
	АдминистраторыКластера = Элементы.Список(Отбор, ОбновитьПринудительно);
	
	Если АдминистраторыКластера.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат АдминистраторыКластера[0];

КонецФункции // Получить()

// Процедура добавляет нового администратора кластера
//   
// Параметры:
//	Имя							- Строка		- имя администратора кластера 1С
//	ПараметрыАдминКластера		- Структура		- параметры создаваемого администратора
//		- Пароль					- Строка		- пароль администратора кластера 1С
//		- Описание					- Строка		- описание администратора кластера 1С
//		- СпособАвторизации			- Строка		- Пароль / пользователь ОС
//		- ПользовательОС			- Строка	- пользователь ОС, соответствующий администратору
//	УстановитьТекущим 			- Булево		- Истина - сделать добавленного администратора
//												  текущим для кластера
//
Процедура Добавить(Знач Имя, Знач ПараметрыАдминКластера = Неопределено, УстановитьТекущим = Ложь) Экспорт

	Если НЕ ТипЗнч(ПараметрыАдминКластера) = Тип("Структура") Тогда
		ПараметрыАдминКластера = Новый Структура();
	КонецЕсли;

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("cluster");
	ПараметрыЗапуска.Добавить("admin");
	ПараметрыЗапуска.Добавить("register");
	
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаАвторизации());

	ПараметрыЗапуска.Добавить(СтрШаблон("--name=%1", Имя));

	Если ПараметрыАдминКластера.Свойство("Пароль") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--pwd=%1", ПараметрыАдминКластера.Пароль));
	Иначе
		ПараметрыАдминКластера.Вставить("Пароль", "");
	КонецЕсли;
	Если ПараметрыАдминКластера.Свойство("Описание") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--descr=%1", ПараметрыАдминКластера.Описание));
	КонецЕсли;
	Если ПараметрыАдминКластера.Свойство("СпособАвторизации") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--auth=%1", ПараметрыАдминКластера.СпособАвторизации));
	Иначе
		ПараметрыЗапуска.Добавить(СтрШаблон("--auth=%1", Перечисления.СпособыАвторизации.Пароль));
	КонецЕсли;
	Если ПараметрыАдминКластера.Свойство("ПользовательОС") Тогда
		ПараметрыЗапуска.Добавить(СтрШаблон("--os-user=%1", ПараметрыАдминКластера.ПользовательОС));
	КонецЕсли;
	
	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));
	ПараметрыЗапуска.Добавить(Кластер_Владелец.СтрокаАвторизации());
	
	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Если УстановитьТекущим Тогда
		Кластер_Владелец.УстановитьАдминистратора(Имя, ПараметрыАдминКластера.Пароль);
	КонецЕсли;

	Лог.Информация(Кластер_Агент.ВыводКоманды());

	Элементы = Неопределено;

КонецПроцедуры // Добавить()

// Процедура удаляет администратора кластера
//   
// Параметры:
//   Имя			 	- Строка		- имя администратора кластера 1С
//
Процедура Удалить(Имя) Экспорт

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("cluster");
	ПараметрыЗапуска.Добавить("admin");
	ПараметрыЗапуска.Добавить("remove");
	
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаАвторизации());

	ПараметрыЗапуска.Добавить(СтрШаблон("--name=%1", Имя));

	ПараметрыЗапуска.Добавить(СтрШаблон("--cluster=%1", Кластер_Владелец.Ид()));
	ПараметрыЗапуска.Добавить(Кластер_Владелец.СтрокаАвторизации());
	
	Кластер_Агент.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Лог.Информация(Кластер_Агент.ВыводКоманды());

	Элементы = Неопределено;

КонецПроцедуры // Удалить()

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
