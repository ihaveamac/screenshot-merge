--ihaveamac--
-- https://github.com/ihaveamac/screenshot-merge
-- licensed under the MIT license - see https://github.com/ihaveamac/screenshot-merge/blob/master/LICENSE.md
version = "1.2"
dev_version = false
System.setCpuSpeed(NEW_3DS_CLOCK)
Screen.enable3D()

-- input_folder exists for debugging reasons, and the fact that I back up my screenshots
input_folder = "screenshots"
output_folder = "screenshots-merged"

NINJHAX = "ninjhax"
NTR     = "ntr"
LUMA    = "luma"

c_white      = Color.new(255, 255, 255)
c_grey       = Color.new(127, 127, 127)
c_black      = Color.new(0, 0, 0)
c_green      = Color.new(0, 255, 0)
c_red        = Color.new(255, 0, 0)
c_light_blue = Color.new(127, 127, 255)

 -- to prevent errors
System.createDirectory("/"..input_folder)
System.createDirectory("/luma")
System.createDirectory("/luma/"..input_folder)

System.createDirectory("/"..output_folder)
System.createDirectory("/"..output_folder.."/"..NINJHAX)
System.createDirectory("/"..output_folder.."/"..NTR)
System.createDirectory("/"..output_folder.."/"..LUMA)

local takeScreenshot = System.takeScreenshot
local loadImage = Screen.loadImage
local drawImage = Screen.drawImage
local freeImage = Screen.freeImage
local fillEmptyRect = Screen.fillEmptyRect

-- this doesn't have a real purpose other than to switch "SD" and "microSD" + "3DS" and "2DS"
model = System.getModel()
--[[
0 = Old 3DS
1 = Old 3DS XL
2 = New 3DS
3 = 2DS
4 = New 3DS XL
]]
sdcardtype = "SD"
sysmodel   = "3DS"
if model == 2 or model == 4 then
    sdcardtype = "microSD"
end
if model == 3 then
    sysmodel = "2DS"
end

build = System.checkBuild()
function checkCIAForExit(key)
    if build == 1 then
        return "HOME: return to Home Menu"
    else
        return key..": exit"
    end
end
function checkExit(key, pad)
    -- this is necessary to enable the Home Menu properly
    --Screen.debugPrint(0, 0, "", c_white, BOTTOM_SCREEN)
    if build == 1 then
        if Controls.check(pad, KEY_HOME) or Controls.check(pad, KEY_POWER) then
            System.showHomeMenu()
            doDoubleDraw()
        end
        if System.checkStatus() == APP_EXITING then
            System.exit()
        end
    else
        if Controls.check(pad, key) then
            System.exit()
        end
    end
end

function print(x, y, text, clr)
    if not clr then
        clr = c_white
    end
    Screen.debugPrint(x, y, text, clr, TOP_SCREEN, LEFT_EYE)
    Screen.debugPrint(x, y, text, clr, TOP_SCREEN, RIGHT_EYE)
end
-- 'cause double buffering stuff
saved_dd = function() end
function setDoubleDraw(draw)
    saved_dd = draw
    doubleDraw(draw)
end
function doubleDraw(draw)
    draw()
    Screen.flip()
    Screen.refresh()
    draw()
end
function doDoubleDraw()
    doubleDraw(saved_dd)
end

function drawMain()
    Screen.waitVblankStart()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.clear(BOTTOM_SCREEN)
    print(5, 5, "Screenshot merge "..version, c_white)
    fillEmptyRect(6, 394, 17, 18, c_grey, TOP_SCREEN, LEFT_EYE)
    fillEmptyRect(6, 394, 17, 18, c_grey, TOP_SCREEN, RIGHT_EYE)
    Screen.debugPrint(5, 5, "ianburgwin.net/scr-merge", c_grey, BOTTOM_SCREEN)
    --[[if new_ver_available and not dev_version then
        Screen.debugPrint(5, 25, "New version available!", c_green, BOTTOM_SCREEN)
        Screen.debugPrint(5, 40, "Go to the URL above to get it.", c_green, BOTTOM_SCREEN)
    end]]
end

--[[doubleDraw(function()
    drawMain()
end)
new_ver_available = (Network.requestString("http://ianburgwin.net/scr-merge/version"):sub(1, version:len()) ~= version)]]

setDoubleDraw(function()
    drawMain()
    print(5, 25, "This tool will merge screenshots on your")
    print(5, 40, "3DS's "..sdcardtype.." card.")
    print(5, 60, "The resulting images will be placed in a")
    print(5, 75, "folder called /"..output_folder..".")
    print(5, 75, "folder called /"..output_folder, c_light_blue)
    print(5, 75, "folder called /")
    print(5, 95, "Only those with a top and bottom image")
    print(5, 110, "will be merged.")
    print(5, 130, "This tool supports ninjhax 2.x, NTR CFW")
    print(5, 145, "and Luma3DS screenshot formats.")
    print(5, 185, "A: next", c_green)
    print(5, 200, checkCIAForExit("B"), c_grey)
end)
repeat
    doDoubleDraw()
    pad = Controls.read()
    checkExit(KEY_B, pad)
until Controls.check(pad, KEY_A)

setDoubleDraw(function()
    drawMain()
    print(5, 25, "Getting list of files to merge...", c_grey)
end)
-- for seeing if a number is already seen
numbers = {[NINJHAX] = {}, [NTR] = {}, [LUMA] = {}}
-- for the actual numbers, checking if TOP_LEFT and BOTTOM exist
files_to_process = {}

overwriting_files = false
-- NINJHAX
for _, v in pairs(System.listDirectory("/"..input_folder)) do
    local num = v.name:sub(5, v.name:find("_", 5) - 1)
    if not numbers[NINJHAX][num] then
        numbers[NINJHAX][num] = true
    end
end
for k, _ in pairs(numbers[NINJHAX]) do
    if System.doesFileExist("/"..input_folder.."/scr_"..k.."_TOP_LEFT.png") and System.doesFileExist("/"..input_folder.."/scr_"..k.."_BOTTOM.png") then
        table.insert(files_to_process, {k, NINJHAX})
        if System.doesFileExist("/"..output_folder.."/"..NINJHAX.."/scr_"..k.."_MERGED.bmp") then
            overwriting_files = true
        end
    end
end

-- NTR
for _, v in pairs(System.listDirectory("/")) do
    local num = v.name:sub(5, 8)
    if not numbers[NTR][num] then
        numbers[NTR][num] = true
    end
end
for k, _ in pairs(numbers[NTR]) do
    if System.doesFileExist("/top_"..k..".bmp") and System.doesFileExist("/bot_"..k..".bmp") then
        table.insert(files_to_process, {k, NTR})
        if System.doesFileExist("/"..output_folder.."/"..NTR.."/mrg_"..k..".bmp") then
            overwriting_files = true
        end
    end
end

-- LUMA
for _, v in pairs(System.listDirectory("/luma/"..input_folder)) do
    local num = v.name:sub(5, 8)
    if not numbers[LUMA][num] then
        numbers[LUMA][num] = true
    end
end
for k, _ in pairs(numbers[LUMA]) do
    if System.doesFileExist("/luma/"..input_folder.."/top_"..k..".bmp") and System.doesFileExist("/luma/"..input_folder.."/bot_"..k..".bmp") then
        table.insert(files_to_process, {k, LUMA})
        if System.doesFileExist("/"..output_folder.."/"..LUMA.."/mrg_"..k..".bmp") then
            overwriting_files = true
        end
    end
end

setDoubleDraw(function()
    drawMain()
    print(5, 25, "Processing "..(#files_to_process * 2).." screenshots, ")
    print(5, 25, "Processing "..(#files_to_process * 2), c_light_blue)
    print(5, 25, "Processing")
    print(5, 40, "creating a total of "..#files_to_process.." images.")
    print(5, 40, "creating a total of "..#files_to_process, c_light_blue)
    print(5, 40, "creating a total of")
    if overwriting_files then
        -- this will be split into multiple lines
        print(5, 60, "WARNING: It has been detected that some")
        print(5, 60, "WARNING", c_red)
        print(5, 75, "files will be overwritten in the process.")
        print(5, 95, "It is highly recommended to move the")
        print(5, 110, "/"..output_folder.." folder before")
        print(5, 110, "/"..output_folder, c_light_blue)
        print(5, 110, "/")
        print(5, 125, "starting.")
        print(5, 145, "You are responsible for lost data due to use")
        print(5, 160, "of this tool.")
        print(5, 200, "X: start merging", c_green)
        print(5, 215, checkCIAForExit("B"), c_grey)
    else
        print(5, 80, "X: start merging", c_green)
        print(5, 95, checkCIAForExit("B"), c_grey)
    end
end)
repeat
    doDoubleDraw()
    pad = Controls.read()
    checkExit(KEY_B, pad)
until Controls.check(pad, KEY_X)

-- show 0% before files are actually processed
doubleDraw(function()
    drawMain()
    print(5, 25, "Processing screenshots...")
    print(5, 45, "0")
    print(51, 45, "/")
    print(73, 45, #files_to_process)
    print(160, 45, "0")
    print(190, 45, "%")
    print(5, 60, "Hold B to stop.", c_grey)
end)
stop_count = 0
for i = 1, #files_to_process do
    if files_to_process[i][2] == NINJHAX then
        System.deleteFile("/"..output_folder.."/"..NINJHAX.."/scr_"..files_to_process[i][1].."_MERGED.bmp")
        local top = loadImage("/"..input_folder.."/scr_"..files_to_process[i][1].."_TOP_LEFT.png")
        drawImage(0, 0, top, TOP_SCREEN)
        freeImage(top)
        local bottom = loadImage("/"..input_folder.."/scr_"..files_to_process[i][1].."_BOTTOM.png")
        drawImage(0, 0, bottom, BOTTOM_SCREEN)
        freeImage(bottom)
        takeScreenshot("/"..output_folder.."/"..NINJHAX.."/scr_"..files_to_process[i][1].."_MERGED.bmp", false)
    elseif files_to_process[i][2] == NTR then
        System.deleteFile("/"..output_folder.."/"..NTR.."/mrg_"..files_to_process[i][1]..".bmp")
        local top = loadImage("/top_"..files_to_process[i][1]..".bmp")
        drawImage(0, 0, top, TOP_SCREEN)
        freeImage(top)
        local bottom = loadImage("/bot_"..files_to_process[i][1]..".bmp")
        drawImage(0, 0, bottom, BOTTOM_SCREEN)
        freeImage(bottom)
        takeScreenshot("/"..output_folder.."/"..NTR.."/mrg_"..files_to_process[i][1]..".bmp", false)
    elseif files_to_process[i][2] == LUMA then
        System.deleteFile("/"..output_folder.."/"..LUMA.."/mrg_"..files_to_process[i][1]..".bmp")
        local top = loadImage("/luma/"..input_folder.."/top_"..files_to_process[i][1]..".bmp")
        drawImage(0, 0, top, TOP_SCREEN)
        freeImage(top)
        local bottom = loadImage("/luma/"..input_folder.."/bot_"..files_to_process[i][1]..".bmp")
        drawImage(0, 0, bottom, BOTTOM_SCREEN)
        freeImage(bottom)
        takeScreenshot("/"..output_folder.."/"..LUMA.."/mrg_"..files_to_process[i][1]..".bmp", false)
    end
    stop_count = i
    doubleDraw(function()
        drawMain()
        print(5, 25, "Processing screenshots...")
        print(5, 45, i)
        print(51, 45, "/")
        print(73, 45, #files_to_process)
        print(160, 45, math.floor((i / #files_to_process) * 100))
        print(190, 45, "%")
        fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 394), 17, 18, c_green, TOP_SCREEN, LEFT_EYE)
        fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 394), 17, 18, c_green, TOP_SCREEN, RIGHT_EYE)
        print(5, 60, "Hold B to stop.", c_grey)
    end)
    if Controls.check(Controls.read(), KEY_B) then
        break
    end
end
setDoubleDraw(function()
    drawMain()
    print(5, 25, "Processing screenshots...")
    print(5, 45, stop_count)
    print(51, 45, "/")
    print(73, 45, #files_to_process)
    print(160, 45, math.floor((stop_count / #files_to_process) * 100))
    print(190, 45, "%")
    if stop_count ~= #files_to_process then
        print(5, 60, "Stopped.", c_red)
        fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 388) + 6, 17, 18, c_red, TOP_SCREEN, LEFT_EYE)
        fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 388) + 6, 17, 18, c_red, TOP_SCREEN, RIGHT_EYE)
    else
        print(5, 60, "Done!", c_green)
        fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 394), 17, 18, c_green, TOP_SCREEN, LEFT_EYE)
        fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 394), 17, 18, c_green, TOP_SCREEN, RIGHT_EYE)
    end
    print(5, 100, checkCIAForExit("A"), c_green)
    if System.doesFileExist("/gridlauncher/glinfo.txt") and build ~= 1 then
        print(5, 140, "If you are using mashers's grid launcher,")
        print(5, 155, "you should use the exit shortcut instead.")
        print(5, 175, "ninjhax 2.x exit shortcut: L + R + Down + B", c_light_blue)
        print(5, 175, "ninjhax 2.x exit shortcut:", c_grey)
    end
end)
while true do
    doDoubleDraw()
    pad = Controls.read()
    checkExit(KEY_A, pad)
end
