﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Считывание параметров передачи.
	ПараметрыПередачи = ПолучитьИзВременногоХранилища(Параметры.АдресХранилища); // см. ОбработкаОбъект.КонсольЗапросов.ПоместитьЗапросыВоВременноеХранилище
	Объект.Запросы.Загрузить(ПараметрыПередачи.Запросы);
	Объект.Параметры.Загрузить(ПараметрыПередачи.Параметры);
	Объект.ИмяФайла = ПараметрыПередачи.ИмяФайла;
	ИдентификаторТекущегоЗапроса = ПараметрыПередачи.ИдентификаторТекущегоЗапроса;
	ИдентификаторТекущегоПараметра = ПараметрыПередачи.ИдентификаторТекущегоПараметра;
	
	ОбработкаОбъект = ОбъектОбработки();
	Объект.ДоступныеТипыДанных = ОбработкаОбъект.Метаданные().Реквизиты.ДоступныеТипыДанных.Тип;
	
	СписокТипов = ОбъектОбработки().СформироватьСписокТипов();
	ОбработкаОбъект.ФильтрацияСпискаТипов(СписокТипов, "");
	
	Фильтр = Новый Структура;
	Фильтр.Вставить("Идентификатор", ИдентификаторТекущегоЗапроса);
	СтрокиЗапросовСИдентификатор = Объект.Запросы.НайтиСтроки(Фильтр);
	Если СтрокиЗапросовСИдентификатор.Количество() > 0 Тогда
		Элементы.Запросы.ТекущаяСтрока = СтрокиЗапросовСИдентификатор.Получить(0).ПолучитьИдентификатор();
	КонецЕсли;
	Заголовок = НСтр("ru = 'Выбрать запрос'");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗапросыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	
	ЭлементКопирования = Элемент.ТекущиеДанные;
	
	ИмяЗапросаПоУмолчанию = ВладелецФормы.ИмяЗапросаПоУмолчанию;
	ИдентификаторЗапроса = Новый УникальныйИдентификатор;
	
	Запрос = Объект.Запросы.Добавить();
	Запрос.Имя = ИмяЗапросаПоУмолчанию;
	Запрос.Идентификатор = ИдентификаторЗапроса;
	Запрос.АдресХранилищаПланаЗапроса = ПоместитьВоВременноеХранилище(Неопределено,Новый УникальныйИдентификатор);
	
	Если Копирование Тогда
		ИмяНовогоЗапроса = СформироватьИмяКопииЗапроса(ЭлементКопирования.Имя);
		Запрос.Имя = ИмяНовогоЗапроса;
		Запрос.Текст = ЭлементКопирования.Текст;
		ИдентификаторТекущегоЗапроса = ЭлементКопирования.Идентификатор;
		
		// Копирование параметров
		Фильтр = Новый Структура;
		Фильтр.Вставить("ИдентификаторЗапроса", ИдентификаторТекущегоЗапроса);
		МассивПараметров = Объект.Параметры.НайтиСтроки(Фильтр);
		Для каждого Стр Из МассивПараметров Цикл
			ЭлементПараметр = Объект.Параметры.Добавить();
			ЭлементПараметр.Идентификатор = Новый УникальныйИдентификатор;
			ЭлементПараметр.ИдентификаторЗапроса = ИдентификаторЗапроса;
			ЭлементПараметр.Имя = Стр.Имя;
			ЭлементПараметр.Тип = Стр.Тип;
			ЭлементПараметр.Значение = Стр.Значение;
			ЭлементПараметр.ТипВФорме = Стр.ТипВФорме;
			ЭлементПараметр.ЗначениеВФорме = Стр.ЗначениеВФорме;
		КонецЦикла;
	КонецЕсли;
	
	ВладелецФормы.Модифицированность = Истина;
	
КонецПроцедуры

// Обработчик перед удалением Запроса.
// Удаляет параметры для данного запроса.
//
&НаКлиенте
Процедура ЗапросыПередУдалением(Элемент, Отказ)
	
	ПараметрыВФорме = Объект.Параметры;
	ИдентификаторУдаляемогоЗапроса = Элементы.Запросы.ТекущиеДанные.Идентификатор;
	
	КоличествоСтрок = ПараметрыВФорме.Количество() - 1;
	Пока КоличествоСтрок >= 0 Цикл
		ТекущийПараметр = ПараметрыВФорме.Получить(КоличествоСтрок);
		Если ТекущийПараметр.ИдентификаторЗапроса = ИдентификаторУдаляемогоЗапроса Тогда
			ПараметрыВФорме.Удалить(КоличествоСтрок);
			Модифицированность = Истина;
		КонецЕсли;
		КоличествоСтрок = КоличествоСтрок - 1;
	КонецЦикла;
	
	ВладелецФормы.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗапроса();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросыИмяПриИзменении(Элемент)
	
	ВладелецФормы.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СравнитьРезультатыЗапросов(Команда)
	
#Если Не ТолстыйКлиентУправляемоеПриложение И Не ТолстыйКлиентОбычноеПриложение Тогда
	ПоказатьПредупреждение(, НСтр("ru = 'Сравнивать результаты можно только в режиме толстого клиента.'"));
	Возврат;
#Иначе
	ВыделенныеЗапросы = Элементы.Запросы.ВыделенныеСтроки;
	Если ВыделенныеЗапросы.Количество() <> 2 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для сравнения выберите только 2 запроса'"));
		Возврат;
	Иначе
		ИдентификаторСтрокиПервогоЗапроса = ВыделенныеЗапросы.Получить(0);
		ИдентификаторСтрокиВторогоЗапроса = ВыделенныеЗапросы.Получить(1);
	КонецЕсли;
	
	ИдентификаторПервогоЗапроса = Объект.Запросы.НайтиПоИдентификатору(ИдентификаторСтрокиПервогоЗапроса).Идентификатор;
	ИдентификаторВторогоЗапроса = Объект.Запросы.НайтиПоИдентификатору(ИдентификаторСтрокиВторогоЗапроса).Идентификатор;
	
	ФайлПервогоЗапроса = Неопределено;
	ФайлВторогоЗапроса = Неопределено;
	
	ПолучитьТабличныеДокументыСравниваемыхЗапросов(ИдентификаторПервогоЗапроса, ИдентификаторВторогоЗапроса, ФайлПервогоЗапроса, ФайлВторогоЗапроса);
	
	Если ТипЗнч(ФайлПервогоЗапроса) <> Неопределено
		И ТипЗнч(ФайлВторогоЗапроса) <> Неопределено Тогда
		// Сравниваются два файла.
		Сравнение = Новый СравнениеФайлов;
		Сравнение.СпособСравнения = СпособСравненияФайлов.ТабличныйДокумент;
		Сравнение.ПервыйФайл = ФайлПервогоЗапроса;
		Сравнение.ВторойФайл = ФайлВторогоЗапроса;
		Сравнение.ПоказатьРазличияМодально();
		
		УдалитьФайлы(ФайлПервогоЗапроса);
		УдалитьФайлы(ФайлВторогоЗапроса);
	КонецЕсли;
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗапросыВДругойФайл(Команда)
	
	СохранитьФайлЗапроса();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗапросыВФайл(Команда)
	
	СохранитьФайлЗапроса(Объект.ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьЗапросыИзФайла(Команда)
	
	ОбработкаЧтенияФайла(Истина);
	ВладелецФормы.Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗапрос(Команда)
	
	ОбработкаВыбораЗапроса();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗапросыИзФайла(Команда)
	
	ОбработкаЧтенияФайла(Ложь);
	ВладелецФормы.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОбъектОбработки()
	
	Возврат РеквизитФормыВЗначение("Объект");
	
КонецФункции

&НаСервере
Функция ПоместитьЗапросыВСтруктуру(ИдентификаторЗапроса, ИдентификаторПараметра)
	
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("АдресХранилища", ОбъектОбработки().ПоместитьЗапросыВоВременноеХранилище(Объект, ИдентификаторЗапроса, ИдентификаторПараметра));
	Возврат ПараметрыПередачи;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораЗапроса()
	
	ТекущаяСтрока = Элементы.Запросы.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущийЗапрос = Элементы.Запросы.ТекущиеДанные;
		ИдентификаторТекущегоЗапроса = ТекущийЗапрос.Идентификатор;
		
		ПараметрыПередачи = ПоместитьЗапросыВСтруктуру(ИдентификаторТекущегоЗапроса, ИдентификаторТекущегоПараметра);
		
		// Передача в открывающую форму.
		Закрыть();
		Оповестить("ВыгрузитьЗапросыВРеквизиты", ПараметрыПередачи);
		Оповестить("ОчиститьМеткуЗапроса");
		Оповестить("ОбновитьФормуКлиент");
	Иначе
		ПоказатьСообщениеПользователю(НСтр("ru = 'Выберите запрос.'"), "Объект");
	КонецЕсли;
	
КонецПроцедуры

// Сохранение
&НаКлиенте
Процедура СохранитьФайлЗапроса(ИмяФайла = "")
	
	ДополнительныеПараметры = Новый Структура("ИмяФайла", ИмяФайла);
#Если Не ВебКлиент Тогда
		// В мобильном, тонком и толстом клиентах расширение подключено всегда.
		СохранитьФайлЗапросаЗавершение(Истина, ДополнительныеПараметры);
		Возврат;
#КонецЕсли
	
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект,
		Новый ОписаниеОповещения("СохранитьФайлЗапросаЗавершение", ЭтотОбъект, ДополнительныеПараметры));
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗапросаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	Если Результат Тогда
		
		Получаемые = Новый Массив;
		Получаемые.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяФайла, СохранитьЗапросыВоВременноеХранилище(Объект)));
		
		ОписаниеОповещенияПолученияФайлов = Новый ОписаниеОповещения("ПолучениеФайловЗавершение", ЭтотОбъект);
		Если ЗначениеЗаполнено(ИмяФайла) Тогда
			НачатьПолучениеФайлов(ОписаниеОповещенияПолученияФайлов, Получаемые, ИмяФайла, Ложь);
		Иначе
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Диалог.Заголовок = НСтр("ru = 'Выберите файл запросов'");
			Диалог.ПредварительныйПросмотр = Ложь;
			Диалог.Фильтр = НСтр("ru = 'Файл запросов (*.q1c)|*.q1c'");
			Диалог.Расширение = "q1c";
			Диалог.ПроверятьСуществованиеФайла = Истина;
			Диалог.МножественныйВыбор = Ложь;
			
			НачатьПолучениеФайлов(ОписаниеОповещенияПолученияФайлов, Получаемые, Диалог, Истина);
		КонецЕсли;
	Иначе
		ПоказатьСообщениеПользователю(НСтр("ru = 'Без расширения для работы с 1С:Предприятием невозможно работать с файлами.'"), "Объект");
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   Результат - Массив из Файл
//   ДополнительныеПараметры - Структура
//
&НаКлиенте
Процедура ПолучениеФайловЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И ТипЗнч(Результат) = Тип("Массив") Тогда
		ВладелецФормы.Модифицированность = Ложь;
		Объект.ИмяФайла = Результат[0].Имя;
		ВладелецФормы.Объект.ИмяФайла = Результат[0].Имя;
	КонецЕсли;
	
КонецПроцедуры

// Загрузка

&НаКлиенте
Процедура ОбработкаЧтенияФайла(Удалять)
	
	ДополнительныеПараметры = Новый Структура("Удалять", Удалять);
	
#Если Не ВебКлиент Тогда
		// В мобильном, тонком и толстом клиентах расширение подключено всегда.
		ЧтениеФайлаЗавершение(Истина, ДополнительныеПараметры);
		Возврат;
#КонецЕсли
	
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект,
		Новый ОписаниеОповещения("ЧтениеФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры));
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЧтениеФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		// Выбор файла для загрузки.
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.Заголовок = НСтр("ru = 'Выберите файл запросов'");
		Диалог.ПредварительныйПросмотр = Ложь;
		Диалог.Фильтр = НСтр("ru = 'Файл запросов (*.q1c)|*.q1c'");
		Диалог.Расширение = "q1c";
		Диалог.ПроверятьСуществованиеФайла  = Истина;
		Диалог.МножественныйВыбор = Ложь;

		ДополнительныеПараметры = Новый Структура("Удалять", ДополнительныеПараметры.Удалять);
		Оповещение = Новый ОписаниеОповещения("ПомещениеФайловЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайлов(Оповещение,, Диалог, Истина, УникальныйИдентификатор);
	Иначе
		ПоказатьСообщениеПользователю(НСтр("ru = 'Без расширения для работы с 1С:Предприятием невозможно работать с файлами.'"), "Объект");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайловЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		Если Результат.Количество() > 0 Тогда
			
			Если ДополнительныеПараметры.Удалять Тогда
				Объект.Запросы.Очистить();
				Объект.Параметры.Очистить();
			КонецЕсли;
			
			ИмяФайла = Результат[0].Имя;
			ЗагрузитьЗапросыИзФайла(Результат[0].Хранение);
			Объект.ИмяФайла = ИмяФайла;
			
		КонецЕсли;
	КонецЕсли;
	
	КоличествоЗапросов = Объект.Запросы.Количество();
	Если КоличествоЗапросов > 0 Тогда
		
		ИдентификаторТекущегоЗапроса = Объект.Запросы.Получить(0).Идентификатор;
		ПараметрыПередачи = ПоместитьЗапросыВСтруктуру(ИдентификаторТекущегоЗапроса, ИдентификаторТекущегоПараметра);
		
		Оповестить("ВыгрузитьЗапросыВРеквизиты", ПараметрыПередачи);
		Оповестить("ОбновитьФормуКлиент");
		
	КонецЕсли;
	
КонецПроцедуры

// Общие процедуры для сохранения и загрузки

&НаКлиенте
Процедура НачатьПодключениеРасширенияРаботыСФайламиЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Истина);
	Иначе
		Если Не ЗаданВопросОбУстановкеРасширения Тогда
			ЗаданВопросОбУстановкеРасширения = Истина;
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОбУстановкеРасширения", ЭтотОбъект, ДополнительныеПараметры);
			НачатьУстановкуРасширенияРаботыСФайлами(ОписаниеОповещения);
		Иначе
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры, РасширениеПодключено);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОбУстановкеРасширения(Оповещение) Экспорт
	
	ВыполнитьОбработкуОповещения(Оповещение, Истина);
	
КонецПроцедуры

// Сохранение запросов.
//
// Параметры:
//  ИмяФайла - имя файла XML.
//  Объект - объект обработки.
//
&НаСервере
Функция СохранитьЗапросы(Знач Объект)
	
	ДвоичныеДанные = ОбъектОбработки().ЗаписатьЗапросыВФайлXML(Объект);
	Возврат ДвоичныеДанные;
	
КонецФункции

&НаСервере
Функция СохранитьЗапросыВоВременноеХранилище(Знач Объект)
	
	ДвоичныеДанные = СохранитьЗапросы(Объект);
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьЗапросыИзФайла(АдресВоВременномХранилище)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	ОбъектВнешнейОбработки = ОбъектОбработки().ПрочитатьЗапросыИзФайлаXML(ДвоичныеДанные);
	ЗаполнитьЗапросыИПараметрыИзОбъектаВнешнейОбработки(ОбъектВнешнейОбработки);
	
КонецПроцедуры

// Заполняет из объекта внешней обработки запросы и параметры.
//
// Параметры:
//  ОбъектОбработки - объект внешней обработки.
//
&НаСервере
Процедура ЗаполнитьЗапросыИПараметрыИзОбъектаВнешнейОбработки(ОбъектОбработки)
	
	ЗапросыОбработка = ОбъектОбработки.Запросы;
	ПараметрыОбработка = ОбъектОбработки.Параметры;
	
	Объект.Запросы.Очистить();
	Объект.Параметры.Очистить();
	
	// Заполнение запросов и параметров в форме.
	Для каждого ТекстЗапрос Из ЗапросыОбработка Цикл
		ЭлементЗапроса = Объект.Запросы.Добавить();
		ЭлементЗапроса.Идентификатор = ТекстЗапрос.Идентификатор;
		ЭлементЗапроса.Имя = ТекстЗапрос.Имя;
		ЭлементЗапроса.Текст = ТекстЗапрос.Текст;
		ЭлементЗапроса.АдресХранилищаПланаЗапроса = ТекстЗапрос.АдресХранилищаПланаЗапроса;
	КонецЦикла;
	
	Для каждого ТекПараметр Из ПараметрыОбработка Цикл
		ТипСтрока = ТекПараметр.Тип;
		
		Значение = ТекПараметр.Значение;
		Значение = ЗначениеИЗСтрокиВнутр(Значение);
		
		Если ТипСтрока = "ТаблицаЗначений" ИЛИ ТипСтрока = "МоментВремени" ИЛИ ТипСтрока = "Граница" Тогда
			ЭлементПараметр = Объект.Параметры.Добавить();
			ЭлементПараметр.ИдентификаторЗапроса = ТекПараметр.ИдентификаторЗапроса;
			ЭлементПараметр.Идентификатор = ТекПараметр.Идентификатор;
			ЭлементПараметр.Имя = ТекПараметр.Имя;
			ЭлементПараметр.Тип = СписокТипов.НайтиПоЗначению(ТипСтрока).Значение;
			ЭлементПараметр.Значение = ТекПараметр.Значение;
			ЭлементПараметр.ТипВФорме = СписокТипов.НайтиПоЗначению(ТипСтрока).Представление;
			ЭлементПараметр.ЗначениеВФорме = ОбъектОбработки().ФормированиеПредставленияЗначения(Значение);
		Иначе
			Массив = Новый Массив;
			Массив.Добавить(Тип(ТипСтрока));
			Описание = Новый ОписаниеТипов(Массив);
			
			ЭлементПараметр = Объект.Параметры.Добавить();
			ЭлементПараметр.ИдентификаторЗапроса = ТекПараметр.ИдентификаторЗапроса;
			ЭлементПараметр.Идентификатор = ТекПараметр.Идентификатор;
			ЭлементПараметр.Имя = ТекПараметр.Имя;
			ЭлементПараметр.Тип = ТипСтрока;
			ЭлементПараметр.ТипВФорме = Описание;
			ЭлементПараметр.Значение = ЗначениеВСтрокуВнутр(Значение);
			ЭлементПараметр.ЗначениеВФорме = Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСообщениеПользователю(ТекстСообщения, ПутьКДанным)
	
	ОчиститьСообщения();
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст = ТекстСообщения;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.УстановитьДанные(Объект);
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТабличныеДокументыСравниваемыхЗапросов(ИДПервогоЗапроса, ИДВторогоЗапроса, ФайлПервогоЗапроса, ФайлВторогоЗапроса)
	
	ФильтрПервого = Новый Структура;
	ФильтрПервого.Вставить("Идентификатор",ИДПервогоЗапроса);
	АдресПервогоДокумента = Объект.Запросы.НайтиСтроки(ФильтрПервого).Получить(0).АдресРезультата;
	
	ФильтрПервого.Вставить("Идентификатор",ИДВторогоЗапроса);
	АдресВторогоДокумента = Объект.Запросы.НайтиСтроки(ФильтрПервого).Получить(0).АдресРезультата;
	
	Если ПустаяСтрока(АдресПервогоДокумента) ИЛИ ПустаяСтрока(АдресВторогоДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	ТДПервогоЗапроса = ПолучитьИзВременногоХранилища(АдресПервогоДокумента); // ДвоичныеДанные
	ТДВторогоЗапроса = ПолучитьИзВременногоХранилища(АдресВторогоДокумента); // ДвоичныеДанные
	
	ФайлПервогоЗапроса = ПолучитьИмяВременногоФайла("mxl");
	ТДПервогоЗапроса.Записать(ФайлПервогоЗапроса);
	
	ФайлВторогоЗапроса = ПолучитьИмяВременногоФайла("mxl");
	ТДВторогоЗапроса.Записать(ФайлВторогоЗапроса);
	
КонецПроцедуры

// Формирует имя копии запроса.
//
// Параметры:
//  Имя - передаваемое имя запроса.
//
&НаКлиенте
Функция СформироватьИмяКопииЗапроса(Имя)
	
	Флаг 	= Истина;
	Индекс 	= 1;
	
	Пока Флаг Цикл
		ФормируемоеИмяЗапроса = НСтр("ru = '%ИмяЗапроса% - Копия %НомерКопии%'");
		ФормируемоеИмяЗапроса = СтрЗаменить(ФормируемоеИмяЗапроса, "%ИмяЗапроса%", Имя);
		ФормируемоеИмяЗапроса = СтрЗаменить(ФормируемоеИмяЗапроса, "%НомерКопии%", Индекс);
		
		Фильтр = Новый Структура;
		Фильтр.Вставить("Имя", ФормируемоеИмяЗапроса);
		
		МассивЗапросовПоФильтру = Объект.Запросы.НайтиСтроки(Фильтр);
		
		Если МассивЗапросовПоФильтру.Количество() = 0 Тогда
			Флаг = Ложь;
		КонецЕсли;
		
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Возврат ФормируемоеИмяЗапроса;
	
КонецФункции

#КонецОбласти