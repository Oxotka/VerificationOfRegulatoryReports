﻿Функция СформироватьОтчет(Организация, МассивСубконтоПДР, Период) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Показатели = ПоказателиСверкиДанныхРегламентированныхОтчетов(Организация, НачалоГода(Период), КонецДня(Период));
	Макет = ПолучитьМакет("МакетОтчета");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоГода(Период), Период);
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация, Период);
	ОбластьЗаголовок.Параметры.Заполнить(Новый Структура("Организация, Период", СведенияОбОрганизации.ПолноеНаименование, ПредставлениеПериода));
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	
	Если Показатели.Количество() = 0 Тогда
		ОбластьНетДанных = Макет.ПолучитьОбласть("НетДанных");
		ТабличныйДокумент.Вывести(ОбластьНетДанных);
		Возврат ТабличныйДокумент;
	КонецЕсли;
	
	Периоды = НовыйПериоды(Период);
	ДополнитьПоказателиУчетнымиДанными(Организация, МассивСубконтоПДР, Показатели, Периоды);
	ТаблицаСверкиДанных = ТаблицаСверкиДанныхРегламентированныхОтчетов(Показатели, Периоды);
	
	// Шапка
	Область = Макет.ПолучитьОбласть("Шапка|Показатель");
	ТабличныйДокумент.Присоединить(Область);
	Область = Макет.ПолучитьОбласть("Шапка|Период");
	Для Каждого СтрокаПериода Из Периоды Цикл
		Область.Параметры.Заполнить(СтрокаПериода);
		ТабличныйДокумент.Присоединить(Область);
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("СтрокаВерхнийУровень|Показатель");
	Область.Параметры.Показатель = "Декларация по налогу на прибыль";
	ТабличныйДокумент.Вывести(Область);
	ВывестиВидОтчетности(Макет, Периоды, ТаблицаСверкиДанных, "ПрибыльВидОтчетности", ТабличныйДокумент);
	
	Область = Макет.ПолучитьОбласть("СтрокаСреднийУровень|Показатель");
	Область.Параметры.Показатель = "Налоговая база по прибыли";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "БазаПрибыль", ТаблицаСверкиДанных, ТабличныйДокумент);
	
	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "Доходы от реализации" + Символы.ПС + "Лист 02, строка 010";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "ДоходыОтРеализации", ТаблицаСверкиДанных, ТабличныйДокумент, Истина);
	
	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "Внереализационные доходы" + Символы.ПС + "Лист 02, строка 020";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "ВнереализационныеДоходы", ТаблицаСверкиДанных, ТабличныйДокумент, Истина);
	
	Область = Макет.ПолучитьОбласть("СтрокаВерхнийУровень|Показатель");
	Область.Параметры.Показатель = "Декларация по НДС";
	ТабличныйДокумент.Вывести(Область);
	ВывестиВидОтчетности(Макет, Периоды, ТаблицаСверкиДанных, "НДСВидОтчетности", ТабличныйДокумент);

	Область = Макет.ПолучитьОбласть("СтрокаСреднийУровень|Показатель");
	Область.Параметры.Показатель = "Налоговая база по НДС";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "БазаНДС", ТаблицаСверкиДанных, ТабличныйДокумент,,Истина);
	
	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "НДС по ставке 18%" + Символы.ПС + "Раздел 3, строка 010";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "Выручка18", ТаблицаСверкиДанных, ТабличныйДокумент, Истина, Истина);

	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "НДС по ставке 10%" + Символы.ПС + "Раздел 3, строка 020";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "Выручка10", ТаблицаСверкиДанных, ТабличныйДокумент, Истина, Истина);
	
	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "Подтвержденная реализация на экспорт" + Символы.ПС + "Раздел 4, строка 020";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "РеализацияНаЭкспорт", ТаблицаСверкиДанных, ТабличныйДокумент, Истина, Истина);
	
	Область = Макет.ПолучитьОбласть("СтрокаВерхнийУровень|Показатель");
	Область.Параметры.Показатель = "Разрешенные разницы";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "РазрешенныеРазницыИтог", ТаблицаСверкиДанных, ТабличныйДокумент,,,Ложь);
	
	Область = Макет.ПолучитьОбласть("СтрокаСреднийУровень|Показатель");
	Область.Параметры.Показатель = "Переходящие разницы";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "ПереходящиеРазницы", ТаблицаСверкиДанных, ТабличныйДокумент,,,Ложь);

	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "Не подтвержденная реализация" + Символы.ПС + "на экспорт";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "НеподтвержденныйНДС", ТаблицаСверкиДанных, ТабличныйДокумент, Истина,,Ложь);
	
	Область = Макет.ПолучитьОбласть("СтрокаСреднийУровень|Показатель");
	Область.Параметры.Показатель = "Неизменные разницы";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "НеизменныеРазницы", ТаблицаСверкиДанных, ТабличныйДокумент,,,Ложь);
	
	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "Возвраты товаров поставщику";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "ВозвратПоставщику", ТаблицаСверкиДанных, ТабличныйДокумент, Истина,,Ложь);
	
	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "Возвраты товаров от покупателей";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "ВозвратОтПокупателя", ТаблицаСверкиДанных, ТабличныйДокумент, Истина,,Ложь);
	
	Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Показатель");
	Область.Параметры.Показатель = "Внереализационные доходы," + Символы.ПС + "не облагаемые НДС";
	ТабличныйДокумент.Вывести(Область);
	ВывестиЗначенияПоказателей(Макет, Периоды, "ВнерелизационныеДоходыНеОблагаемыеНДС", ТаблицаСверкиДанных, ТабличныйДокумент, Истина,,Ложь);
	
	Область = Макет.ПолучитьОбласть("СтрокаВерхнийУровень|Показатель");
	Область.Параметры.Показатель = "Разница";
	ТабличныйДокумент.Вывести(Область);
	ВывестиРазницу(Макет, Периоды, "Разница", ТаблицаСверкиДанных, ТабличныйДокумент);
	
	ТабличныйДокумент.ФиксацияСлева = 3;
	Возврат ТабличныйДокумент;
	
КонецФункции

#Область ВыводОтчета

Процедура ВывестиЗначенияПоказателей(Макет, Периоды, Показатель, ТаблицаСверкиДанных, ТабличныйДокумент, ЭтоРасшифровка = Ложь, Оборотный = Ложь, ВыделятьЦветом = Истина)
	
	Если ЭтоРасшифровка Тогда
		Область = Макет.ПолучитьОбласть("СтрокаНижнийУровень|Период");
	Иначе
		Область = Макет.ПолучитьОбласть("СтрокаСреднийУровень|Период");
	КонецЕсли;
	ЦветПоУмолчанию = Область.ТекущаяОбласть.ЦветТекста;
	СтрокаПоказателя = ТаблицаСверкиДанных.НайтиСтроки(Новый Структура("ИмяПоказателя", Показатель))[0];
	Для Каждого СтрокаПериода Из Периоды Цикл
		ЗначениеПоказателя = СтрокаПоказателя[СтрокаПериода.ИмяКолонки];
		Область.ТекущаяОбласть.ЦветТекста = ЦветПоУмолчанию;
		Если СтрокаПериода.ИмяКолонки <> "Квартал1" И ВыделятьЦветом Тогда
			Если Оборотный И СтрокаПериода.Накопительный Тогда
				Область.ТекущаяОбласть.ЦветТекста = WebЦвета.СветлоСерый;
			ИначеЕсли НЕ Оборотный И НЕ СтрокаПериода.Накопительный Тогда
				Область.ТекущаяОбласть.ЦветТекста = WebЦвета.СветлоСерый;
			КонецЕсли;
		КонецЕсли;
		
		Область.Параметры.ЗначениеПоказателя = ЗначениеПоказателя;
		ТабличныйДокумент.Присоединить(Область);
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиВидОтчетности(Макет, Периоды, ТаблицаСверкиДанных, Показатель, ТабличныйДокумент)
	
	Область = Макет.ПолучитьОбласть("СтрокаВерхнийУровень|Период");
	СтрокаПоказателя = ТаблицаСверкиДанных.НайтиСтроки(Новый Структура("ИмяПоказателя", Показатель))[0];
	ЦветПоУмолчанию = Область.ТекущаяОбласть.ЦветТекста;
	Для Каждого СтрокаПериода Из Периоды Цикл
		ЗначениеПоказателя = СтрокаПоказателя[СтрокаПериода.ИмяКолонки];
		Если ЗначениеПоказателя = 0 Тогда
			ЗначениеПоказателя = "Расчетный";
		ИначеЕсли ЗначениеПоказателя = 1 Тогда
			ЗначениеПоказателя = "Первичный";
		Иначе
			ЗначениеПоказателя = "К/" + (ЗначениеПоказателя - 1);
		КонецЕсли;
		Если ЗначениеПоказателя = "Расчетный" Тогда
			Область.ТекущаяОбласть.ЦветТекста = WebЦвета.СветлоСерый;
		Иначе
			Область.ТекущаяОбласть.ЦветТекста = ЦветПоУмолчанию;
		КонецЕсли;
		Область.Параметры.ЗначениеПоказателя = ЗначениеПоказателя;
		ТабличныйДокумент.Присоединить(Область);
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиРазницу(Макет, Периоды, Показатель, ТаблицаСверкиДанных, ТабличныйДокумент)
	
	СтрокаПоказателя = ТаблицаСверкиДанных.НайтиСтроки(Новый Структура("ИмяПоказателя", Показатель))[0];
	Для Каждого СтрокаПериода Из Периоды Цикл
		ЗначениеПоказателя = СтрокаПоказателя[СтрокаПериода.ИмяКолонки];
		
		Если ЗначениеПоказателя <> 0 Тогда
			Область = Макет.ПолучитьОбласть("СтрокаВерхнийУровеньСРисунком|Период");
		Иначе
			Область = Макет.ПолучитьОбласть("СтрокаВерхнийУровень|Период");
		КонецЕсли;
		
		Область.Параметры.ЗначениеПоказателя = ЗначениеПоказателя;
		ТабличныйДокумент.Присоединить(Область);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТаблицаСверкиДанных

Функция ТаблицаСверкиДанныхРегламентированныхОтчетов(Показатели, Периоды)

	ТаблицаСверкиДанных = Новый ТаблицаЗначений;
	ТаблицаСверкиДанных.Колонки.Добавить("ИмяПоказателя", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	ТаблицаСверкиДанных.Колонки.Добавить("ИсточникДанных", ОбщегоНазначения.ОписаниеТипаСтрока(30));
	Для Каждого СтрокаПериода Из Периоды Цикл
		ТаблицаСверкиДанных.Колонки.Добавить(СтрокаПериода.ИмяКолонки, ОбщегоНазначения.ОписаниеТипаЧисло(15));
	КонецЦикла;
	ТаблицаСверкиДанных.Индексы.Добавить("ИмяПоказателя");
	
	// Прибыль
	ДобавитьПоказательВидОтчетностиПрибыль(ТаблицаСверкиДанных, Периоды, Показатели);
	ДобавитьПоказательНакопительный(ТаблицаСверкиДанных, "РегламентированныйОтчетПрибыль", "ДоходыОтРеализации", Периоды, Показатели);
	ДобавитьПоказательНакопительный(ТаблицаСверкиДанных, "РегламентированныйОтчетПрибыль", "ВнереализационныеДоходы", Периоды, Показатели);
	ДобавитьПоказательИтоговый(ТаблицаСверкиДанных, "РегламентированныйОтчетПрибыль", "БазаПрибыль");
	
	// НДС
	ДобавитьПоказательВидОтчетностиНДС(ТаблицаСверкиДанных, Периоды, Показатели);
	ДобавитьПоказательОборотный(ТаблицаСверкиДанных, "РегламентированныйОтчетНДС", "Выручка18", Периоды, Показатели);
	ДобавитьПоказательОборотный(ТаблицаСверкиДанных, "РегламентированныйОтчетНДС", "Выручка10", Периоды, Показатели);
	ДобавитьПоказательОборотный(ТаблицаСверкиДанных, "РегламентированныйОтчетНДС", "РеализацияНаЭкспорт", Периоды, Показатели);
	ДобавитьПоказательИтоговый(ТаблицаСверкиДанных, "РегламентированныйОтчетНДС", "БазаНДС");

	// Разрешенные разницы
	ДобавитьПоказательНеподтвержденныйНДС(ТаблицаСверкиДанных, "РазрешенныеРазницы", "НеподтвержденныйНДС", Периоды, Показатели);
	ДобавитьПоказательОборотный(ТаблицаСверкиДанных, "РазрешенныеРазницы", "ВозвратПоставщику", Периоды, Показатели);
	ДобавитьПоказательОборотный(ТаблицаСверкиДанных, "РазрешенныеРазницы", "ВозвратОтПокупателя", Периоды, Показатели);
	ДобавитьПоказательОборотный(ТаблицаСверкиДанных, "РазрешенныеРазницы", "ВнерелизационныеДоходыНеОблагаемыеНДС", Периоды, Показатели);
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("ВозвратОтПокупателя");
	МассивПоказателей.Добавить("ВозвратПоставщику");
	МассивПоказателей.Добавить("ВнерелизационныеДоходыНеОблагаемыеНДС");
	ДобавитьПоказательИтоговыйПоПоказателям(ТаблицаСверкиДанных, "РазрешенныеРазницы", "НеизменныеРазницы", МассивПоказателей);
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("НеподтвержденныйНДС");
	ДобавитьПоказательИтоговыйПоПоказателям(ТаблицаСверкиДанных, "РазрешенныеРазницы", "ПереходящиеРазницы", МассивПоказателей);

	ДобавитьПоказательИтоговый(ТаблицаСверкиДанных, "РазрешенныеРазницы", "РазрешенныеРазницыИтог");
	
	// Разница
	ДобавитьПоказательРазница(ТаблицаСверкиДанных);
	
	Возврат ТаблицаСверкиДанных;
	
КонецФункции

Процедура ДобавитьПоказательВидОтчетностиНДС(ТаблицаСверкиДанных, Периоды, Показатели)
	
	СтрокаТаблицы = ТаблицаСверкиДанных.Добавить();
	СтрокаТаблицы.ИмяПоказателя = "НДСВидОтчетности";
	Для Каждого СтрокаПериода Из Периоды Цикл
		Если СтрокаПериода.Накопительный Тогда
			Продолжить;
		КонецЕсли;
		Отбор = Новый Структура("ДатаОкончания, ИсточникОтчета", СтрокаПериода.ДатаОтчета, "РегламентированныйОтчетНДС");
		СтрокаПоказателя = Показатели.НайтиСтроки(Отбор);
		Если СтрокаПоказателя.Количество() > 0 Тогда
			СтрокаТаблицы[СтрокаПериода.ИмяКолонки] = СтрокаПоказателя[0].Вид + 1;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьПоказательВидОтчетностиПрибыль(ТаблицаСверкиДанных, Периоды, Показатели)
	
	СтрокаТаблицы = ТаблицаСверкиДанных.Добавить();
	СтрокаТаблицы.ИмяПоказателя = "ПрибыльВидОтчетности";
	Для Каждого СтрокаПериода Из Периоды Цикл
		Если НЕ (СтрокаПериода.ИмяКолонки = "Квартал1" ИЛИ СтрокаПериода.Накопительный) Тогда
			Продолжить;
		КонецЕсли;
		Отбор = Новый Структура("ДатаОкончания, ИсточникОтчета", СтрокаПериода.ДатаОтчета, "РегламентированныйОтчетПрибыль");
		СтрокаПоказателя = Показатели.НайтиСтроки(Отбор);
		Если СтрокаПоказателя.Количество() > 0 Тогда
			СтрокаТаблицы[СтрокаПериода.ИмяКолонки] = СтрокаПоказателя[0].Вид + 1;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьПоказательНакопительный(ТаблицаСверкиДанных, ИсточникДанных, ИмяПоказателя, Периоды, Показатели)
	
	СтрокаТаблицы = ТаблицаСверкиДанных.Добавить();
	СтрокаТаблицы.ИмяПоказателя = ИмяПоказателя;
	СтрокаТаблицы.ИсточникДанных = ИсточникДанных;
	МассивПериодовДляРасчета = Новый Массив;
	Для Каждого СтрокаПериода Из Периоды Цикл
		
		Если НЕ (СтрокаПериода.ИмяКолонки = "Квартал1" ИЛИ СтрокаПериода.Накопительный) Тогда
			МассивПериодовДляРасчета.Добавить(СтрокаПериода.ИмяКолонки);
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура("ДатаОкончания, ИсточникОтчета, Показатель", СтрокаПериода.ДатаОтчета, ИсточникДанных, ИмяПоказателя);
		СтрокиПоказателей = Показатели.НайтиСтроки(Отбор);
		Для Каждого СтрокаПоказателя ИЗ СтрокиПоказателей Цикл
			СтрокаТаблицы[СтрокаПериода.ИмяКолонки] = СтрокаТаблицы[СтрокаПериода.ИмяКолонки] + СтрокаПоказателя.ЗначениеПоказателя;
		КонецЦикла;
	КонецЦикла;
	Для Каждого ПериодДляРасчета Из МассивПериодовДляРасчета Цикл
		ПоказателиДляРасчета = Новый Структура("Накопленное, Предыдущее",0,0);
		
		Если ПериодДляРасчета = "Квартал2" Тогда
			ПоказателиДляРасчета.Накопленное = СтрокаТаблицы.Полугодие;
			ПоказателиДляРасчета.Предыдущее = СтрокаТаблицы.Квартал1;
		ИначеЕсли ПериодДляРасчета = "Квартал3" Тогда
			ПоказателиДляРасчета.Накопленное = СтрокаТаблицы.Месяцев9;
			ПоказателиДляРасчета.Предыдущее = СтрокаТаблицы.Полугодие;
		ИначеЕсли ПериодДляРасчета = "Квартал4" Тогда
			ПоказателиДляРасчета.Накопленное = СтрокаТаблицы.Год;
			ПоказателиДляРасчета.Предыдущее = СтрокаТаблицы.Месяцев9;
		КонецЕсли;
		Если ПоказателиДляРасчета.Накопленное = 0 Тогда
			Продолжить;
		КонецЕсли;
		СтрокаТаблицы[ПериодДляРасчета] = ПоказателиДляРасчета.Накопленное - ПоказателиДляРасчета.Предыдущее;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПоказательОборотный(ТаблицаСверкиДанных, ИсточникДанных, ИмяПоказателя, Периоды, Показатели)

	СтрокаТаблицы = ТаблицаСверкиДанных.Добавить();
	СтрокаТаблицы.ИмяПоказателя = ИмяПоказателя;
	СтрокаТаблицы.ИсточникДанных = ИсточникДанных;
	МассивПериодовДляРасчета = Новый Массив;
	Для Каждого СтрокаПериода Из Периоды Цикл
		Если СтрокаПериода.Накопительный Тогда
			МассивПериодовДляРасчета.Добавить(СтрокаПериода.ИмяКолонки);
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура("ДатаОкончания, ИсточникОтчета, Показатель", СтрокаПериода.ДатаОтчета, ИсточникДанных, ИмяПоказателя);
		СтрокиПоказателей = Показатели.НайтиСтроки(Отбор);
		Для Каждого СтрокаПоказателя ИЗ СтрокиПоказателей Цикл
			СтрокаТаблицы[СтрокаПериода.ИмяКолонки] = СтрокаТаблицы[СтрокаПериода.ИмяКолонки] + СтрокаПоказателя.ЗначениеПоказателя;
		КонецЦикла;
	КонецЦикла;
	Для Каждого ПериодДляРасчета Из МассивПериодовДляРасчета Цикл
		ПоказателиДляРасчета = Новый Структура("Слагаемое1, Слагаемое2",0,0);
		
		Если ПериодДляРасчета = "Полугодие" Тогда
			ПоказателиДляРасчета.Слагаемое1 = СтрокаТаблицы.Квартал1;
			ПоказателиДляРасчета.Слагаемое2 = СтрокаТаблицы.Квартал2;
		ИначеЕсли ПериодДляРасчета = "Месяцев9" Тогда
			ПоказателиДляРасчета.Слагаемое1 = СтрокаТаблицы.Полугодие;
			ПоказателиДляРасчета.Слагаемое2 = СтрокаТаблицы.Квартал3;
		ИначеЕсли ПериодДляРасчета = "Год" Тогда
			ПоказателиДляРасчета.Слагаемое1 = СтрокаТаблицы.Месяцев9;
			ПоказателиДляРасчета.Слагаемое2 = СтрокаТаблицы.Квартал4;
		КонецЕсли;

		СтрокаТаблицы[ПериодДляРасчета] = ПоказателиДляРасчета.Слагаемое1 + ПоказателиДляРасчета.Слагаемое2;
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьПоказательИтоговыйПоПоказателям(ТаблицаСверкиДанных, ИсточникДанных, ИмяПоказателя, МассивПоказателей)
	
	МассивКолонокИсключений = Новый Массив;
	МассивКолонокИсключений.Добавить("ИмяПоказателя");
	МассивКолонокИсключений.Добавить("ИсточникДанных");
	
	МассивСтрок   = ТаблицаСверкиДанных.НайтиСтроки(Новый Структура("ИсточникДанных", ИсточникДанных));
	СтрокаТаблицы = ТаблицаСверкиДанных.Добавить();
	СтрокаТаблицы.ИмяПоказателя = ИмяПоказателя;
	Для Каждого Строка Из МассивСтрок Цикл
		Если МассивПоказателей.Найти(Строка.ИмяПоказателя) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого Колонка Из ТаблицаСверкиДанных.Колонки Цикл
			ИмяКолонки = Колонка.Имя;
			Если МассивКолонокИсключений.Найти(ИмяКолонки) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СтрокаТаблицы[ИмяКолонки] = СтрокаТаблицы[ИмяКолонки] + Строка[ИмяКолонки];
		КонецЦикла
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПоказательИтоговый(ТаблицаСверкиДанных, ИсточникДанных, ИмяПоказателя)
	
	МассивКолонокИсключений = Новый Массив;
	МассивКолонокИсключений.Добавить("ИмяПоказателя");
	МассивКолонокИсключений.Добавить("ИсточникДанных");
	
	МассивСтрок   = ТаблицаСверкиДанных.НайтиСтроки(Новый Структура("ИсточникДанных", ИсточникДанных));
	СтрокаТаблицы = ТаблицаСверкиДанных.Добавить();
	СтрокаТаблицы.ИмяПоказателя = ИмяПоказателя;
	Для Каждого Строка Из МассивСтрок Цикл
		Для Каждого Колонка Из ТаблицаСверкиДанных.Колонки Цикл
			ИмяКолонки = Колонка.Имя;
			Если МассивКолонокИсключений.Найти(ИмяКолонки) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СтрокаТаблицы[ИмяКолонки] = СтрокаТаблицы[ИмяКолонки] + Строка[ИмяКолонки];
		КонецЦикла
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПоказательРазница(ТаблицаСверкиДанных)
	
	СтрокаПрибыль = ТаблицаСверкиДанных.НайтиСтроки(Новый Структура("ИмяПоказателя", "БазаПрибыль"))[0];
	СтрокаНДС = ТаблицаСверкиДанных.НайтиСтроки(Новый Структура("ИмяПоказателя", "БазаНДС"))[0];
	СтрокаРазрешенныеРазницы = ТаблицаСверкиДанных.НайтиСтроки(Новый Структура("ИмяПоказателя", "РазрешенныеРазницыИтог"))[0];
	
	СтрокаТаблицы = ТаблицаСверкиДанных.Добавить();
	СтрокаТаблицы.ИмяПоказателя = "Разница";
	МассивКолонокИсключений = Новый Массив;
	МассивКолонокИсключений.Добавить("ИмяПоказателя");
	МассивКолонокИсключений.Добавить("ИсточникДанных");

	Для Каждого Колонка Из ТаблицаСверкиДанных.Колонки Цикл
		ИмяКолонки = Колонка.Имя;
		Если МассивКолонокИсключений.Найти(ИмяКолонки) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗначениеПоказателя = СтрокаПрибыль[ИмяКолонки] - СтрокаНДС[ИмяКолонки] - СтрокаРазрешенныеРазницы[ИмяКолонки];
		// Делаем округление 1 рубля до 0.
		Если ЗначениеПоказателя = 1 ИЛИ ЗначениеПоказателя = -1 Тогда
			ЗначениеПоказателя = 0;
		КонецЕсли;
		СтрокаТаблицы[ИмяКолонки] = ЗначениеПоказателя;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПоказательНеподтвержденныйНДС(ТаблицаСверкиДанных, ИсточникДанных, ИмяПоказателя, Периоды, Показатели)

	СтрокаТаблицы = ТаблицаСверкиДанных.Добавить();
	СтрокаТаблицы.ИмяПоказателя = ИмяПоказателя;
	СтрокаТаблицы.ИсточникДанных = ИсточникДанных;
	Для Каждого СтрокаПериода Из Периоды Цикл
		
		Если СтрокаПериода.Накопительный Тогда
			Отбор = Новый Структура("ДатаОкончания, ИсточникОтчета, Показатель", СтрокаПериода.ДатаОтчета, ИсточникДанных, "НеподтвержденныйНДСОстатки");
		Иначе
			Отбор = Новый Структура("ДатаОкончания, ИсточникОтчета, Показатель", СтрокаПериода.ДатаОтчета, ИсточникДанных, "НеподтвержденныйНДСОбороты");
		КонецЕсли;
		
		СтрокиПоказателей = Показатели.НайтиСтроки(Отбор);
		
		Для Каждого СтрокаПоказателя ИЗ СтрокиПоказателей Цикл
			СтрокаТаблицы[СтрокаПериода.ИмяКолонки] = СтрокаТаблицы[СтрокаПериода.ИмяКолонки] + СтрокаПоказателя.ЗначениеПоказателя;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ПолучениеДанныхРегламентированныхОтчетов

Функция ПоказателиСверкиДанныхРегламентированныхОтчетов(Организация, ДатаНачала, ДатаОкончания)
	
	ТаблицаОтчетов = ОтчетыСверкиДанныхРегламентированныхОтчетов(Организация, ДатаНачала, ДатаОкончания);
	
	ТаблицаПоказателей = НоваяТаблицаПоказателейСверкиДанныхРегламентированныхОтчетов();
	
	Для Каждого СтрокаОтчета Из ТаблицаОтчетов Цикл
		ВставитьПоказательВТаблицуСверкиДанныхРегламентированныхОтчетов(ТаблицаПоказателей, СтрокаОтчета);
	КонецЦикла;
	
	Возврат ТаблицаПоказателей
	
КонецФункции

Функция ОтчетыСверкиДанныхРегламентированныхОтчетов(Организация, ДатаНачала, ДатаОкончания)
	
	ТаблицаОтчетов = Новый ТаблицаЗначений;
	ТаблицаОтчетов.Колонки.Добавить("РегламентированныйОтчет");
	ТаблицаОтчетов.Колонки.Добавить("ИсточникОтчета");
	ТаблицаОтчетов.Колонки.Добавить("ВыбраннаяФорма");
	ТаблицаОтчетов.Колонки.Добавить("ПериодДокумента");
	ТаблицаОтчетов.Колонки.Добавить("КодНалоговогоОргана");
	ТаблицаОтчетов.Колонки.Добавить("Вид");
	ТаблицаОтчетов.Колонки.Добавить("МоментВремени");
	ТаблицаОтчетов.Колонки.Добавить("ДатаОтчета");
	ТаблицаОтчетов.Колонки.Добавить("ОтчетныйПериод");
	ТаблицаОтчетов.Колонки.Добавить("Периодичность");
	ТаблицаОтчетов.Колонки.Добавить("ДатаНачала");
	ТаблицаОтчетов.Колонки.Добавить("ДатаОкончания");
	
	ВидыОтчетов = ВидыСверкиДанныхРегламентированныхОтчетов();
	Выборка = РегламентированнаяОтчетность.ВыборкаРегламентированныхОтчетов(Организация, ДатаНачала, ДатаОкончания, ВидыОтчетов);
	ОсновнойКодНалоговогоОргана = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "КодНалоговогоОргана");
	Пока Выборка.Следующий() Цикл
		// Отбираем декларации только для основного кода налоговой органа.
		// Декларации по обособленным подразделениям не учитываем.
		Если Выборка.КодНалоговогоОргана <> ОсновнойКодНалоговогоОргана Тогда
			Продолжить;
		КонецЕсли;
		УсловияПоиска = Новый Структура("ИсточникОтчета, ПериодДокумента, КодНалоговогоОргана");
		ЗаполнитьЗначенияСвойств(УсловияПоиска, Выборка);
		
		СтрокиТаблицыОтчетов = ТаблицаОтчетов.НайтиСтроки(УсловияПоиска);
		
		Если СтрокиТаблицыОтчетов.Количество() = 0 Тогда
			// Отчет еще не учитывался.
			НоваяСтрокаТаблицы = ТаблицаОтчетов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицы, Выборка);
			
		Иначе
			СтрокаТаблицы = СтрокиТаблицыОтчетов[0];
			
			Если СтрСравнить(Выборка.ВыбраннаяФорма, СтрокаТаблицы.ВыбраннаяФорма) > 0 Тогда
				// Поздняя форма отчета вытесняет предшествующие.
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
				
			ИначеЕсли СтрСравнить(Выборка.ВыбраннаяФорма, СтрокаТаблицы.ВыбраннаяФорма) = 0 Тогда
				Если СтрокаТаблицы.РегламентированныйОтчет.СтатусОтчета = "Сдано" И
					Выборка.РегламентированныйОтчет.СтатусОтчета <> "Сдано" Тогда
					Продолжить;
				КонецЕсли;
				
				Если Выборка.Вид > СтрокаТаблицы.Вид Тогда
					// Поздние корректировки вытесняют предшествующие.
					ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
					
				ИначеЕсли Выборка.Вид = СтрокаТаблицы.Вид Тогда
					Если Выборка.МоментВремени.Сравнить(СтрокаТаблицы.МоментВремени) > 0 Тогда
						// Отчеты созданные позже вытесняют предшествующие.
						ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаОтчетов;
	
КонецФункции

Функция ВидыСверкиДанныхРегламентированныхОтчетов()
	
	ВидыОтчетов = Новый Массив;
	
	ВидыОтчетов.Добавить("РегламентированныйОтчетПрибыль");
	ВидыОтчетов.Добавить("РегламентированныйОтчетНДС");
	
	Возврат ВидыОтчетов;
	
КонецФункции

Функция НоваяТаблицаПоказателейСверкиДанныхРегламентированныхОтчетов();
	
	ТипСтрока  = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	ТипСтрока4 = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(4));
	ТипДата    = Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты);
	ТипЧисло   = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2));
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	ТаблицаПоказателей.Колонки.Добавить("Показатель", ТипСтрока);
	ТаблицаПоказателей.Колонки.Добавить("ИсточникОтчета", ТипСтрока);
	ТаблицаПоказателей.Колонки.Добавить("ДатаОтчета", ТипДата);
	ТаблицаПоказателей.Колонки.Добавить("РегламентированныйОтчет", ОбщегоНазначения.ОписаниеТипаВсеСсылки());
	ТаблицаПоказателей.Колонки.Добавить("ОтчетныйПериод", ТипДата);
	ТаблицаПоказателей.Колонки.Добавить("КодНалоговогоОргана", ТипСтрока4);
	ТаблицаПоказателей.Колонки.Добавить("Периодичность");
	ТаблицаПоказателей.Колонки.Добавить("ДатаНачала", ТипДата);
	ТаблицаПоказателей.Колонки.Добавить("ДатаОкончания", ТипДата);
	ТаблицаПоказателей.Колонки.Добавить("ПериодДокумента", ТипСтрока);
	ТаблицаПоказателей.Колонки.Добавить("ЗначениеПоказателя", ТипЧисло);
	ТаблицаПоказателей.Колонки.Добавить("Вид", ТипЧисло);
	
	Возврат ТаблицаПоказателей;
	
КонецФункции

Процедура ВставитьПоказательВТаблицуСверкиДанныхРегламентированныхОтчетов(ТаблицаПоказателей, ОписаниеОтчета)
	
	Если ОписаниеОтчета.ИсточникОтчета = "РегламентированныйОтчетПрибыль" Тогда
		ВставитьПоказатели_Прибыль(ТаблицаПоказателей, ОписаниеОтчета);
		
	ИначеЕсли ОписаниеОтчета.ИсточникОтчета = "РегламентированныйОтчетНДС" Тогда
		ВставитьПоказатели_НДС(ТаблицаПоказателей, ОписаниеОтчета);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВставитьПоказатели_Прибыль(ТаблицаПоказателей, ОписаниеОтчета)
	
	СведенияОтчета = ОписаниеОтчета.РегламентированныйОтчет.ДанныеОтчета.Получить();
	
	ЗначениеПоказателя = 0;
	
	Если ОписаниеОтчета.ВыбраннаяФорма = "ФормаОтчета2016Кв4"
		ИЛИ ОписаниеОтчета.ВыбраннаяФорма = "ФормаОтчета2015Кв1" Тогда
		
		ЗначениеПоказателя = 0;
		
		Для Каждого Лист Из СведенияОтчета.ДанныеМногостраничныхРазделов.Лист02 Цикл
			ДанныеЛиста = Лист.Данные;
			ЗначениеПоказателя = ЗначениеПоказателя
			                   + ПоказательОтчета(ДанныеЛиста, "П000200001003");
		КонецЦикла;
		
		НоваяСтрока = ТаблицаПоказателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
		НоваяСтрока.Показатель = "ДоходыОтРеализации";
		НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
		
		ЗначениеПоказателя = 0;
		
		Для Каждого Лист Из СведенияОтчета.ДанныеМногостраничныхРазделов.Лист02 Цикл
			ДанныеЛиста = Лист.Данные;
			ЗначениеПоказателя = ЗначениеПоказателя
			                   + ПоказательОтчета(ДанныеЛиста, "П000200002003");
		КонецЦикла;
		
		НоваяСтрока = ТаблицаПоказателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
		НоваяСтрока.Показатель = "ВнереализационныеДоходы";
		НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
		
	Иначе
		
		ЗначениеПоказателя = 0;
		
		Для Каждого Лист Из СведенияОтчета.ДанныеМногостраничныхРазделов.Лист02 Цикл
			ДанныеЛиста = Лист.Данные;
			ЗначениеПоказателя = ЗначениеПоказателя
			                   + ПоказательОтчета(ДанныеЛиста, "П002000001003");
		КонецЦикла;
		
		НоваяСтрока = ТаблицаПоказателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
		НоваяСтрока.Показатель = "ДоходыОтРеализации";
		НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
		
		ЗначениеПоказателя = 0;
		
		Для Каждого Лист Из СведенияОтчета.ДанныеМногостраничныхРазделов.Лист02 Цикл
			ДанныеЛиста = Лист.Данные;
			ЗначениеПоказателя = ЗначениеПоказателя
			                   + ПоказательОтчета(ДанныеЛиста, "П002000002003");
		КонецЦикла;
		
		НоваяСтрока = ТаблицаПоказателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
		НоваяСтрока.Показатель = "ВнереализационныеДоходы";
		НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВставитьПоказатели_НДС(ТаблицаПоказателей, ОписаниеОтчета)
	
	СведенияОтчета = ОписаниеОтчета.РегламентированныйОтчет.ДанныеОтчета.Получить();
	
	Раздел3 = СведенияОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел3;
		
	// 18%
	ЗначениеПоказателя = ПоказательОтчета(Раздел3, "П000300001003");
	НоваяСтрока = ТаблицаПоказателей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
	НоваяСтрока.Показатель = "Выручка18";
	НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
	
	// 10%
	ЗначениеПоказателя = ПоказательОтчета(Раздел3, "П000300002003");
	НоваяСтрока = ТаблицаПоказателей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
	НоваяСтрока.Показатель = "Выручка10";
	НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
	
	Раздел4 = СведенияОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел4;
		
	Если ОписаниеОтчета.ВыбраннаяФорма = "ФормаОтчета2017Кв1" Тогда
		// 10%
		ЗначениеПоказателя = ПоказательОтчета(Раздел4, "П0004М1002003_1");
		НоваяСтрока = ТаблицаПоказателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
		НоваяСтрока.Показатель = "РеализацияНаЭкспорт";
		НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
		
	Иначе
		
		// 10%
		ЗначениеПоказателя = ПоказательОтчета(Раздел4, "П000400002003_1");
		НоваяСтрока = ТаблицаПоказателей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеОтчета);
		НоваяСтрока.Показатель = "РеализацияНаЭкспорт";
		НоваяСтрока.ЗначениеПоказателя = ЗначениеПоказателя;
	КонецЕсли;
КонецПроцедуры

Функция ПоказательОтчета(ИсточникСведений, ИмяПоказателя)
	
	ЗначениеПоказателя = 0;
	
	Если ТипЗнч(ИсточникСведений) = Тип("Структура") Тогда
		Если ИсточникСведений.Свойство(ИмяПоказателя) Тогда
			ЗначениеПоказателя = ИсточникСведений[ИмяПоказателя];
		КонецЕсли;
		
	Иначе
		ВызватьИсключение "Попытка получить значение показателя, сохраненного в неподдерживаемом типе данных";
		
	КонецЕсли;
	
	Возврат ЗначениеПоказателя;
	
КонецФункции

Процедура ДополнитьПоказателиУчетнымиДанными(Организация, МассивСубконтоПДР, Показатели, Периоды)

	Для Каждого СтрокаПериода Из Периоды Цикл
		
		ДополнитьПоказателиУчетнымиДаннымиНеподтвержденныйНДС(Организация, Показатели, СтрокаПериода);
		
		Если СтрокаПериода.Накопительный Тогда
			Продолжить;
		КонецЕсли;
		
		ДополнитьПоказателиУчетнымиДаннымиВозвратПоставщику(Организация, Показатели, СтрокаПериода);
		ДополнитьПоказателиУчетнымиДаннымиВозвратОтПокупателя(Организация, Показатели, СтрокаПериода);
		ДополнитьПоказателиУчетнымиДаннымиВнереализационныеДоходыНеОблагаемыеНДС(Организация, Показатели, МассивСубконтоПДР, СтрокаПериода);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДополнитьПоказателиУчетнымиДаннымиВозвратПоставщику(Организация, Показатели, СтрокаПериода)
	
	СтрокаПоказателя = Показатели.Добавить();
	СтрокаПоказателя.ИсточникОтчета = "РазрешенныеРазницы";
	СтрокаПоказателя.Показатель = "ВозвратПоставщику";
	СтрокаПоказателя.ДатаОтчета = СтрокаПериода.ДатаОтчета;
	СтрокаПоказателя.ДатаОкончания = СтрокаПериода.КонецПериода;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачалоПериода", СтрокаПериода.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Новый Граница(КонецДня(СтрокаПериода.КонецПериода), ВидГраницы.Включая));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	-НДСЗаписиКнигиПродажОбороты.СуммаБезНДСОборот КАК Сумма
	|ИЗ
	|	РегистрНакопления.НДСЗаписиКнигиПродаж.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Регистратор,
	|			Организация = &Организация
	|				И СчетФактура ССЫЛКА Документ.ВозвратТоваровПоставщику) КАК НДСЗаписиКнигиПродажОбороты";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтрокаПоказателя.ЗначениеПоказателя = Выборка.Сумма;
	КонецЕсли;

КонецПроцедуры

Процедура ДополнитьПоказателиУчетнымиДаннымиВозвратОтПокупателя(Организация, Показатели, СтрокаПериода)
	
	СтрокаПоказателя = Показатели.Добавить();
	СтрокаПоказателя.ИсточникОтчета = "РазрешенныеРазницы";
	СтрокаПоказателя.Показатель = "ВозвратОтПокупателя";
	СтрокаПоказателя.ДатаОтчета = СтрокаПериода.ДатаОтчета;
	СтрокаПоказателя.ДатаОкончания = СтрокаПериода.КонецПериода;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачалоПериода", СтрокаПериода.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Новый Граница(КонецДня(СтрокаПериода.КонецПериода), ВидГраницы.Включая));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	-НДСЗаписиКнигиПокупокОбороты.СуммаБезНДСОборот КАК Сумма
	|ИЗ
	|	РегистрНакопления.НДСЗаписиКнигиПокупок.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Регистратор,
	|			Организация = &Организация
	|				И ВидЦенности = ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.Возврат)) КАК НДСЗаписиКнигиПокупокОбороты";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтрокаПоказателя.ЗначениеПоказателя = Выборка.Сумма;
	КонецЕсли;

КонецПроцедуры

Процедура ДополнитьПоказателиУчетнымиДаннымиВнереализационныеДоходыНеОблагаемыеНДС(Организация, Показатели, МассивСубконтоПДР, СтрокаПериода)
	
	СтрокаПоказателя = Показатели.Добавить();
	СтрокаПоказателя.ИсточникОтчета = "РазрешенныеРазницы";
	СтрокаПоказателя.Показатель = "ВнерелизационныеДоходыНеОблагаемыеНДС";
	СтрокаПоказателя.ДатаОтчета = СтрокаПериода.ДатаОтчета;
	СтрокаПоказателя.ДатаОкончания = СтрокаПериода.КонецПериода;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачалоПериода", СтрокаПериода.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Новый Граница(КонецДня(СтрокаПериода.КонецПериода), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Счета9101", БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.ПрочиеДоходы));
	Запрос.УстановитьПараметр("МассивСубконто", МассивСубконтоПДР.ВыгрузитьЗначения());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	-ХозрасчетныйОбороты.СуммаНУОборот КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Счет В (&Счета9101),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы),
	|			Организация = &Организация
	|				И Субконто1 В (&МассивСубконто),
	|			,
	|			) КАК ХозрасчетныйОбороты";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтрокаПоказателя.ЗначениеПоказателя = Выборка.Сумма;
	КонецЕсли;

КонецПроцедуры

Процедура ДополнитьПоказателиУчетнымиДаннымиНеподтвержденныйНДС(Организация, Показатели, СтрокаПериода)
	
	Если СтрокаПериода.Накопительный Тогда
		СтрокаПоказателя = Показатели.Добавить();
		СтрокаПоказателя.ИсточникОтчета = "РазрешенныеРазницы";
		СтрокаПоказателя.Показатель = "НеподтвержденныйНДСОстатки";
		СтрокаПоказателя.ДатаОтчета = СтрокаПериода.ДатаОтчета;
		СтрокаПоказателя.ДатаОкончания = СтрокаПериода.ДатаОтчета;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("Период", Новый Граница(КонецДня(СтрокаПериода.КонецПериода), ВидГраницы.Включая));
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НДСРеализация0Остатки.СуммаБезНДСОстаток КАК Сумма
		|ИЗ
		|	РегистрНакопления.НДСРеализация0.Остатки(
		|			&Период,
		|			Организация = &Организация
		|				И Состояние <> ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ПодтвержденаРеализация0)) КАК НДСРеализация0Остатки";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			СтрокаПоказателя.ЗначениеПоказателя = Выборка.Сумма;
		КонецЕсли;
	Иначе
		СтрокаПоказателя = Показатели.Добавить();
		СтрокаПоказателя.ИсточникОтчета = "РазрешенныеРазницы";
		СтрокаПоказателя.Показатель = "НеподтвержденныйНДСОбороты";
		СтрокаПоказателя.ДатаОтчета = СтрокаПериода.ДатаОтчета;
		СтрокаПоказателя.ДатаНачала = СтрокаПериода.НачалоПериода;
		СтрокаПоказателя.ДатаОкончания = СтрокаПериода.КонецПериода;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(СтрокаПериода.НачалоПериода));
		Запрос.УстановитьПараметр("КонецПериода", Новый Граница(КонецДня(СтрокаПериода.КонецПериода), ВидГраницы.Включая));
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НДСРеализация0Обороты.СуммаБезНДСОборот КАК Сумма
		|ИЗ
		|	РегистрНакопления.НДСРеализация0.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Организация = &Организация
		|				И Состояние <> ЗНАЧЕНИЕ(Перечисление.НДССостоянияРеализация0.ПодтвержденаРеализация0)) КАК НДСРеализация0Обороты";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			СтрокаПоказателя.ЗначениеПоказателя = Выборка.Сумма;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция НовыйПериоды(Знач Период)
	
	Периоды = Новый ТаблицаЗначений;
	Периоды.Колонки.Добавить("ИмяПериода", ОбщегоНазначения.ОписаниеТипаСтрока(20));
	Периоды.Колонки.Добавить("ИмяКолонки", ОбщегоНазначения.ОписаниеТипаСтрока(20));
	Периоды.Колонки.Добавить("ДатаОтчета", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Периоды.Колонки.Добавить("НачалоПериода", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Периоды.Колонки.Добавить("КонецПериода", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Периоды.Колонки.Добавить("Накопительный", Новый ОписаниеТипов("Булево"));
	Период = КонецКвартала(Период);
	
	НачалоГода = НачалоГода(Период);
	
	Для НомерКвартала = 1 По 4 Цикл
		Квартал = КонецКвартала(ДобавитьМесяц(НачалоГода, 3 * НомерКвартала)-1);
		Если Квартал <= Период Тогда
			ИмяПериода = СтрШаблон("%1 квартал", НомерКвартала);
			ИмяКолонки = СтрШаблон("Квартал%1", НомерКвартала);
			СтрокаПериода = Периоды.Добавить();
			СтрокаПериода.ИмяПериода = ИмяПериода;
			СтрокаПериода.ИмяКолонки = ИмяКолонки;
			СтрокаПериода.ДатаОтчета = Квартал;
			СтрокаПериода.НачалоПериода = НачалоКвартала(Квартал);
			СтрокаПериода.КонецПериода  = КонецКвартала(Квартал);
		Иначе
			Прервать;
		КонецЕсли;
		Если НомерКвартала = 2 Тогда
			СтрокаПериода = Периоды.Добавить();
			СтрокаПериода.ИмяПериода = "Полугодие";
			СтрокаПериода.ИмяКолонки = "Полугодие";
			СтрокаПериода.ДатаОтчета = Квартал;
			СтрокаПериода.Накопительный = Истина;
		ИначеЕсли НомерКвартала = 3 Тогда
			СтрокаПериода = Периоды.Добавить();
			СтрокаПериода.ИмяПериода = "9 месяцев";
			СтрокаПериода.ИмяКолонки = "Месяцев9";
			СтрокаПериода.ДатаОтчета = Квартал;
			СтрокаПериода.Накопительный = Истина;
		ИначеЕсли НомерКвартала = 4 Тогда
			СтрокаПериода = Периоды.Добавить();
			СтрокаПериода.ИмяПериода = "Год";
			СтрокаПериода.ИмяКолонки = "Год";
			СтрокаПериода.ДатаОтчета = Квартал;
			СтрокаПериода.Накопительный = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Периоды;
	
КонецФункции

#КонецОбласти