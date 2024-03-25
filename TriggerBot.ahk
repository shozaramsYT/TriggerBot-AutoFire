#Persistent ; Скрипт будет продолжать работу даже после выполнения всего кода

; Настройки
SetBatchLines, -1
CoordMode, Pixel, Screen

; Размеры экрана
ScreenWidth := 1440
ScreenHeight := 900

; Цвет, который мы будем искать (фиолетовый цвет в формате RGB)
targetColor := 0x800080 ; Фиолетовый цвет

; Радиус сканирования в пикселях
radius := 50 ; Увеличенный радиус для сканирования

; Определяем, какая кнопка должна быть нажата (в данном случае - "0")
hotkeyButton := "0"

; Переменная для отслеживания состояния горячей клавиши
AltPressed := false

; Определяем горячую клавишу для активации скрипта (левый ALT)
~LAlt::
AltPressed := !AltPressed
if (AltPressed)
{
SetTimer, CheckColor, 100 ; Запускаем таймер проверки цвета каждую секунду
MsgBox, Скрипт активирован. %targetColor%
}
else
{
SetTimer, CheckColor, Off ; Останавливаем таймер
MsgBox, Скрипт деактивирован.
WinClose, ColorOverlay ; Закрываем окно оверлея цвета
}
return

CheckColor:
; Получаем цвет пикселя в центре экрана
PixelGetColor, currentColor, % ScreenWidth / 2, % ScreenHeight / 2

; Проверяем, находится ли цвет в радиусе сканирования
if (IsColorInRadius(currentColor, targetColor, radius))
{
; Если цвет находится в радиусе, нажимаем указанную кнопку с задержкой
Send, {%hotkeyButton% down}
Sleep, 10 ; Задержка 10 миллисекунд
Send, {%hotkeyButton% up}
MsgBox, Клавиша %hotkeyButton% нажата.
}

; Отображаем оверлей с цветом
ShowColorOverlay(currentColor)

; Ждем некоторое время перед повторной проверкой
Sleep, 100 ; Время в миллисекундах (здесь 100 мс)
return

IsColorInRadius(color1, color2, radius)
{
; Получаем цветность каждого канала цвета
red1 := (color1 » 16) & 0xFF
green1 := (color1 » 8) & 0xFF
blue1 := color1 & 0xFF
red2 := (color2 » 16) & 0xFF
green2 := (color2 » 8) & 0xFF
blue2 := color2 & 0xFF

; Вычисляем разницу в цветности для каждого канала
deltaRed := abs(red1 - red2)
deltaGreen := abs(green1 - green2)
deltaBlue := abs(blue1 - blue2)

; Проверяем, находится ли цвет в радиусе сканирования
return (deltaRed < radius) && (deltaGreen < radius) && (deltaBlue < radius)
}

ShowColorOverlay(color)
{
; Создаем графический оверлей с информацией о цвете
Gui, ColorOverlay:New, +AlwaysOnTop -Caption
Gui, ColorOverlay:Color, Black
Gui, ColorOverlay:Margin, 0, 0
Gui, ColorOverlay:Add, Text, x10, Цвет: %color%
}