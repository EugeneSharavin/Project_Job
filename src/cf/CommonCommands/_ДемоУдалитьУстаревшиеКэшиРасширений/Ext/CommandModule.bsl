﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УдалитьУстаревшиеКэшиРасширенийНаСервере();
	ПоказатьПредупреждение(, НСтр("ru = 'Выполнено удаление устаревших версий параметров работы расширений.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УдалитьУстаревшиеКэшиРасширенийНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	// АПК:278-выкл - №644.2.1 Допустимо вызывать служебный программный интерфейс
	// так как этот вызов и команда сделаны только для целей тестирования.
	// АПК:1443-выкл - №644.3.5 Допустимо обращение к объекту метаданных,
	// так как этот вызов и команда сделаны только для целей тестирования.
	Справочники.ВерсииРасширений.УдалитьУстаревшиеВерсииПараметров();
	// АПК:1443-вкл.
	// АПК:278-вкл.
	
КонецПроцедуры

#КонецОбласти
