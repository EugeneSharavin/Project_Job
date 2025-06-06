﻿
#Область ПрограммныйИнтерфейс

Процедура ИсторияСтатусовПодарочныхСертификатовПроверкаНаличия(Регистратор, Статус = Неопределено, ОжидаемоеКоличествоЗаписей = 0) Экспорт
	
	ОписаниеЗапроса = ЮТЗапросы.ОписаниеЗапроса();
	
	ОписаниеЗапроса.ИмяТаблицы = "РегистрСведений.ИсторияСтатусовПодарочныхСертификатов";
	
	ОписаниеЗапроса.Условия.Добавить("Регистратор = &Регистратор");
	
	Если Статус <> Неопределено Тогда
		ОписаниеЗапроса.Условия.Добавить("Статус = &Статус");
	КонецЕсли;
	
	ОписаниеЗапроса.ЗначенияПараметров.Вставить("Регистратор", Регистратор);

	Если Статус <> Неопределено Тогда
		ОписаниеЗапроса.ЗначенияПараметров.Вставить("Статус", Статус);
	КонецЕсли;
	
	ОписаниеЗапроса.ВыбираемыеПоля.Добавить("КОЛИЧЕСТВО(*) КАК КоличествоЭлементов");

	ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатЗапроса(ОписаниеЗапроса))
	    .ИмеетДлину(1)
	    .Свойство("[0].КоличествоЭлементов").Равно(ОжидаемоеКоличествоЗаписей);
		
КонецПроцедуры

Процедура ОстаткиСтоимостиПодарочныхСертификатовПроверкаНаличия(Регистратор, ОжидаемоеКоличествоЗаписей = 0, ОжидаемыйОстатокСтоимости = Неопределено) Экспорт
	
	ОписаниеЗапроса = ЮТЗапросы.ОписаниеЗапроса();
	
	ОписаниеЗапроса.ИмяТаблицы = "РегистрНакопления.ПодарочныеСертификаты";
	
	ОписаниеЗапроса.Условия.Добавить("Регистратор = &Регистратор");
	
	ОписаниеЗапроса.ЗначенияПараметров.Вставить("Регистратор", Регистратор);
	
	Если ОжидаемыйОстатокСтоимости = Неопределено Тогда
		ОписаниеЗапроса.ВыбираемыеПоля.Добавить("КОЛИЧЕСТВО(*) КАК КоличествоЭлементов");

		ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатЗапроса(ОписаниеЗапроса))
		    .ИмеетДлину(1)
		    .Свойство("[0].КоличествоЭлементов").Равно(ОжидаемоеКоличествоЗаписей);
	Иначе
		ОписаниеЗапроса.ВыбираемыеПоля.Добавить("КОЛИЧЕСТВО(*) КАК КоличествоЭлементов, СУММА(Сумма) КАК ОстатокСтоимости");

		ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатЗапроса(ОписаниеЗапроса))
		    .ИмеетДлину(1)
		    .Свойство("[0].КоличествоЭлементов").Равно(ОжидаемоеКоличествоЗаписей)
		    .Свойство("[0].ОстатокСтоимости").Равно(ОжидаемыйОстатокСтоимости);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
