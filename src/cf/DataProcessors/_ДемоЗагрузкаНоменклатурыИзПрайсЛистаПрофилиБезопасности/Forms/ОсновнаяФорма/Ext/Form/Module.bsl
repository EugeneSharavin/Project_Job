﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// АПК:78-выкл дополнительная обработка

// Обработчик клиентской назначаемой команды.
//
// Параметры:
//   ИдентификаторКоманды - Строка - имя команды, как оно задано в функции СведенияОВнешнейОбработке модуля объекта.
//   ОбъектыНазначения - Массив - ссылки, для которых выполняется команда.
//
&НаКлиенте
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения) Экспорт
	
	Параметры.ИдентификаторКоманды = ИдентификаторКоманды;
	ПараметрыКоманды = ДополнительныеОтчетыИОбработкиКлиент.ПараметрыВыполненияКомандыВФоне(Параметры.ДополнительнаяОбработкаСсылка);
	ПараметрыКоманды.ОбъектыНазначения = ОбъектыНазначения;
	ВыполнитьКомандуНапрямую(ПараметрыКоманды);
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры
// АПК:78-вкл

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ДополнительнаяОбработкаСсылка) Тогда
		Настройки = ДополнительныеОтчетыИОбработки.ЗагрузитьНастройки(Параметры.ДополнительнаяОбработкаСсылка);
		
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			АдресФайла = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Настройки, "АдресФайла");
		КонецЕсли;
	Иначе
		Параметры.ИдентификаторКоманды = "ФормаНастройки";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(АдресФайла) Тогда
		АдресФайла = "https://www.1c.ru/ftp/pub/pricelst/price_1c.zip";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Укажите путь к файлу прайс-листа'");
	ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Файл Microsoft Office Excel (*.xls)|*.xls|Архив (*.zip)|*.zip'");
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	
	Контекст = Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла);
	
	Оповещение = Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтотОбъект, Контекст);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(Оповещение, ДиалогОткрытияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершение(ВыбранныеФайлы, Контекст) Экспорт
	
	ДиалогОткрытияФайла = Контекст.ДиалогОткрытияФайла;
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		АдресФайла = ДиалогОткрытияФайла.ПолноеИмяФайла;
		Если ЗначениеЗаполнено(Параметры.ДополнительнаяОбработкаСсылка) Тогда
			СохранитьНастройкиФормы(Параметры.ДополнительнаяОбработкаСсылка, АдресФайла);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФайлаОчистка(Элемент, СтандартнаяОбработка)
	АдресФайла = "https://www.1c.ru/ftp/pub/pricelst/price_1c.zip";
	Если ЗначениеЗаполнено(Параметры.ДополнительнаяОбработкаСсылка) Тогда
		СохранитьНастройкиФормы(Параметры.ДополнительнаяОбработкаСсылка, АдресФайла);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьНастройкиФормы(Параметры.ДополнительнаяОбработкаСсылка, АдресФайла);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗагрузить(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	Разрешения = ИнтерактивныйЗапросРазрешений();
	Обработчик = Новый ОписаниеОповещения("СохранитьИЗагрузитьЗавершение", ЭтотОбъект);
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Разрешения, ЭтотОбъект, Обработчик);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьИЗагрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	СопровождающийТекст = НСтр("ru = 'Загрузка номенклатуры'");
	
	ПараметрыКоманды = ДополнительныеОтчетыИОбработкиКлиент.ПараметрыВыполненияКомандыВФоне(Параметры.ДополнительнаяОбработкаСсылка);
	ПараметрыКоманды.Вставить("АдресФайла", АдресФайла);
	ПараметрыКоманды.СопровождающийТекст = СопровождающийТекст + "...";
	
	ПоказатьОповещениеПользователя(ПараметрыКоманды.СопровождающийТекст);
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияДлительнойОперации", ЭтотОбъект, СопровождающийТекст);
	
	Операция = ВыполнитьКомандуНапрямую(ПараметрыКоманды);
	ВыполнитьОбработкуОповещения(Обработчик, Операция);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияДлительнойОперации(Операция, СопровождающийТекст) Экспорт
	
	Если Операция.Статус = "Выполнено" Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Успешное завершение'"), , СопровождающийТекст, БиблиотекаКартинок.Успешно32);
	Иначе
		ПоказатьПредупреждение(, Операция.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиФормы(ДополнительнаяОбработкаСсылка, АдресФайла)
	
	СохраняемоеЗначение = Новый Структура("АдресФайла", АдресФайла);
	ДополнительныеОтчетыИОбработки.СохранитьНастройки(ДополнительнаяОбработкаСсылка, СохраняемоеЗначение);
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьКомандуНапрямую(ПараметрыКоманды)
	
	Операция = Новый Структура("Статус, КраткоеПредставлениеОшибки, ПодробноеПредставлениеОшибки");
	Попытка
		ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(
			Параметры.ИдентификаторКоманды,
			ПараметрыКоманды,
			ЭтотОбъект);
		Операция.Статус = "Выполнено";
	Исключение
		Операция.КраткоеПредставлениеОшибки   = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Операция.ПодробноеПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	Возврат Операция;
	
КонецФункции

&НаСервере
Функция ИнтерактивныйЗапросРазрешений()
	
	Разрешения = Новый Массив();
	
	ЭтоИнтернетАдрес = Ложь;
	Для Каждого Префикс Из ПрефиксыИнтернетПротоколов() Цикл
		Если Лев(НРег(АдресФайла), СтрДлина(Префикс)) = НРег(Префикс) Тогда
			ЭтоИнтернетАдрес = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Если ЭтоИнтернетАдрес Тогда
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресФайла);
		
		Разрешения.Добавить(
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
				НРег(СтруктураURI.Схема),
				НРег(СтруктураURI.Хост),
				СтруктураURI.Порт));
		
	Иначе
		
		АдресВФайловойСистеме = СтрЗаменить(АдресФайла, "\", "/");
		СтруктураАдреса = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(АдресВФайловойСистеме, "/", Истина, Ложь);
		СтруктураАдреса.Удалить(СтруктураАдреса.ВГраница());
		Каталог = СтрСоединить(СтруктураАдреса, ",");
		
		Разрешения.Добавить(
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(Каталог, Истина, Ложь));
		
	КонецЕсли;
	
	Идентификаторы = Новый Массив();
	Идентификаторы.Добавить(
		МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
			Параметры.ДополнительнаяОбработкаСсылка,
			Разрешения,
			Истина));
	
	Возврат Идентификаторы;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПрефиксыИнтернетПротоколов()
	
	Результат = Новый Массив();
	
	Результат.Добавить("http");
	Результат.Добавить("https");
	Результат.Добавить("ftp");
	Результат.Добавить("ftps");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
