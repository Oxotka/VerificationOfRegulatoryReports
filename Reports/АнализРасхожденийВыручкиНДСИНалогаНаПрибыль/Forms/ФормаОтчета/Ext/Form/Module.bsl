﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьМассивСубконтоПДР();
	
	// В сервисе внешние отчеты подключаются с другим именем. Это уникальный идентификатор.
	// Поэтому сохраним имя отчета для дальнейшего использования.
	ПолноеИмяОтчета = РеквизитФормыВЗначение("Отчет").Метаданные().ПолноеИмя();
	
	Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	Период      = КонецКвартала(ТекущаяДатаСеанса());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	Период = КонецКвартала(Период);
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПоляТабличногоДокумент

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	
	Результат = СформироватьОтчетНаСервере();
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоГода(Период), КонецКвартала(Период));
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	
	ИмяФормыВыбораПериода = ПолноеИмяОтчета + ".Форма.ВыборПериодаНарастающимИтогом";
	ОткрытьФорму(ИмяФормыВыбораПериода, ПараметрыВыбора, Элементы.Период, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Настройка(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаЗавершение", ЭтотОбъект);
	ИмяФормыНастроек = ПолноеИмяОтчета + ".Форма.ФормаНастроек";

	ОткрытьФорму(ИмяФормыНастроек,
		Новый Структура("МассивСубконтоПДР", МассивСубконтоПДР),
		ЭтотОбъект,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация", Организация);
	ПараметрыОтчета.Вставить("МассивСубконтоПДР", МассивСубконтоПДР);
	ПараметрыОтчета.Вставить("Период", Период);
	
	Возврат РеквизитФормыВЗначение("Отчет").СформироватьОтчет(ПараметрыОтчета);
	
КонецФункции

&НаКлиенте
Процедура НастройкаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивСубконтоПДР = Результат;
	ЗаписатьРеквизитНеОблагаетсяНДС(МассивСубконтоПДР.ВыгрузитьЗначения());
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьМассивСубконтоПДР()
	
	МассивСубконто = Справочники.ПрочиеДоходыИРасходы.МассивСубконтоНеОблагаетсяНДС();
	Если МассивСубконто.Количество() = 0 Тогда
		ЗаполнитьМассивСубконтоПоУмолчанию();
	Иначе
		МассивСубконтоПДР.ЗагрузитьЗначения(МассивСубконто);
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьМассивСубконтоПоУмолчанию()
	
	МассивСубконто = Справочники.ПрочиеДоходыИРасходы.МассивСубконтоРазрешенныхПрочихДоходовИРасходов();
	МассивСубконтоПДР.ЗагрузитьЗначения(МассивСубконто);
	
	ЗаписатьРеквизитНеОблагаетсяНДС(МассивСубконто);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРеквизитНеОблагаетсяНДС(МассивСубконто)
	
	Справочники.ПрочиеДоходыИРасходы.ЗаписатьРеквизитНеОблагаетсяНДС(МассивСубконто);
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, Элементы.Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Период = КонецКвартала(РезультатВыбора.КонецПериода);
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
	ШаблонИмениФормы = ПолноеИмяОтчета + ".Форма.%1";

	Если ТипЗнч(Расшифровка) = Тип("Структура") И Расшифровка.Свойство("Имя") Тогда
		Если Расшифровка.Имя = "ДоходыОтРеализации" ИЛИ Расшифровка.Имя = "ВнереализационныеДоходы" ИЛИ Расшифровка.Имя = "ВыручкаПоПрочимОперациям" Тогда
			ОткрытьФорму(СтрШаблон(ШаблонИмениФормы, "ФормаАктуальныеДанные"), Расшифровка, ЭтотОбъект);
		КонецЕсли;
	ИначеЕсли Расшифровка = "ДекларацияПоНалогуНаПрибыль" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация", ЭтотОбъект.Организация);
		ПараметрыФормы.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Отчеты"));
		ПараметрыФормы.Вставить("ВидОтчета", "Декларация по налогу на прибыль");
		ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыФормы);
	ИначеЕсли Расшифровка = "ДекларацияПоНДС" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация", ЭтотОбъект.Организация);
		ПараметрыФормы.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Отчеты"));
		ПараметрыФормы.Вставить("ВидОтчета", "Декларация по НДС");
		ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыФормы);
	ИначеЕсли Расшифровка = "Разница" Тогда
		ОткрытьФорму(СтрШаблон(ШаблонИмениФормы, "ФормаРазница"), , ЭтотОбъект);
	ИначеЕсли Расшифровка = "ПодсказкаНеподтвержденныйНДС" Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Показатель", Расшифровка);
		ОткрытьФорму(СтрШаблон(ШаблонИмениФормы, "ФормаПодсказкиПоказателя"), СтруктураПараметров, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
