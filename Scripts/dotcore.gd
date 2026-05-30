extends Node
const arch = 2
const dotver = 1500
const ver = "r1"
var lang = "ru"
const table = {
	"[or]" : {
		"eng" : "or",
		"ru" : "или",
		"ua" : "чи",
		"cul" : "иле",
		"ial" : "лило"
		},
	"[not]" : {
		"eng" : "not",
		"ru" : "не",
		"ua" : "не",
		"cul" : "ни",
		"ial" : "ливы"
		},
	"[t]" : {
		"eng" : "to",
		"ru" : "к",
		"ua" : "до"
		},
	"[and]" : {
		"eng" : "and",
		"ru" : "и",
		"ua" : "та",
		"cul" : "и",
		"ial" : "хино"
		},
	"[join]" : {
		"eng" : "join",
		"ru" : "соединить",
		"ua" : "з'єднати"
		},
	"[rand]" : {
		"eng" : "random",
		"ru" : "рандом",
		"ua" : "рандом"
		},
	"[ad]" : {
		"eng" : "Add",
		"ru" : "Добавить",
		"ua" : "Додати"
		},
	"[roun]" : {
		"eng" : "round",
		"ru" : "целое",
		"ua" : "ціле"
		},
	"[great]" : {
		"eng" : "greater",
		"ru" : "большее",
		"ua" : "більше",
		"cul" : "больше блин",
		"ial" : "тапуля"
		},
	"[lessr]" : {
		"eng" : "lesser",
		"ru" : "меньшее",
		"ua" : "менше",
		"cul" : "в никуда",
		"ial" : "мимуля"
		},
	"[fal]" : {
		"eng" : "false",
		"ru" : "ложь",
		"ua" : "хиба"
		},
	"[tru]" : {
		"eng" : "True",
		"ru" : "Истина",
		"ua" : "Істина",
		"cul" : "Проверенный источник",
		"ial" : "Таща"
		},
	"[is]" : {
		"eng" : "is",
		"ru" : "это",
		"ua" : "це",
		"cul" : "чё это",
		"ial" : "земо"
		},
	"[from]" : {
		"eng" : "from",
		"ru" : "от",
		"ua" : "від"
		},
	"[fro]" : {
		"eng" : "from",
		"ru" : "из",
		"ua" : "з"
		},
	"[to]" : {
		"eng" : "to",
		"ru" : "до",
		"ua" : "до"
		},
	"[var]" : {
		"eng" : "variable",
		"ru" : "переменная",
		"ua" : "змінна"
		},
	"[varu]" : {
		"eng" : "variable",
		"ru" : "переменную",
		"ua" : "змінну"
		},
	"[list]" : {
		"eng" : "list",
		"ru" : "список",
		"ua" : "список"
		},
	"[listu]" : {
		"eng" : "list",
		"ru" : "списку",
		"ua" : "списку"
		},
	"[lista]" : {
		"eng" : "list",
		"ru" : "спискa",
		"ua" : "списку"
		},
	"[rev]" : {
		"eng" : "reverse",
		"ru" : "развернуть",
		"ua" : "обернути",
		"cul" : "вращать оёэоэёоэёоэоёоэёоэёоэёоэ",
		"ial" : "праверо"
		},
	"[text]" : {
		"eng" : "text",
		"ru" : "текст",
		"ua" : "текст"
		},
	"[texta]" : {
		"eng" : "text",
		"ru" : "текста",
		"ua" : "тексту"
		},
	"[in]" : {
		"eng" : "in",
		"ru" : "в",
		"ua" : "у",
		"cul" : "в",
		"ial" : "желк"
		},
	"[len]" : {
		"eng" : "length",
		"ru" : "длина",
		"ua" : "длина",
		"cul" : "угу, ща померяем , а ну кароч",
		"ial" : "тапера"
		},
	"[sys]" : {
		"eng" : "OS",
		"ru" : "система",
		"ua" : "система",
		"cul" : "паяльник",
		"ial" : "кудахтыр"
		},
	"[year]" : {
		"eng" : "year",
		"ru" : "год",
		"ua" : "рік",
		"cul" : "200 яиц",
		"ial" : "ерана"
		},
	"[month]" : {
		"eng" : "month",
		"ru" : "месяц",
		"ua" : "місяць",
		"cul" : "18 яиц",
		"ial" : "пордоло"
		},
	"[weekday]" : {
		"eng" : "weekday",
		"ru" : "день недели",
		"ua" : "день тижня",
		"cul" : "0.4 яйца от 4 яиц",
		"ial" : "шомена менане"
		},
	"[day]" : {
		"eng" : "day",
		"ru" : "день",
		"ua" : "день",
		"cul" : "0.4 яйца",
		"ial" : "менане"
		},
	"[hour]" : {
		"eng" : "hour",
		"ru" : "час",
		"ua" : "година",
		"cul" : "0.018 яйца",
		"ial" : "лирила"
		},
	"[minute]" : {
		"eng" : "minute",
		"ru" : "минута",
		"ua" : "хвилина",
		"cul" : "0.0003 яйца",
		"ial" : "тогодон"
		},
	"[second]" : {
		"eng" : "second",
		"ru" : "секунда",
		"ua" : "секунда",
		"cul" : "0.000005 яйца",
		"ial" : "шуршила"
		},
	"[pos]" : {
		"eng" : "position",
		"ru" : "позиция",
		"ua" : "позиція",
		"cul" : "тапок",
		"ial" : "бушки"
		},
	"[posu]" : {
		"eng" : "position",
		"ru" : "позицию",
		"ua" : "позицію"
		},
	"[scl]" : {
		"eng" : "scale",
		"ru" : "размер",
		"ua" : "розмір",
		"cul" : "жир",
		"ial" : "сумбюмь"
		},
	"[rot]" : {
		"eng" : "rotation",
		"ru" : "поворот",
		"ua" : "поворот",
		"cul" : "упжжпулуіклжкулж",
		"ial" : "мыравот"
		},
	"[skew]" : {
		"eng" : "skew",
		"ru" : "скос",
		"ua" : "скіс"
		},
	"[key]" : {
		"eng" : "key",
		"ru" : "ключ",
		"ua" : "ключ"
		},
	"[loc]" : {
		"eng" : "loc",
		"ru" : "лок",
		"ua" : "лок"
		},
	"[logic]" : {
		"eng" : "logic",
		"ru" : "логика",
		"ua" : "логіка"
		},
	"[obj]" : {
		"eng" : "object",
		"ru" : "объект",
		"ua" : "об'єкт"
		},
	"[touchs]" : {
		"eng" : "collides with",
		"ru" : "касается",
		"ua" : "торкається"
		},
	"[clone]" : {
		"eng" : "clone",
		"ru" : "клон",
		"ua" : "дублікат"
		},
	"[sin]" : {
		"eng" : "sine",
		"ru" : "синус",
		"ua" : "синус"
		},
	"[cosin]" : {
		"eng" : "cosine",
		"ru" : "косинус",
		"ua" : "косинус"
		},
	"[tan]" : {
		"eng" : "tangent",
		"ru" : "тангенс",
		"ua" : "тангенс"
		},
	"[ar]" : {
		"eng" : "arc",
		"ru" : "арк",
		"ua" : "арк"
		},
	"[osver]" : {
		"eng" : "OS version",
		"ru" : "Версия ОС",
		"ua" : "Версія ОС"
		},
	"[tch]" : {
		"eng" : "touch",
		"ru" : "касание",
		"ua" : "дотик"
		},
	"[prs]" : {
		"eng" : "touched",
		"ru" : "нажат",
		"ua" : "натиснутий"
		},
	"[set]" : {
		"eng" : "Set",
		"ru" : "Задать",
		"ua" : "Задати"
		},
	"[add]" : {
		"eng" : "Add",
		"ru" : "Изменить",
		"ua" : "Додати"
		},
	"[stmove]" : {
		"eng" : "Walk",
		"ru" : "Идти",
		"ua" : "Іти"
		},
	"[colto]" : {
		"eng" : "Paint",
		"ru" : "Окрасить в",
		"ua" : "Пофарбувати в"
		},
	"[bri]" : {
		"eng" : "brightness",
		"ru" : "яркость",
		"ua" : "яркість"
		},
	"[hide]" : {
		"eng" : "Hide",
		"ru" : "Скрыть",
		"ua" : "Сховати"
		},
	"[show]" : {
		"eng" : "Show",
		"ru" : "Показать",
		"ua" : "Показати"
		},
	"[sproff]" : {
		"eng" : "sprite offset",
		"ru" : "смещение спрайта",
		"ua" : "зміщення спрайта"
		},
	"[flip]" : {
		"eng" : "Flip",
		"ru" : "Развернуть по",
		"ua" : "Перевернути по"
		},
	"[sprite]" : {
		"eng" : "sprite",
		"ru" : "спрайт",
		"ua" : "спрайт"
		},
	"[layer]" : {
		"eng" : "layer",
		"ru" : "слой",
		"ua" : "шар"
		},
	"[opa]" : {
		"eng" : "opacity",
		"ru" : "прозрачность",
		"ua" : "прозорість"
		},
	"[tree]" : {
		"eng" : "Tree",
		"ru" : "Дерево",
		"ua" : "Дерево"
		},
	"[data]" : {
		"eng" : "Data",
		"ru" : "Данные",
		"ua" : "Дані"
		},
	"[datal]" : {
		"eng" : "data",
		"ru" : "данные",
		"ua" : "дані"
		},
	"[scrs]" : {
		"eng" : "Scripts",
		"ru" : "Скрипты",
		"ua" : "Скрипти"
		},
	"[back]" : {
		"eng" : "back",
		"ru" : "назад",
		"ua" : "назад"
		},
	"[wait]" : {
		"eng" : "Wait",
		"ru" : "Ждать",
		"ua" : "Чекати"
		},
	"[fr]" : {
		"eng" : "for",
		"ru" : "до",
		"ua" : "на"
		},
	"[frame]" : {
		"eng" : "frame",
		"ru" : "кадр",
		"ua" : "кадр"
		},
	"[repeat]" : {
		"eng" : "Repeat",
		"ru" : "Повторять",
		"ua" : "Повторювати"
		},
	"[while]" : {
		"eng" : "while",
		"ru" : "пока",
		"ua" : "поки"
		},
	"[end]" : {
		"eng" : "End",
		"ru" : "Конец",
		"ua" : "Кінець"
		},
	"[cycle]" : {
		"eng" : "cycle",
		"ru" : "цикла",
		"ua" : "циклу"
		},
	"[clear]" : {
		"eng" : "Clear",
		"ru" : "Очистить",
		"ua" : "Очистити"
		},
	"[if]" : {
		"eng" : "If",
		"ru" : "Если",
		"ua" : "Якщо"
		},
	"[else]" : {
		"eng" : "Else",
		"ru" : "Иначе",
		"ua" : "Інакше"
		},
	"[clonne]" : {
		"eng" : "Clone",
		"ru" : "Клонировать",
		"ua" : "Дублювати"
		},
	"[del]" : {
		"eng" : "Delete",
		"ru" : "Удалить",
		"ua" : "Видалити"
		},
	"[cami]" : {
		"eng" : "of camera",
		"ru" : "камеры",
		"ua" : "камери"
		},
	"[zoom]" : {
		"eng" : "zoom",
		"ru" : "зум",
		"ua" : "зум"
		},
	"[logica]" : {
		"eng" : "Logic",
		"ru" : "Логика",
		"ua" : "Логіка"
		},
	"[look]" : {
		"eng" : "Look",
		"ru" : "Вид",
		"ua" : "Вигляд"
		},
	"[snds]" : {
		"eng" : "Sound",
		"ru" : "Звук",
		"ua" : "Звук"
		},
	"[phys]" : {
		"eng" : "Physics",
		"ru" : "Физика",
		"ua" : "Фізика"
		},
	"[even]" : {
		"eng" : "Events",
		"ru" : "События",
		"ua" : "Події"
		},
	"[mvm]" : {
		"eng" : "Movement",
		"ru" : "Движение",
		"ua" : "Рух"
		},
	"[vars]" : {
		"eng" : "Variables",
		"ru" : "Переменные",
		"ua" : "Змінні"
		},
	"[deaclo]" : {
		"eng" : "Delete all clones",
		"ru" : "Удалить все клоны",
		"ua" : "Видалити усі дублікати"
		},
	"[lnc]" : {
		"eng" : "Launch",
		"ru" : "Запустить",
		"ua" : "Відтворити"
		},
	"[sceneu]" : {
		"eng" : "scene",
		"ru" : "сцену",
		"ua" : "сцену"
		},
	"[sts]" : {
		"eng" : "Stop this scene",
		"ru" : "Остановить эту сцену",
		"ua" : "Зупинити цю сцену"
		},
	"[stop]" : {
		"eng" : "Stop",
		"ru" : "Остановить",
		"ua" : "Зупинити"
		},
	"[stasig]" : {
		"eng" : "Emit signal",
		"ru" : "Подать сигнал",
		"ua" : "Подати сигнал"
		},
	"[copyclip]" : {
		"eng" : "Copy to buffer",
		"ru" : "Скопировать в буффер",
		"ua" : "Скопіювати"
		},
	"[opensite]" : {
		"eng" : "Open site",
		"ru" : "Открыть сайт",
		"ua" : "Перейти за посиланням"
		},
	"[toast]" : {
		"eng" : "Toast",
		"ru" : "Тост",
		"ua" : "Тост"
		},
	"[vibr]" : {
		"eng" : "Vibrate",
		"ru" : "Вибрировать",
		"ua" : "Вібрувати"
		},
	"[alert]" : {
		"eng" : "Alert",
		"ru" : "Предупреждение",
		"ua" : "Попередження"
		},
	"[title]" : {
		"eng" : "title",
		"ru" : "заголовок",
		"ua" : "назва"
		},
	"[vert]" : {
		"eng" : "Vertical",
		"ru" : "Вертикальная ориентация",
		"ua" : "Вертикальна орієнтація"
		},
	"[gori]" : {
		"eng" : "Horizontal",
		"ru" : "Горизонтальная ориентация",
		"ua" : "Горизонтальна орієнтація"
		},
	"[local]" : {
		"eng" : "local",
		"ru" : "локальную",
		"ua" : "локальну"
		},
	"[up]" : {
		"eng" : "top",
		"ru" : "вверху",
		"ua" : "вгорі"
		},
	"[down]" : {
		"eng" : "bottom",
		"ru" : "внизу",
		"ua" : "знизу"
		},
	"[left]" : {
		"eng" : "left",
		"ru" : "слева",
		"ua" : "ліворуч"
		},
	"[right]" : {
		"eng" : "right",
		"ru" : "справа",
		"ua" : "праворуч"
		},
	"[cre]" : {
		"eng" : "Create",
		"ru" : "Создать",
		"ua" : "Створити"
		},
	"[red]" : {
		"eng" : "Redact",
		"ru" : "Редактировать",
		"ua" : "Редагувати"
		},
	"[sty]" : {
		"eng" : "Style",
		"ru" : "Стилизовать",
		"ua" : "Стилізувати"
		},
	"[outa]" : {
		"eng" : "outline",
		"ru" : "обводки",
		"ua" : "контура"
		},
	"[color]" : {
		"eng" : "Color",
		"ru" : "Цвет",
		"ua" : "Колір"
		},
	"[amb]" : {
		"eng" : "ambient",
		"ru" : "окружение",
		"ua" : "оточення"
		},
	"[ligcol]" : {
		"eng" : "Light color",
		"ru" : "Цвет излучаемого света",
		"ua" : "Колір випромінюваного світла"
		},
	"[liis]" : {
		"eng" : "Light range",
		"ru" : "Дальность света",
		"ua" : "Дальність світла"
		},
	"[liie]" : {
		"eng" : "Light energy",
		"ru" : "Сила света",
		"ua" : "Яркість світла"
		},
	"[lii]" : {
		"eng" : "Emit light",
		"ru" : "Излучать свет",
		"ua" : "Випромінювати світло"
		},
	"[nlii]" : {
		"eng" : "Stop emitting light",
		"ru" : "Перестать излучать свет",
		"ua" : "Припинити випромінювати світло"
		},
	"[buttu]" : {
		"eng" : "button",
		"ru" : "кнопку",
		"ua" : "кнопку"
		},
	"[butti]" : {
		"eng" : "button",
		"ru" : "кнопки",
		"ua" : "кнопки"
		},
	"[signal]" : {
		"eng" : "signal",
		"ru" : "сигнал",
		"ua" : "сигнал"
		},
	"[width]" : {
		"eng" : "Width",
		"ru" : "Ширина",
		"ua" : "Ширина"
		},
	"[rund]" : {
		"eng" : "Corner radius of",
		"ru" : "Скругление",
		"ua" : "Заокруглення"
		},
	"[dict]" : {
		"eng" : "dictionary",
		"ru" : "словарь",
		"ua" : "таблиця"
		},
	"[dictu]" : {
		"eng" : "dictionary",
		"ru" : "словарю",
		"ua" : "таблиці"
		},
	"[dicta]" : {
		"eng" : "dictionary",
		"ru" : "словаря",
		"ua" : "таблиці"
		},
	"[shadi]" : {
		"eng" : "shadow",
		"ru" : "тени",
		"ua" : "тіні"
		},
	"[offs]" : {
		"eng" : "offset",
		"ru" : "смещение",
		"ua" : "зміщення"
		},
	"[val]" : {
		"eng" : "value",
		"ru" : "значение",
		"ua" : "значення"
		},
	"[ostart]" : {
		"eng" : "Started",
		"ru" : "При старте",
		"ua" : "Проект запущено"
		},
	"[presd]" : {
		"eng" : "Pressed",
		"ru" : "При нажатии",
		"ua" : "Об'єкт натиснуто"
		},
	"[rlsed]" : {
		"eng" : "Released",
		"ru" : "При отпускании",
		"ua" : "Об'єкт відпущено"
		},
	"[sign]" : {
		"eng" : "Signal received",
		"ru" : "Получен сигнал",
		"ua" : "Сигнал отримано"
		},
	"[ascln]" : {
		"eng" : "As clone",
		"ru" : "При старте как клон",
		"ua" : "Як дублікат"
		},
	"[evrframe]" : {
		"eng" : "Process frame",
		"ru" : "Каждый кадр",
		"ua" : "Кожен кадр"
		},
	"[newproj]" : {
		"eng" : "New project",
		"ru" : "Новый проект",
		"ua" : "Новий проєкт"
		},
	"[contin]" : {
		"eng" : "Continue",
		"ru" : "Продолжить",
		"ua" : "Продовжити"
		},
	"[projs]" : {
		"eng" : "Projects",
		"ru" : "Проекты",
		"ua" : "Проєкти"
		},
	"[docs]" : {
		"eng" : "Tutorial",
		"ru" : "Обучение",
		"ua" : "Документація"
		},
	"[exit]" : {
		"eng" : "Exit",
		"ru" : "Выход",
		"ua" : "Вихід"
		},
	"[import]" : {
		"eng" : "Import",
		"ru" : "Импортировать",
		"ua" : "Імпорт"
		}
}
var symbs = {}

func _ready() -> void:
	while true:
		symbs = {
			"plus" : " + ",
			"minus" : " - ",
			"mult" : " × ",
			"div" : " ÷ ",
			"step" : " ^ ",
			"=" : " = ",
			"n=" : " ≠ ",
			">" : " > ",
			"<" : " < ",
			"≤" : " ≤ ",
			"≥" : " ≥ ",
			"and" : " " + table["[and]"][lang] + " ",
			"or" : " " + table["[or]"][lang] + " ",
			"not" : " " + table["[not]"][lang] + " ",
			"rev" : " " + table["[rev]"][lang] + "( ",
			"true" : " " + table["[tru]"][lang] + " ",
			"false" : " " + table["[fal]"][lang] + " ",
			"join" : table["[join]"][lang] + "( ",
			"len" : table["[len]"][lang] + "( ",
			"var" : table["[var]"][lang] + "( ",
			"pi" : "π",
			"(" : "( ",
			")" : " )",
			"]" : "]",
			"abs" : "модуль( ",
			"gpu" : "GPU",
			"cpu" : "CPU",
			"os" : "система",
			"osver" : "версия ОС",
			"sin" : table["[sin]"][lang] + "( ",
			"cos" : table["[cosin]"][lang] + "( ",
			"tan" : table["[tan]"][lang] + "( ",
			"asin" : table["[ar]"][lang] + table["[sin]"][lang] + "( ",
			"acos" : table["[ar]"][lang] + table["[cosin]"][lang] + "( ",
			"atan" : table["[ar]"][lang] + table["[tan]"][lang] + "( ",
			"rand" : table["[rand]"][lang] + "( ",
			"round" : table["[roun]"][lang] + "( ",
			"floor" : table["[roun]"][lang] + " " + table["[lessr]"][lang] + "( ",
			"ceil" : table["[roun]"][lang] + " " + table["[great]"][lang] + "( ",
			"unix" : "unix time",
			"year" : table["[year]"][lang],
			"month" : table["[month]"][lang],
			"weekday" : table["[weekday]"][lang],
			"day" : table["[day]"][lang],
			"hour" : table["[hour]"][lang],
			"minute" : table["[minute]"][lang],
			"second" : table["[second]"][lang],
			"posx" : table["[pos]"][lang] + " X",
			"posy" : table["[pos]"][lang] + " Y",
			"presd" : "объект нажат? ",
			"rot" : table["[rot]"][lang],
			"skew" : table["[skew]"][lang],
			"clone" : table["[clone]"][lang] + "?",
			"mposx" : table["[tch]"][lang] + " X",
			"mposy" : table["[tch]"][lang] + " Y",
			"tocx" : table["[tch]"][lang] + " X №[",
			"tocy" : table["[tch]"][lang] + " Y №[",
			"tocs" : "кол.во касаний",
			"sizx" : table["[scl]"][lang] + " X",
			"sizy" : table["[scl]"][lang] + " Y",
			"," : ", "
		}
		await get_tree().create_timer(2).timeout
