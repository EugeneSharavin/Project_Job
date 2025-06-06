﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьОтветНаВопросОбУдаленииПодарочныхСертификатов", ЭтотОбъект, 
									Новый Структура("ПодарочныеСертификаты, Список", 
													 ПараметрКоманды,
													 ПараметрыВыполненияКоманды.Источник.Элементы.Список));
	
	Если ПараметрКоманды.Количество() = 1 Тогда
		ТекстВопроса = НСтр("ru = 'Вы хотите удалить выделенный подарочный сертификат?'");
	ИначеЕсли ПараметрКоманды.Количество() > 1 Тогда
		ТекстВопроса = НСтр("ru = 'Вы хотите удалить выделенные подарочные сертификаты?'");
	Иначе
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОтветНаВопросОбУдаленииПодарочныхСертификатов(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		УдалитьНепосредственно(ДополнительныеПараметры.ПодарочныеСертификаты);
		ДополнительныеПараметры.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьНепосредственно(ПодарочныеСертификаты)
	НайденныеСсылки = НайтиПоСсылкам(ПодарочныеСертификаты);

	КонтролироватьУникальностьНомеровПодарочныхСертификатовПоВсемВидам = Константы.КонтролироватьУникальностьНомеровПодарочныхСертификатовПоВсемВидам.Получить();
	
	Для Каждого ПодарочныйСертификат Из ПодарочныеСертификаты Цикл
		Если НайденныеСсылки.Найти(ПодарочныйСертификат, "Ссылка") = Неопределено Тогда
			ПодарочныйСертификатОбъект = ПодарочныйСертификат.ПолучитьОбъект();
			ПодарочныйСертификатОбъект.ДополнительныеСвойства.Вставить("КонтролироватьУникальностьПоВсемВидам", КонтролироватьУникальностьНомеровПодарочныхСертификатовПоВсемВидам);
			ПодарочныйСертификатОбъект.Удалить();
		Иначе     
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Невозможно удалить подарочный сертификат %1, так как он использован в документах!'"), ПодарочныйСертификат), ПодарочныйСертификат);
		КонецЕсли;
	КонецЦикла;                                                    
КонецПроцедуры
