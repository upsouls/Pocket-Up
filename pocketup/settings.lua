utf8 = require( "plugin.utf8" )
utf8.split = function(text, sep) local result = {} for s in text:gmatch('[^' .. sep .. ']+') do result[#result + 1] = s end return result end
json = require("json")
widget = require("widget")
--math = require("math")
lfs = require("lfs")
physics = require("physics")
orientation = require('plugin.orientation')

display.setDefault( 'minTextureFilter', 'nearest' )
display.setDefault( 'magTextureFilter', 'nearest' )

os.removeFolder = function (path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local filePath = path.."/"..file
            local attr = lfs.attributes(filePath)
            if (attr~=nil) then
                if attr.mode == "directory" then
                    os.removeFolder(filePath)
                else
                    os.remove(filePath)
                end
            end
        end
    end
    lfs.rmdir(path)
end

isWin = system.getInfo 'platform' ~= 'android'
isSim = system.getInfo 'environment' == 'simulator'
_G.display = display
_G.system = system

_G.os = os
os.write = function (value , path , basedir)
    if type(path) ~= 'string' or value == nil then
        return true
    end
    local link = path
    if basedir then
        link = system.pathForFile(path , basedir)
    end
    local file = io.open(link , 'w')
    file:write(value)
    file:close()
end

os.read = function (path , mode , basedir)
    local link = path
    if type(path) ~= 'string' then
        return true
    end
    if type(mode) ~= 'string' then
        mode = '*a'
    end
    if basedir then
        link = system.pathForFile(path , basedir)
    end
    local file = io.open(link , 'r+')
    local value = file:read(mode)
    file:close()
    return value
end

display.setStatusBar(display.DefaultStatusBar)

function setFocus(object, id)
	display.getCurrentStage():setFocus( object, id )
end

cerberus = {}
cerberus.newImage = function(nameFile, directory, x, y)
	if (directory~=system.DocumentsDirectory) then
		return display.newImage(nameFile)
	else
		-- взять изображение из ресурсов
	end
end

IDPROJECT = nil
NMPROJECT = nil
IDSCENE = nil
IDOBJECT = nil
display.setDefault("background", 4/255, 34/255, 44/255)
display.contentWidth = display.actualContentWidth
--display.contentHeight = display.safeActualContentHeight
CENTER_X = display.contentCenterX
CENTER_Y = display.screenOriginY+display.contentHeight/2
SCENE = nil
SCENES = {}

---------------------------------------------------
printText = display.newText({
	text="тест",
	x=CENTER_X,
	y=CENTER_Y*1.5,
	width=display.contentWidth,
	font=nil,
	fontSize=nil,
})
function printC(event)
	printText.text = event
	printText:toFront()
end
printText.alpha=0
---------------------------------------------------

fontSize1 = math.min(display.contentWidth/20, 32.5)
fontSize2 = math.min(display.contentWidth/24, 25)
fontSize0 = fontSize1*1.125
roundedRect = fontSize1/8
words = {"Проекты",'Нажмите "+", чтобы добавить актеров или объекты',"Актеры и объекты","Копировать","Удалить"--[[5]],"Переименовать","Новая группа","Новая сцена","Опции проекта",
"Выбрать все"--[[10]],"Отменить все","В этом списке пока нет элементов. Пожалуйста, добавьте сначала несколько.","Переименовать актера или объекта","Название актера или объекта",
"Данное имя уже используется, пожалуйста, выберите другое"--[[15]],"ОК","ОТМЕНИТЬ","Пожалуйста, введите текст","Копирован <count> актер или объект",
"Копировано <count> актеров или объектов"--[[20]],"Удален <count> актер или объект","Удалено <count> актеров или объектов","Группа","Новая группа","Название группы"--[[25]],"Новая сцена",
 "Название сцены","Сцена","Новый актер или объект", "Фон"--[[30]], "Переименовать сцену","Копирована <count> сцена", "Копировано <count> сцен","Удалена <count> сцена",
 "Удалено <count> сцен"--[[35]], "Импортировать проект", "Удален <count> проект", "Удалено <count> проектов","Переименовать проект","Название проекта"--[[40]], "Сортировка",
 "Без сортировки","Мой проект","Описание","Примечание и авторы"--[[45]], "Сохранять исходное соотношение сторон","Выложить проект","Сохранить проект на устройство","Подробнее",
 "УДАЛИТЬ ПРОЕКТ"--[[50]], "В процессе разработки","Сохранение проекта на устройство","Проект сохранен на устройство", "Удалить этот проект?\n\nВы не сможете это отменить!", "НЕТ"--[[55]]
 ,"ДА", "При старте", "Поместить в", "X","Y"--[[60]], "Вечно", "Конец (вечно)", "Скользить","секунд", "по X"--[[65]], "Категории", "Недавно использованные","Событие","Управление",
 "Физика"--[[70]],"Звуки","Образы","Перо","Данные","Устройство"--[[75]],"При нажатии", "При прикосновении к экрану","Когда будет получен сигнал","Новый сигнал","Вещать всем"--[[80]],
 "Вещать всем и ждать","Как только","становится истинной","При столкновении с","любым краем, актером ил..."--[[85]],"Когда фон изменится на","новое...","Когда начинает как клон",
 "Клонировать","этот актер или объект"--[[90]],"Удалить этот клон","Ждать","секунд","Примечание","Новое примечание"--[[95]], "Если","истина, то","Иначе","Конец (если)",
 "Ждать до тех пор, пока"--[[100]],"истина","Повторять","раз","Конец (повторений)","Повторять до тех пор, пока"--[[105]],"Для значений от","до","Конец (цикла)","Для каждого значения от",
 "в"--[[110]],"Продолжить сцену","Запустить сцену","Остановить","этот скрипт","все скрипты"--[[115]],"другие скрипты этого актера...","Ждать остановки всех других...","Установить X в",
 "Установить Y в","Изменить X на"--[[120]],"Изменить Y на","Перейти в","место, к которому прикосну...","Случайное место","Идти"--[[125]],"шагов","Повернуть налево на"
 ,"градусов","Повернуть направо на","Указать в направлении"--[[130]],"Указать в направление к","Задать тип вращения","только слева-направо","вокруг","не вращать"--[[135]],"Вибрировать"
 ,"Задать скорость","шагов в секунду","Вращать влево","Вращать вправо"--[[140]],"Задать силу тяжести для все...","Задать массу","килограмм","Задать упругость","Задать трение"--[[145]],
 "Воспроизвести звук","Воспроизвести звук и ждать","Остановить звук","Остановить все звуки","Задать громкость"--[[150]],"Изменить громкость на","Задать образ","Задать образ под номером",
 "Следующий образ","Предыдущий образ"--[[155]],"Задать размер","Изменить размер на","Спрятать","Показать","Спросить"--[[160]],"Как тебя зовут?","и сохранить напечатанный от...","Сказать",
 "Привет!","в течение"--[[165]],"секунд","Думать","Хмммм!","Задать прозрачность","значение"--[[170]],"Изменить прозрачность","на","Задать яркость","Изменить яркость","Задать цвет"--[[175]],
 "Изменить цвет","Создать радиальные частицы","в","из","Включить аддаптивности эфф..."--[[180]],"Задать цвет частиц","Очистить графические эффек...","вкл.","выкл.",
 "Сфокусироваться на объект с"--[[185]],"% горизонтальной и", "% вертикальной гибкостью","Задать фон","Задать фон под номером","Задать фон и ждать"--[[190]],"и ждать",
 "Получить изображение из","и использовать как текущий...","Опустить перо","Поднять перо"--[[195]],"Задать размер пера","Задать цвет пера","красный","зеленый","синий"--[[200]],"Штамп",
 "Очистить","Присвоить переменной","Изменить значение переменн...","Показать переменную"--[[205]],"На X","размер","% цвет","выравненный","по центру"--[[210]],"слева","справа",
 "Скрыть переменную","Сохранить переменную на уст...","Прочитать переменную с устр..."--[[215]],"Сохранить переменную","в файл","переменная","Прочитать переменную", "с файла"--[[220]],
 "и","сохранить файл","удалить файл","Добавить","к списку"--[[225]],"Удалить элемент из списка","На позиции","Удалить все элементы из спи...","Вставить","в список"--[[230]],"на позицию",
 "Заменить предмет в списке","с позиции","Сохранить список на устройст...","Считать список с устройства"--[[235]],
 "Столбец хранилища","значения через запятую","котенок,милый\nщенок, непослушный\nосьминог,умный","в список","Отправить веб-запрос"--[[240]],"и сохранить ответ в","Сбросить таймер",
 "Открыть","в браузере","Коснуться до объекта"--[[245]],"Прикоснуться к экрану","","от X","Новая переменная","Название"--[[250]],
 "Переменная","Для всех актеров, объектов, и клонов во всех сценах","Только для этого актера, объекта или его клонов","Новый список","Список"--[[255]],"редактировать...",
 "Новый сигнал","сообщение","Сообщение","Редактировать сообщение"--[[260]],"Копировать кирпич","Удалить кирпич","Отключить кирпич","Включить кирпич","Отключить/включить"--[[265]]
 ,"Проект импортирован","Произошла ошибка при импорте проекта","Переименовать образ","Название образа","Переименовать звук"--[[270]],"Название звука","Редактор формул","Функции",
 "Свойства","Устройство"--[[275]],"Логика","Данные","Абв","Вычис..","Новый текст"--[[280]],"Изменить текст","Текст","текущий","новый","крас"--[[285]],"зеле","сини","HEX","ОТМЕНИТЬ",
 "ПРИМЕНИТЬ"--[[290]],"Свойста этого актера ил...","Математика","синус","косинус","касательная"--[[295]],"натуральный логарифм","десятичный логарифм","число Pi","корень","случайный"--[[300]]
 ,"абсолютное значение","округлить","модуль","арксинус","арккосинус"--[[305]],"арктангенс","арктангенс2","экспонента","степень","округлить к меньшему"--[[310]],"округлить к большему"
 ,"максимум","минимум","если то иначе","Строки"--[[315]],"длина","символ","соединить","регулярное выражение","выравнивание"--[[320]],"Списки","количество элементов","элемент","содержит"
 ,"индекс предмета"--[[325]],"Создайте список для доступа новых функц...","Свойства отображения","прозрачность","яркость","цвет"--[[330]],"номер образа","название образа"
 ,"количество образов","Свойства движения","координата X"--[[335]],"координата Y","размер","направление","направление взгляда",""--[[340]],"касается актера или объекта",
 "касается края","касается пальца","скорость по оси X","скорость по оси Y"--[[345]],"угловая скорость","Датчики устройства","цвет на X и Y","язык пользователя",
 "Обнаружение касаний"--[[350]],"прикосновение к экрану X","прикосновение к экрану Y","коснулся экрана","касание к экрану X","касание к экрану Y"--[[355]],"коснулся экрана",
 "количество касаний к экрану","количество касаний","индекс текущего касания","дата и время"--[[360]],"таймер","год","месяц","день","день недели"--[[365]],"час","минута","секунда",
 "Логические операторы и константы","И"--[[370]],"ИЛИ","НЕ","ИСТИНА","ЛОЖЬ","Операторы сравнения"--[[375]],"Переменные для всех актеров и объектов",
 "Переменные только для этого актера или объекта","Списки для всех актеров или объектов","Списки только для этого актера или объекта","ПЕРЕМЕННАЯ УДАЛЕНА"--[[380]],"СПИСОК УДАЛЕН",
 "Удалить?\n\nУдаление переменной или списка, которые все еще используются могут вызвать ошибки. Вы не можете отменить это!","УДАЛИТЬ","ERROR","NaN"--[[385]],
 "В формуле присутствует ошибка", "Вставка на Lua", "Заголовок", "Сообщение", "C задержкой"--[[390]], "Конец (таймер)","Задать тип движения","динамический",
"статический","без физики"--[[395]], "Завершить сеанс","Переместить на передний план","Переместить на задний план","Имя частиц","Максимум частиц"--[[400]],"Зависимость к углу","Угол вылета",
"Отклонение","Максимальный радиус","Создать линейные частицы"--[[405]],"Минимальный радиус","Радиальное вращение","Время жизни частицы","Начальный размер","Конечный размер",
"Начальное вращение"--[[410]],"Конечное вращение","Начальный цвет","Конечный цвет","Исходный цвет GL",--[[415]]"Целевой цвет GL","Mои частицы","Скорость","диапазон по X","и Y"--[[420]],
"Гриавитация по X","Радиальное ускорение","Касательное ускорение","Удалить частицы","Удалить все частицы"--[[425]],"Установить позицию частицам","Частицы","Задать размер частицам",
"Изменить позицию частиц","с именем"--[[430]],"на Y","Отвязать от камеры","Привязать к камере","Убрать фокус с объекта", "Отвязать от камеры переменную",--[[435]] "Привязать к камере переменную",
"Выполнить","Вещать всем объектам","Вещать всем актерам","Вещать объекту и его актерам"--[[440]],"Вещать объекту","Вещать всем актерам объекта","Дать имя актеру","Мой клон","Вещать актеру объекта"--[[445]],
"Конец (ждать)", "Задать цвет фона", "Красный", "Зелёный", "Синий", "HEX Цвет", "Отменить все таймеры", "Вызвать сообщение", "С текстом", "Показать хитбоксы"--[[455]], "Скрыть хитбоксы"}--[[456]]


_G.select_Scroll = ''
local function moveScroll(event)
	if event.type == 'scroll' and type(select_Scroll)~='string' then
		local x, y = select_Scroll:getContentPosition()
		if (event.scrollY > 0 and (y + (event.scrollY /2)) <0) or (event.scrollY < 0)  then
			select_Scroll:scrollToPosition({
				y = y + (event.scrollY),
				time = 0
			})
		end
		return true
	end
end
Runtime:addEventListener("mouse", moveScroll)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end