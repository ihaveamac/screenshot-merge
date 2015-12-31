# screenshot-merge
This tool is for really lazy people who want to merge their ninjhax 2.5 and NTR CFW screenshots on their 3DS. Inspired by [RedInquisitive's PC Screenshot Tool](https://github.com/RedInquisitive/Screenshot-Tool).

This uses lpp-3ds r4 by Rinnegatamante. Please see [its repo](https://github.com/Rinnegatamante/lpp-3ds) for more details, including license. Releases use the "unsafe" build with no error handling.

For ninjhax 2.5 screenshots, it searches `/screenshots` for files that match the name `scr_X_TOP_LEFT.png` and `scr_X_BOTTOM.png` and saves the result at `/screenshots-merged/ninjhax/scr_X_MERGED.bmp`.

For NTR CFW screenshots, it searches the root for files that match the name `top_XXXX.bmp` and `bot_XXXX.bmp` and saves the result at `/screenshots-merged/ntr/mrg_XXXX.bmp`.

Merged images are in .bmp format until lpp-3ds can save in .png.

## How to use
Run the tool follow the on-screen prompts.

# License
screenshot-merge is under the MIT license. Lua Player Plus is under the GPLv3 license.
