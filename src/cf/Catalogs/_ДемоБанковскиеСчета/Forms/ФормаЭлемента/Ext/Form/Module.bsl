﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ИмяРедактируемогоРеквизита;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		БИКБанка		  = Объект.БИКБанка;
		НаименованиеБанка = Объект.НаименованиеБанка;
		КоррСчетБанка	  = Объект.КоррСчетБанка;
		ГородБанка		  = Объект.ГородБанка;
		СВИФТБИК = Объект.СВИФТБИК;
	Иначе
		Если Не Объект.Банк.Пустая() Тогда
			ЗаполнитьРеквизитыБанкаПоБанку(Объект.Банк, "Банк", Ложь);
		КонецЕсли;
	КонецЕсли;

	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если (ЗначениеЗаполнено(Объект.БИКБанкаДляРасчетов)) Или (ЗначениеЗаполнено(Объект.БанкДляРасчетов))
			Или ЗначениеЗаполнено(Объект.СВИФТБИКДляРасчетов) Тогда
			ИспользуетсяБанкДляРасчетов = Истина;
		Иначе
			ИспользуетсяБанкДляРасчетов = Ложь;
		КонецЕсли;
	КонецЕсли;

	Если Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
		БИКБанкаДляРасчетов			 = Объект.БИКБанкаДляРасчетов;
		НаименованиеБанкаДляРасчетов = Объект.НаименованиеБанкаДляРасчетов;
		КоррСчетБанкаДляРасчетов	 = Объект.КоррСчетБанкаДляРасчетов;
		ГородБанкаДляРасчетов		 = Объект.ГородБанкаДляРасчетов;
		СВИФТБИКДляРасчетов = Объект.СВИФТБИКДляРасчетов;
	Иначе
		Если Не Объект.БанкДляРасчетов.Пустая() Тогда
			ЗаполнитьРеквизитыБанкаПоБанку(Объект.БанкДляРасчетов, "БанкДляРасчетов", Ложь);
		КонецЕсли;
	КонецЕсли;

	НациональнаяВалюта = Справочники.Валюты.НайтиПоКоду("643");
	СпособУказанияРеквизитовБанка = ?(Объект.РучноеИзменениеРеквизитовБанка, "Вручную", "ИзКлассификатора");
	СпособУказанияРеквизитовБанкаРасчетов = ?(Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов, "Вручную",
		"ИзКлассификатора");
	МестоОткрытия = ?(Объект.Зарубежный, "ЗаРубежом", "РФ");

	ОбновитьТекстПоясненияНедействительностиБанка();
	УправлениеЭлементамиФормы(ЭтотОбъект);

	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)

	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник._ДемоБанковскиеСчета.Форма.РеквизитыБанка") Тогда
		УстановитьРеквизитыБанка(РезультатВыбора);
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.КлассификаторБанков.Форма.ФормаВыбора") Тогда
		ВыбратьБанк(РезультатВыбора);
	КонецЕсли;

	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;

	ОбновитьТекстПоясненияНедействительностиБанка();
	УправлениеЭлементамиФормы(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		Объект.БИКБанка			 = БИКБанка;
		Объект.КоррСчетБанка	 = КоррСчетБанка;
		Объект.НаименованиеБанка = НаименованиеБанка;
		Объект.ГородБанка		 = ГородБанка;
		Объект.СВИФТБИК = СВИФТБИК;
	Иначе
		Объект.БИКБанка			 = "";
		Объект.КоррСчетБанка	 = "";
		Объект.НаименованиеБанка = "";
		Объект.ГородБанка		 = "";
		Объект.СВИФТБИК = "";
	КонецЕсли;

	Если ИспользуетсяБанкДляРасчетов И Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
		Объект.БИКБанкаДляРасчетов			= БИКБанкаДляРасчетов;
		Объект.КоррСчетБанкаДляРасчетов		= КоррСчетБанкаДляРасчетов;
		Объект.НаименованиеБанкаДляРасчетов = НаименованиеБанкаДляРасчетов;
		Объект.ГородБанкаДляРасчетов		= ГородБанкаДляРасчетов;
		Объект.СВИФТБИКДляРасчетов = СВИФТБИКДляРасчетов;
	Иначе
		Объект.БИКБанкаДляРасчетов			= "";
		Объект.КоррСчетБанкаДляРасчетов		= "";
		Объект.НаименованиеБанкаДляРасчетов = "";
		Объект.ГородБанкаДляРасчетов		= "";
		Объект.СВИФТБИКДляРасчетов = "";
	КонецЕсли;

	Объект.Зарубежный = МестоОткрытия = "ЗаРубежом";

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользуетсяБанкДляРасчетовПриИзменении(Элемент)

	УправлениеЭлементамиФормы(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "БИКБанка";
	РеквизитБанкаПриВыборе("БИКБанка", ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаОткрытие(Элемент, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "БИКБанка";
	СтандартнаяОбработка = Ложь;
	РеквизитБанкаОткрытие("БИКБанка");
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаДляРасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов";
	РеквизитБанкаПриВыборе("БИКБанкаДляРасчетов", ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаДляРасчетовОткрытие(Элемент, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов";
	СтандартнаяОбработка = Ложь;
	РеквизитБанкаОткрытие("БИКБанкаДляРасчетов");
КонецПроцедуры

&НаКлиенте
Процедура МестоОткрытияПриИзменении(Элемент)
	Объект.Зарубежный = МестоОткрытия = "ЗаРубежом";
	Объект.РучноеИзменениеРеквизитовБанка = Истина;
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов = Объект.Валюта <> НациональнаяВалюта;
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СпособУказанияРеквизитовБанкаРасчетовПриИзменении(Элемент)
	Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов = СпособУказанияРеквизитовБанкаРасчетов = "Вручную";
	Если Не Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
		ЗаполнитьРеквизитыБанкаПоБИК(БИКБанкаДляРасчетов, "БанкДляРасчетов", Истина);
	КонецЕсли;
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СпособУказанияРеквизитовБанкаПриИзменении(Элемент)
	Объект.РучноеИзменениеРеквизитовБанка = СпособУказанияРеквизитовБанка = "Вручную";
	Если Не Объект.РучноеИзменениеРеквизитовБанка Тогда
		ЗаполнитьРеквизитыБанкаПоБИК(БИКБанка, "Банк", Истина);
	КонецЕсли;
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоБИК(БИК, ТипБанка, ПеренестиЗначенияРеквизитов = Ложь)

	СведенияОБанке = РаботаСБанками.СведенияБИК(БИК);
	Результат = СведенияОБанке.Количество() > 0;
	Если ТипБанка = "Банк" Тогда

		БИКБанка		  = "";
		КоррСчетБанка	  = "";
		НаименованиеБанка = "";
		ГородБанка		  = "";

		Если Не Результат Тогда
			Возврат Результат;
		КонецЕсли;

		ЗаписьОБанке      = СведенияОБанке[0].Ссылка.ПолучитьОбъект();
		БИКБанка          = ЗаписьОБанке.Код;
		КоррСчетБанка     = ЗаписьОБанке.КоррСчет;
		НаименованиеБанка = ЗаписьОБанке.Наименование;
		ГородБанка        = ЗаписьОБанке.Город;
		НашлиПоБИК        = Истина;
		СВИФТБИК = ЗаписьОБанке.СВИФТБИК;
		Если ПеренестиЗначенияРеквизитов Тогда
			Объект.БИКБанка          = "";
			Объект.НаименованиеБанка = "";
			Объект.КоррСчетБанка     = "";
			Объект.ГородБанка        = "";
			Объект.АдресБанка        = "";
			Объект.ТелефоныБанка     = "";
			Объект.Банк              = ЗаписьОБанке.Ссылка;
		КонецЕсли;
		ДеятельностьБанкаПрекращена = Не Объект.РучноеИзменениеРеквизитовБанка И ДеятельностьБанкаПрекращена(БИКБанка);
		
	ИначеЕсли ТипБанка = "БанкДляРасчетов" Тогда
		БИКБанкаДляРасчетов          = "";
		КоррСчетБанкаДляРасчетов     = "";
		НаименованиеБанкаДляРасчетов = "";
		ГородБанкаДляРасчетов        = "";

		Если Результат Тогда
			ЗаписьОБанке = СведенияОБанке[0].Ссылка.ПолучитьОбъект();
			БИКБанкаДляРасчетов          = ЗаписьОБанке.Код;
			КоррСчетБанкаДляРасчетов     = ЗаписьОБанке.КоррСчет;
			НаименованиеБанкаДляРасчетов = ЗаписьОБанке.Наименование;
			ГородБанкаДляРасчетов        = ЗаписьОБанке.Город;
			СВИФТБИКДляРасчетов = ЗаписьОБанке.СВИФТБИК;
			НашлиПоБИК                   = Истина;
			Если ПеренестиЗначенияРеквизитов Тогда
				Объект.БИКБанкаДляРасчетов          = "";
				Объект.НаименованиеБанкаДляРасчетов = "";
				Объект.КоррСчетБанкаДляРасчетов     = "";
				Объект.ГородБанкаДляРасчетов        = "";
				Объект.АдресБанкаДляРасчетов        = "";
				Объект.ТелефоныБанкаДляРасчетов     = "";
				Объект.БанкДляРасчетов              = ЗаписьОБанке.Ссылка;
			КонецЕсли;
		КонецЕсли;
		ДеятельностьБанкаНепрямыхРасчетовПрекращена = Не Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов
			И ДеятельностьБанкаПрекращена(БИКБанкаДляРасчетов);
	КонецЕсли;

	ОбновитьТекстПоясненияНедействительностиБанка();

	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыБанкаПоБанку(Банк, ТипБанка, ПеренестиЗначенияРеквизитов = Ложь)
	Если ТипБанка = "Банк" Тогда
		БИКБанка          = Банк.Код;
		КоррСчетБанка     = Банк.КоррСчет;
		НаименованиеБанка = Банк.Наименование;
		ГородБанка        = Банк.Город;
		СВИФТБИК = Банк.СВИФТБИК;
		Если ПеренестиЗначенияРеквизитов Тогда
			Объект.БИКБанка          = Банк.Код;
			Объект.НаименованиеБанка = Банк.Наименование;
			Объект.КоррСчетБанка     = Банк.КоррСчет;
			Объект.ГородБанка        = Банк.Город;
			Объект.АдресБанка        = Банк.Адрес;
			Объект.ТелефоныБанка     = Банк.Телефоны;
			Объект.Банк              = "";
			Объект.СВИФТБИК = Банк.СВИФТБИК;
		КонецЕсли;
		ДеятельностьБанкаПрекращена = Не Объект.РучноеИзменениеРеквизитовБанка И ДеятельностьБанкаПрекращена(БИКБанка);
	ИначеЕсли ТипБанка = "БанкДляРасчетов" Тогда
		БИКБанкаДляРасчетов			 = Банк.Код;
		КоррСчетБанкаДляРасчетов	 = Банк.КоррСчет;
		НаименованиеБанкаДляРасчетов = Банк.Наименование;
		ГородБанкаДляРасчетов		 = Банк.Город;
		СВИФТБИКДляРасчетов = Банк.СВИФТБИК;
		Если ПеренестиЗначенияРеквизитов Тогда
			Объект.БИКБанкаДляРасчетов          = Банк.Код;
			Объект.НаименованиеБанкаДляРасчетов = Банк.Наименование;
			Объект.КоррСчетБанкаДляРасчетов     = Банк.КоррСчет;
			Объект.ГородБанкаДляРасчетов        = Банк.Город;
			Объект.АдресБанкаДляРасчетов        = Банк.Адрес;
			Объект.ТелефоныБанкаДляРасчетов     = Банк.Телефоны;
			Объект.БанкДляРасчетов              = "";
			Объект.СВИФТБИКДляРасчетов = Банк.СВИФТБИКДляРасчетов;
		КонецЕсли;
		ДеятельностьБанкаНепрямыхРасчетовПрекращена = Не Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов
			И ДеятельностьБанкаПрекращена(БИКБанкаДляРасчетов);
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	Форма.СпособУказанияРеквизитовБанка = ?(Объект.РучноеИзменениеРеквизитовБанка, "Вручную", "ИзКлассификатора");
	Форма.СпособУказанияРеквизитовБанкаРасчетов = ?(Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов, "Вручную",
		"ИзКлассификатора");

	ЭтоСчетОрганизации = (ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка._ДемоОрганизации"));
	ЗарубежныйСчет = Объект.Зарубежный;

	Элементы.СтраницаНастройкаПечати.Видимость = ЭтоСчетОрганизации;
	Элементы.СведенияОСчете.ОтображениеСтраниц = ?(ЭтоСчетОрганизации, ОтображениеСтраницФормы.ЗакладкиСверху,
		ОтображениеСтраницФормы.Нет);
	Элементы.ГруппаБанкДляРасчетов.Доступность = Форма.ИспользуетсяБанкДляРасчетов;
	Элементы.СпособУказанияРеквизитовБанка.Доступность = Не ЗарубежныйСчет;

	Элементы.РеквизитыБанка.Доступность = Объект.РучноеИзменениеРеквизитовБанка;
	Элементы.РеквизитыБанкаРасчетов.Доступность = Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов;

	Элементы.СпособУказанияРеквизитовБанкаРасчетов.Доступность = Объект.Валюта = Форма.НациональнаяВалюта;

	Элементы.РеквизитыБанка.Доступность = Объект.РучноеИзменениеРеквизитовБанка;
	Элементы.РеквизитыБанкаРасчетов.Доступность = Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов;

	Элементы.СостояниеБанка.ТекущаяСтраница = ?(Форма.ДеятельностьБанкаПрекращена, Элементы.БанкЗакрыт,
		Элементы.БанкРаботает);

	Элементы.СостояниеБанкаНепрямыхРасчетов.ТекущаяСтраница = ?(Форма.ДеятельностьБанкаНепрямыхРасчетовПрекращена,
		Элементы.БанкНепрямыхРасчетовЗакрыт, Элементы.БанкНепрямыхРасчетовРаботает);

	Если Не Объект.Зарубежный Тогда
		Элементы.КодыБанка.ТекущаяСтраница = Элементы.КодыБанкаРоссийскогоСчета;
	Иначе
		Элементы.КодыБанка.ТекущаяСтраница = Элементы.КодыБанкаЗарубежногоСчета;
	КонецЕсли;

	Если Объект.Валюта = Форма.НациональнаяВалюта Тогда
		Элементы.КодыБанкаРасчетов.ТекущаяСтраница = Элементы.КодыБанкаРасчетовРублевогоСчета;
	Иначе
		Элементы.КодыБанкаРасчетов.ТекущаяСтраница = Элементы.КодыБанкаРасчетовВалютногоСчета;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриВыборе(ИмяЭлемента, Форма)
	Если ИмяЭлемента = "БИКБанка" Тогда
		Если Не Объект.РучноеИзменениеРеквизитовБанка Тогда
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
			ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", СтруктураПараметров, Форма);
		КонецЕсли;
	ИначеЕсли ИмяЭлемента = "БИКБанкаДляРасчетов" Тогда
		Если Не Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
			ОткрытьФорму("Справочник.КлассификаторБанков.ФормаВыбора", СтруктураПараметров, Форма);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаОткрытие(ИмяЭлемента)

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
	ЗначенияПараметров = Новый Структура;

	Если ИмяЭлемента = "БИКБанка" Тогда

		СтруктураПараметров.Вставить("РучноеИзменение", Объект.РучноеИзменениеРеквизитовБанка);

		Если Объект.РучноеИзменениеРеквизитовБанка Тогда
			ЗначенияПараметров.Вставить("БИК", БИКБанка);
			ЗначенияПараметров.Вставить("Наименование", НаименованиеБанка);
			ЗначенияПараметров.Вставить("КоррСчет", КоррСчетБанка);
			ЗначенияПараметров.Вставить("Город", ГородБанка);
			ЗначенияПараметров.Вставить("Адрес", Объект.АдресБанка);
			ЗначенияПараметров.Вставить("Телефоны", Объект.ТелефоныБанка);
		Иначе
			СтруктураПараметров.Вставить("Банк", Объект.Банк);
		КонецЕсли;

	ИначеЕсли ИмяЭлемента = "БИКБанкаДляРасчетов" Тогда

		СтруктураПараметров.Вставить("РучноеИзменение", Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов);

		Если Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
			ЗначенияПараметров.Вставить("БИК", БИКБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("Наименование", НаименованиеБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("КоррСчет", КоррСчетБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("Город", ГородБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("Адрес", Объект.АдресБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("Телефоны", Объект.ТелефоныБанкаДляРасчетов);
		Иначе
			СтруктураПараметров.Вставить("Банк", Объект.БанкДляРасчетов);
		КонецЕсли;

	КонецЕсли;

	СтруктураПараметров.Вставить("ЗначенияПолей", ЗначенияПараметров);
	ОткрытьФорму("Справочник._ДемоБанковскиеСчета.Форма.РеквизитыБанка", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьБанк(Знач РезультатВыбора)

	Если ТипЗнч(РезультатВыбора) <> Тип("СправочникСсылка.КлассификаторБанков") Тогда
		Возврат;
	КонецЕсли;

	Если ИмяРедактируемогоРеквизита = "БИКБанка" Тогда
		Объект.Банк				 = РезультатВыбора;
		Объект.БИКБанка			 = "";
		Объект.НаименованиеБанка = "";
		Объект.КоррСчетБанка	 = "";
		Объект.ГородБанка		 = "";
		Объект.АдресБанка		 = "";
		Объект.ТелефоныБанка	 = "";

		ЗаполнитьРеквизитыБанкаПоБанку(РезультатВыбора, "Банк", Ложь);
	ИначеЕсли ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов" Тогда
		Объект.БанкДляРасчетов				= РезультатВыбора;
		Объект.БИКБанкаДляРасчетов			= "";
		Объект.НаименованиеБанкаДляРасчетов = "";
		Объект.КоррСчетБанкаДляРасчетов		= "";
		Объект.ГородБанкаДляРасчетов		= "";
		Объект.АдресБанкаДляРасчетов		= "";
		Объект.ТелефоныБанкаДляРасчетов		= "";

		ЗаполнитьРеквизитыБанкаПоБанку(РезультатВыбора, "БанкДляРасчетов", Ложь);
	КонецЕсли;

КонецПроцедуры

// Параметры:
//   РезультатВыбора - Структура:
//   * ЗначенияПолей - Структура
//
&НаКлиенте
Процедура УстановитьРеквизитыБанка(Знач РезультатВыбора)

	Если ПустаяСтрока(РезультатВыбора) Тогда
		Возврат;
	КонецЕсли;

	Если РезультатВыбора.Реквизит = "БИКБанка" Тогда
		Объект.РучноеИзменениеРеквизитовБанка = РезультатВыбора.РучноеИзменение;
		СпособУказанияРеквизитовБанка = ?(Объект.РучноеИзменениеРеквизитовБанка, "Вручную", "ИзКлассификатора");
		Если РезультатВыбора.РучноеИзменение Тогда
			Объект.Банк				 = "";
			Объект.БИКБанка			 = РезультатВыбора.ЗначенияПолей.БИК;
			Объект.НаименованиеБанка = РезультатВыбора.ЗначенияПолей.Наименование;
			Объект.КоррСчетБанка	 = РезультатВыбора.ЗначенияПолей.КоррСчет;
			Объект.ГородБанка		 = РезультатВыбора.ЗначенияПолей.Город;
			Объект.АдресБанка		 = РезультатВыбора.ЗначенияПолей.Адрес;
			Объект.ТелефоныБанка	 = РезультатВыбора.ЗначенияПолей.Телефоны;

			БИКБанка		  = РезультатВыбора.ЗначенияПолей.БИК;
			КоррСчетБанка	  = РезультатВыбора.ЗначенияПолей.КоррСчет;
			НаименованиеБанка = РезультатВыбора.ЗначенияПолей.Наименование;
			ГородБанка		  = РезультатВыбора.ЗначенияПолей.Город;
		Иначе
			Объект.Банк				 = РезультатВыбора.Банк;
			Объект.БИКБанка			 = "";
			Объект.НаименованиеБанка = "";
			Объект.КоррСчетБанка	 = "";
			Объект.ГородБанка		 = "";
			Объект.АдресБанка		 = "";
			Объект.ТелефоныБанка	 = "";

			ЗаполнитьРеквизитыБанкаПоБанку(Объект.Банк, "Банк", Ложь);
		КонецЕсли;
	ИначеЕсли РезультатВыбора.Реквизит = "БИКБанкаДляРасчетов" Тогда
		Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов = РезультатВыбора.РучноеИзменение;
		СпособУказанияРеквизитовБанкаРасчетов = ?(Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов, "Вручную",
			"ИзКлассификатора");
		Если РезультатВыбора.РучноеИзменение Тогда
			Объект.БанкДляРасчетов				= "";
			Объект.БИКБанкаДляРасчетов			= РезультатВыбора.ЗначенияПолей.БИК;
			Объект.НаименованиеБанкаДляРасчетов = РезультатВыбора.ЗначенияПолей.Наименование;
			Объект.КоррСчетБанкаДляРасчетов		= РезультатВыбора.ЗначенияПолей.КоррСчет;
			Объект.ГородБанкаДляРасчетов		= РезультатВыбора.ЗначенияПолей.Город;
			Объект.АдресБанкаДляРасчетов		= РезультатВыбора.ЗначенияПолей.Адрес;
			Объект.ТелефоныБанкаДляРасчетов		= РезультатВыбора.ЗначенияПолей.Телефоны;

			БИКБанкаДляРасчетов			 = РезультатВыбора.ЗначенияПолей.БИК;
			КоррСчетБанкаДляРасчетов	 = РезультатВыбора.ЗначенияПолей.КоррСчет;
			НаименованиеБанкаДляРасчетов = РезультатВыбора.ЗначенияПолей.Наименование;
			ГородБанкаДляРасчетов		 = РезультатВыбора.ЗначенияПолей.Город;
		Иначе
			Объект.БанкДляРасчетов				= РезультатВыбора.Банк;
			Объект.БИКБанкаДляРасчетов			= "";
			Объект.НаименованиеБанкаДляРасчетов = "";
			Объект.КоррСчетБанкаДляРасчетов		= "";
			Объект.ГородБанкаДляРасчетов		= "";
			Объект.АдресБанкаДляРасчетов		= "";
			Объект.ТелефоныБанкаДляРасчетов		= "";

			ЗаполнитьРеквизитыБанкаПоБанку(Объект.БанкДляРасчетов, "БанкДляРасчетов", Ложь);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриИзменении(Элемент)

	ТипБанка = "Банк";
	РучноеИзменениеРеквизитовБанка = Объект.РучноеИзменениеРеквизитовБанка;
	ИмяРедактируемогоРеквизита = "БИКБанка";

	Если СтрНачинаетсяС(Элемент.Имя, "БИКБанкаДляРасчетов") Тогда
		ТипБанка = "БанкДляРасчетов";
		РучноеИзменениеРеквизитовБанка = Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов;
		ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов";
	КонецЕсли;

	Если РучноеИзменениеРеквизитовБанка Тогда
		Возврат;
	КонецЕсли;

	Если ЗаполнитьРеквизитыБанкаПоБИК(ЭтотОбъект[ИмяРедактируемогоРеквизита], ТипБанка, Истина) Тогда
		УправлениеЭлементамиФормы(ЭтотОбъект);
		Возврат;
	КонецЕсли;

	БИК = ЭтотОбъект[Элемент.Имя];
	РаботаСБанкамиКлиент.ВыбратьИзСправочникаБИК(БИК, ЭтотОбъект);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДеятельностьБанкаПрекращена(БИК)

	Результат = Ложь;

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторБанков.ДеятельностьПрекращена
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|ГДЕ
	|	КлассификаторБанков.Код = &БИК
	|	И КлассификаторБанков.ЭтоГруппа = ЛОЖЬ";

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("БИК", БИК);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.ДеятельностьПрекращена;
	КонецЕсли;

	Возврат Результат;

КонецФункции

&НаСервере
Процедура ОбновитьТекстПоясненияНедействительностиБанка()
	Элементы.НадписьДеятельностьБанкаПрекращена.Заголовок = РаботаСБанками.ПояснениеНедействительногоБанка(Объект.Банк);
	Элементы.НадписьДеятельностьБанкаРасчетовПрекращена.Заголовок =РаботаСБанками.ПояснениеНедействительногоБанка(
		Объект.БанкДляРасчетов);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьНомерСчета(Отказ);

КонецПроцедуры

&НаСервере
Процедура ПроверитьНомерСчета(Отказ)

	Если Не Объект.Зарубежный И ЗначениеЗаполнено(Объект.НомерСчета) И ЗначениеЗаполнено(БИКБанка) Тогда
		_ДемоЛокализация.ПриПроверкеНомераСчета(Объект.НомерСчета, БИКБанка, Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти