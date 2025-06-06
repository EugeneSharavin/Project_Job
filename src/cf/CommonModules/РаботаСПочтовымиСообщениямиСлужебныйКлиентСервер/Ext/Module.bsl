﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ВысокаяВажностьИнтернетПочтовогоСообщения() Экспорт
	Возврат "Высокая";
КонецФункции

Функция НизкаяВажностьИнтернетПочтовогоСообщения() Экспорт
	Возврат "Низкая";
КонецФункции

Функция ОбычнаяВажностьИнтернетПочтовогоСообщения() Экспорт
	Возврат "Обычная";
КонецФункции

Функция ЭтоОшибкаРаботыИнтернетПочты(ИнформацияОбОшибке) Экспорт
	
	Возврат ИнформацияОбОшибке.Код = КодОшибкиРаботыИнтернетПочты();
	
КонецФункции

Функция КодОшибкиРаботыИнтернетПочты() Экспорт
	
	Возврат "ОшибкаРаботыИнтернетПочты";
	
КонецФункции

#КонецОбласти
