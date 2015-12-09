--ihaveamac--
-- https://github.com/ihaveamac/screenshot-merge
-- licensed under the MIT license - see https://github.com/ihaveamac/screenshot-merge/blob/master/LICENSE.md
version = "1.0"

c_white = Color.new(255, 255, 255)
System.createDirectory("/screenshots") -- to prevent errors
System.createDirectory("/screenshots-merged")

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
    Screen.fillEmptyRect(6, 394, 17, 18, c_white, TOP_SCREEN)
end

doubleDraw(function()
    drawMain()
    print(5, 25, "This tool will merge all screenshots in the")
    print(5, 40, "\"screenshots\" folder on your 3DS's ")
    print(5, 55, sdcardtype.." card.")
    print(5, 75, "The resulting images will be placed in a")
    print(5, 90, "folder called \"screenshots-merged\".")
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
for _, v in pairs(System.listDirectory("/screenshots")) do
    local num = v.name:sub(5, v.name:find("_", 5) - 1)
    if not numbers[num] then
        numbers[num] = true
    end
end
overwriting_files = false
for k, _ in pairs(numbers) do
    if System.doesFileExist("/screenshots/scr_"..k.."_TOP_LEFT.png") and System.doesFileExist("/screenshots/scr_"..k.."_BOTTOM.png") then
        table.insert(files_to_process, k)
        if System.doesFileExist("/screenshots-merged/scr_"..k.."_MERGED.bmp") then
            overwriting_files = true
        end
    end
end
overwriting_files = true
doubleDraw(function()
    drawMain()
    print(5, 25, "The resulting screenshots will be in bmp")
    print(5, 40, "format with the filename scr_X_MERGED.bmp.")
    print(5, 60, "Processing a total of "..(#files_to_process * 2).." screenshots, ")
    print(5, 75, "creating "..#files_to_process.." images.")
    if overwriting_files then
        -- this will be split into multiple lines
        print(5, 75, "WARNING: It has been detected that some files will be overwritten in the process. It is highly recommended to move or the \"screenshots-merged\" folder before starting.")
    end
end)
repeat
    --noinspection GlobalCreationOutsideO
    pad = Controls.read()
    if Controls.check(pad, KEY_B) then
        System.exit()
    end
until Controls.check(pad, KEY_X)