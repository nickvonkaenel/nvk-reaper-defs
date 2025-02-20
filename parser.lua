local header = [[---@diagnostic disable: keyword
---@meta

---@class reaper
reaper = {}

---@class (exact) AudioWriter : userdata
---@class (exact) PackageEntry : userdata
---@class (exact) MRP_Window : userdata
---@class (exact) MRP_Array : userdata
---@class (exact) RprMidiNote : userdata
---@class (exact) RprMidiTake : userdata
---@class (exact) WDL_FastString : userdata
---@class (exact) FxChain : userdata
---@class (exact) CF_Preview : userdata
---@class (exact) BR_Envelope : userdata
---@class (exact) joystick_device : userdata
---@class (exact) HWND : userdata
---@class (exact) IReaperControlSurface : userdata
---@class (exact) TrackEnvelope : userdata
---@class (exact) KbdSectionInfo : userdata
---@class (exact) PCM_source : userdata
---@class (exact) AudioAccessor : userdata
---@class (exact) MediaItem_Take : userdata
---@class (exact) ReaProject : userdata
---@class (exact) MediaItem : userdata
---@class (exact) MediaTrack : userdata
---@class (exact) identifier: userdata
---@class (exact) unsupported: boolean?


---Causes gmem_read()/gmem_write() to read EEL2/JSFX/Video shared memory segment named by parameter. Set to empty string to detach. 6.20+: returns previous shared memory segment name.Must be called, before you can use a specific gmem-variable-index with gmem_write!
---@param sharedMemoryName string
---@return string former_attached_gmemname
function reaper.gmem_attach(sharedMemoryName) end

---Read (number) value from shared memory attached-to by gmem_attach(). index can be [0..1<<25).returns nil if not available
---@param index integer
---@return number retval
function reaper.gmem_read(index) end

---Write (number) value to shared memory attached-to by gmem_attach(). index can be [0..1<<25).Before you can write into a currently unused variable with index "index", you must call gmem_attach first!
---@param index integer
---@param value number
function reaper.gmem_write(index, value) end


--- @class reaper.array : { [integer]: number }
local reaper_array = {}

---Creates a new reaper.array object of maximum and initial size size, if specified, or from the size/values of a table/array. Both size and table/array can be specified, the size parameter will override the table/array size.
--- @overload fun(table: reaper.array): reaper.array
--- @overload fun(table: reaper.array, size: integer): reaper.array
--- @overload fun(size: integer, table: reaper.array): reaper.array
--- @param size integer
--- @return reaper.array
function reaper.new_array(size) end

---Sets the value of zero or more items in the array. If value not specified, 0.0 is used. offset is 1-based, if size omitted then the maximum amount available will be set.
---@param value? number|string
---@param offset? integer
---@param size? integer
---@return boolean retval
function reaper_array.clear(value, offset, size) end

---Convolves complex value pairs from reaper.array, starting at 1-based srcoffs, reading/writing to 1-based destoffs. size is in normal items (so it must be even)
---@param src? reaper.array
---@param srcoffs? integer
---@param size? integer
---@param destoffs? integer
---@return integer retval
function reaper_array.convolve(src, srcoffs, size, destoffs) end

---Copies values from reaper.array or table, starting at 1-based srcoffs, writing to 1-based destoffs.
---@param src? reaper.array
---@param srcoffs? integer
---@param size? integer
---@param destoffs? integer
---@return integer retval
function reaper_array.copy(src, srcoffs, size, destoffs) end

---Performs a forward FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled following the FFT to be in normal order.
---@param size integer
---@param permute? boolean
---@param offset? integer
---@return boolean retval
function reaper_array.fft(size, permute, offset) end

---Performs a forward real->complex FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled following the FFT to be in normal order.
---@param size integer
---@param permute? boolean
---@param offset? integer
---@return boolean retval
function reaper_array.fft_real(size, permute, offset) end

---Returns the maximum (allocated) size of the array.
---@return integer size
function reaper_array.get_alloc() end

---Performs a backwards FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled before the IFFT to be in fft-order.
---@param size integer
---@param permute? boolean
---@param offset? integer
---@return boolean retval
function reaper_array.ifft(size, permute, offset) end

---Performs a backwards complex->real FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled before the IFFT to be in fft-order.
---@param size integer
---@param permute? boolean
---@param offset? integer
---@return boolean retval
function reaper_array.ifft_real(size, permute, offset) end

---Multiplies values from reaper.array, starting at 1-based srcoffs, reading/writing to 1-based destoffs.
---@param src? reaper.array
---@param srcoffs? integer
---@param size? integer
---@param destoffs? number
---@return integer retvals
function reaper_array.multiply(src, srcoffs, size, destoffs) end

---Resizes an array object to size. size must be [0..max_size].
---@param size integer
---@return boolean retval
function reaper_array.resize(size) end

---Returns a new table with values from items in the array. Offset is 1-based and if size is omitted all available values are used.
---@param offset? integer
---@param size? integer
---@return table new_table
function reaper_array.table(offset, size) end

--- @class gfx
--- @field r number current red component (0..1) used by drawing operations.
--- @field g number current green component (0..1) used by drawing operations.
--- @field b number current blue component (0..1) used by drawing operations.
--- @field a2 number  current alpha component (0..1) used by drawing operations when writing solid colors (normally ignored but useful when creating transparent images).
--- @field a number alpha for drawing (1=normal).
--- @field mode number blend mode for drawing. Set mode to 0 for default options. Add 1.0 for additive blend mode (if you wish to do subtractive, set gfx.a to negative and use gfx.mode as additive). Add 2.0 to disable source alpha for gfx.blit(). Add 4.0 to disable filtering for gfx.blit().
--- @field w number width of the UI framebuffer.
--- @field h number height of the UI framebuffer.
--- @field x number current graphics position X. Some drawing functions use as start position and update.
--- @field y number current graphics position Y. Some drawing functions use as start position and update.
--- @field clear number if greater than -1.0, framebuffer will be cleared to that color. the color for this one is packed RGB (0..255), i.e. red+green*256+blue*65536. The default is 0 (black).
--- @field dest number destination for drawing operations, -1 is main framebuffer, set to 0..1024-1 to have drawing operations go to an offscreen buffer (or loaded image).
--- @field texth number the (READ-ONLY) height of a line of text in the current font. Do not modify this variable.
--- @field ext_retina number to support hidpi/retina, callers should set to 1.0 on initialization, this value will be updated to value greater than 1.0 (such as 2.0) if retina/hidpi. On macOS gfx.w/gfx.h/etc will be doubled, but on other systems gfx.w/gfx.h will remain the same and gfx.ext_retina is a scaling hint for drawing.
--- @field mouse_x number current X coordinate of the mouse relative to the graphics window.
--- @field mouse_y number current Y coordinate of the mouse relative to the graphics window.
--- @field mouse_wheel number wheel position, will change typically by 120 or a multiple thereof, the caller should clear the state to 0 after reading it.
--- @field mouse_hwheel number horizontal wheel positions, will change typically by 120 or a multiple thereof, the caller should clear the state to 0 after reading it.
--- @field mouse_cap number a bitfield of mouse and keyboard modifier state:
gfx = {}

---Draws an arc of the circle centered at x,y, with ang1/ang2 being specified in radians.
---@param x number
---@param y number
---@param r number
---@param ang1 number
---@param ang2 number
---@param antialias? number
function gfx.arc(x, y, r, ang1, ang2, antialias) end

---Blits(draws) the content of source-image to another source-image or an opened window.Copies from source (-1 = main framebuffer, or an image from gfx.loadimg() etc), using current opacity and copy mode (set with gfx.a, gfx.mode).If destx/desty are not specified, gfx.x/gfx.y will be used as the destination position.scale (1.0 is unscaled) will be used only if destw/desth are not specified.rotation is an angle in radianssrcx/srcy/srcw/srch specify the source rectangle (if omitted srcw/srch default to image size)destx/desty/destw/desth specify destination rectangle (if not specified destw/desth default to srcw/srch * scale).
---@param source number
---@param scale number
---@param rotation number
---@param srcx? number
---@param srcy? number
---@param srcw? number
---@param srch? number
---@param destx? number
---@param desty? number
---@param destw? number
---@param desth? number
---@param rotxoffs? number
---@param rotyoffs? number
---@return number source
function gfx.blit(source, scale, rotation, srcx, srcy, srcw, srch, destx, desty, destw, desth, rotxoffs, rotyoffs) end

---Deprecated, use gfx.blit instead.Note: the naming of the function might be misleading, as it has nothing to do with blitting of text, but rather is called Blit Ext.
---@param source number
---@param coordinatelist number
---@param rotation number
---@return number retval
function gfx.blitext(source, coordinatelist, rotation) end

---Blurs the region of the screen between gfx.x,gfx.y and x,y, and updates gfx.x,gfx.y to x,y.
---@param x number
---@param y number
function gfx.blurto(x, y) end

---Draws a circle, optionally filling/antialiasing. 
---@param x number
---@param y number
---@param r number
---@param fill? number
---@param antialias? number
function gfx.circle(x, y, r, fill, antialias) end

---Converts the coordinates x,y to screen coordinates, returns those values.
---@param x number
---@param y number
---@return number convx
---@return number convy
function gfx.clienttoscreen(x, y) end

---Blits from srcimg(srcs,srct,srcw,srch) to destination (destx,desty,destw,desth). Source texture coordinates are s/t, dsdx represents the change in s coordinate for each x pixel, dtdy represents the change in t coordinate for each y pixel, etc. dsdxdy represents the change in dsdx for each line. If usecliprect is specified and 0, then srcw/srch are ignored.This function allows you to manipulate the image, which you want to blit, by transforming, moving or cropping it.To do rotation, you can manipulate dtdx and dsdy together.
---@param srcimg number
---@param srcs number
---@param srct number
---@param srcw number
---@param srch number
---@param destx number
---@param desty number
---@param destw number
---@param desth number
---@param dsdx number
---@param dtdx number
---@param dsdy number
---@param dtdy number
---@param dsdxdy number
---@param dtdxdy number
---@param usecliprect? number
---@return number retval
function gfx.deltablit(srcimg, srcs, srct, srcw, srch, destx, desty, destw, desth, dsdx, dtdx, dsdy, dtdy, dsdxdy, dtdxdy, usecliprect) end

---Queries or sets the docking-state of the gfx.init()-window.
---Call with v=-1 to query docked state, otherwise v>=0 to set docked state. 
---State is &1 if docked, second byte is docker index (or last docker index if undocked). If you pass numbers to wx-wh, you can query window size and position additionally to the dock-stateA specific docking index does not necessarily represent a specific docker, means, you can not query/set left docker top, but rather all dockers that exist in the current screenset.
---So the first queried/set docker can be top-left-docker or the top docker or even one of the bottom dockers.
---The order doesn't seem to make any sense. Especially with more than 16 windows docked in the current screenset.
---@param v number
---@param wx? number
---@param wy? number
---@param ww? number
---@param wh? number
---@return number querystate
---@return number|nil window_x_position
---@return number|nil window_y_position
---@return number|nil window_width
---@return number|nil window_height
function gfx.dock(v, wx, wy, ww, wh) end

---Draws the character (can be a numeric ASCII code as well), to gfx.x, gfx.y, and moves gfx.x over by the size of the character.
---@param char number
---@return number char
function gfx.drawchar(char) end

---Draws the number n with ndigits of precision to gfx.x, gfx.y, and updates gfx.x to the right side of the drawing. The text height is gfx.texth.
---@param n number
---@param ndigits number
---@return number retval
function gfx.drawnumber(n, ndigits) end

---Draws a string at gfx.x, gfx.y, and updates gfx.x/gfx.y so that subsequent draws will occur in a similar place.You can optionally set a clipping area for the text, if you set parameter flags&256 and the parameters right and bottom.On Windows, fonts with a size > 255 may have trouble of being displayed correctly, due problems with the font-rendering and the alpha-channel. <a href="https://forum.cockos.com/showpost.php?p=2311977&postcount=7">Justin's post about this.</a>
---To overcome this, try this to disable the alpha-channel: 
---By default, gfx.blit() blits with alpha channel. You can disable this behavior by setting "gfx.mode=2" before calling gfx.blit().
---@param str string
---@param flags? number
---@param right? number
---@param bottom? number
---@return number retval
function gfx.drawstr(str, flags, right, bottom) end

---If char is 0 or omitted, returns a character from the keyboard queue, or 0 if no character is available, or -1 if the graphics window is not open. If char is specified and nonzero, that character's status will be checked, and the function will return greater than 0 if it is pressed. Note that calling gfx.getchar() at least once causes gfx.mouse_cap to reflect keyboard modifiers even when the mouse is not captured.</p><p>Common values are standard ASCII, such as 'a', 'A', '=' and '1', but for many keys multi-byte values are used, including 'home', 'up', 'down', 'left', 'rght', 'f1'.. 'f12', 'pgup', 'pgdn', 'ins', and 'del'<br>
---Modified and special keys can also be returned, including:<br>
---
---* Ctrl/Cmd+A..Ctrl+Z as 1..26
---* Ctrl/Cmd+Alt+A..Z as 257..282
---* Alt+A..Z as 'A'+256..'Z'+256
---* 27 for ESC
---* 13 for Enter
---* ' ' for space
---* 65536 for query of special flags, returns:1 (supported), 2=window has focus, 4=window is visible
---If unichar is specified, it will be set to the unicode value of the key if available (and the return value may be the unicode value or a raw key value as described above, depending). If unichar is not specified, unicode codepoints greater than 255 will be returned as 24 + value<br>
---@param character? number
---@param unicode_char? number
---@return number charactercode
function gfx.getchar(character, unicode_char) end

---Returns filenames, drag'n'dropped into a window created by gfx.init().
---Use idx to get a specific filename, that has been dropped into the gfx.init()-window.When returned filename starts with @fx: it is an fx dropped.
---      
---Does NOT support mediaitems/takes or other Reaper-objects!It MUST be called BEFORE calling gfx.update, as gfx.update flushes the filelist accessible with gfx.getdropfile.
---@param idx number
---@return number retval
---@return string|nil filename
function gfx.getdropfile(idx) end

---Returns current font index, and the actual font face used by this font (if available).Use gfx.setfont to set a font for a specific index.
---@return number fontindex
---@return string fontface
function gfx.getfont() end

---Retrieves the dimensions of an image specified by handle, returns w, h pair.
---Handle is basically a frame-buffer.
---@param handle number
---@return number w
---@return number h
function gfx.getimgdim(handle) end

---Returns r,g,b values [0..1] of the pixel at (gfx.x,gfx.y)
---@return number r
---@return number g
---@return number b
function gfx.getpixel() end

---Fills a gradient rectangle with the color and alpha specified. drdx-dadx reflect the adjustment (per-pixel) applied for each pixel moved to the right, drdy-dady are the adjustment applied for each pixel moved toward the bottom. Normally drdx=adjustamount/w, drdy=adjustamount/h, etc.
---@param x number
---@param y number
---@param w number
---@param h number
---@param r number
---@param g number
---@param b number
---@param a number
---@param drdx? number
---@param dgdx? number
---@param dbdx? number
---@param dadx? number
---@param drdy? number
---@param dgdy? number
---@param dbdy? number
---@param dady? number
---@return number retval
function gfx.gradrect(x, y, w, h, r, g, b, a, drdx, dgdx, dbdx, dadx, drdy, dgdy, dbdy, dady) end

---Initializes the graphics window with title name. Suggested width and height can be specified.Once the graphics window is open, gfx.update() should be called periodically. Only one graphics-window can be opened per script! Calling gfx.ini after a window has been opened has no effect.To resize/reposition the window, call gfx.init again and pass an empty string as name-parameter.To retitle the window, run gfx.init again with the new title as parameter name.To get the current window-states, dimensions, etc, you can use gfx.dock).
---@param name string
---@param width? number
---@param height? number
---@param dockstate? number
---@param xpos? number
---@param ypos? number
---@return number retval
function gfx.init(name, width, height, dockstate, xpos, ypos) end

---Draws a line from x,y to x2,y2, and if aa is not specified or 0.5 or greater, it will be antialiased. 
---@param x number
---@param y number
---@param x2 number
---@param y2 number
---@param aa? number
---@return number retval
function gfx.line(x, y, x2, y2, aa) end

---Draws a line from gfx.x,gfx.y to x,y. If aa is 0.5 or greater, then antialiasing is used. Updates gfx.x and gfx.y to x,y.
---@param x number
---@param y number
---@param aa number
---@return number retval
function gfx.lineto(x, y, aa) end

---Load image from filename into slot 0..1024-1 specified by image. Returns the image index if success, otherwise -1 if failure. The image will be resized to the dimensions of the image file. 
---@param image number
---@param filename string
---@return number retval
function gfx.loadimg(image, filename) end

---Measures the drawing dimensions of a character with the current font (as set by gfx.setfont). Returns width and height of character.
---@param char number
---@return number width
---@return number height
function gfx.measurechar(char) end

---Measures the drawing dimensions of a string with the current font (as set by gfx.setfont). Returns width and height of string.
---@param str string
---@return number width
---@return number height
function gfx.measurestr(str) end

---Multiplies each pixel within the given rectangle(x,y,w,h) by the mul_*-parameters and optionally adds add_*-parameters, and updates in-place. Useful for changing brightness/contrast, or other effects.The multiplied values usually affect only pixels, that are not black(0,0,0,0), while the added values affect all pixels.
---@param x number
---@param y number
---@param w number
---@param h number
---@param mul_r number
---@param mul_g number
---@param mul_b number
---@param mul_a? number
---@param add_r? number
---@param add_g? number
---@param add_b? number
---@param add_a? number
---@return number retval
function gfx.muladdrect(x, y, w, h, mul_r, mul_g, mul_b, mul_a, add_r, add_g, add_b, add_a) end

---Formats and draws a string at gfx.x, gfx.y, and updates gfx.x/gfx.y accordingly (the latter only if the formatted string contains newline). For more information on format strings, see sprintf()
---* %% = %
---* %s = string from parameter
---* %d = parameter as integer
---* %i = parameter as integer
---* %u = parameter as unsigned integer
---* %x = parameter as hex (lowercase) integer
---* %X = parameter as hex (uppercase) integer
---* %c = parameter as character
---* %f = parameter as floating point
---* %e = parameter as floating point (scientific notation, lowercase)
---* %E = parameter as floating point (scientific notation, uppercase)
---* %g = parameter as floating point (shortest representation, lowercase)
---* %G = parameter as floating point (shortest representation, uppercase)
---
---Many standard C printf() modifiers can be used, including:    
---* %.10s = string, but only print up to 10 characters
---* %-10s = string, left justified to 10 characters
---* %10s = string, right justified to 10 characters
---* %+f = floating point, always show sign
---* %.4f = floating point, minimum of 4 digits after decimal point
---* %10d = integer, minimum of 10 digits (space padded)
---* %010f = integer, minimum of 10 digits (zero padded)Values for format specifiers can be specified as additional parameters to gfx.printf, or within {} in the format specifier (such as %{varname}d, in that case a global variable is always used).
---@param format string
---@param ... any
---@return number retval
function gfx.printf(format, ...) end

---Closes the graphics window.
---@return number retval
function gfx.quit() end

---Fills a rectangle at x,y, w,h pixels in dimension, filled by default. 
---@param x number
---@param y number
---@param w number
---@param h number
---@param filled? number
---@return number retval
function gfx.rect(x, y, w, h, filled) end

---Fills a rectangle from gfx.x,gfx.y to x,y. Updates gfx.x,gfx.y to x,y. 
---@param x number
---@param y number
---@return number x_coordinate
function gfx.rectto(x, y) end

---Draws a rectangle with rounded corners. 
---@param x number
---@param y number
---@param w number
---@param h number
---@param radius number
---@param antialias? number
---@return number retval
function gfx.roundrect(x, y, w, h, radius, antialias) end

---Converts the screen coordinates x,y to client coordinates, returns those values.
---@param x number
---@param y number
---@return number convx
---@return number convy
function gfx.screentoclient(x, y) end

---Sets color, drawing mode and optionally the drawing-image-source-destination.
---If sets the corresponding gfx-variables.
---Sets gfx.r/gfx.g/gfx.b/gfx.a2/gfx.mode sets gfx.dest if final parameter specified
---@param r number
---@param g? number
---@param b? number
---@param a2? number
---@param mode? number
---@param dest? number
---@return number retval
function gfx.set(r, g, b, a2, mode, dest) end

---Sets the mouse cursor. resource_id is a value like 32512 (for an arrow cursor), custom_cursor_name is a string like "arrow" (for the REAPER custom arrow cursor). resource_id must be nonzero, but custom_cursor_name is optional.examples for resource_id:
---* 101, enter text
---* 102, hourglass
---* 103, cross
---* 104, arrow up
---* 105, arrows to left up AND right down
---* 106, arrows to left down AND right up
---* 107, arrows to left AND right
---* 108, arrows to up AND down
---* 109, arrows to up, down, left and right
---* 110, stop sign
---* 111, arrow with hourglass
---* 112, arrow with question mark
---* 113, a pen
---* 114, hand with index finger pointing
---* 115, a square
---* 116, arrow with cd
---    
---works only with gfx-window opened.
---@param resource_id? number
---@param custom_cursor_name? string
---@return number retval
function gfx.setcursor(resource_id, custom_cursor_name) end

---Can select a font and optionally configure it. After calling gfx_setfont(), gfx_texth may be updated to reflect the new average line height.
---@param idx number
---@param fontface? string
---@param sz? number
---@param flags? number
---@return number retval
function gfx.setfont(idx, fontface, sz, flags) end

---Resize image referenced by index 0..1024-1, width and height must be 0-8192. The contents of the image will be undefined after the resize.
---@param image number
---@param w number
---@param h number
---@return number retval
function gfx.setimgdim(image, w, h) end

---Writes a pixel of r,g,b to gfx.x,gfx.y.
---@param r number
---@param g number
---@param b number
---@return number retval
function gfx.setpixel(r, g, b) end

---Shows a popup menu at gfx_x,gfx_y. 
---str is a list of fields separated by | characters. Each field represents a menu item.
---Fields can start with special characters:# : grayed out
---* ! : checked
---* \> : this menu item shows a submenu
---* < : last item in the current submenu
---* & : before a character makes it underlined as the quick-access-character for this menu-item
---An empty field || will appear as a separator in the menu. Example:<br>
---selection = gfx.showmenu("first item, followed by separator||!second item, checked|>third item which spawns a submenu|#first item in submenu, grayed out|>second and last item in submenu|fourth item in top menu")gfx.showmenu returns 0 if the user selected nothing from the menu, 1 if the first field is selected, etc.
---Note: It skips submenus and separators in the selection-number, so a if menu_string="Entry1||<Entry two|Entry three" will only return 1 for entry1 and 2 for Entry three but nothing for <Entry and ||.
---@param menu_string string
---@return number selection
function gfx.showmenu(menu_string) end

---Blits to destination at (destx,desty), size (destw,desth). div_w and div_h should be 2..64, and table should point to a table of 2*div_w*div_h values (table can be a regular table or (for less overhead) a reaper.array). Each pair in the table represents a S,T coordinate in the source image, and the table is treated as a left-right, top-bottom list of texture coordinates, which will then be rendered to the destination.
---
---@param srcimg number
---@param destx number
---@param desty number
---@param destw number
---@param desth number
---@param div_w number
---@param div_h number
---@param table table|reaper.array
---@return number retval
function gfx.transformblit(srcimg, destx, desty, destw, desth, div_w, div_h, table) end

---Draws a filled triangle, or any convex polygon. 
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param x3 number
---@param y3 number
---@param x4? number
---@param y4? number
---@param ... number
---@return number retval
function gfx.triangle(x1, y1, x2, y2, x3, y3, x4, y4, ... ) end

---Updates the graphics display, if opened
---@return number retval
function gfx.update() end

---Returns the path to the directory containing imgui.lua, imgui.py and gfx2imgui.lua.
---@return string path
function reaper.ImGui_GetBuiltinPath() end
]]

--------------------------------------------------------------------------------
-- Helper: Remove HTML tags and convert <br> to newlines.
local function strip_html(s)
	s = s:gsub("<br>", "\n")
	s = s:gsub("<.->", "")
	-- Decode common HTML entities:
	s = s:gsub("&amp;", "&")
	s = s:gsub("&lt;", "<")
	s = s:gsub("&gt;", ">")
	s = s:gsub("&quot;", '"')
	s = s:gsub("&#39;", "'")
	return s:gsub("^%s*(.-)%s*$", "%1")
end

--------------------------------------------------------------------------------
-- Parse the Lua function signature.
-- Returns a table with:
--   func_name (e.g. "reaper.Xen_AudioWriter_Create")
--   ret_type (or nil if none)
--   params (a list of { name, type, optional })
local function parse_lua_signature(sig)
	local ret_types = {}
	local func_name, params_str

	if sig:find("=") then
		-- Handle multiple return values.
		local ret_part, rest = sig:match("^(.-)%s*=%s*(.*)$")
		if not ret_part or not rest then
			error("Could not split return part and function signature in: " .. sig)
		end
		-- Parse each return value from the left side.
		for part in ret_part:gmatch("[^,]+") do
			part = part:match("^%s*(.-)%s*$")
			if #part > 0 then
				local type_str, name = part:match("^<i>(.-)</i>%s*(%S+)$")
				local optional_ret = false
				if type_str and type_str:match("^optional%s+") then
					optional_ret = true
					type_str = type_str:gsub("^optional%s+", "")
				end
				if not type_str then
					-- Try matching just the type without a name.
					type_str = part:match("^<i>(.-)</i>%s*$")
					if type_str then
						name = "retval"
					else
						error("Could not parse return type part: " .. part)
					end
				end
				-- Remove stray italic tags.
				type_str = type_str:gsub("</?i>", "")
				if name then
					name = name:gsub("</?i>", "")
				end
				table.insert(ret_types, { type = type_str, name = name, optional = optional_ret })
			end
		end
		func_name, params_str = rest:match("^(reaper%.[%w_]+)%s*%((.-)%)")
		if not func_name then
			error("Could not parse function name from: " .. rest)
		end
	else
		-- No '=' present; check for an inline return type.
		local ret_type = sig:match("^<i>(.-)</i>%s+")
		if ret_type then
			func_name, params_str = sig:match("^<i>.-</i>%s+(reaper%.[%w_]+)%s*%((.-)%)")
			if not func_name then
				error("Could not parse function name from: " .. sig)
			end
			ret_types = { { type = ret_type, name = "retval" } }
		else
			func_name, params_str = sig:match("^(reaper%.[%w_]+)%s*%((.-)%)")
			if not func_name then
				error("Could not parse function name from: " .. sig)
			end
			ret_types = {}
		end
	end

	local params = {}
	for param in params_str:gmatch("[^,]+") do
		param = param:match("^%s*(.-)%s*$")
		if #param > 0 then
			-- Try matching an italic tag first…
			local type_str, name = param:match("^<i>(.-)</i>%s*(%S+)$")
			if not type_str then
				-- …and if that fails, try matching a bold tag.
				type_str, name = param:match("^<b>(.-)</b>%s*(%S+)$")
			end
			if not type_str then
				name = param
				type_str = "any"
			end
			-- Remove any stray italic or bold tags from type and name.
			type_str = type_str:gsub("</?i>", ""):gsub("</?b>", "")
			if name then
				name = name:gsub("</?i>", ""):gsub("</?b>", "")
				-- Also replace dots in parameter names (e.g. r.left => r_left)
				name = name:gsub("%.", "_")
			end
			local optional = false
			if type_str:match("^optional%s+") then
				optional = true
				type_str = type_str:gsub("^optional%s+", "")
			end
			if type_str == "identifier" then
				type_str = "userdata"
			end
			table.insert(params, { name = name, type = type_str, optional = optional })
		end
	end

	return {
		func_name = func_name,
		ret_types = ret_types,
		params = params,
	}
end

--------------------------------------------------------------------------------
-- Parse one function block.
-- Expects block text containing several <div> elements and a trailing description.
local function parse_block(block)
	-- Extract the Lua signature from the <div class="l_func"> block.
	local lua_sig = block:match('<div class="l_func">.-<code>(.-)</code>')
	if not lua_sig then
		return nil -- skip if no Lua definition found
	end

	local parsed = parse_lua_signature(lua_sig)

	-- Remove all <div ...>...</div> blocks to avoid extra signatures in the description.
	local description_raw = block:gsub('<div class=".-">.-</div>', "")
	-- Now strip remaining HTML (like <br> tags)
	parsed.description = strip_html(description_raw)
	return parsed
end

--------------------------------------------------------------------------------
-- Parse all function blocks in the HTML defs.
local function parse_all(html)
	local funcs = {}
	-- Remove all hyperlink tags with href so they don't interfere.
	html = html:gsub('<a%s+href=".-">(.-)</a>', "%1")

	local pos = 1
	while true do
		-- Find the next block anchor.
		local start_pos, end_pos, anchor = html:find('<a name="(.-)"><hr></a>', pos)
		if not start_pos then
			break
		end

		-- Find the start of the next anchor.
		local next_anchor_pos = html:find('<a name="', end_pos + 1)
		local block
		if next_anchor_pos then
			block = html:sub(end_pos + 1, next_anchor_pos - 1)
		else
			block = html:sub(end_pos + 1)
		end

		-- Skip if the anchor is "END" or if parse_block returns nil.
		if anchor ~= "END" then
			local func = parse_block(block)
			if func then
				table.insert(funcs, func)
			end
		end

		pos = next_anchor_pos or (#html + 1)
	end

	return funcs
end

--------------------------------------------------------------------------------
-- Generate the annotated Lua stub for a given parsed function.
local function generate_stub(func)
	local lines = {}
	if func.description and #func.description > 0 then
		for line in func.description:gmatch("[^\n]+") do
			table.insert(lines, "---" .. line)
		end
	end
	for _, p in ipairs(func.params) do
		local pname = p.optional and (p.name .. "?") or p.name
		p.type = p.type:gsub("ReaProject", "ReaProject|nil|0")
		table.insert(lines, string.format("---@param %s %s", pname, p.type))
	end
	for _, ret in ipairs(func.ret_types or {}) do
		local trimmed_type = ret.type:gsub("%s+$", "")
		local rettype = trimmed_type .. (ret.optional and "?" or "")
		table.insert(lines, string.format("---@return %s %s", rettype, ret.name))
	end
	local param_names = {}
	for _, p in ipairs(func.params) do
		table.insert(param_names, p.name)
	end
	table.insert(lines, string.format("function %s(%s) end", func.func_name, table.concat(param_names, ", ")))
	return table.concat(lines, "\n")
end

local r = reaper

local html_defs
local file_path = r.GetExtState("ReaScript_API_Generator", "html_file_path")

if file_path == "" or not r.file_exists(file_path) then
	r.Main_OnCommand(41065, 0) -- ReaScript: Open ReaScript documentation (html)...
	local retval, new_path = r.GetUserInputs("HTML File Path", 1, "Enter path to HTML file:,extrawidth=100", "")
	if not retval then
		return
	end
	file_path = new_path:gsub("^file:/+", "")
	r.SetExtState("ReaScript_API_Generator", "html_file_path", file_path, true)
end

local html_file = io.open(file_path, "r")
if html_file then
	html_defs = html_file:read("*all")
	html_file:close()
else
	r.ShowMessageBox("Could not open file: " .. file_path, "Error", 0)
	return
end
--------------------------------------------------------------------------------
-- Main: Parse the input HTML and generate stubs.
local funcs = parse_all(html_defs)
local output = { header }
for _, func in ipairs(funcs) do
	table.insert(output, generate_stub(func))
	table.insert(output, "") -- add a blank line between functions
end

local output_path = debug.getinfo(1, "S").source:match("@(.*)[\\/].*$") .. "/reaper_defs.lua"
local output_file = io.open(output_path, "w")
if output_file then
	output_file:write(table.concat(output, "\n"))
	output_file:close()
	reaper.ShowMessageBox("Stubs written to: " .. output_path, "Success", 0)
else
	reaper.ShowMessageBox("Could not write to file: " .. output_path, "Error", 0)
end
