--ihaveamac--
-- https://github.com/ihaveamac/screenshot-merge
-- licensed under the MIT license - see https://github.com/ihaveamac/screenshot-merge/blob/master/LICENSE.md
version = "1.2 dev"
dev_version = false

-- input_folder exists for debugging reasons, and the fact that I back up my screenshots
input_folder = "screenshots"
output_folder = "screenshots-merged"

NINJHAX = "ninjhax"
NTR     = "ntr"

c_white      = Color.new(255, 255, 255)
c_grey       = Color.new(127, 127, 127)
c_black      = Color.new(0, 0, 0)
c_green      = Color.new(0, 255, 0)
c_red        = Color.new(255, 0, 0)
c_light_blue = Color.new(127, 127, 255)
System.setCpuSpeed(NEW_3DS_CLOCK)
System.createDirectory("/"..input_folder) -- to prevent errors
System.createDirectory("/"..output_folder)
System.createDirectory("/"..output_folder.."/"..NINJHAX)
System.createDirectory("/"..output_folder.."/"..NTR)

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

function print(x, y, text, clr)
    if not clr then
        clr = c_white
    end
    Screen.debugPrint(x, y, text, clr, TOP_SCREEN)
end
-- 'cause double buffering stuff
function doubleDraw(draw)
    draw()
    Screen.flip()
    Screen.refresh()
    draw()
end
function drawMain()
    Screen.waitVblankStart()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.clear(BOTTOM_SCREEN)
    Screen.debugPrint(5, 5, "Screenshot merge "..version, c_white, TOP_SCREEN)
    Screen.fillEmptyRect(6, 394, 17, 18, c_grey, TOP_SCREEN)
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

doubleDraw(function()
    drawMain()
    print(5, 25, "This tool will merge screenshots on your")
    print(5, 40, "3DS's "..sdcardtype.." card.")
    print(5, 60, "The resulting images will be placed in a")
    print(5, 75, "folder called /"..output_folder..".")
    print(5, 75, "folder called /"..output_folder, c_light_blue)
    print(5, 75, "folder called /")
    print(5, 95, "Only those with a top and bottom image")
    print(5, 110, "will be merged.")
    print(5, 130, "This tool supports ninjhax 2.5 and NTR CFW")
    print(5, 145, "screenshot formats.")
    print(5, 185, "A: next", c_green)
    print(5, 200, "B: exit", c_grey)
end)
repeat
    pad = Controls.read()
    if Controls.check(pad, KEY_B) then
        System.exit()
    end
until Controls.check(pad, KEY_A)

doubleDraw(function()
    drawMain()
    print(5, 25, "Getting list of files to merge...", c_grey)
end)
-- for seeing if a number is already seen
numbers = {[NINJHAX] = {}, [NTR] = {}}
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

doubleDraw(function()
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
        print(5, 145, "ihaveamac is not responsible for lost data")
        print(5, 160, "due to use of this tool.")
        print(5, 200, "X: start merging", c_green)
        print(5, 215, "B: exit", c_grey)
    else
        print(5, 80, "X: start merging", c_green)
        print(5, 95, "B: exit", c_grey)
    end
end)
repeat
    pad = Controls.read()
    if Controls.check(pad, KEY_B) then
        System.exit()
    end
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
        local top = Screen.loadImage("/"..input_folder.."/scr_"..files_to_process[i][1].."_TOP_LEFT.png")
        Screen.drawImage(0, 0, top, TOP_SCREEN)
        Screen.freeImage(top)
        local bottom = Screen.loadImage("/"..input_folder.."/scr_"..files_to_process[i][1].."_BOTTOM.png")
        Screen.drawImage(0, 0, bottom, BOTTOM_SCREEN)
        Screen.freeImage(bottom)
        System.takeScreenshot("/"..output_folder.."/"..NINJHAX.."/scr_"..files_to_process[i][1].."_MERGED.bmp", false)
    elseif files_to_process[i][2] == NTR then
        System.deleteFile("/"..output_folder.."/"..NTR.."/mrg_"..files_to_process[i][1]..".bmp")
        local top = Screen.loadImage("/top_"..files_to_process[i][1]..".bmp")
        Screen.drawImage(0, 0, top, TOP_SCREEN)
        Screen.freeImage(top)
        local bottom = Screen.loadImage("/bot_"..files_to_process[i][1]..".bmp")
        Screen.drawImage(0, 0, bottom, BOTTOM_SCREEN)
        Screen.freeImage(bottom)
        System.takeScreenshot("/"..output_folder.."/"..NTR.."/mrg_"..files_to_process[i][1]..".bmp", false)
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
        Screen.fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 394), 17, 18, c_green, TOP_SCREEN)
        print(5, 60, "Hold B to stop.", c_grey)
    end)
    if Controls.check(Controls.read(), KEY_B) then
        break
    end
end
doubleDraw(function()
    drawMain()
    print(5, 25, "Processing screenshots...")
    print(5, 45, stop_count)
    print(51, 45, "/")
    print(73, 45, #files_to_process)
    print(160, 45, math.floor((stop_count / #files_to_process) * 100))
    print(190, 45, "%")
    if stop_count ~= #files_to_process then
        print(5, 60, "Stopped.", c_red)
        Screen.fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 388) + 6, 17, 18, c_red, TOP_SCREEN)
    else
        print(5, 60, "Done!", c_green)
        Screen.fillEmptyRect(6, math.floor((stop_count / #files_to_process) * 394), 17, 18, c_green, TOP_SCREEN)
    end
    print(5, 100, "A: exit", c_green)
    if System.doesFileExist("/gridlauncher/glinfo.txt") then
        print(5, 140, "If you are using mashers's grid launcher,")
        print(5, 155, "you should use the exit shortcut instead.")
        print(5, 175, "ninjhax 2.5 exit shortcut: L + R + Down + B", c_light_blue)
        print(5, 175, "ninjhax 2.5 exit shortcut:", c_grey)
    end
end)
while true do
    pad = Controls.read()
    if Controls.check(pad, KEY_A) then
        System.exit()
    end
end
