--ihaveamac--
-- https://github.com/ihaveamac/screenshot-merge
-- licensed under the MIT license - see https://github.com/ihaveamac/screenshot-merge/blob/master/LICENSE.md
version = "1.0"

c_white = Color.new(255, 255, 255)

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
function drawMain()
    Screen.clear(TOP_SCREEN)
    Screen.clear(BOTTOM_SCREEN)
    Screen.debugPrint(5, 5, "Screenshot merge "..version, c_white, TOP_SCREEN)
    Screen.fillEmptyRect(6, 394, 17, 18, c_white, TOP_SCREEN)
end

Screen.waitVblankStart()
Screen.refresh()
drawMain()
print(5, 25, "This tool will merge all screenshots in the")
print(5, 40, "\"screenshots\" folder on your 3DS's ")
print(5, 55, sdcardtype.." card.")
print(5, 75, "The resulting images will be placed in a")
print(5, 90, "folder called \"screenshots-merged\".")
Screen.flip()

repeat
    --noinspection GlobalCreationOutsideO
    pad = Controls.read()
    if Controls.check(pad, KEY_B) then
        System.exit()
    end
until Controls.check(pad, KEY_A)