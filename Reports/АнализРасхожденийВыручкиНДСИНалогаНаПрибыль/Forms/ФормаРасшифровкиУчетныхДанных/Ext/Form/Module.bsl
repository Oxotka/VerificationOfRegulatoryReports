﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("МассивРасшифровки") Тогда
		Для Каждого СтрокаРасшифровки Из Параметры.МассивРасшифровки Цикл
			ЗаполнитьЗначенияСвойств(Отчет.Расшифровка.Добавить(), СтрокаРасшифровки);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыРасшифровка

&НаКлиенте
Процедура РасшифровкаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Документ = Элементы.Расшифровка.ТекущиеДанные.Документ;
	Если ЗначениеЗаполнено(Документ) Тогда
		ПоказатьЗначение( ,Документ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
