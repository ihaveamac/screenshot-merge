# screenshot merge
This tool is for really lazy people who want to merge their ninjhax 2.x and NTR CFW screenshots on their 3DS. Inspired by [RedInquisitive's PC Screenshot Tool](https://github.com/RedInquisitive/Screenshot-Tool).

This uses lpp-3ds r5 by Rinnegatamante. Please see [its repo](https://github.com/Rinnegatamante/lpp-3ds) for more details, including license. Releases use the "unsafe" build with no error handling.

The CIA UniqueID is `0xF0ACC`.

## How to use
Run the tool, and follow the on-screen prompts.

For ninjhax 2.x screenshots, it searches `/screenshots` for files that match the name `scr_X_TOP_LEFT.png` and `scr_X_BOTTOM.png`, puts them together, and saves the result at `/screenshots-merged/scr_X_MERGED.bmp`.

For NTR CFW screenshots, it searches the root for files that match the name `top_XXXX.bmp` and `bot_XXXX.bmp` and saves the result at `/screenshots-merged/ntr/mrg_XXXX.bmp`.

Merged images are in .bmp format until lpp-3ds can save in .png.

# Credits/License
screenshot merge is under the MIT license. Lua Player Plus is under the GPLv3 license. `resources/icon.png` and `resources/banner.png` was created by @Favna.