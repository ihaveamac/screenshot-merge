--ihaveamac--
-- https://github.com/ihaveamac/screenshot-merge
-- licensed under the MIT license - see https://github.com/ihaveamac/screenshot-merge/blob/master/LICENSE.md
version = "1.0"

-- input_folder exists for debugging reasons, and the fact that I back up my screenshots
input_folder = "screenshots"
output_folder = "screenshots-merged"

c_white = Color.new(255, 255, 255)
c_grey = Color.new(127, 127, 127)
c_black = Color.new(0, 0, 0)
System.setCpuSpeed(NEW_3DS_CLOCK)
System.createDirectory("/"..input_folder) -- to prevent errors
System.createDirectory("/"..output_folder)

-- this doesn't have a real purpose other than to switch "SD" and "microSD"
model = System.getModel()
--[[
0 = Old 3DS
1 = Old 3DS XL
2 = New 3DS
3 = 2DS
4 = New 3DS XL
]]
sdcardtype = "SD"
if model == 2 or model == 4 then
    sdcardtype = "microSD"
end

function print(x, y, text)
    Screen.debugPrint(x, y, text, c_white, TOP_SCREEN)
end
-- 'cause double buffering stuff
function doubleDraw(func)
    func()
    Screen.flip()
    Screen.refresh()
    func()
end
function drawMain()
    Screen.waitVblankStart()
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.clear(BOTTOM_SCREEN)
    Screen.debugPrint(5, 5, "Screenshot merge "..version, c_white, TOP_SCREEN)
    Screen.debugPrint(5, 5, "ianburgwin.net/scr-merge", c_grey, BOTTOM_SCREEN)
    Screen.fillEmptyRect(6, 394, 17, 18, c_white, TOP_SCREEN)
end

doubleDraw(function()
    drawMain()
    print(5, 25, "This tool will merge all screenshots in the")
    print(5, 40, "\""..input_folder.."\" folder on your 3DS's ")
    print(5, 55, sdcardtype.." card.")
    print(5, 75, "The resulting images will be placed in a")
    print(5, 90, "folder called \""..output_folder.."\".")
    print(5, 110, "If this folder exists, you should back it")
    print(5, 125, "up to prevent conflicts.")
    print(5, 145, "Only those with scr_X_TOP_LEFT.png and")
    print(5, 160, "scr_X_BOTTOM.png will be merged.")
    print(5, 200, "A: next")
    print(5, 215, "B: exit")
end)
repeat
    --noinspection GlobalCreationOutsideO
    pad = Controls.read()
    if Controls.check(pad, KEY_B) then
        System.exit()
    end
until Controls.check(pad, KEY_A)

doubleDraw(function()
    drawMain()
    print(5, 25, "The resulting screenshots will be in bmp")
    print(5, 40, "format with the filename scr_X_MERGED.bmp.")
    print(5, 60, "Getting list of files to merge...")
end)
-- for seeing if a number is already seen
numbers = {}
-- for the actual numbers, checking if TOP_LEFT and BOTTOM exist
files_to_process = {}
for _, v in pairs(System.listDirectory("/"..input_folder)) do
    local num = v.name:sub(5, v.name:find("_", 5) - 1)
    if not numbers[num] then
        numbers[num] = true
    end
end
overwriting_files = false
for k, _ in pairs(numbers) do
    if System.doesFileExist("/"..input_folder.."/scr_"..k.."_TOP_LEFT.png") and System.doesFileExist("/"..input_folder.."/scr_"..k.."_BOTTOM.png") then
        table.insert(files_to_process, k)
        if System.doesFileExist("/"..output_folder.."/scr_"..k.."_MERGED.bmp") then
            overwriting_files = true
        end
    end
end
doubleDraw(function()
    drawMain()
    print(5, 25, "The resulting screenshots will be in bmp")
    print(5, 40, "format with the filename scr_X_MERGED.bmp.")
    print(5, 60, "Processing "..(#files_to_process * 2).." screenshots, ")
    print(5, 75, "creating a total of "..#files_to_process.." images.")
    if overwriting_files then
        -- this will be split into multiple lines
        print(5, 95, "WARNING: It has been detected that some")
        print(5, 110, "files will be overwritten in the process.")
        print(5, 130, "It is highly recommended to move or the")
        print(5, 145, "\""..output_folder.."\" folder before")
        print(5, 160, "starting.")
        print(5, 200, "X: start")
        print(5, 215, "B: exit")
    else
        print(5, 115, "X: start")
        print(5, 130, "B: exit")
    end
end)
repeat
    --noinspection GlobalCreationOutsideO
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
    print(5, 60, "Hold B to stop.")
end)
stop_count = 0
for i = 1, #files_to_process do
    System.deleteFile("/"..output_folder.."/scr_"..files_to_process[i].."_MERGED.bmp")
    local top = Screen.loadImage("/"..input_folder.."/scr_"..files_to_process[i].."_TOP_LEFT.png")
    Screen.drawImage(0, 0, top, TOP_SCREEN)
    Screen.freeImage(top)
    local bottom = Screen.loadImage("/"..input_folder.."/scr_"..files_to_process[i].."_BOTTOM.png")
    Screen.drawImage(0, 0, bottom, BOTTOM_SCREEN)
    Screen.freeImage(bottom)
    System.takeScreenshot("/"..output_folder.."/scr_"..files_to_process[i].."_MERGED.bmp", false)
    doubleDraw(function()
        drawMain()
        print(5, 25, "Processing screenshots...")
        print(5, 45, i)
        print(51, 45, "/")
        print(73, 45, #files_to_process)
        print(160, 45, math.floor((i / #files_to_process) * 100))
        print(190, 45, "%")
        print(5, 60, "Hold B to stop.")
    end)
    --noinspection GlobalCreationOutsideO
    stop_count = i
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
        print(5, 60, "Stopped.")
    else
        print(5, 60, "Done!")
    end
    print(5, 100, "A: exit")
end)
while true do
    --noinspection GlobalCreationOutsideO
    pad = Controls.read()
    if Controls.check(pad, KEY_A) then
        System.exit()
    end
end
