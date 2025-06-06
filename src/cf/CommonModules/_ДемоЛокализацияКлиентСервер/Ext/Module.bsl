﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Для обработки и заполнения данных, связанных с национальными атрибутами физических лиц.
// 
// Параметры:
//  Объект - СправочникОбъект._ДемоФизическиеЛица
//         - ДанныеФормыСтруктура - справочник или данные формы, содержащие информацию о физических лицах.
//  Поля - Структура - набор полей, включая национальные атрибуты, которые необходимо обработать и заполнить.
//
Процедура ПриЗаполненииНациональныхПолейФизическогоЛица(Объект, Поля) Экспорт
	
	// Локализация
	Объект.Отчество = Поля.Отчество;
	// Конец Локализация
	
КонецПроцедуры

#КонецОбласти