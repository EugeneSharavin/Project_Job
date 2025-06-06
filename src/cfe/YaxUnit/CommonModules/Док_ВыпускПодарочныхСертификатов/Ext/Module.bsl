﻿
#Область ПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
    
    ЮТТесты
		.ДобавитьТестовыйНабор("Документ ""Выпуск подарочных сертификатов"": Проверка отмены проведения").ВТранзакции()
			.ДобавитьТест("ВыпускПодарочныхСертификатовПроверкаОтменыПроведения")
			.ДобавитьТест("ВыпускПодарочныхСертификатовПроверкаОтменыПроведенияСОшибками")
		;
	
КонецПроцедуры

Процедура ПередВсемиТестами() Экспорт
	
	Общ_Инициализация.ВыполнитьИнициализациюДанных();
	
КонецПроцедуры

Процедура ВыпускПодарочныхСертификатовПроверкаОтменыПроведения() Экспорт
	
	// Описание программного создания: https://bia-technologies.github.io/yaxunit/docs/features/test-data/data-generation/
	
	//Сгенерируем необходимые виды и подарочные сертификаты
	Спр_ПодарочныеСертификаты.ПроверкаАвтоматическойГенерацииПодарочныхСертификатов();
	
	Выборка = Документы.ВыпускПодарочныхСертификатов.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЮТест.ОжидаетЧто(Выборка.ПолучитьОбъект())  
			.Метод("Записать").Параметр(РежимЗаписиДокумента.ОтменаПроведения)   
			.НеВыбрасываетИсключение()	
			;
				
		Рег_ПроверкиЗаписейВРегистрах.ИсторияСтатусовПодарочныхСертификатовПроверкаНаличия(Выборка.Ссылка);
		
		ОписаниеЗапроса = ЮТЗапросы.ОписаниеЗапроса();
		ОписаниеЗапроса.ИмяТаблицы = "Справочник.ПодарочныеСертификаты";
		ОписаниеЗапроса.Условия.Добавить("Ссылка В(&ПодарочныеСертификаты)");
		ОписаниеЗапроса.Условия.Добавить("ПометкаУдаления = ИСТИНА");
		
		ПодарочныеСертификаты = Выборка.Ссылка.ПодарочныеСертификаты.ВыгрузитьКолонку("ПодарочныйСертификат");
		ОписаниеЗапроса.ЗначенияПараметров.Вставить("ПодарочныеСертификаты", ПодарочныеСертификаты);
		ОписаниеЗапроса.ВыбираемыеПоля.Добавить("КОЛИЧЕСТВО(*) КАК КоличествоЭлементов");

		ЮТест.ОжидаетЧто(ЮТЗапросы.РезультатЗапроса(ОписаниеЗапроса))
		    .ИмеетДлину(1)
		    .Свойство("[0].КоличествоЭлементов").Равно(5);
	КонецЦикла;

КонецПроцедуры

Процедура ВыпускПодарочныхСертификатовПроверкаОтменыПроведенияСОшибками() Экспорт
	
	// Описание программного создания: https://bia-technologies.github.io/yaxunit/docs/features/test-data/data-generation/
	
	//Сгенерируем и проведем документ реализации подарочных сертификатов (а он уже по цепочке создаст и проведет документ выпуска)
	Док_РеализацияПодарочныхСертификатов.РеализацияПодарочныхСертификатовПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок(Ложь);
	
	Выборка = Документы.ВыпускПодарочныхСертификатов.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЮТест.ОжидаетЧто(Выборка.ПолучитьОбъект())  
			.Метод("Записать").Параметр(РежимЗаписиДокумента.ОтменаПроведения)   
			.ВыбрасываетИсключение("Не удалось сделать непроведенным ""Выпуск подарочных сертификатов")	
			;
				
	КонецЕсли;                                               

	Сообщения = ПолучитьСообщенияПользователю();
	ЮТест.ОжидаетЧто(Сообщения)
		.ИмеетТип("ФиксированныйМассив")
		.ИмеетДлину(6)
		.Свойство("[0].Текст")
			.Содержит(НСтр("ru = 'В строке 1 с подарочным сертификатом проведена дальнейшая операция!'"))
		.Свойство("[1].Текст")
			.Содержит(НСтр("ru = 'В строке 2 с подарочным сертификатом проведена дальнейшая операция!'"))
		.Свойство("[2].Текст")
			.Содержит(НСтр("ru = 'В строке 3 с подарочным сертификатом проведена дальнейшая операция!'"))
		.Свойство("[3].Текст")
			.Содержит(НСтр("ru = 'В строке 4 с подарочным сертификатом проведена дальнейшая операция!'"))
		.Свойство("[4].Текст")
			.Содержит(НСтр("ru = 'В строке 5 с подарочным сертификатом проведена дальнейшая операция!'"))
		.Свойство("[5].Текст")
			.Содержит(НСтр("ru = 'Невозможно отменить проведение документа!'"))
		;
		
КонецПроцедуры

#КонецОбласти

