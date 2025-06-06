﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОрганизацииСервер

// Переопределяет структуру, содержащую сведения о регистрационной информации организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - см. ОрганизацииСервер.РегистрационныеДанныеОрганизации
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
// 
// Пример:
//       СведенияОбОрганизации = ОрганизацииСервер.СведенияОбОрганизации(Организация);
//
//	СвойстваОрганизации = СтрРазделить(Поля, ",", Ложь);
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Ссылка", Организация);
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	Организации.Ссылка КАК Ссылка,
//		|	Организации.ВерсияДанных КАК ВерсияДанных,
//		|	Организации.ПометкаУдаления КАК ПометкаУдаления,
//		|	Организации.Код КАК Код,
//		|	Организации.Наименование КАК Наименование,
//		|	Организации.БИК КАК БИК,
//		|	Организации.ГлавныйБухгалтер КАК ГлавныйБухгалтер,
//		|	Организации.Директор КАК Директор,
//		|	Организации.ИндивидуальныйПредприниматель КАК ИндивидуальныйПредприниматель,
//		|	Организации.ИНН КАК ИНН,
//		|	Организации.ИнформационноеОбслуживание КАК ИнформационноеОбслуживание,
//		|	Организации.КорреспондентскийСчет КАК КорреспондентскийСчет,
//		|	Организации.КПП КАК КПП,
//		|	Организации.НаименованиеПолное КАК НаименованиеПолное,
//		|	Организации.НаименованиеСокращенное КАК НаименованиеСокращенное,
//		|	Организации.ОГРН КАК ОГРН,
//		|	Организации.Префикс КАК Префикс,
//		|	Организации.РасчетныйСчет КАК РасчетныйСчет,
//		|	Организации.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
//		|	Организации.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
//		|	Организации.Предопределенный КАК Предопределенный,
//		|	Организации.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
//		|	Организации.ВАрхиве КАК ВАрхиве
//		|ИЗ
//		|	Справочник.Организации КАК Организации
//		|ГДЕ
//		|	Организации.Ссылка = &Ссылка";
//	
//	РезультатЗапроса = Запрос.Выполнить();
//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
//		Для каждого Элемент Из СвойстваОрганизации Цикл
//			Если РезультатЗапроса.Колонки.Найти(Элемент) <> Неопределено Тогда
//				РегистрационныеДанные.Вставить(Элемент, ВыборкаДетальныеЗаписи[Элемент]);
//			КонецЕсли;
//		КонецЦикла;
//	КонецЕсли;
//
Процедура ПриОпределенииРегистрационныхДанныхОрганизации(Организация, Поля, Дата, РегистрационныеДанные, КодЯзыка) Экспорт
	
	// _Демо начало примера
	СвойстваОрганизации = СтрРазделить(Поля, ",", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Организация);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	_ДемоОрганизации.Ссылка КАК Ссылка,
		|	_ДемоОрганизации.ВерсияДанных КАК ВерсияДанных,
		|	_ДемоОрганизации.ПометкаУдаления КАК ПометкаУдаления,
		|	_ДемоОрганизации.Код КАК Код,
		|	_ДемоОрганизации.Наименование КАК Наименование,
		|	_ДемоОрганизации.БИК КАК БИК,
		|	_ДемоОрганизации.ГлавныйБухгалтер КАК ГлавныйБухгалтер,
		|	_ДемоОрганизации.Директор КАК Директор,
		|	_ДемоОрганизации.ИндивидуальныйПредприниматель КАК ИндивидуальныйПредприниматель,
		|	_ДемоОрганизации.ИНН КАК ИНН,
		|	_ДемоОрганизации.ИнформационноеОбслуживание КАК ИнформационноеОбслуживание,
		|	_ДемоОрганизации.КорреспондентскийСчет КАК КорреспондентскийСчет,
		|	_ДемоОрганизации.КПП КАК КПП,
		|	_ДемоОрганизации.НаименованиеПолное КАК НаименованиеПолное,
		|	_ДемоОрганизации.НаименованиеСокращенное КАК НаименованиеСокращенное,
		|	_ДемоОрганизации.ОГРН КАК ОГРН,
		|	_ДемоОрганизации.Префикс КАК Префикс,
		|	_ДемоОрганизации.РасчетныйСчет КАК РасчетныйСчет,
		|	_ДемоОрганизации.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	_ДемоОрганизации.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
		|	_ДемоОрганизации.Предопределенный КАК Предопределенный,
		|	_ДемоОрганизации.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
		|	ЛОЖЬ КАК ВАрхиве
		|ИЗ
		|	Справочник._ДемоОрганизации КАК _ДемоОрганизации
		|ГДЕ
		|	_ДемоОрганизации.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
			Если Не ЗначениеЗаполнено(СвойстваОрганизации) Или СвойстваОрганизации.Найти(Колонка.Имя) <> Неопределено Тогда
				РегистрационныеДанные.Вставить(Колонка.Имя, ВыборкаДетальныеЗаписи[Колонка.Имя]);
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

// Возвращает структуру, содержащую сведения о дополнительной информации организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  ДополнительныеСведения - см. ОрганизацииСервер.ДополнительныеСведенияОрганизации.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииДополнительныхСведенийОрганизации(Организация, Поля, Дата, ДополнительныеСведения, КодЯзыка) Экспорт

	// _Демо начало примера
	Отбор = УправлениеКонтактнойИнформацией.ОтборКонтактнойИнформации();
	Отбор.Дата = Дата;
	Отбор.КодЯзыка = КодЯзыка;
	
	КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформация(Организация, Отбор);
	
	АдресЭлектроннойПочтыОрганизации = КонтактнаяИнформация.Найти(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоEmailОрганизации"), "Вид");
	ДополнительныеСведения.Вставить("АдресЭлектроннойПочтыОрганизации", ?(АдресЭлектроннойПочтыОрганизации <> Неопределено, АдресЭлектроннойПочтыОрганизации.Представление, ""));
	
	ТелефонОрганизации = КонтактнаяИнформация.Найти(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоТелефонОрганизации"), "Вид");
	ДополнительныеСведения.Вставить("ТелефонОрганизации", ?(ТелефонОрганизации <> Неопределено, ТелефонОрганизации.Представление, ""));
	
	ФаксОрганизации = КонтактнаяИнформация.Найти(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоФаксОрганизации"), "Вид");
	ДополнительныеСведения.Вставить("ФаксОрганизации", ?(ФаксОрганизации <> Неопределено, ФаксОрганизации.Представление, ""));
	
	ЭмблемаДляШтампа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЭмблемаОрганизацииДляШтампаЭлектроннойПодписи");
	ДополнительныеСведения.Вставить("ЭмблемаОрганизацииДляШтампаЭлектроннойПодписи", _ДемоСтандартныеПодсистемы.КартинкаИзФайла(ЭмблемаДляШтампа));
	// _Демо конец примера

КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - см. ОрганизацииСервер.КонтактнаяИнформацияОрганизации.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииКонтактнойИнформацииОрганизации(Организация, Поля, Дата, КонтактнаяИнформация, КодЯзыка) Экспорт
	// _Демо начало примера
	Отбор = УправлениеКонтактнойИнформацией.ОтборКонтактнойИнформации();
	Отбор.Дата = Дата;
	Отбор.КодЯзыка = КодЯзыка;
	КонтактнаяИнформацияОбъекта = УправлениеКонтактнойИнформацией.КонтактнаяИнформация(Организация, Отбор);
	
	АдресОрганизации = КонтактнаяИнформацияОбъекта.Найти(УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоЮридическийАдресОрганизации"), "Вид");
	КонтактнаяИнформация.Вставить("АдресОрганизации", ?(АдресОрганизации <> Неопределено, АдресОрганизации.Представление, ""));
	
	Если Не ЗначениеЗаполнено(КодЯзыка) Или СтрРазделить(КодЯзыка, "_", Истина)[0] = ТекущийЯзык().КодЯзыка Тогда
		КонтактнаяИнформация.Вставить("НаименованиеДляПечати", ?(ЗначениеЗаполнено(Организация.НаименованиеСокращенное),
			Организация.НаименованиеСокращенное, Организация.Наименование));
	Иначе
		КонтактнаяИнформация.Вставить("НаименованиеДляПечати", ?(ЗначениеЗаполнено(Организация.НаименованиеМеждународное),
			Организация.НаименованиеМеждународное, СтроковыеФункции.СтрокаЛатиницей(Организация.Наименование)));
	КонецЕсли;
	// _Демо конец примера

КонецПроцедуры

// Переопределяет структуру, содержащую сведения о банковской информации организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  БанковскийСчет - см. ОрганизацииСервер.БанковскийСчетОрганизации.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииБанковскогоСчетаОрганизации(Организация, Поля, Дата, БанковскийСчет, КодЯзыка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОбОбособленномПодразделении

// Переопределяет структуру, содержащую сведения о регистрационных данных обособленного подразделения.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - см. ОрганизацииСервер.РегистрационныеДанныеОбособленногоПодразделения.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииРегистрационныхДанныхОбособленногоПодразделения(Организация, Поля, Дата, РегистрационныеДанные, КодЯзыка) Экспорт	
	
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации обособленного подразделения.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - см. ОрганизацииСервер.КонтактнаяИнформацияОбособленногоПодразделения.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииКонтактнойИнформацииОбособленногоПодразделения(Организация, Поля, Дата, КонтактнаяИнформация, КодЯзыка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОбИностраннойОрганизации

// Переопределяет структуру, содержащую сведения о регистрационной информации иностранной организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные -  см. ОрганизацииСервер.РегистрационныеДанныеОтделенияИностраннойОрганизации.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииРегистрационныхДанныхОтделенияИностраннойОрганизации(Организация, Поля, Дата, РегистрационныеДанные, КодЯзыка) Экспорт
	
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации иностранной организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - см. ОрганизацииСервер.КонтактнаяИнформацияОтделенияИностраннойОрганизации.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииКонтактнойИнформацииИностраннойОрганизации(Организация, Поля, Дата, КонтактнаяИнформация, КодЯзыка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОбИндивидуальномПредпринимателе

// Переопределяет структуру, содержащую сведения о регистрационной информации индивидуального предпринимателя.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - см. ОрганизацииСервер.РегистрационныеДанныеИндивидуальногоПредпринимателя.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииРегистрационныхДанныхИндивидуальногоПредпринимателя(Организация, Поля, Дата, РегистрационныеДанные, КодЯзыка) Экспорт
			
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации индивидуального предпринимателя.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - см. ОрганизацииСервер.КонтактнаяИнформацияИндивидуальногоПредпринимателя.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииКонтактнойИнформацииИндивидуальногоПредпринимателя(Организация, Поля, Дата, КонтактнаяИнформация, КодЯзыка) Экспорт
		
КонецПроцедуры

#КонецОбласти

#Область СведенияОРуководителеОрганизации

// Переопределяет структуру, содержащую сведения о регистрационной информации руководителя организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - см. ОрганизацииСервер.РегистрационныеДанныеРуководителяОрганизации.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииРегистрационныхДанныхРуководителяОрганизации(Организация, Поля, Дата, РегистрационныеДанные, КодЯзыка) Экспорт	
	// _Демо начало примера
	СвойстваРуководителя = СтрРазделить(Поля, ",", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	_ДемоФизическиеЛица.Наименование КАК СведенияОРуководителеФИО,
		|	_ДемоФизическиеЛица.ДатаРождения КАК ДатаРождения,
		|	_ДемоФизическиеЛица.Пол КАК Пол,
		|	_ДемоФизическиеЛица.МестоРождения КАК МестоРождения,
		|	_ДемоФизическиеЛица.Гражданство КАК Гражданство,
		|	_ДемоФизическиеЛица.СерияДокумента КАК СерияДокумента,
		|	_ДемоФизическиеЛица.НомерДокумента КАК НомерДокумента,
		|	_ДемоФизическиеЛица.КемВыданДокумент КАК КемВыданДокумент,
		|	_ДемоФизическиеЛица.КодПодразделенияДокумента КАК КодПодразделенияДокумента,
		|	_ДемоФизическиеЛица.ДатаВыдачиДокумента КАК ДатаВыдачиДокумента,
		|	_ДемоФизическиеЛица.СНИЛС КАК СНИЛС
		|ИЗ
		|	РегистрСведений._ДемоОтветственныеЛица КАК _ДемоОтветственныеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник._ДемоФизическиеЛица КАК _ДемоФизическиеЛица
		|		ПО _ДемоОтветственныеЛица.ФизическоеЛицо = _ДемоФизическиеЛица.Ссылка
		|ГДЕ
		|	_ДемоОтветственныеЛица.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Для каждого Элемент Из СвойстваРуководителя Цикл
			
			Если РезультатЗапроса.Колонки.Найти(Элемент) <> Неопределено Тогда
				
				РегистрационныеДанные.Вставить(Элемент, ВыборкаДетальныеЗаписи[Элемент]);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	// _Демо конец примера

КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации руководителя организации.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - см. ОрганизацииСервер.КонтактнаяИнформацияРуководителяОрганизации.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииКонтактнойИнформацииРуководителяОрганизации(Организация, Поля, Дата, КонтактнаяИнформация, КодЯзыка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОГлавномБухгалтере

// Переопределяет структуру, содержащую сведения о регистрационной информации главного бухгалтера.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - см. ОрганизацииСервер.РегистрационныеДанныеГлавногоБухгалтера.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииРегистрационныхДанныхГлавногоБухгалтера(Организация, Поля, Дата, РегистрационныеДанные, КодЯзыка) Экспорт
		
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации главного бухгалтера.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - см. ОрганизацииСервер.КонтактнаяИнформацияГлавногоБухгалтера.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииКонтактнойИнформацииГлавногоБухгалтера(Организация, Поля, Дата, КонтактнаяИнформация, КодЯзыка) Экспорт	
	
КонецПроцедуры

#КонецОбласти

#Область СведенияОбУполномоченномПредставителе

// Переопределяет структуру, содержащую сведения о регистрационных данных уполномоченного представителя.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  РегистрационныеДанные - см. ОрганизацииСервер.РегистрационныеДанныеУполномоченногоПредставителя.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииРегистрационныхДанныхУполномоченногоПредставителя(Организация, Поля, Дата, РегистрационныеДанные, КодЯзыка) Экспорт
			
КонецПроцедуры

// Переопределяет структуру, содержащую сведения о контактной информации уполномоченного представителя.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация, сведения по которой необходимо получить.
//  Поля - Строка - имена полей, перечисленные через запятую, в формате требований к свойствам структуры.
//                  Список допустимых имен полей см. в описании возвращаемого значения.
//                  Если указана пустая строка, то возвращаются значения всех полей.
//  Дата - Дата
//       - Неопределено - дата, на которую требуется получить данные. Если значение не указано,
//                  то возвращается значение на текущую дату.
//  КонтактнаяИнформация - см. ОрганизацииСервер.КонтактнаяИнформацияУполномоченногоПредставителя.
//  КодЯзыка - см. ОрганизацииСервер.СведенияОбОрганизации.КодЯзыка
//
Процедура ПриОпределенииКонтактнойИнформацииУполномоченногоПредставителя(Организация, Поля, Дата, КонтактнаяИнформация, КодЯзыка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти