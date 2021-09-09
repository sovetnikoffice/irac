# Библиотека управления кластером 1С

[![GitHub release](https://img.shields.io/github/release/ArKuznetsov/irac.svg?style=flat-square)](https://github.com/ArKuznetsov/irac/releases)
[![GitHub license](https://img.shields.io/github/license/ArKuznetsov/irac.svg?style=flat-square)](https://github.com/ArKuznetsov/irac/blob/develop/LICENSE)
[![Build Status](https://img.shields.io/github/workflow/status/ArKuznetsov/irac/%D0%9A%D0%BE%D0%BD%D1%82%D1%80%D0%BE%D0%BB%D1%8C%20%D0%BA%D0%B0%D1%87%D0%B5%D1%81%D1%82%D0%B2%D0%B0)](https://github.com/arkuznetsov/irac/actions/)
[![Quality Gate](https://open.checkbsl.org/api/project_badges/measure?project=irac&metric=alert_status)](https://open.checkbsl.org/dashboard/index/irac)
[![Coverage](https://open.checkbsl.org/api/project_badges/measure?project=irac&metric=coverage)](https://open.checkbsl.org/dashboard/index/irac)
[![Tech debt](https://open.checkbsl.org/api/project_badges/measure?project=irac&metric=sqale_index)](https://open.checkbsl.org/dashboard/index/irac)

## Назначение

Библиотека (oscript) irac предоставляет интерфейс управления кластером серверов 1С:Предприятие 8 с использованием утилиты администрирования кластера (RAC).

## Принцип работы

Библиотека подключается, как отдельный класс и используется для вызова команд утилиты RAC для взаимодействия с одним экземпляром сервера администрирования кластера 1С.

### Пример получения списка кластеров, параметров серверов и информационных баз

```bsl
#Использовать irac
Админ = Новый Структура();
Админ.Вставить("Администратор", "admin");
Админ.Вставить("Пароль", "P@$$w0rd");

Админка = Новый УправлениеКластером1С("8.3", "localhost:1545", Админ);

Кластеры = Админка.Кластеры();

// Обходим список кластеров
Для Каждого Кластер Из Кластеры.Список() Цикл
    Сообщить(Кластер.Получить("Имя"));
КонецЦикла;

// Кластер.УстановитьАдминистратора("<admin>", "<pwd>"); // - указывается если задан администратор кластера

Серверы = Кластер.Серверы();

// Обходим список серверов
Для Каждого Сервер Из Серверы.Список() Цикл

    Сообщить(Сервер.Имя() + " (" + Сервер.АдресСервера() + ":" + Сервер.ПортСервера() + ")");

    Для Каждого ТекАтрибут Из Серверы.ПараметрыОбъекта().ОписаниеСвойств() Цикл
        Сообщить(ТекАтрибут.Ключ + " : " + Сервер.Получить(ТекАтрибут.Значение.Имя));
    КонецЦикла;

КонецЦикла;

ИБ = Кластер.ИнформационныеБазы();

Сообщить("Всего ИБ: " + ИБ.Список().Количество());

// Обходим список информационных баз
Для Каждого ТекИБ Из ИБ.Список() Цикл

    Сообщить(ТекИБ.Имя() + " (" + ?(ТекИБ.ПолноеОписание(), "Полное", "Сокращенное") + " " + ТекИБ.Описание() + ")");

    Для Каждого ТекАтрибут Из ИБ.ПараметрыОбъекта().ОписаниеСвойств() Цикл
        Сообщить(ТекАтрибут.Ключ + " : " + ТекИБ.Получить(ТекАтрибут.Значение.Имя));
    КонецЦикла;

КонецЦикла;

```

### Пример блокировки/разблокировки сеансов в информационной базе

```bsl

#Использовать irac

Админ = Новый Структура("Администратор, Пароль", "agentAdmin", "P@$$w0rd");
Управление = Новый УправлениеКластером1С("8.3", "localhost:1545", Админ);

Кластер = Управление.Кластеры().Список()[0];
Кластер.УстановитьАдминистратора("clusterAdmin", "P@$$w0rd");

// Получение ИБ по имени
ИБ = Кластер.ИнформационныеБазы().Получить("MyAwesomeDatabase");
ИБ.УстановитьАдминистратора("Администратор", "P@$$w0rd");

// Установка блокировки начала сеансов с базой
ПараметрыИБ = Новый Структура();
ПараметрыИБ.Вставить("НачалоБлокировкиСеансов"   , Дата(20010101));
ПараметрыИБ.Вставить("ОкончаниеБлокировкиСеансов", Дата(20991231));
ПараметрыИБ.Вставить("СообщениеБлокировкиСеансов", "База заблокирована до особых распоряжений");
ПараметрыИБ.Вставить("КодРазрешения"             , "SuperSecretKey");
ПараметрыИБ.Вставить("БлокировкаСеансовВключена" , Перечисления.СостоянияВыключателя.Включено);

ИБ.Изменить(ПараметрыИБ);

// Снятие блокировки начала сеансов с базой
ПараметрыИБ = Новый Структура();
ПараметрыИБ.Вставить("БлокировкаСеансовВключена" , Перечисления.СостоянияВыключателя.Выключено);

ИБ.Изменить(ПараметрыИБ);

```

### Пример блокировки/разблокировки регламентных заданий в информационной базе

```bsl

#Использовать irac

Админ = Новый Структура("Администратор, Пароль", "agentAdmin", "P@$$w0rd");
Управление = Новый УправлениеКластером1С("8.3", "localhost:1545", Админ);

Кластер.УстановитьАдминистратора("clusterAdmin", "P@$$w0rd");

// Получение ИБ по имени
ИБ = Кластер.ИнформационныеБазы().Получить("MyAwesomeDatabase");
ИБ.УстановитьАдминистратора("Администратор", "P@$$w0rd");

// Установка блокировки регламентных заданий
ПараметрыИБ = Новый Структура();
ПараметрыИБ.Вставить("БлокировкаРегламентныхЗаданийВключена" , Перечисления.СостоянияВыключателя.Включено);

ИБ.Изменить(ПараметрыИБ);
// Снятие блокировки регламентных заданий
ПараметрыИБ = Новый Структура();
ПараметрыИБ.Вставить("БлокировкаРегламентныхЗаданийВключена" , Перечисления.СостоянияВыключателя.Выключено);

ИБ.Изменить(ПараметрыИБ);

```
## Структура основных объектов

УправлениеКластером1С

```txt
    |-Администраторы
    |-Кластеры
        |-Администраторы
        |-МенеджерыКластера
        |-Серверы
        |   |-ТребованияНазначения
        |-РабочиеПроцессы
        |   |-Лицензии
        |-ИнформационныеБазы
        |-Сервисы
        |-Сеансы
        |-Соединения
        |   |-Лицензии
        |-Блокировки
        |-ПрофилиБезопасности
        |-СчетчикиПотребленияРесурсов
```

## Объекты и методы

### УправлениеКластером1С

Основной класс библиотеки. Предоставляет интерфейс управления серверами 1С.

```bsl
    Админ = Новый Структура("Администратор, Пароль", "admin", "P@ssw0rd")
    УправлениеКластером = Новый УправлениеКластером1С("8.3.10", "localhost:1545", Админ);
```

| Параметры конструктора |||
|-|-|-|
| **ВерсияИлиПутьКУтилитеАдминистрирования** |Строка|маска версии 1С или путь к утилите RAC|
| **СтрокаПодключенияСервиса** |Строка|адрес:порт сервиса агента администрирования (RAS) (по умолчанию: "localhost:1545")|
| **Администратор** |Структура|параметры администратора агента сервера 1С|
| &nbsp;&nbsp;&nbsp;*- Администратор* | &nbsp;&nbsp;&nbsp;*Строка* | &nbsp;&nbsp;&nbsp;*имя администратора агента сервера 1С*|
| &nbsp;&nbsp;&nbsp;*- Пароль*        | &nbsp;&nbsp;&nbsp;*Строка* | &nbsp;&nbsp;&nbsp;*пароль администратора агента сервера 1С*|

| Методы |||
|-|-|-|
| **СтрокаПодключения()** |Строка|возвращает строку параметров подключения к агенту администрирования (RAS)|
| **СтрокаАвторизации()** |Строка|возвращает строку параметров авторизации на агенте кластера 1С|
| **УстановитьАдминистратора(Администратор, Пароль)** ||устанавливает параметры авторизации на агенте кластера 1С|
| **ИсполнительКоманд()** |ИсполнительКоманд|возвращает текущий объект-исполнитель команд|
| **УстановитьИсполнительКоманд(НовыйИсполнитель)** ||устанавливает объект-исполнитель команд|
| **ОписаниеПодключения()** |Строка|возвращает строку описания подключения к серверу администрирования кластера 1С|
| **Администраторы()** |АдминистраторыАгента|возвращает список администраторов агента кластера 1С|
| **Кластеры()** |Кластеры|возвращает список кластеров 1С|
| **ВыполнитьКоманду(ПараметрыКоманды)** |Число|передает команду в объект-исполнитель команды и возвращает код возврата команды|
| **ВыводКоманды()** |Массив(Соответствие)|возвращает вывод команды из объекта-исполнитель команд|

### ИсполнительКоманд

Вспомогательный объект для выполнения команд. Непосредственно вызывает утилиту RAC.

```bsl
    Админ = Новый Структура("Администратор, Пароль", "admin", "P@ssw0rd")
    УправлениеКластером = Новый УправлениеКластером1С("8.3.10", "localhost:1545", Админ);
    УправлениеКластером.УстановитьИсполнительКоманд(Новый ИсполнительКоманд("8.3"));
```

| Параметры конструктора |||
|-|-|-|
| **ВерсияИлиПутьКРАК** |Строка|маска версии 1С или путь к утилите RAC|

| Методы |||
|-|-|-|
| **ВерсияУтилитыАдминистрирования()** |Строка|возвращает версию утилиты RAC|
| **ПутьКУтилитеАдминистрирования()** |Строка|возвращает путь к утилите RAC|
| **УстановитьПутьКУтилитеАдминистрирования(Путь)** ||устанавливает переданный путь к утилите RAC|
| **ВыполнитьКоманду(ПараметрыКоманды)** |Массив(Соответствие)|выполняет команду и возвращает код возврата|
| **ВыводКоманды(РазобратьВывод)** |Строка/Массив(Соответствие)|возвращает вывод команды|
| **КодВозврата()** |Число|возвращает код возврата выполнения команды|

### Кластеры

Объект предоставляет доступ к списку кластеров, доступных для администрирования.

```bsl
    Админ = Новый Структура("Администратор, Пароль", "admin", "P@ssw0rd")
    УправлениеКластером = Новый УправлениеКластером1С("8.3.10", "localhost:1545", Админ);
    СписокКластеров = Новый Кластеры(УправлениеКластером);
```

```bsl
    Админ = Новый Структура("Администратор, Пароль", "admin", "P@ssw0rd")
    УправлениеКластером = Новый УправлениеКластером1С("8.3.10", "localhost:1545", Админ);
    СписокКластеров = УправлениеКластером.Кластеры();
```

| Параметры конструктора |||
|-|-|-|
| **АгентКластера** |УправлениеКластером1С|ссылка на родительский объект агент кластера|

| Методы |||
|-|-|-|
| **ОбновитьДанные(РежимОбновления)** ||обновляет список кластеров вызывая утилиту RAC|
| **ПараметрыОбъекта()** |Соответствие|список параметров объекта кластера|
| **Список(Отбор, РежимОбновления)** ||возвращает список кластеров, соответствующих отбору|
| **ВыполнитьКоманду(ПараметрыКоманды)** |Массив(Соответствие)|выполняет команду и возвращает код возврата|
| **ВыводКоманды(РазобратьВывод)** |Строка/Массив(Соответствие)|возвращает вывод команды|
| **КодВозврата()** |Число|возвращает код возврата выполнения команды|
