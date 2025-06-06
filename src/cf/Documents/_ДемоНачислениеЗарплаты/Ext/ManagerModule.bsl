﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ответственный)
	|	И ДляВсехСтрок(ЗначениеРазрешено(Зарплата.ФизическоеЛицо, Null КАК Истина, ПустаяСсылка КАК Истина))";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

// СтандартныеПодсистемы.ЗащитаПерсональныхДанных

#Область СлужебныйПрограммныйИнтерфейс

// См. ЗащитаПерсональныхДанныхПереопределяемый.ПриРасчетеСроковХраненияПерсональныхДанных.
Процедура ПриРасчетеСроковХраненияПерсональныхДанных(ДанныеСубъектов, СрокиХранения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Субъекты", ДанныеСубъектов.ВыгрузитьКолонку("Субъект")); 
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	_ДемоНачислениеЗарплатыЗарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	_ДемоНачислениеЗарплатыЗарплата.Ссылка.Организация КАК Организация
	|ИЗ
	|	Документ._ДемоНачислениеЗарплаты.Зарплата КАК _ДемоНачислениеЗарплатыЗарплата
	|ГДЕ
	|	_ДемоНачислениеЗарплатыЗарплата.ФизическоеЛицо В (&Субъекты)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ФизическоеЛицо") Цикл
		НоваяСтрока = СрокиХранения.Добавить();
		НоваяСтрока.Субъект = Выборка.ФизическоеЛицо;
		НоваяСтрока.Организация = Выборка.Организация;
		НоваяСтрока.СрокХранения = Дата(3999, 12, 31);
		НоваяСтрока.Комментарий = НСтр("ru = 'Субъект оформлен по ТК РФ'", ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных

#КонецЕсли
