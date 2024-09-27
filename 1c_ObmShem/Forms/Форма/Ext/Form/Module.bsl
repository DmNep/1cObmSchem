﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Версия 
	ВерсияОбработки = "v.0.03 21-09-2024";  
	
	// Настройки соединения с сервером
	СерверРендеринга = "www.plantuml.com";
	РесурсСервера = "/plantuml/png/";
	ТаймаутСоединения = 20000;
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

Процедура УстановитьВидимостьЭлементов()
	
	Если ПолныйИнтерфейс Тогда
		Элементы.БазыКомментСЛева.Видимость   = Истина;
		Элементы.БазыИконка.Видимость         = Истина;
		Элементы.ГруппаСхема.Видимость		  = Истина; 
		Элементы.ЗагрузитьИзТабДок.Видимость  = Истина;
		Элементы.ОбменыКомментСЛева.Видимость = Истина;
		Элементы.ОбменыТипЛинии.Видимость     = Истина;
		Элементы.ОбменыТолщинаЛинии.Видимость = Истина;
		Элементы.ОбменыЦветЛинии.Видимость    = Истина;
		Элементы.ОбменыДвусторонний.Видимость = Истина;
		Элементы.Настройки.Видимость          = Истина;
	Иначе
		Элементы.БазыКомментСЛева.Видимость   = Ложь;
		Элементы.БазыИконка.Видимость         = Ложь;
		Элементы.ГруппаСхема.Видимость		  = Ложь;
		Элементы.ЗагрузитьИзТабДок.Видимость  = Ложь;
		Элементы.ОбменыКомментСЛева.Видимость = Ложь;
		Элементы.ОбменыТипЛинии.Видимость     = Ложь;
		Элементы.ОбменыТолщинаЛинии.Видимость = Ложь;
		Элементы.ОбменыЦветЛинии.Видимость    = Ложь;
		Элементы.ОбменыДвусторонний.Видимость = Ложь;
		Элементы.Настройки.Видимость          = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолныйИнтерфесйПриИзменении(Элемент)

	УстановитьВидимостьЭлементов();

	Если ЗначениеЗаполнено(Объект.Базы) Тогда
		Если ЗначениеЗаполнено(Объект.Обмены) Тогда
			СформироватьСхемуНаКлиенте();		
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БазыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	СоздатьСпискиВыбора();
КонецПроцедуры 

&НаКлиенте
Процедура СоздатьСпискиВыбора()

	СписокВыбора = Новый Массив;
	Для Каждого Строка Из Объект.Базы Цикл
		//Пропускаем пустые строки
		Если Не ЗначениеЗаполнено(Строка.База) Тогда
			Продолжить;		
		КонецЕсли;
		СписокВыбора.Добавить(Строка.База);
	КонецЦикла;
	ЭтаФорма.Элементы.ОбменыБазаИсточник.СписокВыбора.ЗагрузитьЗначения(СписокВыбора);	
	ЭтаФорма.Элементы.ОбменыБазаПриемник.СписокВыбора.ЗагрузитьЗначения(СписокВыбора);	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСхему(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Базы) Тогда
		Если Не ЗначениеЗаполнено(Объект.Обмены) Тогда
			Сообщить("Заполните ТЧ Базы и ТЧ Обмены");
			Возврат;
		КонецЕсли;
	КонецЕсли; 

	СформироватьСхемуНаКлиенте();
	
КонецПроцедуры  

&НаКлиенте
Процедура СформироватьСхемуНаКлиенте()
	
	ОчиститьПустыеСтрокиВТЧ();
	СформироватьСхемуНаСервере();
	
КонецПроцедуры  



Процедура ОчиститьПустыеСтрокиВТЧ()

	// Очищаем пустыен строки ТЧ Базы, чтобы избежать ишибки по plantUML
	ПустыеСтрокиБаза = Объект.Базы.НайтиСтроки(Новый Структура("База", "")); 
	Для Каждого СтрокаБазы Из ПустыеСтрокиБаза Цикл
		Объект.Базы.Удалить(СтрокаБазы);	
	КонецЦикла;
	
	// Очищаем пустыен строки ТЧ Обмены, чтобы избежать ишибки по plantUML
 	ПустыеСтрокиБаза = Объект.Обмены.НайтиСтроки(Новый Структура("Наименование, Разделитель", "", Ложь)); 
	Для Каждого СтрокаОбмены Из ПустыеСтрокиБаза Цикл
		Объект.Обмены.Удалить(СтрокаОбмены);	
	КонецЦикла;

КонецПроцедуры

Процедура СформироватьСхемуНаСервере()

	СхемаPlantUML = СоздатьСхемуPlantUML();
	СгенерироватьНаСервере(СхемаPlantUML);

КонецПроцедуры 

Функция СоздатьСхемуPlantUML()
	
	Индекс = 0;
	
	//Инициализировать ТЗ внутренних обозначений объектов на схеме
	КС = Новый КвалификаторыСтроки(0);
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив, ,КС);
	Массив.Очистить();
	
	ТЗОбозначения = Новый ТаблицаЗначений;
	ТЗОбозначения.Колонки.Добавить("Наименование", ОписаниеТиповС);
	ТЗОбозначения.Колонки.Добавить("Обозначение",  ОписаниеТиповС);
	
	Схема = ""; 
	
	// Инициализтруем схему
	Схема = Схема + "@startuml" + Символы.ПС;
	Схема = Схема + Символы.ПС;
	
	// Верхний комментарий в схеме
	Схема = Схема + "'Создано обработкой 1c_ObmSchem, " + ТекущаяДатаСеанса() + Символы.ПС;
	Схема = Схема + "'Created by processing 1c_ObmSchem, " + ТекущаяДатаСеанса() + Символы.ПС;
	Схема = Схема + "'" + ВерсияОбработки + Символы.ПС;
	Схема = Схема + "'GitHub: github.com/DmNep/1cObmSchem" + Символы.ПС;
	Схема = Схема + Символы.ПС;
	
	// Задаем заголовок 
	Схема = Схема + "title " + ?(ЗначениеЗаполнено(ЗаголовокСхемы), ЗаголовокСхемы + Символы.ПС, "Схема обменов" + Символы.ПС);
	Схема = Схема + Символы.ПС;
	
	// Создаем базы
	Для Каждого СтрокаБазы Из Объект.Базы Цикл
		Если СтрокаБазы.Иконка = "База" Тогда
			ИконкаБазы = "database"
		ИначеЕсли СтрокаБазы.Иконка = "Человек" Тогда
			ИконкаБазы = "actor"
		ИначеЕсли СтрокаБазы.Иконка = "Коллекция" Тогда
			ИконкаБазы = "collections"
		Иначе
			ИконкаБазы = "database"
		КонецЕсли;
		Схема = Схема +	ИконкаБазы + " """ + СтрокаБазы.База + """ as db" + Индекс + Символы.ПС;
		НовОбозначение = ТЗОбозначения.Добавить();
		НовОбозначение.Наименование = СтрокаБазы.База;
		НовОбозначение.Обозначение = "db" + Индекс;
		Если ЗначениеЗаполнено(СтрокаБазы.Комментарий) Тогда
			СтрокаМассив = СтрРазделить(СтрокаБазы.Комментарий, "|");
			СтрокаКомментарий = "";
			Для Каждого ЭлементМассива Из СтрокаМассив Цикл
				СтрокаКомментарий = СтрокаКомментарий + ЭлементМассива + Символы.ПС;	
			КонецЦикла;
			Если СтрокаБазы.КомментСЛева Тогда
				ОбозначениеКомментария = "hnote left of db";
			Иначе	
			    ОбозначениеКомментария = "hnote right of db";
			КонецЕсли;
 			Схема = Схема + ОбозначениеКомментария + Индекс + Символы.ПС + СтрокаКомментарий + "end note" + Символы.ПС; 
		КонецЕсли;
		Индекс = Индекс + 1; 
	КонецЦикла;
	Схема = Схема + Символы.ПС;
	
	// Создаем обмены
	Для Каждого СтрокаОбмены Из Объект.Обмены Цикл
		
		// Разделитель
		Если ЗначениеЗаполнено(СтрокаОбмены.Наименование)  
			 И Не ЗначениеЗаполнено(СтрокаОбмены.БазаИсточник) 
			 И Не ЗначениеЗаполнено(СтрокаОбмены.БазаПриемник) Тогда
			Схема = Схема + "== " + СтрокаОбмены.Наименование + " ==" + Символы.ПС;
			Продолжить;
		КонецЕсли;

		// Защита от коллизии с пробелом в наименовании
		Если Не ЗначениеЗаполнено(СтрокаОбмены.БазаИсточник) И Не ЗначениеЗаполнено(СтрокаОбмены.БазаПриемник) Тогда
			Продолжить;
		КонецЕсли;
		
		// Находим обозначения 
		ОтборСвязьОт = Новый Структура();
		ОтборСвязьОт.Вставить("Наименование", СтрокаОбмены.БазаИсточник);
		БазаИсточник = ТЗОбозначения.НайтиСтроки(ОтборСвязьОт);
		ОтборСвязьК = Новый Структура();
		ОтборСвязьК.Вставить("Наименование", СтрокаОбмены.БазаПриемник);
		БазаПриемник = ТЗОбозначения.НайтиСтроки(ОтборСвязьК);
		
		// Отрисовываем возвраты и вызовы
		Схема = Схема + "skinparam ArrowThickness " + 
				?(ЗначениеЗаполнено(СтрокаОбмены.ТолщинаЛинии), СтрокаОбмены.ТолщинаЛинии, 1) + Символы.ПС;	

		// БазаИсточник
		Если БазаИсточник.Количество() > 0 Тогда
			БИсточник = БазаИсточник[0].Обозначение;
		Иначе
			БИсточник = "";
		КонецЕсли;
		
		// БазаПриемник
		Если БазаПриемник.Количество() > 0 Тогда
			БПриемник = БазаПриемник[0].Обозначение;
		Иначе
		    БПриемник = "";
		КонецЕсли;
		
		// Формируем обмен
		Схема = Схема + БИсточник + ?(СтрокаОбмены.Двусторонний, "<" ,"") + ?(СтрокаОбмены.ТипЛинии = "Пунктирная", "-", "") 
				+ "-" + ?(ЗначениеЗаполнено(СтрокаОбмены.ЦветЛинии), "[#" + СтрокаОбмены.ЦветЛинии + "]", "") + ">" 
				+ БПриемник + " : " + СтрокаОбмены.Наименование + Символы.ПС;
				
		Если ЗначениеЗаполнено(СтрокаОбмены.Комментарий) Тогда
			СтрокаМассив = СтрРазделить(СтрокаОбмены.Комментарий, "|");
			СтрокаКомментарий = "";
			Для Каждого ЭлементМассива Из СтрокаМассив Цикл
				СтрокаКомментарий = СтрокаКомментарий + ЭлементМассива + Символы.ПС;	
			КонецЦикла;
			Если СтрокаОбмены.КомментСЛева Тогда
				ОбозначениеКомментария = "note left ";
			Иначе	
			    ОбозначениеКомментария = "note right ";
			КонецЕсли;
			Схема = Схема + ОбозначениеКомментария + Символы.ПС + СтрокаКомментарий + "end note" + Символы.ПС;		
		КонецЕсли;
		
	КонецЦикла;
	Схема = Схема + Символы.ПС;
	
	// Вставить нижний футер в схему
	Схема = Схема + "footer 1c_ObmSchem" + Символы.ПС;	
	Схема = Схема + Символы.ПС;

	// Завершаем схему
	Схема = Схема + "@enduml"; 
	
	Возврат Схема;
	
КонецФункции 

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Базы) Тогда
		Если Не ЗначениеЗаполнено(Объект.Обмены) Тогда
			Сообщить("Заполните ТЧ Базы и ТЧ Обмены");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Режим      = РежимДиалогаВыбораФайла.Открытие;
	ПутьКФайлу = ПолучитьПутьКФайлуXML(Режим);
	ЗаписьВ_XML(ПутьКФайлу);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПутьКФайлуXML(Режим)
	
	Диалог = Новый ДиалогВыбораФайла(Режим);
	Диалог.Заголовок = "Выбрать"; 
	Диалог.Фильтр    = "XML (*.xml)|*.xml"; 
	Диалог.МножественныйВыбор = Ложь;
	Если Диалог.Выбрать() Тогда
		ПутьКФайлу = Диалог.ПолноеИмяФайла;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПутьКФайлу ; 
	
КонецФункции  

&НаКлиенте
Функция ПолучитьПутьКФайлуPlantUML(Режим)
	
	Диалог = Новый ДиалогВыбораФайла(Режим);
	Диалог.Заголовок = "Выбрать"; 
	Диалог.Фильтр = "PlantUML (*.puml)|*.puml"; 
	Диалог.МножественныйВыбор = Ложь;
	Если Диалог.Выбрать() Тогда
		ПутьКФайлу = Диалог.ПолноеИмяФайла;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПутьКФайлу ; 
	
КонецФункции 

&НаКлиенте
Функция ПолучитьПутьКФайлуКартинки(Режим)
	
	Диалог = Новый ДиалогВыбораФайла(Режим);
	Диалог.Заголовок = "Выбрать"; 
	Диалог.Фильтр = "png (*.png)|*.png"; 
	Диалог.МножественныйВыбор = Ложь;
	Если Диалог.Выбрать() Тогда
		ПутьКФайлу = Диалог.ПолноеИмяФайла;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПутьКФайлу ; 
	
КонецФункции
   
&НаКлиенте
Процедура ЗаписьВ_XML(ПутьКФайлу)
	
	ТекущаяДатаСеанса = ПолучитьТекущуюДату();
	ТекстКомментария = "";
	ТекстКомментария = ТекстКомментария + "'Создано обработкой 1c_ObmSchem, " + ТекущаяДатаСеанса + Символы.ПС;
	ТекстКомментария = ТекстКомментария + "'Created by processing 1c_ObmSchem, " + ТекущаяДатаСеанса + Символы.ПС;
	ТекстКомментария = ТекстКомментария + "'v.0.03  21-09-2024" + Символы.ПС;
	ТекстКомментария = ТекстКомментария + "'GitHub: github.com/DmNep/1cObmSchem" + Символы.ПС;
	
	ЗаписьXML = Новый ЗаписьXML;
	
	//Открываем файл для записи, указываем кодировку
	ЗаписьXML.ОткрытьФайл(ПутьКФайлу, "UTF-8"); 

	// Записываем объявление XML
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьКомментарий(ТекстКомментария);

	// Начало головного элемента
	ЗаписьXML.ЗаписатьНачалоЭлемента("СхемаОбменов"); 
	ЗаписьXML.ЗаписатьАтрибут("ЗаголовокСхемы", Строка(ЗаголовокСхемы));   
	Для Каждого СтрокаБазы Из Объект.Базы Цикл

		// Начало элемента Базы
		ЗаписьXML.ЗаписатьНачалоЭлемента("Базы");
		ЗаписьXML.ЗаписатьАтрибут("База",        Строка(СтрокаБазы.База));   
		ЗаписьXML.ЗаписатьАтрибут("Комментарий", Строка(СтрокаБазы.Комментарий));   
		ЗаписьXML.ЗаписатьАтрибут("КомментСЛева",Строка(СтрокаБазы.КомментСЛева));   
		ЗаписьXML.ЗаписатьАтрибут("Иконка",      Строка(СтрокаБазы.Иконка));   
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Конец элемента Базы
	КонецЦикла;
	Для Каждого СтрокаОбмены Из Объект.Обмены Цикл

		// Начало элемента Обмены
		ЗаписьXML.ЗаписатьНачалоЭлемента("Обмены"); 
		ЗаписьXML.ЗаписатьАтрибут("БазаИсточник",Строка(СтрокаОбмены.БазаИсточник));   
		ЗаписьXML.ЗаписатьАтрибут("Наименование",Строка(СтрокаОбмены.Наименование));   
		ЗаписьXML.ЗаписатьАтрибут("БазаПриемник",Строка(СтрокаОбмены.БазаПриемник));   
		ЗаписьXML.ЗаписатьАтрибут("Комментарий", Строка(СтрокаОбмены.Комментарий));   
		ЗаписьXML.ЗаписатьАтрибут("КомментСЛева",Строка(СтрокаОбмены.КомментСЛева));   

		//ЗаписьXML.ЗаписатьАтрибут("Разделитель", Строка(СтрокаОбмены.Разделитель));   
		ЗаписьXML.ЗаписатьАтрибут("Двусторонний",Строка(СтрокаОбмены.Двусторонний));   
		ЗаписьXML.ЗаписатьАтрибут("ТолщинаЛинии",Строка(СтрокаОбмены.ТолщинаЛинии));   
		ЗаписьXML.ЗаписатьАтрибут("ЦветЛинии",   Строка(СтрокаОбмены.ЦветЛинии));   
		ЗаписьXML.ЗаписатьАтрибут("ТипЛинии",    Строка(СтрокаОбмены.ТипЛинии));   
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Конец элемента Обмены
	КонецЦикла;

	// Конец головного элемента
	ЗаписьXML.ЗаписатьКонецЭлемента(); 
	
	ПоказатьОповещениеПользователя("Уведомление", , "Файл выгружен!", БиблиотекаКартинок.Успешно32); 
	
КонецПроцедуры   

&НаКлиенте
Процедура ЗаписьВ_PlantUML(ПутьКФайлу)
	
	Текст = Новый ЗаписьТекста(ПутьКФайлу, КодировкаТекста.UTF8);
	Текст.ЗаписатьСтроку(Схема);
	Текст.Закрыть();	
	
	ПоказатьОповещениеПользователя("Уведомление", , "Файл выгружен!", БиблиотекаКартинок.Успешно32); 
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаписьВ_Картинку(ПутьКФайлу)

	Изображение = Новый Картинка(ПолучитьИзВременногоХранилища(РезультатОбработки));
	Изображение.Записать(ПутьКФайлу);
	ПоказатьОповещениеПользователя("Уведомление", , "Файл выгружен!", БиблиотекаКартинок.Успешно32); 
	
КонецПроцедуры 

Функция ПолучитьТекущуюДату()
 	Возврат ТекущаяДатаСеанса();	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьНастройки(Команда)
	
	// ВЕРНУТЬ
	//Отмена = Ложь; 
	//Если Объект.Базы.Количество() > 0 Или Объект.Обмены.Количество() > 0 Тогда
	//	Режим = РежимДиалогаВопрос.ДаНет;
	//	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект, Параметры);
	//	ПоказатьВопрос(Оповещение, НСтр("Форма перед загрузкой будет очищена, продолжить?"), Режим, 0);
	//КонецЕсли;
	
	Объект.Базы.Очистить();
	Объект.Обмены.Очистить();
	Чтение_XML();
	
	СформироватьСхемуНаСервере();
	
КонецПроцедуры 

&НаКлиенте
Процедура Чтение_XML()
	
	ПутьКФайлу =  ПолучитьПутьКФайлуXML(РежимДиалогаВыбораФайла.Открытие);
	//Если не выбран путь к фалу прерываем операцию
	Если ПутьКФайлу = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;	
	ЧтениеXML.ОткрытьФайл(ПутьКФайлу);  //Открываем файл
	
	//Цикл по структуре
	Пока ЧтениеXML.Прочитать() Цикл  
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  //Определяем начало элемента
			Если ЧтениеXML.Имя = "ЗаголовокСхемы" Тогда
				ЗаголовокСхемы = ЧтениеXML.ЗначениеАтрибута("ЗаголовокСхемы");
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "Базы" Тогда   
				НоваяСтрока = Объект.Базы.Добавить();
				НоваяСтрока.База         = ЧтениеXML.ЗначениеАтрибута("База");
				НоваяСтрока.Комментарий  = ЧтениеXML.ЗначениеАтрибута("Комментарий");
				НоваяСтрока.КомментСЛева = ЧтениеXML.ЗначениеАтрибута("КомментСЛева");
				НоваяСтрока.Иконка       = ЧтениеXML.ЗначениеАтрибута("Иконка");
			КонецЕсли;
			Если ЧтениеXML.Имя = "Обмены" Тогда
				НоваяСтрока = Объект.Обмены.Добавить();
				НоваяСтрока.БазаИсточник = ЧтениеXML.ЗначениеАтрибута("БазаИсточник");
				НоваяСтрока.Наименование = ЧтениеXML.ЗначениеАтрибута("Наименование");
				НоваяСтрока.БазаПриемник = ЧтениеXML.ЗначениеАтрибута("БазаПриемник");
				НоваяСтрока.Двусторонний = Булево(ЧтениеXML.ЗначениеАтрибута("Двусторонний"));
				НоваяСтрока.Комментарий  = ЧтениеXML.ЗначениеАтрибута("Комментарий");
				НоваяСтрока.КомментСЛева = ЧтениеXML.ЗначениеАтрибута("КомментСЛева");
				НоваяСтрока.ТолщинаЛинии = Число(ЧтениеXML.ЗначениеАтрибута("ТолщинаЛинии"));
				НоваяСтрока.ЦветЛинии    = ЧтениеXML.ЗначениеАтрибута("ЦветЛинии");
				НоваяСтрока.ТипЛинии     = ЧтениеXML.ЗначениеАтрибута("ТипЛинии");
			КонецЕсли;
		КонецЕсли ;
	КонецЦикла;
	
	СоздатьСпискиВыбора();
	
	ПоказатьОповещениеПользователя("Уведомление", , "Файл загружен!", БиблиотекаКартинок.Успешно32); 
	
КонецПроцедуры

&НаСервере
Процедура СгенерироватьНаСервере(СхемаPlantUML)
	
	Результат = СгенерированноеИзображение(СхемаPlantUML, СерверРендеринга, РесурсСервера, ТаймаутСоединения);
	Если ЗначениеЗаполнено(Результат.АдресИзображения) Тогда
		РезультатОбработки = Результат.АдресИзображения; 
		// Меняет масштаб картинки на пропорциональный при формировании
		Элементы.РезультатОбработки.РазмерКартинки = РазмерКартинки.Пропорционально;
	КонецЕсли; 
	
КонецПроцедуры  

&НаСервере
Функция СгенерированноеИзображение(Данные, пСерверРендеринга, пРесурсСервера, пТаймаутСоединения)
	
	ДвоичныеДанныеСтроки = ПолучитьДвоичныеДанныеИзСтроки(Данные);	
	СжатыеДанные = СжатыеДанные(ДвоичныеДанныеСтроки);	
	Base64Строка = Base64Строка(СжатыеДанные);     
	ФорматPlantUML = ФорматPlantUML(Base64Строка);  
	Соединение = Новый HTTPСоединение(пСерверРендеринга, , , , , пТаймаутСоединения);
	ТекстЗапроса = пРесурсСервера + ФорматPlantUML;
	Запрос = Новый HTTPЗапрос(ТекстЗапроса);
	Ответ = Соединение.Получить(Запрос);
	// Ответ  не анализируется, дописать его анализ
	ДвоичныеДанныеКартинки = Ответ.ПолучитьТелоКакДвоичныеДанные();
	Результат = Новый Структура;
	Результат.Вставить("ОтветСервера", Ответ);
	Результат.Вставить("АдресИзображения", ПоместитьВоВременноеХранилище(ДвоичныеДанныеКартинки));
	Возврат Результат;
	
КонецФункции 

Функция СжатыеДанные(Данные) 
	
	ЧтениеДанных = Новый ЧтениеДанных(ЗаписатьZip(Данные));
	
	НачальноеСмещение = 14;
	ЧтениеДанных.Пропустить(НачальноеСмещение);
	CRC32 = ЧтениеДанных.ПрочитатьЦелое32();
	
	РазмерСжатыхДанных = ЧтениеДанных.ПрочитатьЦелое32();
	РазмерИсходныхДанных = ЧтениеДанных.ПрочитатьЦелое32();
	
	РазмерИмениФайла = ЧтениеДанных.ПрочитатьЦелое16();
	РазмерДополнительногоПоля = ЧтениеДанных.ПрочитатьЦелое16();
	ЧтениеДанных.Пропустить(РазмерИмениФайла + РазмерДополнительногоПоля);
	
	ПотокGZip = Новый ПотокВПамяти;
	ЗаписьДанных = Новый ЗаписьДанных(ПотокGZip);
	ЧтениеДанных.КопироватьВ(ЗаписьДанных, РазмерСжатыхДанных);
	
	Возврат ПотокGZip.ЗакрытьИПолучитьДвоичныеДанные();
	
КонецФункции 

Функция ФорматPlantUML(Данные)

	Результат = "";
	СтрокаИскомая	  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	СтрокаПодстановки = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_"; 
	Для Счетчик = 0 По СтрДлина(Данные) - 1 Цикл     
		ТекСимвол = Сред(Данные, счетчик + 1, 1);
		Поз = СтрНайти(СтрокаИскомая, ТекСимвол); 
		Если ТекСимвол = Символы.ПС ИЛИ ТекСимвол = Символы.ВК Тогда
			Продолжить;
		КонецЕсли;
		Если Поз > 0  Тогда
			Результат = Результат + Сред(СтрокаПодстановки, Поз, 1);
		Иначе
			Результат = Результат + ТекСимвол; 
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ЗаписатьZip(Данные)
	
	#Если МобильноеПриложениеСервер Тогда
		ВызватьИсключение(НСтр("ru = 'Работа с Zip-файлами в мобильной платформе не поддерживается'"));
	#Иначе
		ВременныйФайл = ПолучитьИмяВременногоФайла(".bin");
		Данные.Записать(ВременныйФайл);
		ПотокZip = Новый ПотокВПамяти;
		ЗаписьZip = Новый ЗаписьZipФайла(ПотокZip);
		ЗаписьZip.Добавить(ВременныйФайл);
		ЗаписьZip.Записать();
		УдалитьФайлы(ВременныйФайл);
		
		Возврат ПотокZip.ЗакрытьИПолучитьДвоичныеДанные();
	#КонецЕсли
	
КонецФункции     

&НаКлиенте
Процедура СохранитьСхемуPlantuml(Команда)
	
	Если Не ЗначениеЗаполнено(Схема) Тогда
		Сообщить("Сформируйте схему PlantUML");
		Возврат;
	КонецЕсли;
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ПутьКФайлу = ПолучитьПутьКФайлуPlantUML(Режим);
	ЗаписьВ_PlantUML(ПутьКФайлу); 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьГрафическуюСхему(Команда)

	Если Не ЗначениеЗаполнено(РезультатОбработки) Тогда
		Сообщить("Сформируйте схему");
		Возврат;
	КонецЕсли;
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ПутьКФайлу = ПолучитьПутьКФайлуКартинки(Режим);
	ЗаписьВ_Картинку(ПутьКФайлу);  
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТабДок(Команда)
	
	Объект.Базы.Очистить();
	Объект.Обмены.Очистить();
	Чтение_ТабДок();
	
	СформироватьСхемуНаСервере();
	
КонецПроцедуры   

&НаКлиенте
Процедура Чтение_ТабДок()
	
	ПутьКФайлу =  ПолучитьПутьКФайлуMXL(РежимДиалогаВыбораФайла.Открытие);
	//Если не выбран путь к фалу прерываем операцию
	Если ПутьКФайлу = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Двоичное = Новый ДвоичныеДанные(ПутьКФайлу);
	Адрес=ПоместитьВоВременноеХранилище(Двоичное, ЭтаФорма.УникальныйИдентификатор);
	ПрочитатьMXL_в_ТабДок(Адрес);
	
	СоздатьСпискиВыбора();
	
	ПоказатьОповещениеПользователя("Уведомление", , "Файл загружен!", БиблиотекаКартинок.Успешно32); 
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПутьКФайлуMXL(Режим)
	
	Диалог = Новый ДиалогВыбораФайла(Режим);
	Диалог.Заголовок = "Выбрать"; 
	Диалог.Фильтр = "MXL (*.mxl)|*.mxl"; 
	Диалог.МножественныйВыбор = Ложь;
	Если Диалог.Выбрать() Тогда
		ПутьКФайлу = Диалог.ПолноеИмяФайла;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПутьКФайлу ; 
	
КонецФункции  

&НаСервере
Процедура ПрочитатьMXL_в_ТабДок(Адрес)
	
	ТабДок  = Новый ТабличныйДокумент;
	ДД = ПолучитьИзВременногоХранилища(Адрес);
	ТабДок.Прочитать(ДД.ОткрытьПотокДляЧтения(), СпособЧтенияЗначенийТабличногоДокумента.Текст, ТипФайлаТабличногоДокумента.MXL);
	
	ПЗ = Новый ПостроительЗапроса;
	// Передаем ТЗ
	ПЗ.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТабДок.Область());
	ПЗ.ДобавлениеПредставлений = ТипДобавленияПредставлений.НеДобавлять;
	ПЗ.ЗаполнитьНастройки();
	ПЗ.Выполнить();
	ТЗ = ПЗ.Результат.Выгрузить();	

	// Формируем массив баз
	МассивБаз = Новый Массив;
	Для каждого СтрокаТЗ Из ТЗ Цикл
		
		// Переделать без Неопределено
		Если МассивБаз.Найти(СтрокаТЗ.Источник) = Неопределено Тогда 
			МассивБаз.Добавить(СтрокаТЗ.Источник);	
		КонецЕсли;	
		// Переделать без Неопределено
		Если МассивБаз.Найти(СтрокаТЗ.Приемник) = Неопределено Тогда 
			МассивБаз.Добавить(СтрокаТЗ.Приемник);	
		КонецЕсли;	
        		
	КонецЦикла;
	
	//Заполняем ТЧ Базы
	Если ЗначениеЗаполнено(МассивБаз) Тогда
		Для Каждого ЭлементМассив Из МассивБаз Цикл
			НоваяБаза = Объект.Базы.Добавить();
			НоваяБаза.База = ЭлементМассив;
		КонецЦикла;		
	КонецЕсли;
	
	//Заполняем ТЧ Обмены
	Для каждого СтрокаТЗ Из ТЗ Цикл
	
		Если Не ЗначениеЗаполнено(МассивБаз.Найти(СтрокаТЗ.Наименование)) Тогда
			НовыйОбмен = Объект.Обмены.Добавить();
			НовыйОбмен.БазаИсточник = СтрокаТЗ.Источник;
			НовыйОбмен.Наименование = СтрокаТЗ.Наименование;
			НовыйОбмен.БазаПриемник = СтрокаТЗ.Приемник;
		КонецЕсли;	
        		
	КонецЦикла;
	
КонецПроцедуры


