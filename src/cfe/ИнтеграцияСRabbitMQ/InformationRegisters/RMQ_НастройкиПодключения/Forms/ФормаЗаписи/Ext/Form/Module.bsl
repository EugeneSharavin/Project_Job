﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДействуетПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДействуетПриИзмененииНаСервере()
	Элементы.ВиртуальныйХост.ТолькоПросмотр = НЕ Запись.Действует;
	Элементы.Адрес.ТолькоПросмотр = НЕ Запись.Действует;
	Элементы.Порт.ТолькоПросмотр = НЕ Запись.Действует;
	Элементы.ИмяПользователя.ТолькоПросмотр = НЕ Запись.Действует;
	Элементы.Пароль.ТолькоПросмотр = НЕ Запись.Действует;
КонецПроцедуры

&НаКлиенте
Процедура ДействуетПриИзменении(Элемент)
	ДействуетПриИзмененииНаСервере();
КонецПроцедуры
