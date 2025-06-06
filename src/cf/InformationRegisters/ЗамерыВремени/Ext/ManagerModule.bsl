﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТопAPDEX(ДатаНачала, ДатаОкончания, ПериодАгрегации, Количество) Экспорт
	
	Запрос = Новый Запрос;
	
	НастроечнаяТаблицаИнтервалов = НастроечнаяТаблицаИнтервалов();
	
	ТаблицаИнтервалов = ТаблицаИнтерваловПоНастройкам(НастроечнаяТаблицаИнтервалов);
	
	ТекстЗапросаПоИнтервалам_Поля = ЧастьТекстаЗапросаПоИнтервалам(ТаблицаИнтервалов, "Замеры", "ВремяВыполнения", Истина);
	ТекстЗапросаПоИнтервалам_Группировки = ЧастьТекстаЗапросаПоИнтервалам(ТаблицаИнтервалов, "Замеры", "ВремяВыполнения", Ложь);
	
	Запрос = Новый Запрос;	
	Запрос.Текст = ТекстЗапроса();
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Интервалы_Поля,", ТекстЗапросаПоИнтервалам_Поля); 
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Интервалы_Группировки,", ТекстЗапросаПоИнтервалам_Группировки); 
	Запрос.УстановитьПараметр("ДатаНачала", (ДатаНачала - Дата(1,1,1)) * 1000);	
	Запрос.УстановитьПараметр("ДатаОкончания", (ДатаОкончания - Дата(1,1,1)) * 1000);
	Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
КонецФункции

Функция ТекстЗапроса()
	Возврат "ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((Замеры.ДатаНачалаЗамера/1000)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200) КАК Period,
	|	СпрКлючевыеОперации.Наименование КАК KOD,
	|	СпрКлючевыеОперации.Имя КАК KON,
	|	СпрКлючевыеОперации.ИмяХеш КАК KOHash,
	|	Замеры.ВыполненСОшибкой КАК ExecutedWithError,
	|	&Интервалы_Поля,
	|   КОЛИЧЕСТВО(1) КАК MeasurementQuantity,
	|   Среднее(Замеры.ВесЗамера) КАК AvgWeight,
	|   Максимум(Замеры.ВесЗамера) КАК MaxWeight
	|ИЗ
	|	РегистрСведений.ЗамерыВремени КАК Замеры
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Справочник.КлючевыеОперации КАК СпрКлючевыеОперации
	|ПО
	|	Замеры.КлючеваяОперация = СпрКлючевыеОперации.Ссылка
	|ГДЕ
	|	Замеры.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
	|СГРУППИРОВАТЬ ПО                             
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((Замеры.ДатаНачалаЗамера/1000)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200),
	|	&Интервалы_Группировки,
	|	СпрКлючевыеОперации.Имя,
	|	СпрКлючевыеОперации.ИмяХеш,
	|	СпрКлючевыеОперации.Наименование,
	|	Замеры.ВыполненСОшибкой
	|УПОРЯДОЧИТЬ ПО
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((Замеры.ДатаНачалаЗамера/1000)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200)"
КонецФункции

// Возвращает таблицу настроек интервалов по умолчанию.
//
// Возвращаемое значение:
//   ТаблицаЗначений:
//    * НижняяГраница  - Число
//    * ВерхняяГраница - Число
//    * Шаг            - Число
//
Функция НастроечнаяТаблицаИнтервалов()
	
	НастроечнаяТаблицаИнтервалов = Новый ТаблицаЗначений;
	НастроечнаяТаблицаИнтервалов.Колонки.Добавить("НижняяГраница", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Неотрицательный)));
	НастроечнаяТаблицаИнтервалов.Колонки.Добавить("ВерхняяГраница", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Неотрицательный)));
	НастроечнаяТаблицаИнтервалов.Колонки.Добавить("Шаг", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Неотрицательный)));
	
	// Если шаг и нижняя граница равны нулю, то это бесконечный интервал, не ограниченный снизу: x <= ВерхняяГраница.
	// Если же шаг и верхняя граница равны нулю, то это бесконечный интервал, не ограниченный сверху: x > ВерхняяГраница.
	
	// Менее 0,5с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 0;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 0.5;
	НоваяСтрокаНастроек.Шаг				 = 0;
	
	// От 0,5с до 5с с шагом 0,25 с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 0.5;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 5;
	НоваяСтрокаНастроек.Шаг				 = 0.25;
	
	// От 5с до 7с с шагом 0,5 с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 5;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 7;
	НоваяСтрокаНастроек.Шаг				 = 0.5;
	
	// От 7 до 12 с шагом 1с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 7;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 12;
	НоваяСтрокаНастроек.Шаг				 = 1;
	
	// От 12 до 20 с шагом 2с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 12;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 20;
	НоваяСтрокаНастроек.Шаг				 = 2;
	
	// От 20 до 30 с шагом 5с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 20;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 30;
	НоваяСтрокаНастроек.Шаг				 = 5;
	
	// От 30 до 80 с шагом 10с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 30;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 80;
	НоваяСтрокаНастроек.Шаг				 = 10;
	
	// От 80 до 120 с шагом 20с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 80;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 120;
	НоваяСтрокаНастроек.Шаг				 = 20;
	
	// От 120 до 300 с шагом 30с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 120;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 300;
	НоваяСтрокаНастроек.Шаг				 = 30;
	
	// От 300 до 600 с шагом 60с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 300;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 600;
	НоваяСтрокаНастроек.Шаг				 = 60;
	
	// От 600 до 1800 с шагом 300с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 600;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 1800;
	НоваяСтрокаНастроек.Шаг				 = 300;
	
	// От 1800 до 3600 с шагом 600с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 1800;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 3600;
	НоваяСтрокаНастроек.Шаг				 = 600;
	
	// От 3600 до 7200 с шагом 1800с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 3600;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 7200;
	НоваяСтрокаНастроек.Шаг				 = 1800;
	
	// От 7200 до 42300 с шагом 3600с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 7200;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 43200;
	НоваяСтрокаНастроек.Шаг				 = 3600;
	
	// Более 42300с
	НоваяСтрокаНастроек = НастроечнаяТаблицаИнтервалов.Добавить();
	НоваяСтрокаНастроек.НижняяГраница	 = 43200;
	НоваяСтрокаНастроек.ВерхняяГраница	 = 0;
	НоваяСтрокаНастроек.Шаг				 = 0;
	
	Возврат НастроечнаяТаблицаИнтервалов;
	
КонецФункции

// Формирует и возвращает таблицу интервалов из таблицы настроек интервалов
//
// Параметры:
//  ТаблицаНастроек  - ТаблицаЗначений - содержит настройки интервалов.
//                 Должна содержать колонки НижняяГраница, ВерхняяГраница, Шаг типа Число.
//
// Возвращаемое значение:
//   ТаблицаЗначений - содержащая нижнее и верхнее граничные значения для каждого из интервалов.
//					   Колонки: НижняяГраница, ВерхняяГраница.
//
Функция ТаблицаИнтерваловПоНастройкам(ТаблицаНастроек)
	
	ТаблицаИнтервалов = Новый ТаблицаЗначений;
	ТаблицаИнтервалов.Колонки.Добавить("НижняяГраница", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Неотрицательный)));
	ТаблицаИнтервалов.Колонки.Добавить("ВерхняяГраница", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10, 3, ДопустимыйЗнак.Неотрицательный)));
	
	// Ограничивает количество интервалов. Если интервалов будет больше указанного значения,
	// то в таблицу интервалов они уже не попадут
	// ограничение вызвано тем, что по интервалам будут динамически формироваться колонки,
	// следовательно, бесконтрольный рост недопустим.
	МаксимальноеКоличествоИнтервалов = 80;
	ВсегоИнтервалов = 0;
		
	Для каждого СтрокаНастроек Из ТаблицаНастроек Цикл
		
		// Проверка интервалов на корректность.
		// Если шаг не равен нулю, то нижняя граница должна быть больше верхней.
		Если СтрокаНастроек.НижняяГраница >= СтрокаНастроек.ВерхняяГраница И СтрокаНастроек.Шаг <> 0
			ИЛИ СтрокаНастроек.НижняяГраница = СтрокаНастроек.ВерхняяГраница Тогда
			Продолжить;		
		КонецЕсли; 
	
		Если СтрокаНастроек.НижняяГраница = 0 И СтрокаНастроек.Шаг = 0 Тогда
			НоваяСтрокаИнтервала = ТаблицаИнтервалов.Добавить();	
			НоваяСтрокаИнтервала.НижняяГраница	 = 0;
			НоваяСтрокаИнтервала.ВерхняяГраница	 = СтрокаНастроек.ВерхняяГраница;			
			ВсегоИнтервалов = ВсегоИнтервалов + 1;
		ИначеЕсли СтрокаНастроек.ВерхняяГраница = 0 И СтрокаНастроек.Шаг = 0 Тогда
			НоваяСтрокаИнтервала = ТаблицаИнтервалов.Добавить();	
			НоваяСтрокаИнтервала.НижняяГраница	 = СтрокаНастроек.НижняяГраница;
			НоваяСтрокаИнтервала.ВерхняяГраница	 = 0;                           			
			ВсегоИнтервалов = ВсегоИнтервалов + 1;
		Иначе
			ТекущееЗначение = СтрокаНастроек.НижняяГраница;
			Пока ТекущееЗначение < СтрокаНастроек.ВерхняяГраница Цикл
				// проверка превышения лимита колонок.
				Если ВсегоИнтервалов >= МаксимальноеКоличествоИнтервалов Тогда
					Прервать;
				КонецЕсли;
				ВерхнееЗначение = ТекущееЗначение + СтрокаНастроек.Шаг;
				Если ВерхнееЗначение > СтрокаНастроек.ВерхняяГраница Тогда
					// Некорректные настройки интервалов. Верхняя граница текущего интервала выходит за верхнюю границу настроек.
					Прервать;
				КонецЕсли; 								
				НоваяСтрокаИнтервала = ТаблицаИнтервалов.Добавить();	
				НоваяСтрокаИнтервала.НижняяГраница	 = ТекущееЗначение;				
				НоваяСтрокаИнтервала.ВерхняяГраница	 = ВерхнееЗначение;	
				ТекущееЗначение = ВерхнееЗначение;
				ВсегоИнтервалов = ВсегоИнтервалов + 1;
				
			КонецЦикла; 		
		КонецЕсли; 
	
	КонецЦикла; 
	
	Возврат ТаблицаИнтервалов;
	
КонецФункции

// Формирует и возвращает часть текстам запроса по таблице интервалов
//
// Параметры:
//  ТаблицаИнтервалов  - ТаблицаЗначений - содержит перечень интервалов.
//                 Должна содержать колонки НижняяГраница, ВерхняяГраница.
//
// Возвращаемое значение:
//   Строка
//
Функция ЧастьТекстаЗапросаПоИнтервалам(ТаблицаИнтервалов, ИмяТаблицыИсточника, ИмяКолонкиИсточника, СИменем)
	
	ТекстЗапроса = "";	
	ШаблонСтроки = "	КОГДА %1 %2 ТОГДА %3";
	
	Для Каждого СтрокаИнтервала Из ТаблицаИнтервалов Цикл
		
		Если СтрокаИнтервала.НижняяГраница = 0 Тогда
			ТекстНижнейГраницы = "";
			ТекстВерхнейГраницы = ИмяТаблицыИсточника + "." + ИмяКолонкиИсточника + " <= " + Формат(СтрокаИнтервала.ВерхняяГраница,"ЧРД=.; ЧН=0; ЧГ=");
		ИначеЕсли СтрокаИнтервала.ВерхняяГраница = 0 Тогда
			ТекстНижнейГраницы = ИмяТаблицыИсточника + "." + ИмяКолонкиИсточника + " > " + Формат(СтрокаИнтервала.НижняяГраница,"ЧРД=.; ЧН=0; ЧГ=");
			ТекстВерхнейГраницы = "";
		Иначе
			ТекстНижнейГраницы = ИмяТаблицыИсточника + "." + ИмяКолонкиИсточника + " > " + Формат(СтрокаИнтервала.НижняяГраница,"ЧРД=.; ЧН=0; ЧГ=") + " И ";
			ТекстВерхнейГраницы = ИмяТаблицыИсточника + "." + ИмяКолонкиИсточника + " <= " + Формат(СтрокаИнтервала.ВерхняяГраница,"ЧРД=.; ЧН=0; ЧГ=");
		КонецЕсли;
		
		ТекстЗапросаДляИнтервала = ОценкаПроизводительностиКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтроки, ТекстНижнейГраницы, ТекстВерхнейГраницы, Формат(СтрокаИнтервала.ВерхняяГраница,"ЧРД=.; ЧН=0; ЧГ=")); 		
		ТекстЗапроса = ТекстЗапроса + ?(ПустаяСтрока(ТекстЗапроса), "", Символы.ПС) + ТекстЗапросаДляИнтервала;
		
	КонецЦикла;
	
	// АПК:1297-выкл локализация текста запроса не требуется.
	ТекстЗапроса = "ВЫБОР " + ТекстЗапроса + ?(ПустаяСтрока(ТекстЗапроса), "", Символы.ПС) + " Иначе 0 Конец" + ?(СИменем, " КАК ExecutionTime, ", ","); // @query-part-1
	// АПК:1297-вкл
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли
