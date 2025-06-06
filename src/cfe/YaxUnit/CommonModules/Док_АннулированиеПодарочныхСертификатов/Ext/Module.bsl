﻿
#Область ПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
    
    ЮТТесты
		.ДобавитьТестовыйНабор("Документ ""Аннулирование подарочных сертификатов"": Проверка проведения и отмены проведения").ВТранзакции()
			.ДобавитьТест("АннулированиеПодарочныхСертификатовВыбранногоВидаПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок")
			.ДобавитьТест("АннулированиеПодарочныхСертификатовВсехВидовПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок")
			.ДобавитьТест("АннулированиеПодарочныхСертификатовПроверкаПроведенияСОшибкамиНедопустимыйСтатус")
			.ДобавитьТест("АннулированиеПодарочныхСертификатовПроверкаПроведенияСОшибкамиНеИстекСрокДействия")
		;
	
КонецПроцедуры

Процедура ПередВсемиТестами() Экспорт
	
	Общ_Инициализация.ВыполнитьИнициализациюДанных();
	
КонецПроцедуры

Процедура АннулированиеПодарочныхСертификатовВыбранногоВидаПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок(СОтменойПроведения = Истина) Экспорт
	
	// Описание программного создания: https://bia-technologies.github.io/yaxunit/docs/features/test-data/data-generation/
	
	//Сгенерируем необходимый вид и подарочные сертификаты, а также ввод остатков подарочных сертификатов
	Док_ВводОстатковПодарочныхСертификатов.ВводОстатковПодарочныхСертификатовПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок(Ложь);
	
	//Получим созданный на предыдущем этапе вид подарочных сертификатов
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыПодарочныхСертификатов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	ВидПодарочныхСертификатов = ВыборкаДетальныеЗаписи.Ссылка;
	
	КонструкторАннулирования = ЮТест.Данные().КонструкторОбъекта("Документы.АннулированиеПодарочныхСертификатов")
		.Установить("Дата", ТекущаяДатаСеанса() + 5)
		.Установить("Ответственный", Пользователи.ТекущийПользователь())
		.Установить("ВидПодарочныхСертификатов", ВидПодарочныхСертификатов);
		;
	
	АннулированиеСертификатовОбъект = КонструкторАннулирования.НовыйОбъект();
	АннулированиеСертификатовОбъект.ЗаполнитьПодарочныеСертификаты();
	
	ЮТест.ОжидаетЧто(АннулированиеСертификатовОбъект)  
		.Метод("Записать").Параметр(РежимЗаписиДокумента.Проведение)   
		.НеВыбрасываетИсключение()	
		;
		
	АннулированиеСертификатов = АннулированиеСертификатовОбъект.Ссылка;
		
	Рег_ПроверкиЗаписейВРегистрах.ИсторияСтатусовПодарочныхСертификатовПроверкаНаличия(АннулированиеСертификатов, Перечисления.СтатусыПодарочныхСертификатов.Аннулирован, 4);
	
	//Списался остаток неиспользованной суммы 345 рублей по сертифкату из ввода остатков
	Рег_ПроверкиЗаписейВРегистрах.ОстаткиСтоимостиПодарочныхСертификатовПроверкаНаличия(АннулированиеСертификатов, 1, 345);

	Если СОтменойПроведения Тогда
		ЮТест.ОжидаетЧто(АннулированиеСертификатов.ПолучитьОбъект())  
			.Метод("Записать").Параметр(РежимЗаписиДокумента.ОтменаПроведения)   
			.НеВыбрасываетИсключение()	
			;
		
		Рег_ПроверкиЗаписейВРегистрах.ИсторияСтатусовПодарочныхСертификатовПроверкаНаличия(АннулированиеСертификатов);
		Рег_ПроверкиЗаписейВРегистрах.ОстаткиСтоимостиПодарочныхСертификатовПроверкаНаличия(АннулированиеСертификатов);
	КонецЕсли;
	
КонецПроцедуры

Процедура АннулированиеПодарочныхСертификатовВсехВидовПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок(СОтменойПроведения = Истина) Экспорт
	
	// Описание программного создания: https://bia-technologies.github.io/yaxunit/docs/features/test-data/data-generation/
	
	//Сгенерируем необходимые виды и подарочные сертификаты, а также выпуск и реализацию товаров клиента (частичное погашение сертификата)
	Док_РеализацияТоваровОплатаПодарочнымиСертификатами._ДемоРеализацияТоваровПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок(Ложь);
	
	КонструкторАннулирования = ЮТест.Данные().КонструкторОбъекта("Документы.АннулированиеПодарочныхСертификатов")
		.Установить("Дата", ТекущаяДатаСеанса() + 5)
		.Установить("Ответственный", Пользователи.ТекущийПользователь())
		;
	
	АннулированиеСертификатовОбъект = КонструкторАннулирования.НовыйОбъект();
	АннулированиеСертификатовОбъект.ЗаполнитьПодарочныеСертификаты();
	
	ЮТест.ОжидаетЧто(АннулированиеСертификатовОбъект)  
		.Метод("Записать").Параметр(РежимЗаписиДокумента.Проведение)   
		.НеВыбрасываетИсключение()	
		;
		
	АннулированиеСертификатов = АннулированиеСертификатовОбъект.Ссылка;
		
	Рег_ПроверкиЗаписейВРегистрах.ИсторияСтатусовПодарочныхСертификатовПроверкаНаличия(АннулированиеСертификатов, Перечисления.СтатусыПодарочныхСертификатов.Аннулирован, 4);
	
	//Движений по регистру накопления нет, так как по активированным и частично использованным сертификатам еще
	//не подошел срок, и они не попали в табличную часть аннулирования при автоматическим заполнении
	Рег_ПроверкиЗаписейВРегистрах.ОстаткиСтоимостиПодарочныхСертификатовПроверкаНаличия(АннулированиеСертификатов);
	
	Если СОтменойПроведения Тогда
		ЮТест.ОжидаетЧто(АннулированиеСертификатов.ПолучитьОбъект())  
			.Метод("Записать").Параметр(РежимЗаписиДокумента.ОтменаПроведения)   
			.НеВыбрасываетИсключение()	
			;
			
		Рег_ПроверкиЗаписейВРегистрах.ИсторияСтатусовПодарочныхСертификатовПроверкаНаличия(АннулированиеСертификатов);
		Рег_ПроверкиЗаписейВРегистрах.ОстаткиСтоимостиПодарочныхСертификатовПроверкаНаличия(АннулированиеСертификатов);
	КонецЕсли;

КонецПроцедуры

Процедура АннулированиеПодарочныхСертификатовПроверкаПроведенияСОшибкамиНедопустимыйСтатус() Экспорт
	
	// Описание программного создания: https://bia-technologies.github.io/yaxunit/docs/features/test-data/data-generation/
	
	//Сгенерируем аннулирование подарочных сертификатов выбранного вида, вызвав определенную выше процедуру
	АннулированиеПодарочныхСертификатовВыбранногоВидаПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок(Ложь);       
	
	//Создадим конструктором еще одно аннулирование с этими же подарочными сертификатами
	ПодарочныеСертификаты = Новый Массив;
	
	Выборка = Справочники.ПодарочныеСертификаты.Выбрать(, , , "Код ВОЗР");
	Пока Выборка.Следующий() Цикл
		ПодарочныеСертификаты.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	КонструкторАннулирования = ЮТест.Данные().КонструкторОбъекта("Документы.АннулированиеПодарочныхСертификатов")
		.Установить("Дата", ТекущаяДатаСеанса() + 6)
		.Установить("Ответственный", Пользователи.ТекущийПользователь())
		.ТабличнаяЧасть("ПодарочныеСертификаты")
			.ДобавитьСтроку()
				.Установить("ПодарочныйСертификат", ПодарочныеСертификаты[0])
			.ДобавитьСтроку()
				.Установить("ПодарочныйСертификат", ПодарочныеСертификаты[1])
			.ДобавитьСтроку()
				.Установить("ПодарочныйСертификат", ПодарочныеСертификаты[4])
		;
	
	АннулированиеСертификатов = КонструкторАннулирования.Записать();
	
	ЮТест.ОжидаетЧто(АннулированиеСертификатов.ПолучитьОбъект())  
		.Метод("Записать").Параметр(РежимЗаписиДокумента.Проведение)   
		.ВыбрасываетИсключение("Не удалось провести ""Аннулирование подарочных сертификатов")	
		;

	Сообщения = ПолучитьСообщенияПользователю();

	ЮТест.ОжидаетЧто(Сообщения)
		.ИмеетТип("ФиксированныйМассив")
		.ИмеетДлину(3)
		.Свойство("[0].Текст")
			.Содержит(НСтр("ru = 'В строке 1 подарочный сертификат уже аннулирован!'"))
		.Свойство("[1].Текст")
			.Содержит(НСтр("ru = 'В строке 2 подарочный сертификат уже аннулирован!'"))
		.Свойство("[2].Текст")
			.Содержит(НСтр("ru = 'В строке 3 подарочный сертификат уже аннулирован!'"))
		;
		
КонецПроцедуры

Процедура АннулированиеПодарочныхСертификатовПроверкаПроведенияСОшибкамиНеИстекСрокДействия() Экспорт
	
	// Описание программного создания: https://bia-technologies.github.io/yaxunit/docs/features/test-data/data-generation/
	
	//Сгенерируем необходимые виды и подарочные сертификаты, а также выпуск и реализацию товаров клиента (частичное погашение сертификата)
	Док_РеализацияТоваровОплатаПодарочнымиСертификатами._ДемоРеализацияТоваровПроверкаЗаписиПроведенияОтменыПроведенияБезОшибок(Ложь);
	
	//Выберем частично использованный при оплате сертификат номиналом 3000 рублей (он еще действует по сроку)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПодарочныеСертификаты.Ссылка,
		|	ПодарочныеСертификаты.Код КАК Код
		|ИЗ
		|	Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
		|ГДЕ
		|	ПодарочныеСертификаты.Владелец.НоминальнаяСтоимость = 3000
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код";
	
	РезультатЗапроса = Запрос.Выполнить();
	ПодарочныеСертификаты = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");

	КонструкторАннулирования = ЮТест.Данные().КонструкторОбъекта("Документы.АннулированиеПодарочныхСертификатов")
		.Установить("Дата", ТекущаяДатаСеанса() + 5)
		.Установить("Ответственный", Пользователи.ТекущийПользователь())
		.ТабличнаяЧасть("ПодарочныеСертификаты")
			.ДобавитьСтроку()
				.Установить("ПодарочныйСертификат", ПодарочныеСертификаты[0])
		;
	
	АннулированиеСертификатов = КонструкторАннулирования.Записать();
	
	ЮТест.ОжидаетЧто(АннулированиеСертификатов.ПолучитьОбъект())  
		.Метод("Записать").Параметр(РежимЗаписиДокумента.Проведение)   
		.ВыбрасываетИсключение("Не удалось провести ""Аннулирование подарочных сертификатов")	
		;
		
	Сообщения = ПолучитьСообщенияПользователю();
	ЮТест.ОжидаетЧто(Сообщения)
		.ИмеетТип("ФиксированныйМассив")
		.ИмеетДлину(1)
		.Свойство("[0].Текст")
			.Содержит(НСтр("ru = 'В строке 1 подарочный сертификат еще действует и срок действия не истек!'"))
		;
	
КонецПроцедуры

#КонецОбласти

