﻿#Область ПрограммныйИнтерфейс

// Возвращает массив прочих доходов и расходов с флагом НеОблагаетсяНДС.
//
// Возвращаемое значение:
//  - Массив - Массив элементов справочника ПрочиеДоходыИРасходы.
// 
Функция МассивСубконтоНеОблагаетсяНДС() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрочиеДоходыИРасходы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПрочиеДоходыИРасходы КАК ПрочиеДоходыИРасходы
	|ГДЕ
	|	ПрочиеДоходыИРасходы.Отчет_НеОблагаетсяНДС";
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Возвращает массив прочих доходов и расходов по умолчанию для установки флага НеОблагаетсяНДС.
//
// Возвращаемое значение:
//  - Массив - Массив элементов справочника ПрочиеДоходыИРасходы.
// 
Функция МассивСубконтоРазрешенныхПрочихДоходовИРасходов() Экспорт
	
	Запрос = Новый Запрос;
	МассивВидовПрочихДоходовИРасходов = Новый Массив;
	МассивВидовПрочихДоходовИРасходов.Добавить(Перечисления.ВидыПрочихДоходовИРасходов.КурсовыеРазницы);
	МассивВидовПрочихДоходовИРасходов.Добавить(Перечисления.ВидыПрочихДоходовИРасходов.КурсовыеРазницыПоРасчетамВУЕ);
	МассивВидовПрочихДоходовИРасходов.Добавить(Перечисления.ВидыПрочихДоходовИРасходов.ПроцентыКПолучениюУплате);

	Запрос.УстановитьПараметр("МассивВидовПрочихДоходовИРасходов", МассивВидовПрочихДоходовИРасходов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрочиеДоходыИРасходы.Ссылка
	|ИЗ
	|	Справочник.ПрочиеДоходыИРасходы КАК ПрочиеДоходыИРасходы
	|ГДЕ
	|	ПрочиеДоходыИРасходы.ВидПрочихДоходовИРасходов В(&МассивВидовПрочихДоходовИРасходов)";
	ТаблицаПрочихДоходовИРасходов = Запрос.Выполнить().Выгрузить();
	Возврат ТаблицаПрочихДоходовИРасходов.ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Процедура снимает флаг "Не облагается НДС" для субконто, которых нет в переданном и 
// устанавливает флаг для субконто, которые переданы в массиве.
//
// Параметры:
//  - Массив - Массив элементов справочника ПрочиеДоходыИРасходы.
//
Процедура ЗаписатьРеквизитНеОблагаетсяНДС(МассивСубконто) Экспорт
	
	ТекущийМассивСубконто = МассивСубконтоНеОблагаетсяНДС();
	
	// Снимем флаг "Не облагается НДС"
	МассивСубконтоСнятьНеОблагаетсяНДС = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ТекущийМассивСубконто, МассивСубконто);
	Для Каждого Субконто Из МассивСубконтоСнятьНеОблагаетсяНДС Цикл
		Объект = Субконто.ПолучитьОбъект();
		Объект.Отчет_НеОблагаетсяНДС = Ложь;
		Объект.Записать();
	КонецЦикла;
	
	// Установим флаг "Не облагается НДС"
	МассивСубконтоУстановитьНеОблагаетсяНДС = ОбщегоНазначенияКлиентСервер.РазностьМассивов(МассивСубконто, ТекущийМассивСубконто);
	Для Каждого Субконто Из МассивСубконтоУстановитьНеОблагаетсяНДС Цикл
		Объект = Субконто.ПолучитьОбъект();
		Объект.Отчет_НеОблагаетсяНДС = Истина;
		Объект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти