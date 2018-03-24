Перем Кластер_Агент;
Перем Элементы;

Перем Лог;

// Конструктор
//   
// Параметры:
//   АгентКластера			- АгентКластера	- ссылка на родительский объект агента кластера
//
Процедура ПриСозданииОбъекта(АгентКластера)

	Кластер_Агент = АгентКластера;
	
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

	Служебный.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Элементы.Заполнить(Служебный.РазобратьВыводКоманды(Служебный.ВыводКоманды()));

	Элементы.УстановитьАктуальность();

КонецПроцедуры // ОбновитьДанные()

// Функция возвращает список администраторов агента кластеров 1С
//   
// Параметры:
//   ПоляУпорядочивания 	- Строка		- Список полей упорядочивания списка администратор, разделенные ","
//											  если не указаны, то имя администратора name
//   ОбновитьПринудительно 		- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - список администраторов агента кластеров 1С
//
Функция ПолучитьСписок(Знач ПоляУпорядочивания = "", ОбновитьПринудительно = Ложь) Экспорт

	Возврат Элементы.ПолучитьСписок(ПоляУпорядочивания, ОбновитьПринудительно);

КонецФункции // ПолучитьСписок()

// Функция возвращает описание администратора агента кластеров 1С
//   
// Параметры:
//   Отбор				 	- Структура	- Структура отбора сеансов (<поле>:<значение>)
//   ОбновитьПринудительно 	- Булево	- Истина - принудительно обновить данные (вызов RAC)
//
// Возвращаемое значение:
//	Соответствие - описание администратора агента кластеров 1С
//
Функция Получить(Отбор, ОбновитьПринудительно = Ложь) Экспорт

	Возврат Элементы.Получить(Отбор, ОбновитьПринудительно);

КонецФункции // Получить()

// Процедура добавляет нового администратора агента кластеров
//   
// Параметры:
//   Имя			 	- Строка		- имя администратора агента кластеров 1С
//   Пароль			 	- Строка		- пароль администратора агента кластеров 1С
//   УстановитьТекущим 	- Булево		- Истина - сделать добавленного администратора текущим для агента кластеров
//   Описание		 	- Строка		- описание администратора агента кластеров 1С
//   СпособАвторизации 	- Строка		- Пароль / пользователь ОС
//   ПользовательОС 	- Строка		- пользователь ОС, соответствующий администратору
//
Процедура Добавить(Имя
				 , Пароль = ""
				 , УстановитьТекущим = Ложь
				 , Описание = ""
				 , СпособАвторизации = "pwd"
				 , ПользовательОС = "") Экспорт

	ПараметрыЗапуска = Новый Массив();
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаПодключения());

	ПараметрыЗапуска.Добавить("agent");
	ПараметрыЗапуска.Добавить("admin");
	ПараметрыЗапуска.Добавить("register");
	
	ПараметрыЗапуска.Добавить(Кластер_Агент.СтрокаАвторизации());

	ПараметрыЗапуска.Добавить(СтрШаблон("--name=%1", Имя));
	ПараметрыЗапуска.Добавить(СтрШаблон("--pwd=%1", Пароль));
	ПараметрыЗапуска.Добавить(СтрШаблон("--descr=%1", Описание));
	ПараметрыЗапуска.Добавить(СтрШаблон("--auth=%1", СпособАвторизации));
	ПараметрыЗапуска.Добавить(СтрШаблон("--os-user=%1", ПользовательОС));
	
	Служебный.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Если УстановитьТекущим Тогда
		Кластер_Агент.УстановитьАдминистратора(Имя, Пароль);
	КонецЕсли;

	Лог.Информация(Служебный.ВыводКоманды());

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
	
	Служебный.ВыполнитьКоманду(ПараметрыЗапуска);
	
	Лог.Информация(Служебный.ВыводКоманды());

	Элементы = Неопределено;

КонецПроцедуры // Удалить()

Лог = Логирование.ПолучитьЛог("ktb.lib.irac");
