---@diagnostic disable: keyword
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

---creates a new media item.
---@param tr MediaTrack
---@return MediaItem retval
function reaper.AddMediaItemToTrack(tr) end

---Returns the index of the created marker/region, or -1 on failure. Supply wantidx>=0 if you want a particular index number, but you'll get a different index number a region and wantidx is already in use. color should be 0 (default color), or ColorToNative(r,g,b)|0x1000000
---@param proj ReaProject
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param wantidx integer
---@param color integer
---@return integer retval
function reaper.AddProjectMarker2(proj, isrgn, pos, rgnend, name, wantidx, color) end

---creates a new take in an item
---@param item MediaItem
---@return MediaItem_Take retval
function reaper.AddTakeToMediaItem(item) end

---forceset=0,doupd=true,centermode=-1 for default
---@param amt number
---@param forceset integer
---@param doupd boolean
---@param centermode integer
function reaper.adjustZoom(amt, forceset, doupd, centermode) end

---Returns true if function_name exists in the REAPER API
---@param function_name string
---@return boolean retval
function reaper.APIExists(function_name) end

---nudgeflag: &1=set to value (otherwise nudge by value), &2=snap
---nudgewhat: 0=position, 1=left trim, 2=left edge, 3=right edge, 4=contents, 5=duplicate, 6=edit cursor
---nudgeunit: 0=ms, 1=seconds, 2=grid, 3=256th notes, ..., 15=whole notes, 16=measures.beats (1.15 = 1 measure + 1.5 beats), 17=samples, 18=frames, 19=pixels, 20=item lengths, 21=item selections
---value: amount to nudge by, or value to set to
---reverse: in nudge mode, nudges left (otherwise ignored)
---copies: in nudge duplicate mode, number of copies (otherwise ignored)
---@param project ReaProject
---@param nudgeflag integer
---@param nudgewhat integer
---@param nudgeunits integer
---@param value number
---@param reverse boolean
---@param copies integer
---@return boolean retval
function reaper.ApplyNudge(project, nudgeflag, nudgewhat, nudgeunits, value, reverse, copies) end

---open all audio and MIDI devices, if not open
function reaper.Audio_Init() end

---is audio running at all? threadsafe
---@return integer retval
function reaper.Audio_IsRunning() end

---Returns true if the underlying samples (track or media item take) have changed, but does not update the audio accessor, so the user can selectively call AudioAccessorValidateState only when needed. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param accessor AudioAccessor
---@return boolean retval
function reaper.AudioAccessorStateChanged(accessor) end

---Validates the current state of the audio accessor -- must ONLY call this from the main thread. Returns true if the state changed.
---@param accessor AudioAccessor
---@return boolean retval
function reaper.AudioAccessorValidateState(accessor) end

---Calculates loudness statistics of media via dry run render. Statistics will be displayed to the user; call GetSetProjectInfo_String("RENDER_STATS") to retrieve via API. Returns 1 if loudness was calculated successfully, -1 if user canceled the dry run render.
---@param mediasource PCM_source
---@return integer retval
function reaper.CalcMediaSrcLoudness(mediasource) end

function reaper.ClearAllRecArmed() end

---resets the global peak caches
function reaper.ClearPeakCache() end

---Make an OS dependent color from RGB values (e.g. RGB() macro on Windows). r,g and b are in [0..255]. See ColorFromNative.
---@param r integer
---@param g integer
---@param b integer
---@return integer retval
function reaper.ColorToNative(r, g, b) end

---Returns the number of automation items on this envelope. See GetSetAutomationItemInfo
---@param env TrackEnvelope
---@return integer retval
function reaper.CountAutomationItems(env) end

---Returns the number of points in the envelope.
---autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration,
---even if the automation item is trimmed so that not all points are visible.
---Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations.
---See GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@return integer retval
function reaper.CountEnvelopePointsEx(envelope, autoitem_idx) end

---num_markersOut and num_regionsOut may be NULL.
---@param proj ReaProject
---@return integer retval
---@return integer num_markers
---@return integer num_regions
function reaper.CountProjectMarkers(proj) end

---Count the number of selected tracks in the project (proj=0 for active project). This function ignores the master track, see CountSelectedTracks2.
---@param proj ReaProject
---@return integer retval
function reaper.CountSelectedTracks(proj) end

---See GetTakeEnvelope
---@param take MediaItem_Take
---@return integer retval
function reaper.CountTakeEnvelopes(take) end

---Count the number of FX parameter knobs displayed on the track control panel.
---@param project ReaProject
---@param track MediaTrack
---@return integer retval
function reaper.CountTCPFXParms(project, track) end

---see GetTrackEnvelope
---@param track MediaTrack
---@return integer retval
function reaper.CountTrackEnvelopes(track) end

---count the number of tracks in the project (proj=0 for active project)
---@param proj ReaProject
---@return integer retval
function reaper.CountTracks(proj) end

---Create an audio accessor object for this take. Must only call from the main thread. See CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param take MediaItem_Take
---@return AudioAccessor retval
function reaper.CreateTakeAudioAccessor(take) end

---Create a send/receive (desttrInOptional!=NULL), or a hardware output (desttrInOptional==NULL) with default properties, return >=0 on success (== new send/receive index). See RemoveTrackSend, GetSetTrackSendInfo, GetTrackSendInfo_Value, SetTrackSendInfo_Value.
---@param tr MediaTrack
---@param desttrIn MediaTrack
---@return integer retval
function reaper.CreateTrackSend(tr, desttrIn) end

---@param trackid MediaTrack
---@param isPan integer
---@return boolean retval
function reaper.CSurf_GetTouchState(trackid, isPan) end

function reaper.CSurf_GoStart() end

---@param whichdir integer
---@param wantzoom boolean
function reaper.CSurf_OnArrow(whichdir, wantzoom) end

---@param trackid MediaTrack
---@param en integer
---@return boolean retval
function reaper.CSurf_OnFXChange(trackid, en) end

---@param trackid MediaTrack
---@param monitor integer
---@param allowgang boolean
---@return integer retval
function reaper.CSurf_OnInputMonitorChangeEx(trackid, monitor, allowgang) end

---@param trackid MediaTrack
---@param mute integer
---@param allowgang boolean
---@return boolean retval
function reaper.CSurf_OnMuteChangeEx(trackid, mute, allowgang) end

---@param trackid MediaTrack
---@param pan number
---@param relative boolean
---@param allowGang boolean
---@return number retval
function reaper.CSurf_OnPanChangeEx(trackid, pan, relative, allowGang) end

function reaper.CSurf_OnPlay() end

---@param trackid MediaTrack
---@param recarm integer
---@return boolean retval
function reaper.CSurf_OnRecArmChange(trackid, recarm) end

function reaper.CSurf_OnRecord() end

---@param trackid MediaTrack
---@param recv_index integer
---@param volume number
---@param relative boolean
---@return number retval
function reaper.CSurf_OnRecvVolumeChange(trackid, recv_index, volume, relative) end

---@param seekplay integer
---@param dir integer
function reaper.CSurf_OnRewFwd(seekplay, dir) end

---@param trackid MediaTrack
---@param selected integer
---@return boolean retval
function reaper.CSurf_OnSelectedChange(trackid, selected) end

---@param trackid MediaTrack
---@param send_index integer
---@param volume number
---@param relative boolean
---@return number retval
function reaper.CSurf_OnSendVolumeChange(trackid, send_index, volume, relative) end

---@param trackid MediaTrack
---@param solo integer
---@param allowgang boolean
---@return boolean retval
function reaper.CSurf_OnSoloChangeEx(trackid, solo, allowgang) end

---@param bpm number
function reaper.CSurf_OnTempoChange(bpm) end

---@param trackid MediaTrack
---@param volume number
---@param relative boolean
---@return number retval
function reaper.CSurf_OnVolumeChange(trackid, volume, relative) end

---@param trackid MediaTrack
---@param width number
---@param relative boolean
---@return number retval
function reaper.CSurf_OnWidthChange(trackid, width, relative) end

---@param xdir integer
---@param ydir integer
function reaper.CSurf_OnZoom(xdir, ydir) end

---@param amt number
function reaper.CSurf_ScrubAmt(amt) end

---@param play boolean
---@param pause boolean
---@param rec boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetPlayState(play, pause, rec, ignoresurf) end

---@param trackid MediaTrack
---@param mute boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceMute(trackid, mute, ignoresurf) end

---@param trackid MediaTrack
---@param recarm boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceRecArm(trackid, recarm, ignoresurf) end

---@param trackid MediaTrack
---@param solo boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceSolo(trackid, solo, ignoresurf) end

function reaper.CSurf_SetTrackListChange() end

---@param track MediaTrack
---@param mcpView boolean
---@return integer retval
function reaper.CSurf_TrackToID(track, mcpView) end

---Delete the specific shortcut for the given command ID.
---See CountActionShortcuts, GetActionShortcutDesc, DoActionShortcutDialog.
---@param section KbdSectionInfo
---@param cmdID integer
---@param shortcutidx integer
---@return boolean retval
function reaper.DeleteActionShortcut(section, cmdID, shortcutidx) end

---Delete a range of envelope points. See DeleteEnvelopePointRangeEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param time_start number
---@param time_end number
---@return boolean retval
function reaper.DeleteEnvelopePointRange(envelope, time_start, time_end) end

---Delete the extended state value for a specific section and key. persist=true means the value should remain deleted the next time REAPER is opened. See SetExtState, GetExtState, HasExtState.
---@param section string
---@param key string
---@param persist boolean
function reaper.DeleteExtState(section, key, persist) end

---Differs from DeleteProjectMarker only in that markrgnidx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than representing the displayed marker/region ID number (see SetProjectMarker4).
---@param proj ReaProject
---@param markrgnidx integer
---@return boolean retval
function reaper.DeleteProjectMarkerByIndex(proj, markrgnidx) end

---Deletes one or more stretch markers. Returns number of stretch markers deleted.
---@param take MediaItem_Take
---@param idx integer
---@param countIn? integer
---@return integer retval
function reaper.DeleteTakeStretchMarkers(take, idx, countIn) end

---deletes a track
---@param tr MediaTrack
function reaper.DeleteTrack(tr) end

---Destroy an audio accessor. Must only call from the main thread. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param accessor AudioAccessor
function reaper.DestroyAudioAccessor(accessor) end

---updates preference for docker window ident_str to be in dock whichDock on next open
---@param ident_str string
---@param whichDock integer
function reaper.Dock_UpdateDockID(ident_str, whichDock) end

---returns dock index that contains hwnd, or -1
---@param hwnd HWND
---@return integer retval
---@return boolean isFloatingDocker
function reaper.DockIsChildOfDock(hwnd) end

---@param hwnd HWND
---@param name string
---@param pos integer
---@param allowShow boolean
function reaper.DockWindowAdd(hwnd, name, pos, allowShow) end

function reaper.DockWindowRefresh() end

---@param hwnd HWND
function reaper.DockWindowRemove(hwnd) end

---call with a saved window rect for your window and it'll correct any positioning info.
---@param r_left integer
---@param r_top integer
---@param r_right integer
---@param r_bot integer
---@return integer r.left
---@return integer r.top
---@return integer r.right
---@return integer r.bot
function reaper.EnsureNotCompletelyOffscreen(r_left, r_top, r_right, r_bot) end

---List the subdirectories in the "path" directory. Use subdirindex = -1 to force re-read of directory (invalidate cache). Returns NULL/nil when all subdirectories have been listed. See EnumerateFiles
---@param path string
---@param subdirindex integer
---@return string retval
function reaper.EnumerateSubdirectories(path, subdirindex) end

---Start querying modes at 0, returns FALSE when no more modes possible, sets strOut to NULL if a mode is currently unsupported
---@param mode integer
---@return boolean retval
---@return string str
function reaper.EnumPitchShiftModes(mode) end

---@param idx integer
---@return integer retval
---@return boolean isrgn
---@return number pos
---@return number rgnend
---@return string name
---@return integer markrgnindexnumber
function reaper.EnumProjectMarkers(idx) end

---@param proj ReaProject
---@param idx integer
---@return integer retval
---@return boolean isrgn
---@return number pos
---@return number rgnend
---@return string name
---@return integer markrgnindexnumber
---@return integer color
function reaper.EnumProjectMarkers3(proj, idx) end

---Enumerate the data stored with the project for a specific extname. Returns false when there is no more data. See SetProjExtState, GetProjExtState.
---@param proj ReaProject
---@param extname string
---@param idx integer
---@return boolean retval
---@return string? key
---@return string? val
function reaper.EnumProjExtState(proj, extname, idx) end

---returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
---@param track integer
---@param programNumber integer
---@param programName string 
---@return boolean retval
---@return string programName
function reaper.EnumTrackMIDIProgramNames(track, programNumber, programName) end

---Get the effective envelope value at a given time position. samplesRequested is how long the caller expects until the next call to Envelope_Evaluate (often, the buffer block size). The return value is how many samples beyond that time position that the returned values are valid. dVdS is the change in value per sample (first derivative), ddVdS is the second derivative, dddVdS is the third derivative. See GetEnvelopeScalingMode.
---@param envelope TrackEnvelope
---@param time number
---@param samplerate number
---@param samplesRequested integer
---@return integer retval
---@return number value
---@return number dVdS
---@return number ddVdS
---@return number dddVdS
function reaper.Envelope_Evaluate(envelope, time, samplerate, samplesRequested) end

---If take envelope, gets the take from the envelope. If FX, indexOut set to FX index, index2Out set to parameter index, otherwise -1.
---@param env TrackEnvelope
---@return MediaItem_Take retval
---@return integer index
---@return integer index2
function reaper.Envelope_GetParentTake(env) end

---Sort envelope points by time. See SetEnvelopePoint, InsertEnvelopePoint.
---@param envelope TrackEnvelope
---@return boolean retval
function reaper.Envelope_SortPoints(envelope) end

---Executes command line, returns NULL on total failure, otherwise the return value, a newline, and then the output of the command. If timeoutmsec is 0, command will be allowed to run indefinitely (recommended for large amounts of returned output). timeoutmsec is -1 for no wait/terminate, -2 for no wait and minimize
---@param cmdline string
---@param timeoutmsec integer
---@return string retval
function reaper.ExecProcess(cmdline, timeoutmsec) end

---Find the tempo/time signature marker that falls at or before this time position (the marker that is in effect as of this time position).
---@param project ReaProject
---@param time number
---@return integer retval
function reaper.FindTempoTimeSigMarker(project, time) end

---time formatting mode overrides: -1=proj default.
---0=time
---1=measures.beats + time
---2=measures.beats
---3=seconds
---4=samples
---5=h:m:s:f
---offset is start of where the length will be calculated from
---@param tpos number
---@param buf string 
---@param offset number
---@param modeoverride integer
---@return string buf
function reaper.format_timestr_len(tpos, buf, offset, modeoverride) end

---@param gGUID string 
---@return string gGUID
function reaper.genGuid(gGUID) end

---Get reaper.ini full filename.
---@return string retval
function reaper.get_ini_file() end

---get the active take in this item
---@param item MediaItem
---@return MediaItem_Take retval
function reaper.GetActiveTake(item) end

---Returns app version which may include an OS/arch signifier, such as: "6.17" (windows 32-bit), "6.17/x64" (windows 64-bit), "6.17/OSX64" (macOS 64-bit Intel), "6.17/OSX" (macOS 32-bit), "6.17/macOS-arm64", "6.17/linux-x86_64", "6.17/linux-i686", "6.17/linux-aarch64", "6.17/linux-armv7l", etc
---@return string retval
function reaper.GetAppVersion() end

---Get the end time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorSamples.
---@param accessor AudioAccessor
---@return number retval
function reaper.GetAudioAccessorEndTime(accessor) end

---Get a block of samples from the audio accessor. Samples are extracted immediately pre-FX, and returned interleaved (first sample of first channel, first sample of second channel...). Returns 0 if no audio, 1 if audio, -1 on error. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime.
---This function has special handling in Python, and only returns two objects, the API function return value, and the sample buffer. Example usage:
---tr = RPR_GetTrack(0, 0)
---aa = RPR_CreateTrackAudioAccessor(tr)
---buf = list([0]*2*1024) # 2 channels, 1024 samples each, initialized to zero
---pos = 0.0
---(ret, buf) = GetAudioAccessorSamples(aa, 44100, 2, pos, 1024, buf)
---# buf now holds the first 2*1024 audio samples from the track.
---# typically GetAudioAccessorSamples() would be called within a loop, increasing pos each time.
---@param accessor AudioAccessor
---@param samplerate integer
---@param numchannels integer
---@param starttime_sec number
---@param numsamplesperchannel integer
---@param samplebuffer reaper.array 
---@return integer retval
function reaper.GetAudioAccessorSamples(accessor, samplerate, numchannels, starttime_sec, numsamplesperchannel, samplebuffer) end

---get information about the currently open audio device. attribute can be MODE, IDENT_IN, IDENT_OUT, BSIZE, SRATE, BPS. returns false if unknown attribute or device not open.
---@param attribute string
---@return boolean retval
---@return string desc
function reaper.GetAudioDeviceInfo(attribute) end

---returns current project if in load/save (usually only used from project_config_extension_t)
---@return ReaProject retval
function reaper.GetCurrentProjectInLoadSave() end

---0 if track panels, 1 if items, 2 if envelopes, otherwise unknown (unlikely when want_last_valid is true)
---@param want_last_valid boolean
---@return integer retval
function reaper.GetCursorContext2(want_last_valid) end

---edit cursor position
---@param proj ReaProject
---@return number retval
function reaper.GetCursorPositionEx(proj) end

---Returns the custom take, item, or track color that is used (according to the user preference) to color the media item. The returned color is OS dependent|0x01000000 (i.e. ColorToNative(r,g,b)|0x01000000), so a return of zero means "no color", not black.
---@param item MediaItem
---@param take MediaItem_Take
---@return integer retval
function reaper.GetDisplayedMediaItemColor2(item, take) end

---@param env TrackEnvelope
---@return boolean retval
---@return string buf
function reaper.GetEnvelopeName(env) end

---Returns the envelope point at or immediately prior to the given time position. See GetEnvelopePointByTimeEx.
---@param envelope TrackEnvelope
---@param time number
---@return integer retval
function reaper.GetEnvelopePointByTime(envelope, time) end

---Get the attributes of an envelope point.
---autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration,
---even if the automation item is trimmed so that not all points are visible.
---Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations.
---See CountEnvelopePointsEx, SetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param ptidx integer
---@return boolean retval
---@return number time
---@return number value
---@return integer shape
---@return number tension
---@return boolean selected
function reaper.GetEnvelopePointEx(envelope, autoitem_idx, ptidx) end

---Gets the RPPXML state of an envelope, returns true if successful. Undo flag is a performance/caching hint.
---@param env TrackEnvelope
---@param str string 
---@param isundo boolean
---@return boolean retval
---@return string str
function reaper.GetEnvelopeStateChunk(env, str, isundo) end

---returns path of REAPER.exe (not including EXE), i.e. C:\Program Files\REAPER
---@return string retval
function reaper.GetExePath() end

---This function is deprecated (returns GetFocusedFX2()&3), see GetTouchedOrFocusedFX.
---@return integer retval
---@return integer tracknumber
---@return integer itemnumber
---@return integer fxnumber
function reaper.GetFocusedFX() end

---returns free disk space in megabytes, pathIdx 0 for normal, 1 for alternate.
---@param proj ReaProject
---@param pathidx integer
---@return integer retval
function reaper.GetFreeDiskSpaceForRecordPath(proj, pathidx) end

---return -1=no override, 0=trim/read, 1=read, 2=touch, 3=write, 4=latch, 5=bypass
---@return integer retval
function reaper.GetGlobalAutomationOverride() end

---returns approximate input level if available, 0-511 mono inputs, |1024 for stereo pairs, 4096+devidx*32 for MIDI devices
---@param input_id integer
---@return number retval
function reaper.GetInputActivityLevel(input_id) end

---Gets the audio device input/output latency in samples
---@return integer inputlatency
---@return integer outputLatency
function reaper.GetInputOutputLatency() end

---Returns the first item at the screen coordinates specified. If allow_locked is false, locked items are ignored. If takeOutOptional specified, returns the take hit. See GetThingFromPoint.
---@param screen_x integer
---@param screen_y integer
---@param allow_locked boolean
---@return MediaItem retval
---@return MediaItem_Take take
function reaper.GetItemFromPoint(screen_x, screen_y, allow_locked) end

---Gets the RPPXML state of an item, returns true if successful. Undo flag is a performance/caching hint.
---@param item MediaItem
---@param str string 
---@param isundo boolean
---@return boolean retval
---@return string str
function reaper.GetItemStateChunk(item, str, isundo) end

---Get the last project marker before time, and/or the project region that includes time. markeridx and regionidx are returned not necessarily as the displayed marker/region index, but as the index that can be passed to EnumProjectMarkers. Either or both of markeridx and regionidx may be NULL. See EnumProjectMarkers.
---@param proj ReaProject
---@param time number
---@return integer markeridx
---@return integer regionidx
function reaper.GetLastMarkerAndCurRegion(proj, time) end

---@return MediaTrack retval
function reaper.GetLastTouchedTrack() end

---&1=master mute,&2=master solo. This is deprecated as you can just query the master track as well.
---@return integer retval
function reaper.GetMasterMuteSoloFlags() end

---returns &1 if the master track is visible in the TCP, &2 if NOT visible in the mixer. See SetMasterTrackVisibility.
---@return integer retval
function reaper.GetMasterTrackVisibility() end

---@return integer retval
function reaper.GetMaxMidiOutputs() end

---get an item from a project by item count (zero-based) (proj=0 for active project)
---@param proj ReaProject
---@param itemidx integer
---@return MediaItem retval
function reaper.GetMediaItem(proj, itemidx) end

---Get media item numerical-value attributes.
---B_MUTE : bool * : muted (item solo overrides). setting this value will clear C_MUTE_SOLO.
---B_MUTE_ACTUAL : bool * : muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
---C_LANEPLAYS : char * : on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only)
---C_MUTE_SOLO : char * : solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API.
---B_LOOPSRC : bool * : loop source
---B_ALLTAKESPLAY : bool * : all takes play
---B_UISEL : bool * : selected in arrange view
---C_BEATATTACHMODE : char * : item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1
---C_AUTOSTRETCH: : char * : auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
---C_LOCK : char * : locked, &1=locked
---D_VOL : double * : item volume,  0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
---D_POSITION : double * : item position in seconds
---D_LENGTH : double * : item length in seconds
---D_SNAPOFFSET : double * : item snap offset in seconds
---D_FADEINLEN : double * : item manual fadein length in seconds
---D_FADEOUTLEN : double * : item manual fadeout length in seconds
---D_FADEINDIR : double * : item fadein curvature, -1..1
---D_FADEOUTDIR : double * : item fadeout curvature, -1..1
---D_FADEINLEN_AUTO : double * : item auto-fadein length in seconds, -1=no auto-fadein
---D_FADEOUTLEN_AUTO : double * : item auto-fadeout length in seconds, -1=no auto-fadeout
---C_FADEINSHAPE : int * : fadein shape, 0..6, 0=linear
---C_FADEOUTSHAPE : int * : fadeout shape, 0..6, 0=linear
---I_GROUPID : int * : group ID, 0=no group
---I_LASTY : int * : Y-position (relative to top of track) in pixels (read-only)
---I_LASTH : int * : height in pixels (read-only)
---I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---I_CURTAKE : int * : active take number
---IP_ITEMNUMBER : int : item number on this track (read-only, returns the item number directly)
---F_FREEMODE_Y : float * : free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track
---F_FREEMODE_H : float * : free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height
---I_FIXEDLANE : int * : fixed lane of item (fine to call with setNewValue, but returned value is read-only)
---B_FIXEDLANE_HIDDEN : bool * : true if displaying only one fixed lane and this item is in a different lane (read-only)
---P_TRACK : MediaTrack * : (read-only)
---@param item MediaItem
---@param parmname string
---@return number retval
function reaper.GetMediaItemInfo_Value(item, parmname) end

---@param item MediaItem
---@param tk integer
---@return MediaItem_Take retval
function reaper.GetMediaItemTake(item, tk) end

---Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.
---@param take MediaItem_Take
---@param peakrate number
---@param starttime number
---@param numchannels integer
---@param numsamplesperchannel integer
---@param want_extra_type integer
---@param buf reaper.array 
---@return integer retval
function reaper.GetMediaItemTake_Peaks(take, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf) end

---Get parent track of media item take
---@param take MediaItem_Take
---@return MediaTrack retval
function reaper.GetMediaItemTake_Track(take) end

---Get media item take numerical-value attributes.
---D_STARTOFFS : double * : start offset in source media, in seconds
---D_VOL : double * : take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
---D_PAN : double * : take pan, -1..1
---D_PANLAW : double * : take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
---D_PLAYRATE : double * : take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
---D_PITCH : double * : take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
---B_PPITCH : bool * : preserve pitch when changing playback rate
---I_LASTY : int * : Y-position (relative to top of track) in pixels (read-only)
---I_LASTH : int * : height in pixels (read-only)
---I_CHANMODE : int * : channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
---I_PITCHMODE : int * : pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
---I_STRETCHFLAGS : int * : stretch marker flags (&7 mask for mode override: 0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
---F_STRETCHFADESIZE : float * : stretch marker fade size in seconds (0.0025 default)
---I_RECPASSID : int * : record pass ID
---I_TAKEFX_NCH : int * : number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only)
---I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---IP_TAKENUMBER : int : take number (read-only, returns the take number directly)
---P_TRACK : pointer to MediaTrack (read-only)
---P_ITEM : pointer to MediaItem (read-only)
---P_SOURCE : PCM_source *. Note that if setting this, you should first retrieve the old source, set the new, THEN delete the old.
---@param take MediaItem_Take
---@param parmname string
---@return number retval
function reaper.GetMediaItemTakeInfo_Value(take, parmname) end

---Copies the media source filename to filenamebuf. Note that in-project MIDI media sources have no associated filename. See GetMediaSourceParent.
---@param source PCM_source
---@return string filenamebuf
function reaper.GetMediaSourceFileName(source) end

---Returns the number of channels in the source media.
---@param source PCM_source
---@return integer retval
function reaper.GetMediaSourceNumChannels(source) end

---Returns the sample rate. MIDI source media will return zero.
---@param source PCM_source
---@return integer retval
function reaper.GetMediaSourceSampleRate(source) end

---Get track numerical-value attributes.
---B_MUTE : bool * : muted
---B_PHASE : bool * : track phase inverted
---B_RECMON_IN_EFFECT : bool * : record monitoring in effect (current audio-thread playback state, read-only)
---IP_TRACKNUMBER : int : track number 1-based, 0=not found, -1=master track (read-only, returns the int directly)
---I_SOLO : int * : soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place
---B_SOLO_DEFEAT : bool * : when set, if anything else is soloed and this track is not muted, this track acts soloed
---I_FXEN : int * : fx enabled, 0=bypassed, !0=fx active
---I_RECARM : int * : record armed, 0=not record armed, 1=record armed
---I_RECINPUT : int * : record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023) are input start channel (ReaRoute/Loopback start at 512). If 2048 is set, input is multichannel input (using track channel count), or if 1024 is set, input is stereo input, otherwise input is mono.
---I_RECMODE : int * : record mode, 0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation, 4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7=midi overdub, 8=midi replace
---I_RECMODE_FLAGS : int * : record mode flags, &3=output recording mode (0=post fader, 1=pre-fx, 2=post-fx/pre-fader)
---I_RECMON : int * : record monitoring, 0=off, 1=normal, 2=not when playing (tape style)
---I_RECMONITEMS : int * : monitor items while recording, 0=off, 1=on
---B_AUTO_RECARM : bool * : automatically set record arm when selected (does not immediately affect recarm state, script should set directly if desired)
---I_VUMODE : int * : track vu mode, &1:disabled, &30==0:stereo peaks, &30==2:multichannel peaks, &30==4:stereo RMS, &30==8:combined RMS, &30==12:LUFS-M, &30==16:LUFS-S (readout=max), &30==20:LUFS-S (readout=current), &32:LUFS calculation on channels 1+2 only
---I_AUTOMODE : int * : track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch
---I_NCHAN : int * : number of track channels, 2-128, even numbers only
---I_SELECTED : int * : track selected, 0=unselected, 1=selected
---I_WNDH : int * : current TCP window height in pixels including envelopes (read-only)
---I_TCPH : int * : current TCP window height in pixels not including envelopes (read-only)
---I_TCPY : int * : current TCP window Y-position in pixels relative to top of arrange view (read-only)
---I_MCPX : int * : current MCP X-position in pixels relative to mixer container (read-only)
---I_MCPY : int * : current MCP Y-position in pixels relative to mixer container (read-only)
---I_MCPW : int * : current MCP width in pixels (read-only)
---I_MCPH : int * : current MCP height in pixels (read-only)
---I_FOLDERDEPTH : int * : folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc
---I_FOLDERCOMPACT : int * : folder collapsed state (only valid on folders), 0=normal, 1=collapsed, 2=fully collapsed
---I_MIDIHWOUT : int * : track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31)
---I_MIDI_INPUT_CHANMAP : int * : -1 maps to source channel, otherwise 1-16 to map to MIDI channel
---I_MIDI_CTL_CHAN : int * : -1 no link, 0-15 link to MIDI volume/pan on channel, 16 link to MIDI volume/pan on all channels
---I_MIDI_TRACKSEL_FLAG : int * : MIDI editor track list options: &1=expand media items, &2=exclude from list, &4=auto-pruned
---I_PERFFLAGS : int * : track performance flags, &1=no media buffering, &2=no anticipative FX
---I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---I_HEIGHTOVERRIDE : int * : custom height override for TCP window, 0 for none, otherwise size in pixels
---I_SPACER : int * : 1=TCP track spacer above this trackB_HEIGHTLOCK : bool * : track height lock (must set I_HEIGHTOVERRIDE before locking)
---D_VOL : double * : trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
---D_PAN : double * : trim pan of track, -1..1
---D_WIDTH : double * : width of track, -1..1
---D_DUALPANL : double * : dualpan position 1, -1..1, only if I_PANMODE==6
---D_DUALPANR : double * : dualpan position 2, -1..1, only if I_PANMODE==6
---I_PANMODE : int * : pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan
---D_PANLAW : double * : pan law of track, <0=project default, 0.5=-6dB, 0.707..=-3dB, 1=+0dB, 1.414..=-3dB with gain compensation, 2=-6dB with gain compensation, etc
---I_PANLAW_FLAGS : int * : pan law flags, 0=sine taper, 1=hybrid taper with deprecated behavior when gain compensation enabled, 2=linear taper, 3=hybrid taper
---P_ENV:<envchunkname or P_ENV:{GUID... : TrackEnvelope * : (read-only) chunkname can be <VOLENV, <PANENV, etc; GUID is the stringified envelope GUID.
---B_SHOWINMIXER : bool * : track control panel visible in mixer (do not use on master track)
---B_SHOWINTCP : bool * : track control panel visible in arrange view (do not use on master track)
---B_MAINSEND : bool * : track sends audio to parent
---C_MAINSEND_OFFS : char * : channel offset of track send to parent
---C_MAINSEND_NCH : char * : channel count of track send to parent (0=use all child track channels, 1=use one channel only)
---I_FREEMODE : int * : 1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing)
---I_NUMFIXEDLANES : int * : number of track fixed lanes (fine to call with setNewValue, but returned value is read-only)
---C_LANESCOLLAPSED : char * : fixed lane collapse state (1=lanes collapsed, 2=track displays as non-fixed-lanes but hidden lanes exist)
---C_LANESETTINGS : char * : fixed lane settings (&1=auto-remove empty lanes at bottom, &2=do not auto-comp new recording, &4=newly recorded lanes play exclusively (else add lanes in layers), &8=big lanes (else small lanes), &16=add new recording at bottom (else record into first available lane), &32=hide lane buttons
---C_LANEPLAYS:N : char * :  on fixed lane tracks, 0=lane N does not play, 1=lane N plays exclusively, 2=lane N plays and other lanes also play (fine to call with setNewValue, but returned value is read-only)
---C_ALLLANESPLAY : char * : on fixed lane tracks, 0=no lanes play, 1=all lanes play, 2=some lanes play (fine to call with setNewValue 0 or 1, but returned value is read-only)
---C_BEATATTACHMODE : char * : track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only)
---F_MCP_FXSEND_SCALE : float * : scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed)
---F_MCP_FXPARM_SCALE : float * : scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed)
---F_MCP_SENDRGN_SCALE : float * : scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed)
---F_TCP_FXPARM_SCALE : float * : scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed)
---I_PLAY_OFFSET_FLAG : int * : track media playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds)
---D_PLAY_OFFSET : double * : track media playback offset, units depend on I_PLAY_OFFSET_FLAG
---P_PARTRACK : MediaTrack * : parent track (read-only)
---P_PROJECT : ReaProject * : parent project (read-only)
---@param tr MediaTrack
---@param parmname string
---@return number retval
function reaper.GetMediaTrackInfo_Value(tr, parmname) end

---returns true if device present
---@param dev integer
---@param nameout string 
---@return boolean retval
---@return string nameout
function reaper.GetMIDIOutputName(dev, nameout) end

---Get the current mouse modifier assignment for a specific modifier key assignment, in a specific context.
---action will be filled in with the command ID number for a built-in mouse modifier
---or built-in REAPER command ID, or the custom action ID string.
---Note: the action string may have a space and 'c' or 'm' appended to it to specify command ID vs mouse modifier ID.
---See SetMouseModifier for more information.
---@param context string
---@param modifier_flag integer
---@return string action
function reaper.GetMouseModifier(context, modifier_flag) end

---Return number of normal audio hardware inputs available
---@return integer retval
function reaper.GetNumAudioInputs() end

---returns max number of real midi hardware inputs
---@return integer retval
function reaper.GetNumMIDIInputs() end

---Returns number of take markers. See GetTakeMarker, SetTakeMarker, DeleteTakeMarker
---@param take MediaItem_Take
---@return integer retval
function reaper.GetNumTakeMarkers(take) end

---Returns "Win32", "Win64", "OSX32", "OSX64", "macOS-arm64", or "Other".
---@return string retval
function reaper.GetOS() end

---returns output latency in seconds
---@return number retval
function reaper.GetOutputLatency() end

---get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
---@param fn string
---@return string buf
function reaper.GetPeakFileName(fn) end

---Like GetPeakFileNameEx, but you can specify peaksfileextension such as ".reapeaks"
---@param fn string
---@param buf string 
---@param forWrite boolean
---@param peaksfileextension string
---@return string buf
function reaper.GetPeakFileNameEx2(fn, buf, forWrite, peaksfileextension) end

---returns position of next audio block being processed
---@return number retval
function reaper.GetPlayPosition2() end

---returns latency-compensated actual-what-you-hear position
---@param proj ReaProject
---@return number retval
function reaper.GetPlayPositionEx(proj) end

---&1=playing, &2=paused, &4=is recording
---@param proj ReaProject
---@return integer retval
function reaper.GetPlayStateEx(proj) end

---@param proj ReaProject
---@return string buf
function reaper.GetProjectName(proj) end

---Get the project recording path.
---@param proj ReaProject
---@return string buf
function reaper.GetProjectPathEx(proj) end

---Gets project time offset in seconds (project settings - project start time). If rndframe is true, the offset is rounded to a multiple of the project frame size.
---@param proj ReaProject
---@param rndframe boolean
---@return number retval
function reaper.GetProjectTimeOffset(proj, rndframe) end

---Gets basic time signature (beats per minute, numerator of time signature in bpi)
---this does not reflect tempo envelopes but is purely what is set in the project settings.
---@param proj ReaProject
---@return number bpm
---@return number bpi
function reaper.GetProjectTimeSignature2(proj) end

---returns path where ini files are stored, other things are in subdirectories.
---@return string retval
function reaper.GetResourcePath() end

---Discouraged, because GetSelectedMediaItem can be inefficient if media items are added, rearranged, or deleted in between calls. Instead see CountMediaItems, GetMediaItem, IsMediaItemSelected.
---@param proj ReaProject
---@param selitem integer
---@return MediaItem retval
function reaper.GetSelectedMediaItem(proj, selitem) end

---Get a selected track from a project (proj=0 for active project) by selected track count (zero-based).
---@param proj ReaProject
---@param seltrackidx integer
---@param wantmaster boolean
---@return MediaTrack retval
function reaper.GetSelectedTrack2(proj, seltrackidx, wantmaster) end

---Gets or sets the arrange view start/end time for screen coordinates. use screen_x_start=screen_x_end=0 to use the full arrange view's start/end time
---@param proj ReaProject
---@param isSet boolean
---@param screen_x_start integer
---@param screen_x_end integer
---@param start_time number 
---@param end_time number 
---@return number start_time
---@return number end_time
function reaper.GetSet_ArrangeView2(proj, isSet, screen_x_start, screen_x_end, start_time, end_time) end

---@param proj ReaProject
---@param isSet boolean
---@param isLoop boolean
---@param start number 
---@param end number 
---@param allowautoseek boolean
---@return number start
---@return number end
function reaper.GetSet_LoopTimeRange2(proj, isSet, isLoop, start, end, allowautoseek) end

---Get or set automation item information. autoitem_idx=0 for the first automation item on an envelope, 1 for the second item, etc. returns true on success. desc can be any of the following:
---P_POOL_NAME : char * : name of the underlying automation item pool
---P_POOL_EXT:xyz : char * : extension-specific persistent data
---@param env TrackEnvelope
---@param autoitem_idx integer
---@param desc string
---@param valuestrNeedBig string 
---@param is_set boolean
---@return boolean retval
---@return string valuestrNeedBig
function reaper.GetSetAutomationItemInfo_String(env, autoitem_idx, desc, valuestrNeedBig, is_set) end

---deprecated -- see SetEnvelopeStateChunk, GetEnvelopeStateChunk
---@param env TrackEnvelope
---@param str string 
---@return boolean retval
---@return string str
function reaper.GetSetEnvelopeState(env, str) end

---deprecated -- see SetItemStateChunk, GetItemStateChunk
---@param item MediaItem
---@param str string 
---@return boolean retval
---@return string str
function reaper.GetSetItemState(item, str) end

---Gets/sets an item attribute string:
---P_NOTES : char * : item note text (do not write to returned pointer, use setNewValue to update)
---P_EXT:xyz : char * : extension-specific persistent data
---GUID : GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
---@param item MediaItem
---@param parmname string
---@param stringNeedBig string 
---@param setNewValue boolean
---@return boolean retval
---@return string stringNeedBig
function reaper.GetSetMediaItemInfo_String(item, parmname, stringNeedBig, setNewValue) end

---Get or set track string attributes.
---P_NAME : char * : track name (on master returns NULL)
---P_ICON : const char * : track icon (full filename, or relative to resource_path/data/track_icons)
---P_LANENAME:n : char * : lane name (returns NULL for non-fixed-lane-tracks)
---P_MCP_LAYOUT : const char * : layout name
---P_RAZOREDITS : const char * : list of razor edit areas, as space-separated triples of start time, end time, and envelope GUID string.
---  Example: "0.0 1.0 \"\" 0.0 1.0 "{xyz-...}"
---P_RAZOREDITS_EXT : const char * : list of razor edit areas, as comma-separated sets of space-separated tuples of start time, end time, optional: envelope GUID string, fixed/fipm top y-position, fixed/fipm bottom y-position.
---  Example: "0.0 1.0,0.0 1.0 "{xyz-...}",1.0 2.0 "" 0.25 0.75"
---P_TCP_LAYOUT : const char * : layout name
---P_EXT:xyz : char * : extension-specific persistent data
---P_UI_RECT:tcp.mute : char * : read-only, allows querying screen position + size of track WALTER elements (tcp.size queries screen position and size of entire TCP, etc).
---GUID : GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
---@param tr MediaTrack
---@param parmname string
---@param stringNeedBig string 
---@param setNewValue boolean
---@return boolean retval
---@return string stringNeedBig
function reaper.GetSetMediaTrackInfo_String(tr, parmname, stringNeedBig, setNewValue) end

---Get or set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc. swingmode can be 1 for swing enabled, swingamt is -1..1. swingmode can be 3 for measure-grid. Returns grid configuration flags
---@param project ReaProject
---@param set boolean
---@param division? number 
---@param swingmode? integer 
---@param swingamt? number 
---@return integer retval
---@return number? division
---@return integer? swingmode
---@return number? swingamt
function reaper.GetSetProjectGrid(project, set, division, swingmode, swingamt) end

---Get or set project information.
---PROJECT_NAME : project file name (read-only, is_set will be ignored)
---PROJECT_TITLE : title field from Project Settings/Notes dialog
---PROJECT_AUTHOR : author field from Project Settings/Notes dialog
---TRACK_GROUP_NAME:X : track group name, X should be 1..64
---MARKER_GUID:X : get the GUID (unique ID) of the marker or region with index X, where X is the index passed to EnumProjectMarkers, not necessarily the displayed number (read-only)
---MARKER_INDEX_FROM_GUID:{GUID} : get the GUID index of the marker or region with GUID {GUID} (read-only)
---OPENCOPY_CFGIDX : integer for the configuration of format to use when creating copies/applying FX. 0=wave (auto-depth), 1=APPLYFX_FORMAT, 2=RECORD_FORMAT
---RECORD_PATH : recording directory -- may be blank or a relative path, to get the effective path see GetProjectPathEx()
---RECORD_PATH_SECONDARY : secondary recording directory
---RECORD_FORMAT : base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
---APPLYFX_FORMAT : base64-encoded sink configuration (see project files, etc). Used only if RECFMT_OPENCOPY is set to 1. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
---RENDER_FILE : render directory
---RENDER_PATTERN : render file name (may contain wildcards)
---RENDER_METADATA : get or set the metadata saved with the project (not metadata embedded in project media). Example, ID3 album name metadata: valuestr="ID3:TALB" to get, valuestr="ID3:TALB|my album name" to set. Call with valuestr="" and is_set=false to get a semicolon-separated list of defined project metadata identifiers.
---RENDER_TARGETS : semicolon separated list of files that would be written if the project is rendered using the most recent render settings
---RENDER_STATS : (read-only) semicolon separated list of statistics for the most recently rendered files. call with valuestr="XXX" to run an action (for example, "42437"=dry run render selected items) before returning statistics.
---RENDER_FORMAT : base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
---RENDER_FORMAT2 : base64-encoded secondary sink configuration. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type, or "" to disable secondary render.
---&nbsp;&nbsp;&nbsp;&nbsp;Formats available on this machine:
---&nbsp;&nbsp;&nbsp;&nbsp;"wave" "aiff" "caff" "raw " "mp3l" "wvpk" "OggS" "flac" "ddp " "iso " "oggv" "FFMP" "XAVF" "GIF " "LCF "
---@param project ReaProject
---@param desc string
---@param valuestrNeedBig string 
---@param is_set boolean
---@return boolean retval
---@return string valuestrNeedBig
function reaper.GetSetProjectInfo_String(project, desc, valuestrNeedBig, is_set) end

----1 == query,0=clear,1=set,>1=toggle . returns new value
---@param val integer
---@return integer retval
function reaper.GetSetRepeat(val) end

---Gets or sets the attribute flag of a tempo/time signature marker. flag &1=sets time signature and starts new measure, &2=does not set tempo, &4=allow previous partial measure if starting new measure, &8=set new metronome pattern if starting new measure, &16=reset ruler grid if starting new measure
---@param project ReaProject
---@param point_index integer
---@param flag integer
---@param is_set boolean
---@return integer retval
function reaper.GetSetTempoTimeSigMarkerFlag(project, point_index, flag, is_set) end

---Gets or modifies 32 bits (at offset, where 0 is the low 32 bits of the grouping) of the group membership for a track. Returns group state prior to call. if setmask has bits set, those bits in setvalue will be applied to group. Group can be one of:
---MEDIA_EDIT_LEAD
---MEDIA_EDIT_FOLLOW
---VOLUME_LEAD
---VOLUME_FOLLOW
---VOLUME_VCA_LEAD
---VOLUME_VCA_FOLLOW
---PAN_LEAD
---PAN_FOLLOW
---WIDTH_LEAD
---WIDTH_FOLLOW
---MUTE_LEAD
---MUTE_FOLLOW
---SOLO_LEAD
---SOLO_FOLLOW
---RECARM_LEAD
---RECARM_FOLLOW
---POLARITY_LEAD
---POLARITY_FOLLOW
---AUTOMODE_LEAD
---AUTOMODE_FOLLOW
---VOLUME_REVERSE
---PAN_REVERSE
---WIDTH_REVERSE
---NO_LEAD_WHEN_FOLLOW
---VOLUME_VCA_FOLLOW_ISPREFX
---Note: REAPER v6.11 and earlier used _MASTER and _SLAVE rather than _LEAD and _FOLLOW, which is deprecated but still supported (scripts that must support v6.11 and earlier can use the deprecated strings).
---@param tr MediaTrack
---@param groupname string
---@param offset integer
---@param setmask integer
---@param setvalue integer
---@return integer retval
function reaper.GetSetTrackGroupMembershipEx(tr, groupname, offset, setmask, setvalue) end

---Gets/sets a send attribute string:
---P_EXT:xyz : char * : extension-specific persistent data
---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@param parmname string
---@param stringNeedBig string 
---@param setNewValue boolean
---@return boolean retval
---@return string stringNeedBig
function reaper.GetSetTrackSendInfo_String(tr, category, sendidx, parmname, stringNeedBig, setNewValue) end

---deprecated -- see SetTrackStateChunk, GetTrackStateChunk
---@param track MediaTrack
---@param str string 
---@param isundo boolean
---@return boolean retval
---@return string str
function reaper.GetSetTrackState2(track, str, isundo) end

---get a take from an item by take count (zero-based)
---@param item MediaItem
---@param takeidx integer
---@return MediaItem_Take retval
function reaper.GetTake(item, takeidx) end

---@param take MediaItem_Take
---@param envname string
---@return TrackEnvelope retval
function reaper.GetTakeEnvelopeByName(take, envname) end

---returns NULL if the take is not valid
---@param take MediaItem_Take
---@return string retval
function reaper.GetTakeName(take) end

---Gets information on a stretch marker, idx is 0..n. Returns -1 if stretch marker not valid. posOut will be set to position in item, srcposOutOptional will be set to source media position. Returns index. if input index is -1, the following marker is found using position (or source position if position is -1). If position/source position are used to find marker position, their values are not updated.
---@param take MediaItem_Take
---@param idx integer
---@return integer retval
---@return number pos
---@return number? srcpos
function reaper.GetTakeStretchMarker(take, idx) end

---Get information about a specific FX parameter knob (see CountTCPFXParms).
---@param project ReaProject
---@param track MediaTrack
---@param index integer
---@return boolean retval
---@return integer fxindex
---@return integer parmidx
function reaper.GetTCPFXParm(project, track, index) end

---Get information about a tempo/time signature marker. See CountTempoTimeSigMarkers, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param proj ReaProject
---@param ptidx integer
---@return boolean retval
---@return number timepos
---@return integer measurepos
---@return number beatpos
---@return number bpm
---@return integer timesig_num
---@return integer timesig_denom
---@return boolean lineartempo
function reaper.GetTempoTimeSigMarker(proj, ptidx) end

---Hit tests a point in screen coordinates. Updates infoOut with information such as "arrange", "fx_chain", "fx_0" (first FX in chain, floating), "spacer_0" (spacer before first track). If a track panel is hit, string will begin with "tcp" or "mcp" or "tcp.mute" etc (future versions may append additional information). May return NULL with valid info string to indicate non-track thing.
---@param screen_x integer
---@param screen_y integer
---@return MediaTrack retval
---@return string info
function reaper.GetThingFromPoint(screen_x, screen_y) end

---For the main action context, the MIDI editor, or the media explorer, returns the toggle state of the action. 0=off, 1=on, -1=NA because the action does not have on/off states. For the MIDI editor, the action state for the most recently focused window will be returned.
---@param section_id integer
---@param command_id integer
---@return integer retval
function reaper.GetToggleCommandStateEx(section_id, command_id) end

---mode can be 0 to query last touched parameter, or 1 to query currently focused FX. Returns false if failed. If successful, trackIdxOut will be track index (-1 is master track, 0 is first track). itemidxOut will be 0-based item index if an item, or -1 if not an item. takeidxOut will be 0-based take index. fxidxOut will be FX index, potentially with 0x2000000 set to signify container-addressing, or with 0x1000000 set to signify record-input FX. parmOut will be set to the parameter index if querying last-touched. parmOut will have 1 set if querying focused state and FX is no longer focused but still open.
---@param mode integer
---@return boolean retval
---@return integer trackidx
---@return integer itemidx
---@return integer takeidx
---@return integer fxidx
---@return integer parm
function reaper.GetTouchedOrFocusedFX(mode) end

---return the track mode, regardless of global override
---@param tr MediaTrack
---@return integer retval
function reaper.GetTrackAutomationMode(tr) end

---@param track MediaTrack
---@return integer retval
function reaper.GetTrackDepth(track) end

---Gets a built-in track envelope by configuration chunk name, like "<VOLENV", or GUID string, like "{B577250D-146F-B544-9B34-F24FBE488F1F}".
---@param tr MediaTrack
---@param cfgchunkname_or_guid string
---@return TrackEnvelope retval
function reaper.GetTrackEnvelopeByChunkName(tr, cfgchunkname_or_guid) end

---Returns the track from the screen coordinates specified. If the screen coordinates refer to a window associated to the track (such as FX), the track will be returned. infoOutOptional will be set to 1 if it is likely an envelope, 2 if it is likely a track FX. For a free item positioning or fixed lane track, the second byte of infoOutOptional will be set to the (approximate, for fipm tracks) item lane underneath the mouse. See GetThingFromPoint.
---@param screen_x integer
---@param screen_y integer
---@return MediaTrack retval
---@return integer? info
function reaper.GetTrackFromPoint(screen_x, screen_y) end

---@param tr MediaTrack
---@param itemidx integer
---@return MediaItem retval
function reaper.GetTrackMediaItem(tr, itemidx) end

---see GetTrackMIDINoteNameEx
---@param track integer
---@param pitch integer
---@param chan integer
---@return string retval
function reaper.GetTrackMIDINoteName(track, pitch, chan) end

---@param proj ReaProject
---@param track MediaTrack
---@return integer note_lo
---@return integer note_hi
function reaper.GetTrackMIDINoteRange(proj, track) end

---@param tr MediaTrack
---@return integer retval
function reaper.GetTrackNumMediaItems(tr) end

---See GetTrackSendName.
---@param track MediaTrack
---@param recv_index integer
---@return boolean retval
---@return string buf
function reaper.GetTrackReceiveName(track, recv_index) end

---See GetTrackSendUIVolPan.
---@param track MediaTrack
---@param recv_index integer
---@return boolean retval
---@return number volume
---@return number pan
function reaper.GetTrackReceiveUIVolPan(track, recv_index) end

---send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveName.
---@param track MediaTrack
---@param send_index integer
---@return boolean retval
---@return string buf
function reaper.GetTrackSendName(track, send_index) end

---send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveUIVolPan.
---@param track MediaTrack
---@param send_index integer
---@return boolean retval
---@return number volume
---@return number pan
function reaper.GetTrackSendUIVolPan(track, send_index) end

---Gets the RPPXML state of a track, returns true if successful. Undo flag is a performance/caching hint.
---@param track MediaTrack
---@param str string 
---@param isundo boolean
---@return boolean retval
---@return string str
function reaper.GetTrackStateChunk(track, str, isundo) end

---@param track MediaTrack
---@return boolean retval
---@return number pan1
---@return number pan2
---@return integer panmode
function reaper.GetTrackUIPan(track) end

---retrieves the last timestamps of audio xrun (yellow-flash, if available), media xrun (red-flash), and the current time stamp (all milliseconds)
---@return integer audio_xrun
---@return integer media_xrun
---@return integer curtime
function reaper.GetUnderrunTime() end

---Get values from the user.
---If a caption begins with *, for example "*password", the edit field will not display the input text.
---Maximum fields is 16. Values are returned as a comma-separated string. Returns false if the user canceled the dialog. You can supply special extra information via additional caption fields: extrawidth=XXX to increase text field width, separator=X to use a different separator for returned fields.
---@param title string
---@param num_inputs integer
---@param captions_csv string
---@param retvals_csv string 
---@return boolean retval
---@return string retvals_csv
function reaper.GetUserInputs(title, num_inputs, captions_csv, retvals_csv) end

---Seek to region after current region finishes playing (smooth seek). If use_timeline_order==true, region_index 1 refers to the first region on the timeline.  If use_timeline_order==false, region_index 1 refers to the first region with the user-editable index of 1.
---@param proj ReaProject
---@param region_index integer
---@param use_timeline_order boolean
function reaper.GoToRegion(proj, region_index, use_timeline_order) end

---this is just like win32 GetSysColor() but can have overrides.
---@param t integer
---@return integer retval
function reaper.GSC_mainwnd(t) end

---Returns true if there exists an extended state value for a specific section and key. See SetExtState, GetExtState, DeleteExtState.
---@param section string
---@param key string
---@return boolean retval
function reaper.HasExtState(section, key) end

---returns name of track plugin that is supplying MIDI programs,or NULL if there is none
---@param proj ReaProject
---@param track MediaTrack
---@return string retval
function reaper.HasTrackMIDIProgramsEx(proj, track) end

---@param in string
---@param out string 
---@return string out
function reaper.image_resolve_fn(in, out) end

---Insert an envelope point. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. See InsertEnvelopePointEx.
---@param envelope TrackEnvelope
---@param time number
---@param value number
---@param shape integer
---@param tension number
---@param selected boolean
---@param noSortIn? boolean
---@return boolean retval
function reaper.InsertEnvelopePoint(envelope, time, value, shape, tension, selected, noSortIn) end

---mode: 0=add to current track, 1=add new track, 3=add to selected items as takes, &4=stretch/loop to fit time sel, &8=try to match tempo 1x, &16=try to match tempo 0.5x, &32=try to match tempo 2x, &64=don't preserve pitch when matching tempo, &128=no loop/section if startpct/endpct set, &256=force loop regardless of global preference for looping imported items, &512=use high word as absolute track index if mode&3==0 or mode&2048, &1024=insert into reasamplomatic on a new track (add 1 to insert on last selected track), &2048=insert into open reasamplomatic instance (add 512 to use high word as absolute track index), &4096=move to source preferred position (BWF start offset), &8192=reverse. &16384=apply ripple according to project setting
---@param file string
---@param mode integer
---@return integer retval
function reaper.InsertMedia(file, mode) end

---inserts a track at idx,of course this will be clamped to 0..GetNumTracks(). wantDefaults=TRUE for default envelopes/FX,otherwise no enabled fx/env. Superseded, see InsertTrackInProject
---@param idx integer
---@param wantDefaults boolean
function reaper.InsertTrackAtIndex(idx, wantDefaults) end

---Tests a file extension (i.e. "wav" or "mid") to see if it's a media extension.
---If wantOthers is set, then "RPP", "TXT" and other project-type formats will also pass.
---@param ext string
---@param wantOthers boolean
---@return boolean retval
function reaper.IsMediaExtension(ext, wantOthers) end

---Is the project dirty (needing save)? Always returns 0 if 'undo/prompt to save' is disabled in preferences.
---@param proj ReaProject
---@return integer retval
function reaper.IsProjectDirty(proj) end

---If mixer==true, returns true if the track is visible in the mixer.  If mixer==false, returns true if the track is visible in the track control panel.
---@param track MediaTrack
---@param mixer boolean
---@return boolean retval
function reaper.IsTrackVisible(track, mixer) end

---destroys a joystick device
---@param device joystick_device
function reaper.joystick_destroy(device) end

---returns axis value (-1..1)
---@param dev joystick_device
---@param axis integer
---@return number retval
function reaper.joystick_getaxis(dev, axis) end

---returns button count
---@param dev joystick_device
---@return integer retval
---@return integer? axes
---@return integer? povs
function reaper.joystick_getinfo(dev) end

---Updates joystick state from hardware, returns true if successful (joystick_get* will not be valid until joystick_update() is called successfully)
---@param dev joystick_device
---@return boolean retval
function reaper.joystick_update(dev) end

---@param cmd integer
---@param section KbdSectionInfo
---@return string retval
function reaper.kbd_getTextFromCmd(cmd, section) end

---Returns a localized version of src_string, in section section. flags can have 1 set to only localize if sprintf-style formatting matches the original.
---@param src_string string
---@param section string
---@param flags integer
---@return string retval
function reaper.LocalizeString(src_string, section, flags) end

---See Main_OnCommandEx.
---@param command integer
---@param flag integer
function reaper.Main_OnCommand(command, flag) end

---opens a project. will prompt the user to save unless name is prefixed with 'noprompt:'. If name is prefixed with 'template:', project file will be loaded as a template.
---If passed a .RTrackTemplate file, adds the template to the existing project.
---@param name string
function reaper.Main_openProject(name) end

---Save the project. options: &1=save selected tracks as track template, &2=include media with track template, &4=include envelopes with track template. See Main_openProject, Main_SaveProject.
---@param proj ReaProject
---@param filename string
---@param options integer
function reaper.Main_SaveProjectEx(proj, filename, options) end

---Marks project as dirty (needing save) if 'undo/prompt to save' is enabled in preferences.
---@param proj ReaProject
function reaper.MarkProjectDirty(proj) end

---@param project ReaProject
---@return number retval
function reaper.Master_GetPlayRate(project) end

---@return number retval
function reaper.Master_GetTempo() end

---Convert the tempo to/from a value between 0 and 1, representing bpm in the range of 40-296 bpm.
---@param bpm number
---@param isnormalized boolean
---@return number retval
function reaper.Master_NormalizeTempo(bpm, isnormalized) end

---Returns 1 if the track holds the item, 2 if the track is a folder containing the track that holds the item, etc.
---@param item MediaItem
---@param track MediaTrack
---@return integer retval
function reaper.MediaItemDescendsFromTrack(item, track) end

---Count the number of notes, CC events, and text/sysex events in a given MIDI item.
---@param take MediaItem_Take
---@return integer retval
---@return integer notecnt
---@return integer ccevtcnt
---@return integer textsyxevtcnt
function reaper.MIDI_CountEvts(take) end

---Delete a MIDI event.
---@param take MediaItem_Take
---@param evtidx integer
---@return boolean retval
function reaper.MIDI_DeleteEvt(take, evtidx) end

---Delete a MIDI text or sysex event.
---@param take MediaItem_Take
---@param textsyxevtidx integer
---@return boolean retval
function reaper.MIDI_DeleteTextSysexEvt(take, textsyxevtidx) end

---Returns the index of the next selected MIDI CC event after ccidx (-1 if there are no more selected events).
---@param take MediaItem_Take
---@param ccidx integer
---@return integer retval
function reaper.MIDI_EnumSelCC(take, ccidx) end

---Returns the index of the next selected MIDI note after noteidx (-1 if there are no more selected events).
---@param take MediaItem_Take
---@param noteidx integer
---@return integer retval
function reaper.MIDI_EnumSelNotes(take, noteidx) end

---Get all MIDI data. MIDI buffer is returned as a list of { int offset, char flag, int msglen, unsigned char msg[] }.
---offset: MIDI ticks from previous event
---flag: &1=selected &2=muted
---flag high 4 bits for CC shape: &16=linear, &32=slow start/end, &16|32=fast start, &64=fast end, &64|16=bezier
---msg: the MIDI message.
---A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier curve data for the previous MIDI event: 1 byte for the bezier type (usually 0) and 4 bytes for the bezier tension as a float.
---For tick intervals longer than a 32 bit word can represent, zero-length meta events may be placed between valid events.
---See MIDI_SetAllEvts.
---@param take MediaItem_Take
---@return boolean retval
---@return string buf
function reaper.MIDI_GetAllEvts(take) end

---Get CC shape and bezier tension. See MIDI_GetCC, MIDI_SetCCShape
---@param take MediaItem_Take
---@param ccidx integer
---@return boolean retval
---@return integer shape
---@return number beztension
function reaper.MIDI_GetCCShape(take, ccidx) end

---Returns the most recent MIDI editor grid size for this MIDI take, in QN. Swing is between 0 and 1. Note length is 0 if it follows the grid size.
---@param take MediaItem_Take
---@return number retval
---@return number? swing
---@return number? noteLen
function reaper.MIDI_GetGrid(take) end

---Get MIDI note properties.
---@param take MediaItem_Take
---@param noteidx integer
---@return boolean retval
---@return boolean selected
---@return boolean muted
---@return number startppqpos
---@return number endppqpos
---@return integer chan
---@return integer pitch
---@return integer vel
function reaper.MIDI_GetNote(take, noteidx) end

---Returns the MIDI tick (ppq) position corresponding to the start of the measure.
---@param take MediaItem_Take
---@param ppqpos number
---@return number retval
function reaper.MIDI_GetPPQPos_StartOfMeasure(take, ppqpos) end

---Returns the MIDI tick (ppq) position corresponding to a specific project time in seconds.
---@param take MediaItem_Take
---@param projtime number
---@return number retval
function reaper.MIDI_GetPPQPosFromProjTime(take, projtime) end

---Returns the project time in seconds corresponding to a specific MIDI tick (ppq) position.
---@param take MediaItem_Take
---@param ppqpos number
---@return number retval
function reaper.MIDI_GetProjTimeFromPPQPos(take, ppqpos) end

---Get the active scale in the media source, if any. root 0=C, 1=C#, etc. scale &0x1=root, &0x2=minor 2nd, &0x4=major 2nd, &0x8=minor 3rd, &0xF=fourth, etc.
---@param take MediaItem_Take
---@return boolean retval
---@return integer root
---@return integer scale
---@return string name
function reaper.MIDI_GetScale(take) end

---Get a string that only changes when the MIDI data changes. If notesonly==true, then the string changes only when the MIDI notes change. See MIDI_GetHash
---@param track MediaTrack
---@param notesonly boolean
---@return boolean retval
---@return string hash
function reaper.MIDI_GetTrackHash(track, notesonly) end

---Insert a new MIDI CC event.
---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param ppqpos number
---@param chanmsg integer
---@param chan integer
---@param msg2 integer
---@param msg3 integer
---@return boolean retval
function reaper.MIDI_InsertCC(take, selected, muted, ppqpos, chanmsg, chan, msg2, msg3) end

---Insert a new MIDI note. Set noSort if inserting multiple events, then call MIDI_Sort when done.
---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param startppqpos number
---@param endppqpos number
---@param chan integer
---@param pitch integer
---@param vel integer
---@param noSortIn? boolean
---@return boolean retval
function reaper.MIDI_InsertNote(take, selected, muted, startppqpos, endppqpos, chan, pitch, vel, noSortIn) end

---Synchronously updates any open MIDI editors for MIDI take
---@param tk MediaItem_Take
function reaper.MIDI_RefreshEditors(tk) end

---Select or deselect all MIDI content.
---@param take MediaItem_Take
---@param select boolean
function reaper.MIDI_SelectAll(take, select) end

---Set MIDI CC event properties. Properties passed as NULL will not be set. set noSort if setting multiple events, then call MIDI_Sort when done.
---@param take MediaItem_Take
---@param ccidx integer
---@param selectedIn? boolean
---@param mutedIn? boolean
---@param ppqposIn? number 
---@param chanmsgIn? integer
---@param chanIn? integer
---@param msg2In? integer
---@param msg3In? integer
---@param noSortIn? boolean
---@return boolean retval
function reaper.MIDI_SetCC(take, ccidx, selectedIn, mutedIn, ppqposIn, chanmsgIn, chanIn, msg2In, msg3In, noSortIn) end

---Set MIDI event properties. Properties passed as NULL will not be set.  set noSort if setting multiple events, then call MIDI_Sort when done.
---@param take MediaItem_Take
---@param evtidx integer
---@param selectedIn? boolean
---@param mutedIn? boolean
---@param ppqposIn? number 
---@param msg? string
---@param noSortIn? boolean
---@return boolean retval
function reaper.MIDI_SetEvt(take, evtidx, selectedIn, mutedIn, ppqposIn, msg, noSortIn) end

---Set MIDI note properties. Properties passed as NULL (or negative values) will not be set. Set noSort if setting multiple events, then call MIDI_Sort when done. Setting multiple note start positions at once is done more safely by deleting and re-inserting the notes.
---@param take MediaItem_Take
---@param noteidx integer
---@param selectedIn? boolean
---@param mutedIn? boolean
---@param startppqposIn? number 
---@param endppqposIn? number 
---@param chanIn? integer
---@param pitchIn? integer
---@param velIn? integer
---@param noSortIn? boolean
---@return boolean retval
function reaper.MIDI_SetNote(take, noteidx, selectedIn, mutedIn, startppqposIn, endppqposIn, chanIn, pitchIn, velIn, noSortIn) end

---Sort MIDI events after multiple calls to MIDI_SetNote, MIDI_SetCC, etc.
---@param take MediaItem_Take
function reaper.MIDI_Sort(take) end

---get a pointer to the focused MIDI editor window
---see MIDIEditor_GetMode, MIDIEditor_OnCommand
---@return HWND retval
function reaper.MIDIEditor_GetActive() end

---Get settings from a MIDI editor. setting_desc can be:
---snap_enabled: returns 0 or 1
---active_note_row: returns 0-127
---last_clicked_cc_lane: returns 0-127=CC, 0x100|(0-31)=14-bit CC, 0x200=velocity, 0x201=pitch, 0x202=program, 0x203=channel pressure, 0x204=bank/program select, 0x205=text, 0x206=sysex, 0x207=off velocity, 0x208=notation events, 0x210=media item lane
---default_note_vel: returns 0-127
---default_note_chan: returns 0-15
---default_note_len: returns default length in MIDI ticks
---scale_enabled: returns 0-1
---scale_root: returns 0-12 (0=C)
---list_cnt: if viewing list view, returns event count
---if setting_desc is unsupported, the function returns -1.
---See MIDIEditor_SetSetting_int, MIDIEditor_GetActive, MIDIEditor_GetSetting_str
---@param midieditor HWND
---@param setting_desc string
---@return integer retval
function reaper.MIDIEditor_GetSetting_int(midieditor, setting_desc) end

---get the take that is currently being edited in this MIDI editor. see MIDIEditor_EnumTakes
---@param midieditor HWND
---@return MediaItem_Take retval
function reaper.MIDIEditor_GetTake(midieditor) end

---Send an action command to a MIDI editor. Returns false if the supplied MIDI editor pointer is not valid (not an open MIDI editor).
---see MIDIEditor_GetActive, MIDIEditor_LastFocused_OnCommand
---@param midieditor HWND
---@param command_id integer
---@return boolean retval
function reaper.MIDIEditor_OnCommand(midieditor, command_id) end

---Get or set MIDI editor settings for this track. pitchwheelrange: semitones up or down. flags &1: snap pitch lane edits to semitones if pitchwheel range is defined.
---@param track MediaTrack
---@param pitchwheelrange integer 
---@param flags integer 
---@param is_set boolean
---@return integer pitchwheelrange
---@return integer flags
function reaper.MIDIEditorFlagsForTrack(track, pitchwheelrange, flags, is_set) end

---@param strNeed64 string 
---@param vol number
---@param pan number
---@return string strNeed64
function reaper.mkvolpanstr(strNeed64, vol, pan) end

---@param adjamt number
---@param dosel boolean
function reaper.MoveEditCursor(adjamt, dosel) end

---@param mute boolean
function reaper.MuteAllTracks(mute) end

---Get the command ID number for named command that was registered by an extension such as "_SWS_ABOUT" or "_113088d11ae641c193a2b7ede3041ad5" for a ReaScript or a custom action.
---@param command_name string
---@return integer retval
function reaper.NamedCommandLookup(command_name) end

---direct way to simulate pause button hit
---@param proj ReaProject
function reaper.OnPauseButtonEx(proj) end

---direct way to simulate play button hit
---@param proj ReaProject
function reaper.OnPlayButtonEx(proj) end

---direct way to simulate stop button hit
---@param proj ReaProject
function reaper.OnStopButtonEx(proj) end

---Opens mediafn in the Media Explorer, play=true will play the file immediately (or toggle playback if mediafn was already open), =false will just select it.
---@param mediafn string
---@param play boolean
---@return HWND retval
function reaper.OpenMediaExplorer(mediafn, play) end

---Parse hh:mm:ss.sss time string, return time in seconds (or 0.0 on error). See parse_timestr_pos, parse_timestr_len.
---@param buf string
---@return number retval
function reaper.parse_timestr(buf) end

---Parse time string, time formatting mode overrides: -1=proj default.
---0=time
---1=measures.beats + time
---2=measures.beats
---3=seconds
---4=samples
---5=h:m:s:f
---@param buf string
---@param modeoverride integer
---@return number retval
function reaper.parse_timestr_pos(buf, modeoverride) end

---@param idx integer
---@return integer retval
---@return string descstr
function reaper.PCM_Sink_Enum(idx) end

---@param cfg string
---@param hwndParent HWND
---@return HWND retval
function reaper.PCM_Sink_ShowConfig(cfg, hwndParent) end

---See PCM_Source_CreateFromFileEx.
---@param filename string
---@return PCM_source retval
function reaper.PCM_Source_CreateFromFile(filename) end

---Create a PCM_source from a "type" (use this if you're going to load its state via LoadState/ProjectStateContext).
---Valid types include "WAVE", "MIDI", or whatever plug-ins define as well.
---@param sourcetype string
---@return PCM_source retval
function reaper.PCM_Source_CreateFromType(sourcetype) end

---Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.
---@param src PCM_source
---@param peakrate number
---@param starttime number
---@param numchannels integer
---@param numsamplesperchannel integer
---@param want_extra_type integer
---@param buf reaper.array 
---@return integer retval
function reaper.PCM_Source_GetPeaks(src, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf) end

---@param amt integer
function reaper.PluginWantsAlwaysRunFx(amt) end

---Uses the action list to choose an action. Call with session_mode=1 to create a session (init_id will be the initial action to select, or 0), then poll with session_mode=0, checking return value for user-selected action (will return 0 if no action selected yet, or -1 if the action window is no longer available). When finished, call with session_mode=-1.
---@param session_mode integer
---@param init_id integer
---@param section_id integer
---@return integer retval
function reaper.PromptForAction(session_mode, init_id, section_id) end

---returns positive value on success, 0 on failure.
---@param path string
---@param ignored integer
---@return integer retval
function reaper.RecursiveCreateDirectory(path, ignored) end

---See RefreshToolbar2.
---@param command_id integer
function reaper.RefreshToolbar(command_id) end

---Makes a filename "in" relative to the current project, if any.
---@param in string
---@param out string 
---@return string out
function reaper.relative_fn(in, out) end

---Not available while playing back.
---@param source_filename string
---@param target_filename string
---@param start_percent number
---@param end_percent number
---@param playrate number
---@return boolean retval
function reaper.RenderFileSection(source_filename, target_filename, start_percent, end_percent, playrate) end

---@param mode integer
---@return string retval
function reaper.Resample_EnumModes(mode) end

---Resolves a filename "in" by using project settings etc. If no file found, out will be a copy of in.
---@param in string
---@param out string 
---@param checkSubDir? string
---@return string out
function reaper.resolve_fn2(in, out, checkSubDir) end

---See GetEnvelopeScalingMode.
---@param scaling_mode integer
---@param val number
---@return number retval
function reaper.ScaleFromEnvelopeMode(scaling_mode, val) end

---@param uniqueID integer
---@return KbdSectionInfo retval
function reaper.SectionFromUniqueID(uniqueID) end

---@param proj ReaProject
function reaper.SelectProjectInstance(proj) end

---set this take active in this media item
---@param take MediaItem_Take
function reaper.SetActiveTake(take) end

---set current BPM in project, set wantUndo=true to add undo point
---@param __proj ReaProject
---@param bpm number
---@param wantUndo boolean
function reaper.SetCurrentBPM(__proj, bpm, wantUndo) end

---@param time number
---@param moveview boolean
---@param seekplay boolean
function reaper.SetEditCurPos(time, moveview, seekplay) end

---Set attributes of an envelope point. Values that are not supplied will be ignored. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. See SetEnvelopePointEx.
---@param envelope TrackEnvelope
---@param ptidx integer
---@param timeIn? number 
---@param valueIn? number 
---@param shapeIn? integer
---@param tensionIn? number 
---@param selectedIn? boolean
---@param noSortIn? boolean
---@return boolean retval
function reaper.SetEnvelopePoint(envelope, ptidx, timeIn, valueIn, shapeIn, tensionIn, selectedIn, noSortIn) end

---Sets the RPPXML state of an envelope, returns true if successful. Undo flag is a performance/caching hint.
---@param env TrackEnvelope
---@param str string
---@param isundo boolean
---@return boolean retval
function reaper.SetEnvelopeStateChunk(env, str, isundo) end

---mode: see GetGlobalAutomationOverride
---@param mode integer
function reaper.SetGlobalAutomationOverride(mode) end

---set &1 to show the master track in the TCP, &2 to HIDE in the mixer. Returns the previous visibility state. See GetMasterTrackVisibility.
---@param flag integer
---@return integer retval
function reaper.SetMasterTrackVisibility(flag) end

---Redraws the screen only if refreshUI == true.
---See UpdateArrange().
---@param item MediaItem
---@param length number
---@param refreshUI boolean
---@return boolean retval
function reaper.SetMediaItemLength(item, length, refreshUI) end

---@param item MediaItem
---@param selected boolean
function reaper.SetMediaItemSelected(item, selected) end

---Set media item take numerical-value attributes.
---D_STARTOFFS : double * : start offset in source media, in seconds
---D_VOL : double * : take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
---D_PAN : double * : take pan, -1..1
---D_PANLAW : double * : take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
---D_PLAYRATE : double * : take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
---D_PITCH : double * : take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
---B_PPITCH : bool * : preserve pitch when changing playback rate
---I_LASTY : int * : Y-position (relative to top of track) in pixels (read-only)
---I_LASTH : int * : height in pixels (read-only)
---I_CHANMODE : int * : channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
---I_PITCHMODE : int * : pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
---I_STRETCHFLAGS : int * : stretch marker flags (&7 mask for mode override: 0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
---F_STRETCHFADESIZE : float * : stretch marker fade size in seconds (0.0025 default)
---I_RECPASSID : int * : record pass ID
---I_TAKEFX_NCH : int * : number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only)
---I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---IP_TAKENUMBER : int : take number (read-only, returns the take number directly)
---@param take MediaItem_Take
---@param parmname string
---@param newvalue number
---@return boolean retval
function reaper.SetMediaItemTakeInfo_Value(take, parmname, newvalue) end

---Set the MIDI editor grid division. 0.25=quarter note, 1.0/3.0=half note tripet, etc.
---@param project ReaProject
---@param division number
function reaper.SetMIDIEditorGrid(project, division) end

---Set the mouse modifier assignment for a specific modifier key assignment, in a specific context.
---Context is a string like "MM_CTX_ITEM" (see reaper-mouse.ini) or "Media item left drag" (unlocalized).
---Modifier flag is a number from 0 to 15: add 1 for shift, 2 for control, 4 for alt, 8 for win.
---(macOS: add 1 for shift, 2 for command, 4 for opt, 8 for control.)
---For left-click and double-click contexts, the action can be any built-in command ID number
---or any custom action ID string. Find built-in command IDs in the REAPER actions window
---(enable "show command IDs" in the context menu), and find custom action ID strings in reaper-kb.ini.
---The action string may be a mouse modifier ID (see reaper-mouse.ini) with " m" appended to it,
---or (for click/double-click contexts) a command ID with " c" appended to it,
---or the text that appears in the mouse modifiers preferences dialog, like "Move item" (unlocalized).
---For example, SetMouseModifier("MM_CTX_ITEM", 0, "1 m") and SetMouseModifier("Media item left drag", 0, "Move item") are equivalent.
---SetMouseModifier(context, modifier_flag, -1) will reset that mouse modifier to default.
---SetMouseModifier(context, -1, -1) will reset the entire context to default.
---SetMouseModifier(-1, -1, -1) will reset all contexts to default.
---See GetMouseModifier.
---@param context string
---@param modifier_flag integer
---@param action string
function reaper.SetMouseModifier(context, modifier_flag, action) end

---Set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc.
---@param project ReaProject
---@param division number
function reaper.SetProjectGrid(project, division) end

---Note: this function can't clear a marker's name (an empty string will leave the name unchanged), see SetProjectMarker4.
---@param proj ReaProject
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@return boolean retval
function reaper.SetProjectMarker2(proj, markrgnindexnumber, isrgn, pos, rgnend, name) end

---color should be 0 to not change, or ColorToNative(r,g,b)|0x1000000, flags&1 to clear name
---@param proj ReaProject
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color integer
---@param flags integer
---@return boolean retval
function reaper.SetProjectMarker4(proj, markrgnindexnumber, isrgn, pos, rgnend, name, color, flags) end

---Differs from SetProjectMarker4 in that markrgnidx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than representing the displayed marker/region ID number (see SetProjectMarker3). Function will fail if attempting to set a duplicate ID number for a region (duplicate ID numbers for markers are OK). , flags&1 to clear name. If flags&2, markers will not be re-sorted, and after making updates, you MUST call SetProjectMarkerByIndex2 with markrgnidx=-1 and flags&2 to force re-sort/UI updates.
---@param proj ReaProject
---@param markrgnidx integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param IDnumber integer
---@param name string
---@param color integer
---@param flags integer
---@return boolean retval
function reaper.SetProjectMarkerByIndex2(proj, markrgnidx, isrgn, pos, rgnend, IDnumber, name, color, flags) end

---Add (flag > 0) or remove (flag < 0) a track from this region when using the region render matrix. If adding, flag==2 means force mono, flag==4 means force stereo, flag==N means force N/2 channels.
---@param proj ReaProject
---@param regionindex integer
---@param track MediaTrack
---@param flag integer
function reaper.SetRegionRenderMatrix(proj, regionindex, track, flag) end

---Adds or updates a stretch marker. If idx<0, stretch marker will be added. If idx>=0, stretch marker will be updated. When adding, if srcposInOptional is omitted, source position will be auto-calculated. When updating a stretch marker, if srcposInOptional is omitted, srcpos will not be modified. Position/srcposition values will be constrained to nearby stretch markers. Returns index of stretch marker, or -1 if did not insert (or marker already existed at time).
---@param take MediaItem_Take
---@param idx integer
---@param pos number
---@param srcposIn? number 
---@return integer retval
function reaper.SetTakeStretchMarker(take, idx, pos, srcposIn) end

---Set parameters of a tempo/time signature marker. Provide either timepos (with measurepos=-1, beatpos=-1), or measurepos and beatpos (with timepos=-1). If timesig_num and timesig_denom are zero, the previous time signature will be used. ptidx=-1 will insert a new tempo/time signature marker. See CountTempoTimeSigMarkers, GetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param proj ReaProject
---@param ptidx integer
---@param timepos number
---@param measurepos integer
---@param beatpos number
---@param bpm number
---@param timesig_num integer
---@param timesig_denom integer
---@param lineartempo boolean
---@return boolean retval
function reaper.SetTempoTimeSigMarker(proj, ptidx, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo) end

---Updates the toggle state of an action, returns true if succeeded. Only ReaScripts can have their toggle states changed programmatically. See RefreshToolbar2.
---@param section_id integer
---@param command_id integer
---@param state integer
---@return boolean retval
function reaper.SetToggleCommandState(section_id, command_id, state) end

---Set the custom track color, color is OS dependent (i.e. ColorToNative(r,g,b). To unset the track color, see SetMediaTrackInfo_Value I_CUSTOMCOLOR
---@param track MediaTrack
---@param color integer
function reaper.SetTrackColor(track, color) end

---channel < 0 assigns these note names to all channels.
---@param track integer
---@param pitch integer
---@param chan integer
---@param name string
---@return boolean retval
function reaper.SetTrackMIDINoteName(track, pitch, chan, name) end

---@param track MediaTrack
---@param selected boolean
function reaper.SetTrackSelected(track, selected) end

---send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1 for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
---@param track MediaTrack
---@param send_idx integer
---@param pan number
---@param isend integer
---@return boolean retval
function reaper.SetTrackSendUIPan(track, send_idx, pan, isend) end

---Sets the RPPXML state of a track, returns true if successful. Undo flag is a performance/caching hint.
---@param track MediaTrack
---@param str string
---@param isundo boolean
---@return boolean retval
function reaper.SetTrackStateChunk(track, str, isundo) end

---mute: <0 toggles, >0 sets mute, 0=unsets mute. returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param mute integer
---@param igngroupflags integer
---@return integer retval
function reaper.SetTrackUIMute(track, mute, igngroupflags) end

---polarity (AKA phase): <0 toggles, 0=normal, >0=inverted. returns new value or -1 if error.igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param polarity integer
---@param igngroupflags integer
---@return integer retval
function reaper.SetTrackUIPolarity(track, polarity, igngroupflags) end

---solo: <0 toggles, 1 sets solo (default mode), 0=unsets solo, 2 sets solo (non-SIP), 4 sets solo (SIP). returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param solo integer
---@param igngroupflags integer
---@return integer retval
function reaper.SetTrackUISolo(track, solo, igngroupflags) end

---igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param width number
---@param relative boolean
---@param done boolean
---@param igngroupflags integer
---@return number retval
function reaper.SetTrackUIWidth(track, width, relative, done, igngroupflags) end

---Show a message to the user (also useful for debugging). Send "\n" for newline, "" to clear the console. Prefix string with "!SHOW:" and text will be added to console without opening the window. See ClearConsole
---@param msg string
function reaper.ShowConsoleMsg(msg) end

---shows a context menu, valid names include: track_input, track_panel, track_area, track_routing, item, ruler, envelope, envelope_point, envelope_item. ctxOptional can be a track pointer for track_*, item pointer for item* (but is optional). for envelope_point, ctx2Optional has point index, ctx3Optional has item index (0=main envelope, 1=first AI). for envelope_item, ctx2Optional has AI index (1=first AI)
---@param name string
---@param x integer
---@param y integer
---@param hwndParent HWND
---@param ctx userdata
---@param ctx2 integer
---@param ctx3 integer
function reaper.ShowPopupMenu(name, x, y, hwndParent, ctx, ctx2, ctx3) end

---@param project ReaProject
---@param time_pos number
---@return number retval
function reaper.SnapToGrid(project, time_pos) end

---gets the splash window, in case you want to display a message over it. Returns NULL when the splash window is not displayed.
---@return HWND retval
function reaper.Splash_GetWnd() end

---@param str string
---@param gGUID string 
---@return string gGUID
function reaper.stringToGuid(str, gGUID) end

---Adds or queries the position of a named FX in a take. See TrackFX_AddByName() for information on fxname and instantiate. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fxname string
---@param instantiate integer
---@return integer retval
function reaper.TakeFX_AddByName(take, fxname, instantiate) end

---Copies (or moves) FX from src_take to dest_track. dest_fx can have 0x1000000 set to reference input FX. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param src_take MediaItem_Take
---@param src_fx integer
---@param dest_track MediaTrack
---@param dest_fx integer
---@param is_move boolean
function reaper.TakeFX_CopyToTrack(src_take, src_fx, dest_track, dest_fx, is_move) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean retval
function reaper.TakeFX_EndParamEdit(take, fx, param) end

---Note: only works with FX that support Cockos VST extensions. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param value number
---@param buf string 
---@return boolean retval
---@return string buf
function reaper.TakeFX_FormatParamValueNormalized(take, fx, param, value, buf) end

---@param take MediaItem_Take
---@return integer retval
function reaper.TakeFX_GetCount(take) end

---Returns the FX parameter envelope. If the envelope does not exist and create=true, the envelope will be created. If the envelope already exists and is bypassed and create=true, then the envelope will be unbypassed. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fxindex integer
---@param parameterindex integer
---@param create boolean
---@return TrackEnvelope retval
function reaper.TakeFX_GetEnvelope(take, fxindex, parameterindex, create) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean retval
---@return string buf
function reaper.TakeFX_GetFormattedParamValue(take, fx, param) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean retval
---@return string buf
function reaper.TakeFX_GetFXName(take, fx) end

---gets plug-in specific named configuration value (returns true on success). see TrackFX_GetNamedConfigParm FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param parmname string
---@return boolean retval
---@return string buf
function reaper.TakeFX_GetNamedConfigParm(take, fx, parmname) end

---See TakeFX_SetOffline FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean retval
function reaper.TakeFX_GetOffline(take, fx) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number retval
---@return number minval
---@return number maxval
function reaper.TakeFX_GetParam(take, fx, param) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number retval
---@return number minval
---@return number maxval
---@return number midval
function reaper.TakeFX_GetParamEx(take, fx, param) end

---gets an identifying string for the parameter FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean retval
---@return string buf
function reaper.TakeFX_GetParamIdent(take, fx, param) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number retval
function reaper.TakeFX_GetParamNormalized(take, fx, param) end

---Get the name of the preset currently showing in the REAPER dropdown, or the full path to a factory preset file for VST3 plug-ins (.vstpreset). See TakeFX_SetPreset. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean retval
---@return string presetname
function reaper.TakeFX_GetPreset(take, fx) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return string fn
function reaper.TakeFX_GetUserPresetFilename(take, fx) end

---See TakeFX_GetEnabled FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param enabled boolean
function reaper.TakeFX_SetEnabled(take, fx, enabled) end

---See TakeFX_GetOffline FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param offline boolean
function reaper.TakeFX_SetOffline(take, fx, offline) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param val number
---@return boolean retval
function reaper.TakeFX_SetParam(take, fx, param, val) end

---sets the channel mapping bitmask for a particular pin. returns false if unsupported (not all types of plug-ins support this capability). Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param isoutput integer
---@param pin integer
---@param low32bits integer
---@param hi32bits integer
---@return boolean retval
function reaper.TakeFX_SetPinMappings(take, fx, isoutput, pin, low32bits, hi32bits) end

---Sets the preset idx, or the factory preset (idx==-2), or the default user preset (idx==-1). Returns true on success. See TakeFX_GetPresetIndex. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param idx integer
---@return boolean retval
function reaper.TakeFX_SetPresetByIndex(take, fx, idx) end

---Returns true if the active take contains MIDI.
---@param take MediaItem_Take
---@return boolean retval
function reaper.TakeIsMIDI(take) end

---returns theme layout parameter. return value is cfg-name, or nil/empty if out of range.
---@param wp integer
---@return string retval
---@return string? desc
---@return integer? value
---@return integer? defValue
---@return integer? minValue
---@return integer? maxValue
function reaper.ThemeLayout_GetParameter(wp) end

---Sets theme layout override for a particular section -- section can be 'global' or 'mcp' etc. If setting global layout, prefix a ! to the layout string to clear any per-layout overrides. Returns false if failed.
---@param section string
---@param layout string
---@return boolean retval
function reaper.ThemeLayout_SetLayout(section, layout) end

---Gets a precise system timestamp in seconds
---@return number retval
function reaper.time_precise() end

---get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
---@param proj ReaProject
---@param time number
---@return number retval
function reaper.TimeMap2_GetDividedBpmAtTime(proj, time) end

---converts project QN position to time.
---@param proj ReaProject
---@param qn number
---@return number retval
function reaper.TimeMap2_QNToTime(proj, qn) end

---converts project time position to QN position.
---@param proj ReaProject
---@param tpos number
---@return number retval
function reaper.TimeMap2_timeToQN(proj, tpos) end

---get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
---@param time number
---@return number retval
function reaper.TimeMap_GetDividedBpmAtTime(time) end

---Fills in a string representing the active metronome pattern. For example, in a 7/8 measure divided 3+4, the pattern might be "ABCABCD". For backwards compatibility, by default the function will return 1 for each primary beat and 2 for each non-primary beat, so "1221222" in this example, and does not support triplets. If buf is set to "EXTENDED", the function will return the full string as displayed in the pattern editor, including all beat types and triplet representations. Pass in "SET:string" with a correctly formed pattern string matching the current time signature numerator to set the click pattern. The time signature numerator can be deduced from the returned string, and the function returns the time signature denominator.
---@param proj ReaProject
---@param time number
---@param pattern string 
---@return integer retval
---@return string pattern
function reaper.TimeMap_GetMetronomePattern(proj, time, pattern) end

---Find which measure the given QN position falls in.
---@param proj ReaProject
---@param qn number
---@return integer retval
---@return number? qnMeasureStart
---@return number? qnMeasureEnd
function reaper.TimeMap_QNToMeasures(proj, qn) end

---Converts project quarter note count (QN) to time. QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_QNToTime
---@param proj ReaProject
---@param qn number
---@return number retval
function reaper.TimeMap_QNToTime_abs(proj, qn) end

---Converts project time position to quarter note count (QN). QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_timeToQN
---@param proj ReaProject
---@param tpos number
---@return number retval
function reaper.TimeMap_timeToQN_abs(proj, tpos) end

---Returns meter hold state, in dB*0.01 (0 = +0dB, -0.01 = -1dB, 0.02 = +2dB, etc). If clear is set, clears the meter hold. If channel==1024 or channel==1025, returns loudness values if this is the master track or this track's VU meters are set to display loudness.
---@param track MediaTrack
---@param channel integer
---@param clear boolean
---@return number retval
function reaper.Track_GetPeakHoldDB(track, channel, clear) end

---displays tooltip at location, or removes if empty string
---@param fmt string
---@param xpos integer
---@param ypos integer
---@param topmost boolean
function reaper.TrackCtl_SetToolTip(fmt, xpos, ypos, topmost) end

---Copies (or moves) FX from src_track to dest_take. src_fx can have 0x1000000 set to reference input FX. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param src_track MediaTrack
---@param src_fx integer
---@param dest_take MediaItem_Take
---@param dest_fx integer
---@param is_move boolean
function reaper.TrackFX_CopyToTake(src_track, src_fx, dest_take, dest_fx, is_move) end

---Remove a FX from track chain (returns true on success) FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean retval
function reaper.TrackFX_Delete(track, fx) end

---Note: only works with FX that support Cockos VST extensions. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@param val number
---@return boolean retval
---@return string buf
function reaper.TrackFX_FormatParamValue(track, fx, param, val) end

---Get the index of the first track FX insert that matches fxname. If the FX is not in the chain and instantiate is true, it will be inserted. See TrackFX_GetInstrument, TrackFX_GetEQ. Deprecated in favor of TrackFX_AddByName.
---@param track MediaTrack
---@param fxname string
---@param instantiate boolean
---@return integer retval
function reaper.TrackFX_GetByName(track, fxname, instantiate) end

---@param track MediaTrack
---@return integer retval
function reaper.TrackFX_GetCount(track) end

---Get the index of ReaEQ in the track FX chain. If ReaEQ is not in the chain and instantiate is true, it will be inserted. See TrackFX_GetInstrument, TrackFX_GetByName.
---@param track MediaTrack
---@param instantiate boolean
---@return integer retval
function reaper.TrackFX_GetEQ(track, instantiate) end

---Returns false if track/fxidx is not ReaEQ.
---Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass.
---Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc.
---Paramtype (ignored for master gain): 0=freq, 1=gain, 2=Q.
---See TrackFX_GetEQ, TrackFX_SetEQParam, TrackFX_GetEQBandEnabled, TrackFX_SetEQBandEnabled. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fxidx integer
---@param paramidx integer
---@return boolean retval
---@return integer bandtype
---@return integer bandidx
---@return integer paramtype
---@return number normval
function reaper.TrackFX_GetEQParam(track, fxidx, paramidx) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean retval
---@return string buf
function reaper.TrackFX_GetFormattedParamValue(track, fx, param) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean retval
---@return string buf
function reaper.TrackFX_GetFXName(track, fx) end

---Gets the number of input/output pins for FX if available, returns plug-in type or -1 on error FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return integer retval
---@return integer inputPins
---@return integer outputPins
function reaper.TrackFX_GetIOSize(track, fx) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return integer retval
function reaper.TrackFX_GetNumParams(track, fx) end

---Returns true if this FX UI is open in the FX chain window or a floating window. See TrackFX_SetOpen FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean retval
function reaper.TrackFX_GetOpen(track, fx) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean retval
---@return number step
---@return number smallstep
---@return number largestep
---@return boolean istoggle
function reaper.TrackFX_GetParameterStepSizes(track, fx, param) end

---gets the parameter index from an identifying string (:wet, :bypass, :delta, or a string returned from GetParamIdent), or -1 if unknown. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param ident_str string
---@return integer retval
function reaper.TrackFX_GetParamFromIdent(track, fx, ident_str) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean retval
---@return string buf
function reaper.TrackFX_GetParamName(track, fx, param) end

---gets the effective channel mapping bitmask for a particular pin. high32Out will be set to the high 32 bits. Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param tr MediaTrack
---@param fx integer
---@param isoutput integer
---@param pin integer
---@return integer retval
---@return integer high32
function reaper.TrackFX_GetPinMappings(tr, fx, isoutput, pin) end

---Returns current preset index, or -1 if error. numberOfPresetsOut will be set to total number of presets available. See TrackFX_SetPresetByIndex FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return integer retval
---@return integer numberOfPresets
function reaper.TrackFX_GetPresetIndex(track, fx) end

---returns count of record input FX. To access record input FX, use a FX indices [0x1000000..0x1000000+n). On the master track, this accesses monitoring FX rather than record input FX.
---@param track MediaTrack
---@return integer retval
function reaper.TrackFX_GetRecCount(track) end

---presetmove==1 activates the next preset, presetmove==-1 activates the previous preset, etc. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param presetmove integer
---@return boolean retval
function reaper.TrackFX_NavigatePresets(track, fx, presetmove) end

---Enable or disable a ReaEQ band.
---Returns false if track/fxidx is not ReaEQ.
---Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass.
---Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc.
---See TrackFX_GetEQ, TrackFX_GetEQParam, TrackFX_SetEQParam, TrackFX_GetEQBandEnabled. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fxidx integer
---@param bandtype integer
---@param bandidx integer
---@param enable boolean
---@return boolean retval
function reaper.TrackFX_SetEQBandEnabled(track, fxidx, bandtype, bandidx, enable) end

---sets plug-in specific named configuration value (returns true on success).
---Support values for write:
---vst_chunk[_program] : base64-encoded VST-specific chunk.
---clap_chunk : base64-encoded CLAP-specific chunk.
---param.X.lfo.[active,dir,phase,speed,strength,temposync,free,shape] : parameter moduation LFO state
---param.X.acs.[active,dir,strength,attack,release,dblo,dbhi,chan,stereo,x2,y2] : parameter modulation ACS state
---param.X.plink.[active,scale,offset,effect,param,midi_bus,midi_chan,midi_msg,midi_msg2] : parameter link/MIDI link: set effect=-100 to support midi_*
---param.X.mod.[active,baseline,visible] : parameter module global settings
---param.X.learn.[midi1,midi2,osc] : first two bytes of MIDI message, or OSC string if set
---param.X.learn.mode : absolution/relative mode flag (0: Absolute, 1: 127=-1,1=+1, 2: 63=-1, 65=+1, 3: 65=-1, 1=+1, 4: toggle if nonzero)
---param.X.learn.flags : &1=selected track only, &2=soft takeover, &4=focused FX only, &8=LFO retrigger, &16=visible FX only
---param.X.container_map.fx_index : index of FX contained in container
---param.X.container_map.fx_parm : parameter index of parameter of FX contained in container
---param.X.container_map.aliased_name : name of parameter (if user-renamed, otherwise fails)
---BANDTYPEx, BANDENABLEDx : band configuration [ReaEQ]
---THRESHOLD, CEILING, TRUEPEAK : [ReaLimit]
---NUMCHANNELS, NUMSPEAKERS, RESETCHANNELS : [ReaSurroundPan]
---ITEMx : [ReaVerb] state configuration line, when writing should be followed by a write of DONE
---FILE, FILEx, -FILEx, +FILEx, -FILE* : [RS5k] file list, -/+ prefixes are write-only, when writing any, should be followed by a write of DONE
---MODE, RSMODE : [RS5k] general mode, resample mode
---VIDEO_CODE : [video processor] code
---force_auto_bypass : 0 or 1 - force auto-bypass plug-in on silence
---parallel : 0, 1 or 2 - 1=process plug-in in parallel with previous, 2=process plug-in parallel and merge MIDI
---instance_oversample_shift : instance oversampling shift amount, 0=none, 1=~96k, 2=~192k, etc. When setting requires playback stop/start to take effect
---chain_oversample_shift : chain oversampling shift amount, 0=none, 1=~96k, 2=~192k, etc. When setting requires playback stop/start to take effect
---chain_pdc_mode : chain PDC mode (0=classic, 1=new-default, 2=ignore PDC, 3=hwcomp-master)
---chain_sel : selected/visible FX in chain
---renamed_name : renamed FX instance name (empty string = not renamed)
---container_nch : number of internal channels for container
---container_nch_in : number of input pins for container
---container_nch_out : number of output pints for container
---container_nch_feedback : number of internal feedback channels enabled in container
---focused : reading returns 1 if focused. Writing a positive value to this sets the FX UI as "last focused."
---last_touched : reading returns two integers, one indicates whether FX is the last-touched FX, the second indicates which parameter was last touched. Writing a negative value ensures this plug-in is not set as last touched, otherwise the FX is set "last touched," and last touched parameter index is set to the value in the string (if valid).
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param parmname string
---@param value string
---@return boolean retval
function reaper.TrackFX_SetNamedConfigParm(track, fx, parmname, value) end

---Open this FX UI. See TrackFX_GetOpen FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param open boolean
function reaper.TrackFX_SetOpen(track, fx, open) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@param value number
---@return boolean retval
function reaper.TrackFX_SetParamNormalized(track, fx, param, value) end

---Activate a preset with the name shown in the REAPER dropdown. Full paths to .vstpreset files are also supported for VST3 plug-ins. See TrackFX_GetPreset. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param presetname string
---@return boolean retval
function reaper.TrackFX_SetPreset(track, fx, presetname) end

---showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating window(index valid), =3 for show floating window (index valid) FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param index integer
---@param showFlag integer
function reaper.TrackFX_Show(track, index, showFlag) end

function reaper.TrackList_UpdateAllExternalSurfaces() end

---call to start a new block
---@param proj ReaProject
function reaper.Undo_BeginBlock2(proj) end

---returns string of last action,if able,NULL if not
---@param proj ReaProject
---@return string retval
function reaper.Undo_CanUndo2(proj) end

---nonzero if success
---@param proj ReaProject
---@return integer retval
function reaper.Undo_DoUndo2(proj) end

---call to end the block,with extra flags if any,and a description
---@param proj ReaProject
---@param descchange string
---@param extraflags integer
function reaper.Undo_EndBlock2(proj, descchange, extraflags) end

---limited state change to items
---@param proj ReaProject
---@param descchange string
function reaper.Undo_OnStateChange2(proj, descchange) end

---trackparm=-1 by default,or if updating one fx chain,you can specify track index
---@param descchange string
---@param whichStates integer
---@param trackparm integer
function reaper.Undo_OnStateChangeEx(descchange, whichStates, trackparm) end

---Redraw the arrange view
function reaper.UpdateArrange() end

---Recalculate lane arrangement for fixed lane tracks, including auto-removing empty lanes at the bottom of the track
---@param proj ReaProject
---@return boolean retval
function reaper.UpdateItemLanes(proj) end

---see ValidatePtr2
---@param pointer userdata
---@param ctypename string
---@return boolean retval
function reaper.ValidatePtr(pointer, ctypename) end

---Opens the prefs to a page, use pageByName if page is 0.
---@param page integer
---@param pageByName string
function reaper.ViewPrefs(page, pageByName) end

---[BR] Allocate envelope object from track or take envelope pointer. Always call BR_EnvFree when done to release the object and commit changes if needed.
--- takeEnvelopesUseProjectTime: take envelope points' positions are counted from take position, not project start time. If you want to work with project time instead, pass this as true.
---For further manipulation see BR_EnvCountPoints, BR_EnvDeletePoint, BR_EnvFind, BR_EnvFindNext, BR_EnvFindPrevious, BR_EnvGetParentTake, BR_EnvGetParentTrack, BR_EnvGetPoint, BR_EnvGetProperties, BR_EnvSetPoint, BR_EnvSetProperties, BR_EnvValueAtPos.
---@param envelope TrackEnvelope
---@param takeEnvelopesUseProjectTime boolean
---@return BR_Envelope retval
function reaper.BR_EnvAlloc(envelope, takeEnvelopesUseProjectTime) end

---[BR] Delete envelope point by index (zero-based) in the envelope object allocated with BR_EnvAlloc. Returns true on success.
---@param envelope BR_Envelope
---@param id integer
---@return boolean retval
function reaper.BR_EnvDeletePoint(envelope, id) end

---[BR] Find next envelope point after time position in the envelope object allocated with BR_EnvAlloc. Returns envelope point id (zero-based) on success or -1 on failure.
---@param envelope BR_Envelope
---@param position number
---@return integer retval
function reaper.BR_EnvFindNext(envelope, position) end

---[BR] Free envelope object allocated with BR_EnvAlloc and commit changes if needed. Returns true if changes were committed successfully. Note that when envelope object wasn't modified nothing will get committed even if commit = true - in that case function returns false.
---@param envelope BR_Envelope
---@param commit boolean
---@return boolean retval
function reaper.BR_EnvFree(envelope, commit) end

---[BR] Get parent track of envelope object allocated with BR_EnvAlloc. If take envelope, returns NULL.
---@param envelope BR_Envelope
---@return MediaTrack retval
function reaper.BR_EnvGetParentTrack(envelope) end

---[BR] Get envelope properties for the envelope object allocated with BR_EnvAlloc.
---active: true if envelope is active
---visible: true if envelope is visible
---armed: true if envelope is armed
---inLane: true if envelope has it's own envelope lane
---laneHeight: envelope lane override height. 0 for none, otherwise size in pixels
---defaultShape: default point shape: 0->Linear, 1->Square, 2->Slow start/end, 3->Fast start, 4->Fast end, 5->Bezier
---minValue: minimum envelope value
---maxValue: maximum envelope value
---type: envelope type: 0->Volume, 1->Volume (Pre-FX), 2->Pan, 3->Pan (Pre-FX), 4->Width, 5->Width (Pre-FX), 6->Mute, 7->Pitch, 8->Playrate, 9->Tempo map, 10->Parameter
---faderScaling: true if envelope uses fader scaling
---automationItemsOptions: -1->project default, &1=0->don't attach to underl. env., &1->attach to underl. env. on right side,  &2->attach to underl. env. on both sides, &4: bypass underl. env.
---@param envelope BR_Envelope
---@return boolean active
---@return boolean visible
---@return boolean armed
---@return boolean inLane
---@return integer laneHeight
---@return integer defaultShape
---@return number minValue
---@return number maxValue
---@return number centerValue
---@return integer type
---@return boolean faderScaling
---@return integer? automationItemsOptions
function reaper.BR_EnvGetProperties(envelope) end

---[BR] Set envelope properties for the envelope object allocated with BR_EnvAlloc. For parameter description see BR_EnvGetProperties.
---Setting automationItemsOptions requires REAPER 5.979+.
---@param envelope BR_Envelope
---@param active boolean
---@param visible boolean
---@param armed boolean
---@param inLane boolean
---@param laneHeight integer
---@param defaultShape integer
---@param faderScaling boolean
---@param automationItemsOptionsIn? integer
function reaper.BR_EnvSetProperties(envelope, active, visible, armed, inLane, laneHeight, defaultShape, faderScaling, automationItemsOptionsIn) end

---[BR] Get envelope value at time position for the envelope object allocated with BR_EnvAlloc.
---@param envelope BR_Envelope
---@param position number
---@return number retval
function reaper.BR_EnvValueAtPos(envelope, position) end

---[BR] Get closest grid division to position. Note that this functions is different from SnapToGrid in two regards. SnapToGrid() needs snap enabled to work and this one works always. Secondly, grid divisions are different from grid lines because some grid lines may be hidden due to zoom level - this function ignores grid line visibility and always searches for the closest grid division at given position. For more grid division functions, see BR_GetNextGridDivision and BR_GetPrevGridDivision.
---@param position number
---@return number retval
function reaper.BR_GetClosestGridDivision(position) end

---[BR] Get media item from GUID string. Note that the GUID must be enclosed in braces {}. To get item's GUID as a string, see BR_GetMediaItemGUID.
---@param proj ReaProject
---@param guidStringIn string
---@return MediaItem retval
function reaper.BR_GetMediaItemByGUID(proj, guidStringIn) end

---[BR] Get currently loaded image resource and its flags for a given item. Returns false if there is no image resource set. To set image resource, see BR_SetMediaItemImageResource.
---@param item MediaItem
---@return boolean retval
---@return string image
---@return integer imageFlags
function reaper.BR_GetMediaItemImageResource(item) end

---[BR] Get take media source properties as they appear in Item properties. Returns false if take can't have them (MIDI items etc.).
---To set source properties, see BR_SetMediaSourceProperties.
---@param take MediaItem_Take
---@return boolean retval
---@return boolean section
---@return number start
---@return number length
---@return number fade
---@return boolean reverse
function reaper.BR_GetMediaSourceProperties(take) end

---[BR] Get media track freeze count (if track isn't frozen at all, returns 0).
---@param track MediaTrack
---@return integer retval
function reaper.BR_GetMediaTrackFreezeCount(track) end

---[BR] Deprecated, see GetSetMediaTrackInfo (REAPER v5.02+). Get media track layouts for MCP and TCP. Empty string ("") means that layout is set to the default layout. To set media track layouts, see BR_SetMediaTrackLayouts.
---@param track MediaTrack
---@return string mcpLayoutName
---@return string tcpLayoutName
function reaper.BR_GetMediaTrackLayouts(track) end

---[BR] Get source or destination media track for send/receive.
---category is <0 for receives, 0=sends
---sendidx is zero-based (see GetTrackNumSends to count track sends/receives)
---trackType determines which track is returned (0=source track, 1=destination track)
---Note: To get or set other send attributes, see BR_GetSetTrackSendInfo and BR_GetMediaTrackSendInfo_Envelope.
---@param track MediaTrack
---@param category integer
---@param sendidx integer
---@param trackType integer
---@return MediaTrack retval
function reaper.BR_GetMediaTrackSendInfo_Track(track, category, sendidx, trackType) end

---[BR] Get MIDI take pool GUID as a string (guidStringOut_sz should be at least 64). Returns true if take is pooled.
---@param take MediaItem_Take
---@return boolean retval
---@return string guidString
function reaper.BR_GetMidiTakePoolGUID(take) end

---[BR] Get mouse cursor context. Each parameter returns information in a form of string as specified in the table below.
---To get more info on stuff that was found under mouse cursor see BR_GetMouseCursorContext_Envelope, BR_GetMouseCursorContext_Item, BR_GetMouseCursorContext_MIDI, BR_GetMouseCursorContext_Position, BR_GetMouseCursorContext_Take, BR_GetMouseCursorContext_Track 
---Window Segment Details                                            unknown          ""            ""                                                             ruler            region_lane     ""                                                                                                                        marker_lane     ""                                                                                                                        tempo_lane      ""                                                                                                                        timeline        ""                                                             transport        ""            ""                                                             tcp              track           ""                                                                                                                        envelope        ""                                                                                                                        empty           ""                                                             mcp              track           ""                                                                                                                        empty           ""                                                             arrange          track           empty,
---item, item_stretch_marker,
---env_point, env_segment                                                              envelope        empty, env_point, env_segment                                                                                               empty           ""                                                             midi_editor      unknown         ""                                                                                                                        ruler           ""                                                                                                                        piano           ""                                                                                                                        notes           ""                                                                                                                        cc_lane         cc_selector, cc_lane
---@return string window
---@return string segment
---@return string details
function reaper.BR_GetMouseCursorContext() end

---[BR] Returns item under mouse cursor that was captured with the last call to BR_GetMouseCursorContext. Note that the function will return item even if mouse cursor is over some other track lane element like stretch marker or envelope. This enables for easier identification of items when you want to ignore elements within the item.
---@return MediaItem retval
function reaper.BR_GetMouseCursorContext_Item() end

---[BR] Returns project time position in arrange/ruler/midi editor that was captured with the last call to BR_GetMouseCursorContext.
---@return number retval
function reaper.BR_GetMouseCursorContext_Position() end

---[BR] Returns take under mouse cursor that was captured with the last call to BR_GetMouseCursorContext.
---@return MediaItem_Take retval
function reaper.BR_GetMouseCursorContext_Take() end

---[BR] Get next grid division after the time position. For more grid divisions function, see BR_GetClosestGridDivision and BR_GetPrevGridDivision.
---@param position number
---@return number retval
function reaper.BR_GetNextGridDivision(position) end

---[BR] Get or set send attributes.
---category is <0 for receives, 0=sends, >0 for hardware outputs
---sendidx is zero-based (see GetTrackNumSends to count track sends/receives/hardware outputs)
---To set attribute, pass setNewValue as true
---List of possible parameters:
---B_MUTE : send mute state (1.0 if muted, otherwise 0.0)
---B_PHASE : send phase state (1.0 if phase is inverted, otherwise 0.0)
---B_MONO : send mono state (1.0 if send is set to mono, otherwise 0.0)
---D_VOL : send volume (1.0=+0dB etc...)
---D_PAN : send pan (-1.0=100%L, 0=center, 1.0=100%R)
---D_PANLAW : send pan law (1.0=+0.0db, 0.5=-6dB, -1.0=project default etc...)
---I_SENDMODE : send mode (0=post-fader, 1=pre-fx, 2=post-fx(deprecated), 3=post-fx)
---I_SRCCHAN : audio source starting channel index or -1 if audio send is disabled (&1024=mono...note that in that case, when reading index, you should do (index XOR 1024) to get starting channel index)
---I_DSTCHAN : audio destination starting channel index (&1024=mono (and in case of hardware output &512=rearoute)...note that in that case, when reading index, you should do (index XOR (1024 OR 512)) to get starting channel index)
---I_MIDI_SRCCHAN : source MIDI channel, -1 if MIDI send is disabled (0=all, 1-16)
---I_MIDI_DSTCHAN : destination MIDI channel, -1 if MIDI send is disabled (0=original, 1-16)
---I_MIDI_SRCBUS : source MIDI bus, -1 if MIDI send is disabled (0=all, otherwise bus index)
---I_MIDI_DSTBUS : receive MIDI bus, -1 if MIDI send is disabled (0=all, otherwise bus index)
---I_MIDI_LINK_VOLPAN : link volume/pan controls to MIDI
---Note: To get or set other send attributes, see BR_GetMediaTrackSendInfo_Envelope and BR_GetMediaTrackSendInfo_Track.
---@param track MediaTrack
---@param category integer
---@param sendidx integer
---@param parmname string
---@param setNewValue boolean
---@param newValue number
---@return number retval
function reaper.BR_GetSetTrackSendInfo(track, category, sendidx, parmname, setNewValue, newValue) end

---[SWS] Check if take has MIDI inline editor open and returns true or false.
---@param take MediaItem_Take
---@return boolean retval
function reaper.BR_IsMidiOpenInInlineEditor(take) end

---[BR] Get media item under mouse cursor. Position is mouse cursor position in arrange.
---@return MediaItem retval
---@return number position
function reaper.BR_ItemAtMouseCursor() end

---[BR] Replace CC lane in midi editor. Top visible CC lane is laneId 0. Returns true on success.
---Valid CC lanes: CC0-127=CC, 0x100|(0-31)=14-bit CC, 0x200=velocity, 0x201=pitch, 0x202=program, 0x203=channel pressure, 0x204=bank/program select, 0x205=text, 0x206=sysex, 0x207
---@param midiEditor userdata
---@param laneId integer
---@param newCC integer
---@return boolean retval
function reaper.BR_MIDI_CCLaneReplace(midiEditor, laneId, newCC) end

---[BR] Deprecated, see GetSet_ArrangeView2 (REAPER v5.12pre4+) -- Set start and end time position of arrange view. To get arrange view instead, see BR_GetArrangeView.
---@param proj ReaProject
---@param startTime number
---@param endTime number
function reaper.BR_SetArrangeView(proj, startTime, endTime) end

---[BR] Set image resource and its flags for a given item. To clear current image resource, pass imageIn as "".
---imageFlags: &1=0: don't display image, &1: center / tile, &3: stretch, &5: full height (REAPER 5.974+).
---Can also be used to display existing text in empty items unstretched (pass imageIn = "", imageFlags = 0) or stretched (pass imageIn = "". imageFlags = 3).
---To get image resource, see BR_GetMediaItemImageResource.
---@param item MediaItem
---@param imageIn string
---@param imageFlags integer
function reaper.BR_SetMediaItemImageResource(item, imageIn, imageFlags) end

---[BR] Deprecated, see GetSetMediaTrackInfo (REAPER v5.02+). Set media track layouts for MCP and TCP. To set default layout, pass empty string ("") as layout name. In case layouts were successfully set, returns true (if layouts are already set to supplied layout names, it will return false since no changes were made).
---To get media track layouts, see BR_GetMediaTrackLayouts.
---@param track MediaTrack
---@param mcpLayoutNameIn string
---@param tcpLayoutNameIn string
---@return boolean retval
function reaper.BR_SetMediaTrackLayouts(track, mcpLayoutNameIn, tcpLayoutNameIn) end

---[BR] Set new take source from file. To import MIDI file as in-project source data pass inProjectData=true. Returns false if failed.
---Any take source properties from the previous source will be lost - to preserve them, see BR_SetTakeSourceFromFile2.
---Note: To set source from existing take, see SNM_GetSetSourceState2.
---@param take MediaItem_Take
---@param filenameIn string
---@param inProjectData boolean
---@return boolean retval
function reaper.BR_SetTakeSourceFromFile(take, filenameIn, inProjectData) end

---[BR] Get take under mouse cursor. Position is mouse cursor position in arrange.
---@return MediaItem_Take retval
---@return number position
function reaper.BR_TakeAtMouseCursor() end

---[BR] Deprecated, see TrackFX_GetNamedConfigParm/'fx_ident' (v6.37+). Get the exact name (like effect.dll, effect.vst3, etc...) of an FX.
---@param track MediaTrack
---@param fx integer
---@return boolean retval
---@return string name
function reaper.BR_TrackFX_GetFXModuleName(track, fx) end

---[BR] Equivalent to win32 API ComboBox_FindStringExact().
---@param comboBoxHwnd userdata
---@param startId integer
---@param string string
---@return integer retval
function reaper.BR_Win32_CB_FindStringExact(comboBoxHwnd, startId, string) end

---[BR] Equivalent to win32 API FindWindowEx(). Since ReaScript doesn't allow passing NULL (None in Python, nil in Lua etc...) parameters, to search by supplied class or name set searchClass and searchName accordingly. HWND parameters should be passed as either "0" to signify NULL or as string obtained from BR_Win32_HwndToString.
---@param hwndParent string
---@param hwndChildAfter string
---@param className string
---@param windowName string
---@param searchClass boolean
---@param searchName boolean
---@return identifier retval
function reaper.BR_Win32_FindWindowEx(hwndParent, hwndChildAfter, className, windowName, searchClass, searchName) end

---[BR] Equivalent to win32 API GET_Y_LPARAM().
---@param lParam integer
---@return integer retval
function reaper.BR_Win32_GET_Y_LPARAM(lParam) end

---[BR] Equivalent to win32 API GetCursorPos().
---@return boolean retval
---@return integer x
---@return integer y
function reaper.BR_Win32_GetCursorPos() end

---[BR] Equivalent to win32 API GetForegroundWindow().
---@return identifier retval
function reaper.BR_Win32_GetForegroundWindow() end

---[BR] Get mixer window HWND. isDockedOut will be set to true if mixer is docked
---@return identifier retval
---@return boolean isDocked
function reaper.BR_Win32_GetMixerHwnd() end

---[BR] Equivalent to win32 API GetParent().
---@param hwnd userdata
---@return identifier retval
function reaper.BR_Win32_GetParent(hwnd) end

---[BR] Equivalent to win32 API GetWindow().
---@param hwnd userdata
---@param cmd integer
---@return identifier retval
function reaper.BR_Win32_GetWindow(hwnd, cmd) end

---[BR] Equivalent to win32 API GetWindowRect().
---@param hwnd userdata
---@return boolean retval
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.BR_Win32_GetWindowRect(hwnd) end

---[BR] Equivalent to win32 API HIBYTE().
---@param value integer
---@return integer retval
function reaper.BR_Win32_HIBYTE(value) end

---[BR] Convert HWND to string. To convert string back to HWND, see BR_Win32_StringToHwnd.
---@param hwnd userdata
---@return string string
function reaper.BR_Win32_HwndToString(hwnd) end

---[BR] Equivalent to win32 API IsWindowVisible().
---@param hwnd userdata
---@return boolean retval
function reaper.BR_Win32_IsWindowVisible(hwnd) end

---[BR] Equivalent to win32 API LOWORD().
---@param value integer
---@return integer retval
function reaper.BR_Win32_LOWORD(value) end

---[BR] Equivalent to win32 API MAKELPARAM().
---@param low integer
---@param high integer
---@return integer retval
function reaper.BR_Win32_MAKELPARAM(low, high) end

---[BR] Equivalent to win32 API MAKEWORD().
---@param low integer
---@param high integer
---@return integer retval
function reaper.BR_Win32_MAKEWORD(low, high) end

---[BR] Alternative to MIDIEditor_GetActive. REAPER seems to have problems with extensions using HWND type for exported functions so all BR_Win32 functions use void* instead of HWND type.
---@return identifier retval
function reaper.BR_Win32_MIDIEditor_GetActive() end

---[BR] Equivalent to win32 API SendMessage().
---@param hwnd userdata
---@param msg integer
---@param lParam integer
---@param wParam integer
---@return integer retval
function reaper.BR_Win32_SendMessage(hwnd, msg, lParam, wParam) end

---[BR] Equivalent to win32 API SetForegroundWindow().
---@param hwnd userdata
---@return integer retval
function reaper.BR_Win32_SetForegroundWindow(hwnd) end

---[BR] Equivalent to win32 API SetWindowPos().
---hwndInsertAfter may be a string: "HWND_BOTTOM", "HWND_NOTOPMOST", "HWND_TOP", "HWND_TOPMOST" or a string obtained with BR_Win32_HwndToString.
---@param hwnd userdata
---@param hwndInsertAfter string
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param flags integer
---@return boolean retval
function reaper.BR_Win32_SetWindowPos(hwnd, hwndInsertAfter, x, y, width, height, flags) end

---[BR] Equivalent to win32 API ShowWindow().
---@param hwnd userdata
---@param cmdShow integer
---@return boolean retval
function reaper.BR_Win32_ShowWindow(hwnd, cmdShow) end

---[BR] Equivalent to win32 API WindowFromPoint().
---@param x integer
---@param y integer
---@return identifier retval
function reaper.BR_Win32_WindowFromPoint(x, y) end

---Get audio buffer timing information. This is the length (size) of audio buffer in samples, sample rate and 'latest audio buffer switch wall clock time' in seconds.
---@return integer len
---@return number srate
---@return number time
function reaper.Blink_GetAudioBufferTimingInfo() end

---Clock used by Blink.
---@return number retval
function reaper.Blink_GetClockNow() end

---Is Blink Master?
---@return boolean retval
function reaper.Blink_GetMaster() end

---Get session phase at given time for given quantum.
---@param time number
---@param quantum number
---@return number retval
function reaper.Blink_GetPhaseAtTime(time, quantum) end

---Is Blink Puppet?
---@return boolean retval
function reaper.Blink_GetPuppet() end

---Is start/stop synchronization enabled?
---@return boolean retval
function reaper.Blink_GetStartStopSyncEnabled() end

---Get time at which given beat occurs for given quantum.
---@param beat number
---@param quantum number
---@return number retval
function reaper.Blink_GetTimeAtBeat(beat, quantum) end

---Get timeline offset. This is the offset between REAPER timeline and Link session timeline.
---@return number retval
function reaper.Blink_GetTimelineOffset() end

---Convenience function to attempt to map given beat to time when transport is starting to play in context of given quantum. This function evaluates to a no-op if GetPlaying() equals false.
---@param beat number
---@param quantum number
function reaper.Blink_SetBeatAtStartPlayingTimeRequest(beat, quantum) end

---Attempt to map given beat to given time in context of given quantum.
---@param bpm number
---@param time number
---@param quantum number
function reaper.Blink_SetBeatAtTimeRequest(bpm, time, quantum) end

---Enable/disable Blink. In Blink methods transport, tempo and timeline refer to Link session, not local REAPER instance.
---@param enable boolean
function reaper.Blink_SetEnabled(enable) end

---Set Blink as Master. Puppet needs to be enabled first. Same as Puppet, but possible beat offset is broadcast to Link session, effectively forcing local REAPER timeline on peers. Only one, if any, Blink should be Master in Link session.
---@param enable boolean
function reaper.Blink_SetMaster(enable) end

---Convenience function to start or stop transport at given time and attempt to map given beat to this time in context of given quantum.
---@param playing boolean
---@param time number
---@param beat number
---@param quantum number
function reaper.Blink_SetPlayingAndBeatAtTimeRequest(playing, time, beat, quantum) end

---Set quantum. Usually this is set to length of one measure/bar in quarter notes.
---@param quantum number
function reaper.Blink_SetQuantum(quantum) end

---Set timeline tempo to given bpm value.
---@param bpm number
function reaper.Blink_SetTempo(bpm) end

---Transport start/stop.
function reaper.Blink_StartStop() end

---Enumerate the source's media cues. Returns the next index or 0 when finished.
---@param src PCM_source
---@param index integer
---@return integer retval
---@return number time
---@return number endTime
---@return boolean isRegion
---@return string name
---@return boolean isChapter
function reaper.CF_EnumMediaSourceCues(src, index) end

---Deprecated, see kbd_enumerateActions (v6.71+). Wrapper for the unexposed kbd_enumerateActions API function.
---Main=0, Main (alt recording)=100, MIDI Editor=32060, MIDI Event List Editor=32061, MIDI Inline Editor=32062, Media Explorer=32063
---@param section integer
---@param index integer
---@return integer retval
---@return string name
function reaper.CF_EnumerateActions(section, index) end

---Read the contents of the system clipboard.
---@return string text
function reaper.CF_GetClipboard() end

---Deprecated, see kbd_getTextFromCmd (v6.71+). Wrapper for the unexposed kbd_getTextFromCmd API function. See CF_EnumerateActions for common section IDs.
---@param section integer
---@param command integer
---@return string retval
function reaper.CF_GetCommandText(section, command) end

---Return a handle to the currently focused FX chain window.
---@return FxChain retval
function reaper.CF_GetFocusedFXChain() end

---Returns the bit rate for WAVE (wav, aif) and streaming/variable formats (mp3, ogg, opus). REAPER v6.19 or later is required for non-WAVE formats.
---@param src PCM_source
---@return number retval
function reaper.CF_GetMediaSourceBitRate(src) end

---Returns the online/offline status of the given source.
---@param src PCM_source
---@return boolean retval
function reaper.CF_GetMediaSourceOnline(src) end

---Return the current SWS version number.
---@return string version
function reaper.CF_GetSWSVersion() end

---Return a handle to the given track FX chain window.
---@param track MediaTrack
---@return FxChain retval
function reaper.CF_GetTrackFXChain(track) end

---Select the given file in explorer/finder.
---@param file string
---@return boolean retval
function reaper.CF_LocateInExplorer(file) end

---Give a section source created using PCM_Source_CreateFromType("SECTION"). Offset and length are ignored if 0. Negative length to subtract from the total length of the source.
---@param section PCM_source
---@param source PCM_source
---@param offset number
---@param length number
---@param reverse boolean
---@param fadeIn? number 
---@return boolean retval
function reaper.CF_PCM_Source_SetSectionInfo(section, source, offset, length, reverse, fadeIn) end

---Return the maximum sample value played since the last read. Refresh speed depends on buffer size.
---@param preview CF_Preview
---@param channel integer
---@return boolean retval
---@return number peakvol
function reaper.CF_Preview_GetPeak(preview, channel) end

---Start playback of the configured preview object.
---@param preview CF_Preview
---@return boolean retval
function reaper.CF_Preview_Play(preview) end

---See CF_Preview_GetValue.
---@param preview CF_Preview
---@param name string
---@param newValue number
---@return boolean retval
function reaper.CF_Preview_SetValue(preview, name, newValue) end

---Stop and destroy all currently active preview objects.
function reaper.CF_Preview_StopAll() end

---Set which track effect is active in the track's FX chain. The FX chain window does not have to be open.
---@param track MediaTrack
---@param index integer
---@return boolean retval
function reaper.CF_SelectTrackFX(track, index) end

---Write the given string into the system clipboard.
---@param str string
function reaper.CF_SetClipboard(str) end

---Set the online/offline status of the given source (closes files when set=false).
---@param src PCM_source
---@param set boolean
function reaper.CF_SetMediaSourceOnline(src, set) end

---[FNG] Add MIDI note to MIDI take
---@param midiTake RprMidiTake
---@return RprMidiNote retval
function reaper.FNG_AddMidiNote(midiTake) end

---[FNG] Count of how many MIDI notes are in the MIDI take
---@param midiTake RprMidiTake
---@return integer retval
function reaper.FNG_CountMidiNotes(midiTake) end

---[FNG] Get a MIDI note from a MIDI take at specified index
---@param midiTake RprMidiTake
---@param index integer
---@return RprMidiNote retval
function reaper.FNG_GetMidiNote(midiTake, index) end

---[FNG] Set MIDI note property
---@param midiNote RprMidiNote
---@param property string
---@param value integer
function reaper.FNG_SetMidiNoteIntProperty(midiNote, property, value) end

---Runs ReaFab actions/commands. First parameter (command) is ReaFab command number, e.g. 3 for 3rd encoder rotation. Second parameter (val) is MIDI CC Relative value. Value 1 is increment of 1, 127 is decrement of 1. 2 is inc 2, 126 is dec 2 and so on. For button press (commands 9-32) a value of 127 is recommended.
---@param command integer
---@param val integer
---@return boolean retval
function reaper.Fab_Do(command, val) end

---Returns target FX and parameter index for given ReaFab command in context of selected track and ReaFab FX index. Valid command range 1 ... 24. Returns false if no such command mapping is found. Returns param index -1 for ReaFab internal band change command.
---@param command integer
---@return boolean retval
---@return integer fx
---@return integer param
function reaper.Fab_Get(command) end

---Reads from a config file in the GUtilities folder in Reaper's resource folder
---@param fileName string
---@param category string
---@param key string
---@return boolean retval
---@return string value
function reaper.GU_Config_Read(fileName, category, key) end

---Returns count and filesize in megabytes for all valid media files within the path. Returns -1 if path is invalid. Flags can be passed as an argument to determine which media files are valid. A flag with a value of -1 will reset the cache, otherwise, the following flags can be used: ALL = 0, WAV = 1, AIFF = 2, FLAC = 4, MP3 = 8, OGG = 16, BWF = 32, W64 = 64, WAVPACK = 128, GIF = 256, MP4 = 512
---@param path string
---@param flags integer
---@return integer retval
---@return number fileSize
function reaper.GU_Filesystem_CountMediaFiles(path, flags) end

---Returns the first found file's path from within a given path. Returns an empty string if not found
---@param path string
---@param fileName string
---@return string path
function reaper.GU_Filesystem_FindFileInPath(path, fileName) end

---Gets the current GUtilitiesAPI version
---@return string version
function reaper.GU_GUtilitiesAPI_GetVersion() end

---Checks if PCM_source has embedded Media Cue Markers
---@param source PCM_source
---@return boolean retval
function reaper.GU_PCM_Source_HasRegion(source) end

---Returns duration in seconds for PCM_source from start til peak threshold is breached. Returns -1 if invalid
---@param source PCM_source
---@param bufferSize integer
---@param threshold number
---@return number retval
function reaper.GU_PCM_Source_TimeToPeak(source, bufferSize, threshold) end

---Returns duration in seconds for PCM_source from start til RMS threshold is breached. Returns -1 if invalid
---@param source PCM_source
---@param bufferSize integer
---@param threshold number
---@return number retval
function reaper.GU_PCM_Source_TimeToRMS(source, bufferSize, threshold) end

---Returns a string by parsing wildcards relative to the supplied MediaItem_Take
---@param take MediaItem_Take
---@param input string
---@return string value
function reaper.GU_WildcardParseTake(take, input) end

---@param project ReaProject
---@return string retval
function reaper.JB_GetSWSExtraProjectNotes(project) end

---Section:
---0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
---@param section integer
---@param cmdID integer
---@return integer retval
function reaper.JS_Actions_CountShortcuts(section, cmdID) end

---Section:
---0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
---If the shortcut index is higher than the current number of shortcuts, it will add a new shortcut.
---@param section integer
---@param cmdID integer
---@param shortcutidx integer
---@return boolean retval
function reaper.JS_Actions_DoShortcutDialog(section, cmdID, shortcutidx) end

---Returns the unsigned byte at address[offset]. Offset is added as steps of 1 byte each.
---@param pointer userdata
---@param offset integer
---@return integer byte
function reaper.JS_Byte(pointer, offset) end

---On WindowsOS, flickering of composited images can be improved considerably by slowing the refresh rate of the window.  The optimal refresh rate may depend on the number of composited bitmaps.
---minTime is the minimum refresh delay, in seconds, when only one bitmap is composited onto the window.  The delay time will increase linearly with the number of bitmaps, up to a maximum of maxTime when numBitmapsWhenMax is reached.
---If both minTime and maxTime are 0, all delay settings for the window are cleared.
---Returns:
--- * retval = 1 if successful, 0 if arguments are invalid (i.e. if maxTime < minTime, or maxBitmaps < 1).
--- * If delay times have not previously been set for this window, prev time values are 0.
---@param windowHWND userdata
---@param minTime number
---@param maxTime number
---@param numBitmapsWhenMax integer
---@return integer retval
---@return number prevMinTime
---@return number prevMaxTime
---@return integer prevBitmaps
function reaper.JS_Composite_Delay(windowHWND, minTime, maxTime, numBitmapsWhenMax) end

---Unlinks the window and bitmap.
--- * autoUpdate is an optional parameter. If unlinking a single bitmap and autoUpdate is true, the function will automatically re-draw the window to remove the blitted image.
---If no bitmap is specified, all bitmaps composited to the window will be unlinked -- even those by other scripts.
---@param windowHWND userdata
---@param bitmap userdata
---@param autoUpdate unsupported
function reaper.JS_Composite_Unlink(windowHWND, bitmap, autoUpdate) end

---If allowMultiple is true, multiple files may be selected. The returned string is \0-separated, with the first substring containing the folder path and subsequent substrings containing the file names.
--- * On macOS, the first substring may be empty, and each file name will then contain its entire path.
--- * This function only allows selection of existing files, and does not allow creation of new files.
---extensionList is a string containing pairs of \0-terminated substrings. The last substring must be terminated by two \0 characters. Each pair defines one filter pattern:
--- * The first substring in each pair describes the filter in user-readable form (for example, "Lua script files (*.lua)") and will be displayed in the dialog box.
--- * The second substring specifies the filter that the operating system must use to search for the files (for example, "*.txt"; the wildcard should not be omitted). To specify multiple extensions for a single display string, use a semicolon to separate the patterns (for example, "*.lua;*.eel").
---An example of an extensionList string:
---"ReaScript files\0*.lua;*.eel\0Lua files (.lua)\0*.lua\0EEL files (.eel)\0*.eel\0\0".
---On macOS, file dialogs do not accept empty extensionLists, nor wildcard extensions (such as "All files\0*.*\0\0"), so each acceptable extension must be listed explicitly. On Linux and Windows, wildcard extensions are acceptable, and if the extensionList string is empty, the dialog will display a default "All files (*.*)" filter.
---retval is 1 if one or more files were selected, 0 if the user cancelled the dialog, or negative if an error occurred.
---Displaying \0-separated strings:
--- * REAPER's IDE and ShowConsoleMsg only display strings up to the first \0 byte. If multiple files were selected, only the first substring containing the path will be displayed. This is not a problem for Lua or EEL, which can access the full string beyond the first \0 byte as usual.
---@param windowTitle string
---@param initialFolder string
---@param initialFile string
---@param extensionList string
---@param allowMultiple boolean
---@return integer retval
---@return string fileNames
function reaper.JS_Dialog_BrowseForOpenFiles(windowTitle, initialFolder, initialFile, extensionList, allowMultiple) end

---Returns the 8-byte floating point value at address[offset]. Offset is added as steps of 8 bytes each.
---@param pointer userdata
---@param offset integer
---@return number double
function reaper.JS_Double(pointer, offset) end

---Blits between two device contexts, which may include LICE "system bitmaps".
---mode: Optional parameter. "SRCCOPY" by default, or specify "ALPHA" to enable per-pixel alpha blending.
---WARNING: On WindowsOS, GDI_Blit does not perform alpha multiplication of the source bitmap. For proper color rendering, a separate pre-multiplication step is therefore required, using either LICE_Blit or LICE_ProcessRect.
---@param destHDC userdata
---@param dstx integer
---@param dsty integer
---@param sourceHDC userdata
---@param srcx integer
---@param srxy integer
---@param width integer
---@param height integer
---@param mode? string
function reaper.JS_GDI_Blit(destHDC, dstx, dsty, sourceHDC, srcx, srxy, width, height, mode) end

---Parameters:
--- * weight: 0 - 1000, with 0 = auto, 400 = normal and 700 = bold.
--- * angle: the angle, in tenths of degrees, between the text and the x-axis of the device.
--- * fontName: If empty string "", uses first font that matches the other specified attributes.
---Note: Text color must be set separately.
---@param height integer
---@param weight integer
---@param angle integer
---@param italic boolean
---@param underline boolean
---@param strike boolean
---@param fontName string
---@return identifier retval
function reaper.JS_GDI_CreateFont(height, weight, angle, italic, underline, strike, fontName) end

---@param GDIObject userdata
function reaper.JS_GDI_DeleteObject(GDIObject) end

---@param deviceHDC userdata
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function reaper.JS_GDI_FillEllipse(deviceHDC, left, top, right, bottom) end

---@param deviceHDC userdata
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function reaper.JS_GDI_FillRect(deviceHDC, left, top, right, bottom) end

---Returns the device context for the client area of the specified window.
---@param windowHWND userdata
---@return identifier retval
function reaper.JS_GDI_GetClientDC(windowHWND) end

---@param GUIElement string
---@return integer retval
function reaper.JS_GDI_GetSysColor(GUIElement) end

---Returns the device context for the entire window, including title bar and frame.
---@param windowHWND userdata
---@return identifier retval
function reaper.JS_GDI_GetWindowDC(windowHWND) end

---packedX and packedY are strings of points, each packed as "<i4".
---@param deviceHDC userdata
---@param packedX string
---@param packedY string
---@param numPoints integer
function reaper.JS_GDI_Polyline(deviceHDC, packedX, packedY, numPoints) end

---Activates a font, pen, or fill brush for subsequent drawing in the specified device context.
---@param deviceHDC userdata
---@param GDIObject userdata
---@return identifier retval
function reaper.JS_GDI_SelectObject(deviceHDC, GDIObject) end

---@param deviceHDC userdata
---@param color integer
function reaper.JS_GDI_SetTextBkColor(deviceHDC, color) end

---@param deviceHDC userdata
---@param color integer
function reaper.JS_GDI_SetTextColor(deviceHDC, color) end

---@param headerHWND userdata
---@return integer retval
function reaper.JS_Header_GetItemCount(headerHWND) end

---Hue is rolled over, saturation and value are clamped, all 0..1. (Alpha remains unchanged.)
---@param bitmap userdata
---@param hue number
---@param saturation number
---@param value number
function reaper.JS_LICE_AlterBitmapHSV(bitmap, hue, saturation, value) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param cx number
---@param cy number
---@param r number
---@param minAngle number
---@param maxAngle number
---@param color integer
---@param alpha number
---@param mode string
---@param antialias boolean
function reaper.JS_LICE_Arc(bitmap, cx, cy, r, minAngle, maxAngle, color, alpha, mode, antialias) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-pixel alpha blending.
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param xstart number
---@param ystart number
---@param xctl1 number
---@param yctl1 number
---@param xctl2 number
---@param yctl2 number
---@param xend number
---@param yend number
---@param tol number
---@param color integer
---@param alpha number
---@param mode string
---@param antialias boolean
function reaper.JS_LICE_Bezier(bitmap, xstart, ystart, xctl1, yctl1, xctl2, yctl2, xend, yend, tol, color, alpha, mode, antialias) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param cx number
---@param cy number
---@param r number
---@param color integer
---@param alpha number
---@param mode string
---@param antialias boolean
function reaper.JS_LICE_Circle(bitmap, cx, cy, r, color, alpha, mode, antialias) end

---@param isSysBitmap boolean
---@param width integer
---@param height integer
---@return identifier retval
function reaper.JS_LICE_CreateBitmap(isSysBitmap, width, height) end

---Deletes the bitmap, and also unlinks bitmap from any composited window.
---@param bitmap userdata
function reaper.JS_LICE_DestroyBitmap(bitmap) end

---@param bitmap userdata
---@param x integer
---@param y integer
---@param c integer
---@param color integer
---@param alpha number
---@param mode integer
function reaper.JS_LICE_DrawChar(bitmap, x, y, c, color, alpha, mode) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param cx number
---@param cy number
---@param r number
---@param color integer
---@param alpha number
---@param mode string
---@param antialias boolean
function reaper.JS_LICE_FillCircle(bitmap, cx, cy, r, color, alpha, mode, antialias) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param color integer
---@param alpha number
---@param mode string
function reaper.JS_LICE_FillRect(bitmap, x, y, w, h, color, alpha, mode) end

---@param bitmap userdata
---@return identifier retval
function reaper.JS_LICE_GetDC(bitmap) end

---Returns the color of the specified pixel.
---@param bitmap userdata
---@param x integer
---@param y integer
---@return number color
function reaper.JS_LICE_GetPixel(bitmap, x, y) end

---@param bitmap userdata
---@param dstx integer
---@param dsty integer
---@param dstw integer
---@param dsth integer
---@param ir number
---@param ig number
---@param ib number
---@param ia number
---@param drdx number
---@param dgdx number
---@param dbdx number
---@param dadx number
---@param drdy number
---@param dgdy number
---@param dbdy number
---@param dady number
---@param mode string
function reaper.JS_LICE_GradRect(bitmap, dstx, dsty, dstw, dsth, ir, ig, ib, ia, drdx, dgdx, dbdx, dadx, drdy, dgdy, dbdy, dady, mode) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param color integer
---@param alpha number
---@param mode string
---@param antialias boolean
function reaper.JS_LICE_Line(bitmap, x1, y1, x2, y2, color, alpha, mode, antialias) end

---Returns a system LICE bitmap containing the JPEG.
---@param filename string
---@return identifier retval
function reaper.JS_LICE_LoadJPG(filename) end

---Returns a system LICE bitmap containing the PNG.
---@param filename string
---@return identifier retval
function reaper.JS_LICE_LoadPNG(filename) end

---@param text string
---@return integer width
---@return integer Height
function reaper.JS_LICE_MeasureText(text) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param x integer
---@param y integer
---@param color number
---@param alpha number
---@param mode string
function reaper.JS_LICE_PutPixel(bitmap, x, y, color, alpha, mode) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-pixel alpha blending.
---@param destBitmap userdata
---@param dstx integer
---@param dsty integer
---@param dstw integer
---@param dsth integer
---@param sourceBitmap userdata
---@param srcx number
---@param srcy number
---@param srcw number
---@param srch number
---@param angle number
---@param rotxcent number
---@param rotycent number
---@param cliptosourcerect boolean
---@param alpha number
---@param mode string
function reaper.JS_LICE_RotatedBlit(destBitmap, dstx, dsty, dstw, dsth, sourceBitmap, srcx, srcy, srcw, srch, angle, rotxcent, rotycent, cliptosourcerect, alpha, mode) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-pixel alpha blending.
---@param destBitmap userdata
---@param dstx integer
---@param dsty integer
---@param dstw integer
---@param dsth integer
---@param srcBitmap userdata
---@param srcx number
---@param srcy number
---@param srcw number
---@param srch number
---@param alpha number
---@param mode string
function reaper.JS_LICE_ScaledBlit(destBitmap, dstx, dsty, dstw, dsth, srcBitmap, srcx, srcy, srcw, srch, alpha, mode) end

---Sets the color of the font background.
---@param LICEFont userdata
---@param color integer
function reaper.JS_LICE_SetFontBkColor(LICEFont, color) end

---Sets the color of font FX such as shadow.
---@param LICEFont userdata
---@param color integer
function reaper.JS_LICE_SetFontFXColor(LICEFont, color) end

---Parameters:
--- * quality is an integer in the range 1..100.
--- * forceBaseline is an optional boolean parameter that ensures compatibility with all JPEG viewers by preventing too low quality, "cubist" settings.
---@param filename string
---@param bitmap userdata
---@param quality integer
---@param forceBaseline unsupported
---@return boolean retval
function reaper.JS_LICE_WriteJPG(filename, bitmap, quality, forceBaseline) end

---@param listviewHWND userdata
---@param index integer
---@param partialOK boolean
function reaper.JS_ListView_EnsureVisible(listviewHWND, index, partialOK) end

---Returns the index and text of the focused item, if any.
---@param listviewHWND userdata
---@return integer retval
---@return string text
function reaper.JS_ListView_GetFocusedItem(listviewHWND) end

---Returns the text and state of specified item.
---@param listviewHWND userdata
---@param index integer
---@param subItem integer
---@return string text
---@return integer state
function reaper.JS_ListView_GetItem(listviewHWND, index, subItem) end

---Returns client coordinates of the item.
---@param listviewHWND userdata
---@param index integer
---@return boolean retval
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.JS_ListView_GetItemRect(listviewHWND, index) end

---@param listviewHWND userdata
---@param index integer
---@param subItem integer
---@return string text
function reaper.JS_ListView_GetItemText(listviewHWND, index, subItem) end

---@param listviewHWND userdata
---@return integer retval
function reaper.JS_ListView_GetTopIndex(listviewHWND) end

---Returns the indices of all selected items as a comma-separated list.
--- * retval: Number of selected items found; negative or zero if an error occured.
---@param listviewHWND userdata
---@return integer retval
---@return string items
function reaper.JS_ListView_ListAllSelItems(listviewHWND) end

---Currently, this fuction only accepts ASCII text.
---@param listviewHWND userdata
---@param index integer
---@param subItem integer
---@param text string
function reaper.JS_ListView_SetItemText(listviewHWND, index, subItem, text) end

---Finds all open MIDI windows (whether docked or not).
--- * retval: The number of MIDI editor windows found; negative if an error occurred.
--- * The address of each MIDI editor window is stored in the provided reaper.array. Each address can be converted to a REAPER object (HWND) by the function JS_Window_HandleFromAddress.
---@param reaperarray userdata
---@return integer retval
function reaper.JS_MIDIEditor_ArrayAll(reaperarray) end

---Allocates memory for general use by functions that require memory buffers.
---@param sizeBytes integer
---@return identifier retval
function reaper.JS_Mem_Alloc(sizeBytes) end

---Copies a packed string into a memory buffer.
---@param mallocPointer userdata
---@param offset integer
---@param packedString string
---@param stringLength integer
---@return boolean retval
function reaper.JS_Mem_FromString(mallocPointer, offset, packedString, stringLength) end

---Retrieves the states of mouse buttons and modifiers keys.
---Parameters:
--- * flags, state: The parameter and the return value both use the same format as gfx.mouse_cap. For example, to get the states of the left mouse button and the ctrl key, use flags = 0b00000101.
---@param flags integer
---@return integer retval
function reaper.JS_Mouse_GetState(flags) end

---Loads a cursor from a .cur file.
---forceNewLoad is an optional boolean parameter:
--- * If omitted or false, and if the cursor file has already been loaded previously during the REAPER session by any script, the file will not be re-loaded, and the existing handle will be returned.
--- * If true, the file will be re-loaded and a new handle will be returned.
--- * WARNING: Each time that a cursor file is re-loaded, the number of GDI objects increases for the entire duration of the REAPER session.
---If successful, returns a handle to the cursor, which can be used in JS_Mouse_SetCursor.
---@param pathAndFileName string
---@param forceNewLoad unsupported
---@return identifier retval
function reaper.JS_Mouse_LoadCursorFromFile(pathAndFileName, forceNewLoad) end

---Moves the mouse cursor to the specified screen coordinates.
---NOTES:
--- * On Windows and Linux, screen coordinates are relative to *upper* left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
---@param x integer
---@param y integer
---@return boolean retval
function reaper.JS_Mouse_SetPosition(x, y) end

---Returns the memory contents starting at address[offset] as a packed string. Offset is added as steps of 1 byte (char) each.
---@param pointer userdata
---@param offset integer
---@param lengthChars integer
---@return boolean retval
---@return string buf
function reaper.JS_String(pointer, offset, lengthChars) end

---Retrieves the current states (0 or 1) of all virtual keys, from 0x01 to 0xFF, in a 255-byte array.
---cutoffTime: A key is only regarded as down if it sent a KEYDOWN message after the cut-off time, not followed by KEYUP. (This is useful for excluding old KEYDOWN messages that weren't properly followed by KEYUP.) 
---If cutoffTime is positive, is it interpreted as absolute time in similar format as time_precise().
---If cutoffTime is negative, it is relative to the current time.
---Notes:
--- * Mouse buttons and modifier keys are not (currently) reliably detected, and JS_Mouse_GetState can be used instead.
--- * Auto-repeated KEYDOWN messages are ignored.
---@param cutoffTime number
---@return string state
function reaper.JS_VKeys_GetState(cutoffTime) end

---Intercepting (blocking) virtual keys work similar to the native function PreventUIRefresh:  Each key has a (non-negative) intercept state, and the key is passed through as usual if the state equals 0, or blocked if the state is greater than 0.
---keyCode: The virtual key code of the key, or -1 to change the state of all keys.
---intercept: A script can increase the intercept state by passing +1, or lower the state by passing -1.  Multiple scripts can block the same key, and the intercept state may reach up to 255. If zero is passed, the intercept state is not changed, but the current state is returned.
---Returns: If keyCode refers to a single key, the intercept state of that key is returned.  If keyCode = -1, the state of the key that is most strongly blocked (highest intercept state) is returned.
---@param keyCode integer
---@param intercept integer
---@return integer retval
function reaper.JS_VKeys_Intercept(keyCode, intercept) end

---Begins intercepting window messages to specified window.
---Parameters:
--- * messages: comma-separated string of message types to be intercepted (either in WM_ or hexadecimal format), each with a "block" or "passthrough" modifier to specify whether the message should be blocked or passed through to the window. For example "WM_SETCURSOR:block, 0x0201:passthrough".
---    For more information on message codes, refer to the Win32 C++ API documentation.
---    All WM_ and CB_ message types listed in swell-types.h should be valid cross-platform, and the function can recognize all of these by name. Other messages can be specified by their hex code.
---Returns:
--- * 1: Success.
--- * 0: The message type is already being intercepted by another script.
--- * -1: windowHWND is not a valid window.
--- * -2: message string could not be parsed.
--- * -3: Failure getting original window process.
--- * -6: COuld not obtain the window client HDC.
---Notes:
--- * Intercepted messages can be polled using JS_WindowMessage_Peek.
--- * Intercepted messages can be edited, if necessary, and then forwarded to their original destination using JS_WindowMessage_Post or JS_WindowMessage_Send.
--- * To check whether a message type is being blocked or passed through, Peek the message type, or retrieve the entire List of intercepts.
---@param windowHWND userdata
---@param messages string
---@return integer retval
function reaper.JS_WindowMessage_InterceptList(windowHWND, messages) end

---Changes the passthrough setting of a message type that is already being intercepted.
---Returns 1 if successful, 0 if the message type is not yet being intercepted, or -2 if the argument could not be parsed.
---@param windowHWND userdata
---@param message string
---@param passThrough boolean
---@return integer retval
function reaper.JS_WindowMessage_PassThrough(windowHWND, message, passThrough) end

---If the specified window and message type are not currently being intercepted by a script, this function will post the message in the message queue of the specified window, and return without waiting.
---If the window and message type are currently being intercepted, the message will be sent directly to the original window process, similar to WindowMessage_Send, thereby skipping any intercepts.
---Parameters:
--- * message: String containing a single message name, such as "WM_SETCURSOR", or in hexadecimal format, "0x0020".
--- (For a list of WM_ and CB_ message types that are valid cross-platform, refer to swell-types.h. Only these will be recognized by WM_ or CB_ name.)
--- * wParam, wParamHigh, lParam and lParamHigh: Low and high 16-bit WORDs of the WPARAM and LPARAM parameters.
---(Most window messages encode separate information into the two WORDs. However, for those rare cases in which the entire WPARAM and LPARAM must be used to post a large pointer, the script can store this address in wParam or lParam, and keep wParamHigh and lParamHigh zero.)
---Notes:
--- * For more information about parameter values, refer to documentation for the Win32 C++ function PostMessage.
--- * Messages should only be sent to windows that were created from the main thread.
--- * Useful for simulating mouse clicks and calling mouse modifier actions from scripts.
---@param windowHWND userdata
---@param message string
---@param wParam number
---@param wParamHighWord integer
---@param lParam number
---@param lParamHighWord integer
---@return boolean retval
function reaper.JS_WindowMessage_Post(windowHWND, message, wParam, wParamHighWord, lParam, lParamHighWord) end

---Release script intercepts of window messages for all windows.
function reaper.JS_WindowMessage_ReleaseAll() end

---Sends a message to the specified window by calling the window process directly, and only returns after the message has been processed. Any intercepts of the message by scripts will be skipped, and the message can therefore not be blocked.
---Parameters:
--- * message: String containing a single message name, such as "WM_SETCURSOR", or in hexadecimal format, "0x0020".
--- (For a list of WM_ and CB_ message types that are valid cross-platform, refer to swell-types.h. Only these will be recognized by WM_ or CB_ name.)
--- * wParam, wParamHigh, lParam and lParamHigh: Low and high 16-bit WORDs of the WPARAM and LPARAM parameters.
---(Most window messages encode separate information into the two WORDs. However, for those rare cases in which the entire WPARAM and LPARAM must be used to post a large pointer, the script can store this address in wParam or lParam, and keep wParamHigh and lParamHigh zero.)
---Notes:
--- * For more information about parameter and return values, refer to documentation for the Win32 C++ function SendMessage.
--- * Messages should only be sent to windows that were created from the main thread.
--- * Useful for simulating mouse clicks and calling mouse modifier actions from scripts.
---@param windowHWND userdata
---@param message string
---@param wParam number
---@param wParamHighWord integer
---@param lParam number
---@param lParamHighWord integer
---@return integer retval
function reaper.JS_WindowMessage_Send(windowHWND, message, wParam, wParamHighWord, lParam, lParamHighWord) end

---Finds all child windows of the specified parent.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * The addresses are stored in the provided reaper.array, and can be converted to REAPER objects (HWNDs) by the function JS_Window_HandleFromAddress.
---@param parentHWND userdata
---@param reaperarray userdata
---@return integer retval
function reaper.JS_Window_ArrayAllChild(parentHWND, reaperarray) end

---Finds all windows, whether top-level or child, whose titles match the specified string.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * The addresses are stored in the provided reaper.array, and can be converted to REAPER objects (HWNDs) by the function JS_Window_HandleFromAddress.
---Parameters:
--- * exact: Match entire title exactly, or match substring of title.
---@param title string
---@param exact boolean
---@param reaperarray userdata
---@return integer retval
function reaper.JS_Window_ArrayFind(title, exact, reaperarray) end

---Attaches a "pin on top" button to the window frame. The button should remember its state when closing and re-opening the window.
---WARNING: This function does not yet work on Linux.
---@param windowHWND userdata
function reaper.JS_Window_AttachTopmostPin(windowHWND) end

---Creates a modeless window with WS_OVERLAPPEDWINDOW style and only rudimentary features. Scripts can paint into the window using GDI or LICE/Composite functions (and JS_Window_InvalidateRect to trigger re-painting).
---style: An optional parameter that overrides the default style. The string may include any combination of standard window styles, such as "POPUP" for a frameless window, or "CAPTION,SIZEBOX,SYSMENU" for a standard framed window.
---On Linux and macOS, "MAXIMIZE" has not yet been implemented, and the remaining styles may appear slightly different from their WindowsOS counterparts.
---className: On Windows, only standard ANSI characters are supported.
---ownerHWND: Optional parameter, only available on WindowsOS.  Usually either the REAPER main window or another script window, and useful for ensuring that the created window automatically closes when the owner is closed.
---NOTE: On Linux and macOS, the window contents are only updated *between* defer cycles, so the window cannot be animated by for/while loops within a single defer cycle.
---@param title string
---@param className string
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param style? string 
---@param ownerHWND userdata
---@return identifier retval
---@return string? style
function reaper.JS_Window_Create(title, className, x, y, w, h, style, ownerHWND) end

---Enables or disables mouse and keyboard input to the specified window or control.
---@param windowHWND userdata
---@param enable boolean
function reaper.JS_Window_Enable(windowHWND, enable) end

---Returns a HWND to a window whose title matches the specified string.
--- * Unlike the Win32 function FindWindow, this function searches top-level as well as child windows, so that the target window can be found irrespective of docked state.
--- * In addition, the function can optionally match substrings of the title.
--- * Matching is not case sensitive.
---Parameters:
--- * exact: Match entire title, or match substring of title.
---@param title string
---@param exact boolean
---@return identifier retval
function reaper.JS_Window_Find(title, exact) end

---Similar to the C++ WIN32 function GetDlgItem, this function finds child windows by ID.
---(The ID of a window may be retrieved by JS_Window_GetLongPtr.)
---@param parentHWND userdata
---@param ID integer
---@return identifier retval
function reaper.JS_Window_FindChildByID(parentHWND, ID) end

---Returns a HWND to a top-level window whose title matches the specified string.
---Parameters:
--- * exact: Match entire title length, or match substring of title. In both cases, matching is not case sensitive.
---@param title string
---@param exact boolean
---@return identifier retval
function reaper.JS_Window_FindTop(title, exact) end

---WARNING: May not be fully implemented on macOS and Linux.
---@param windowHWND userdata
---@return string class
function reaper.JS_Window_GetClassName(windowHWND) end

---@param windowHWND userdata
---@return boolean retval
---@return integer width
---@return integer height
function reaper.JS_Window_GetClientSize(windowHWND) end

---Retrieves a HWND to the top-level foreground window (the window with which the user is currently working).
---@return identifier retval
function reaper.JS_Window_GetForeground() end

---Returns information about the specified window.
---info: "USERDATA", "WNDPROC", "DLGPROC", "ID", "EXSTYLE" or "STYLE".
---For documentation about the types of information returned, refer to the Win32 function GetWindowLongPtr.
---The values returned by "DLGPROC" and "WNDPROC" are typically used as-is, as pointers, whereas the others should first be converted to integers.
---If the function fails, a null pointer is returned.
---@param windowHWND userdata
---@param info string
---@return identifier retval
function reaper.JS_Window_GetLongPtr(windowHWND, info) end

---Retrieves the screen coordinates of the bounding rectangle of the specified window.
---NOTES:
--- * On Windows and Linux, coordinates are relative to *upper* left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
--- * The pixel at (right, bottom) lies immediately outside the rectangle.
---@param windowHWND userdata
---@return boolean retval
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.JS_Window_GetRect(windowHWND) end

---Retrieves the scroll information of a window.
---Parameters:
--- * windowHWND: The window that contains the scrollbar. This is usually a child window, not a top-level, framed window.
--- * scrollbar: "v" (or "SB_VERT", or "VERT") for vertical scroll, "h" (or "SB_HORZ" or "HORZ") for horizontal.
---Returns:
--- * Leftmost or topmost visible pixel position, as well as the visible page size, the range minimum and maximum, and scroll box tracking position.
---@param windowHWND userdata
---@param scrollbar string
---@return boolean retval
---@return integer position
---@return integer pageSize
---@return integer min
---@return integer max
---@return integer trackPos
function reaper.JS_Window_GetScrollInfo(windowHWND, scrollbar) end

---Retrieves the dimensions of the display monitor that has the largest area of intersection with the specified rectangle.
---If the monitor is not the primary display, some of the rectangle's coordinates may be negative.
---wantWork: Returns the work area of the display, which excludes the system taskbar or application desktop toolbars.
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param wantWork boolean
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.JS_Window_GetViewportFromRect(x1, y1, x2, y2, wantWork) end

---Similar to the Win32 function InvalidateRect.
---@param windowHWND userdata
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
---@param eraseBackground boolean
---@return boolean retval
function reaper.JS_Window_InvalidateRect(windowHWND, left, top, right, bottom, eraseBackground) end

---Determines the visibility state of the window.
---@param windowHWND userdata
---@return boolean retval
function reaper.JS_Window_IsVisible(windowHWND) end

---Finds all child windows of the specified parent.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * list: A comma-separated string of hexadecimal values.
---Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
---@param parentHWND userdata
---@return integer retval
---@return string list
function reaper.JS_Window_ListAllChild(parentHWND) end

---Finds all windows (whether top-level or child) whose titles match the specified string.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * list: A comma-separated string of hexadecimal values. Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
---Parameters:
--- * exact: Match entire title exactly, or match substring of title.
---@param title string
---@param exact boolean
---@return integer retval
---@return string list
function reaper.JS_Window_ListFind(title, exact) end

---Changes the position of the specified window, keeping its size constant.
---NOTES:
--- * For top-level windows, position is relative to the primary display.
--- * On Windows and Linux, position is calculated as the coordinates of the upper left corner of the window, relative to upper left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, position is calculated as the coordinates of the bottom left corner of the window, relative to bottom left corner of the display, and the positive Y-axis points upward.
--- * For a child window, on all platforms, position is relative to the upper-left corner of the parent window's client area.
--- * Equivalent to calling JS_Window_SetPosition with NOSIZE, NOZORDER, NOACTIVATE and NOOWNERZORDER flags set.
---@param windowHWND userdata
---@param left integer
---@param top integer
function reaper.JS_Window_Move(windowHWND, left, top) end

---Changes the dimensions of the specified window, keeping the top left corner position constant.
--- * If resizing script GUIs, call gfx.update() after resizing.
---* Equivalent to calling JS_Window_SetPosition with NOMOVE, NOZORDER, NOACTIVATE and NOOWNERZORDER flags set.
---@param windowHWND userdata
---@param width integer
---@param height integer
function reaper.JS_Window_Resize(windowHWND, width, height) end

---Sets the keyboard focus to the specified window.
---@param windowHWND userdata
function reaper.JS_Window_SetFocus(windowHWND) end

---Similar to the Win32 function SetWindowLongPtr. 
---info: "USERDATA", "WNDPROC", "DLGPROC", "ID", "EXSTYLE" or "STYLE", and only on WindowOS, "INSTANCE" and "PARENT".
---@param windowHWND userdata
---@param info string
---@param value number
---@return number retval
function reaper.JS_Window_SetLong(windowHWND, info, value) end

---If successful, returns a handle to the previous parent window.
---Only on WindowsOS: If parentHWND is not specified, the desktop window becomes the new parent window.
---@param childHWND userdata
---@param parentHWND userdata
---@return identifier retval
function reaper.JS_Window_SetParent(childHWND, parentHWND) end

---Parameters:
--- * scrollbar: "v" (or "SB_VERT", or "VERT") for vertical scroll, "h" (or "SB_HORZ" or "HORZ") for horizontal.
---NOTE: API functions can scroll REAPER's windows, but cannot zoom them.  Instead, use actions such as "View: Zoom to one loop iteration".
---@param windowHWND userdata
---@param scrollbar string
---@param position integer
---@return boolean retval
function reaper.JS_Window_SetScrollPos(windowHWND, scrollbar, position) end

---Changes the title of the specified window. Returns true if successful.
---@param windowHWND userdata
---@param title string
---@return boolean retval
function reaper.JS_Window_SetTitle(windowHWND, title) end

---Sets the specified window's show state.
---Parameters:
--- * state: One of the following options: "SHOW", "SHOWNA" (or "SHOWNOACTIVATE"), "SHOWMINIMIZED", "HIDE", "NORMAL", "SHOWNORMAL", "SHOWMAXIMIZED", "SHOWDEFAULT" or "RESTORE". On Linux and macOS, only the first four options are fully implemented.
---@param windowHWND userdata
---@param state string
function reaper.JS_Window_Show(windowHWND, state) end

---Closes the zip archive, using either the file name or the zip handle. Finalizes entries and releases resources.
---@param zipFile string
---@param zipHandle userdata
---@return integer retval
function reaper.JS_Zip_Close(zipFile, zipHandle) end

---Deletes the specified entries from an existing Zip file.
---entryNames is zero-separated and double-zero-terminated.
---Returns the number of deleted entries on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param entryNames string
---@param entryNamesStrLen integer
---@return integer retval
function reaper.JS_Zip_DeleteEntries(zipHandle, entryNames, entryNamesStrLen) end

---Compresses the specified file into the zip archive's open entry.
---Returns 0 on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param inputFile string
---@return integer retval
function reaper.JS_Zip_Entry_CompressFile(zipHandle, inputFile) end

---Extracts the zip archive's open entry.
---Returns 0 on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param outputFile string
---@return integer retval
function reaper.JS_Zip_Entry_ExtractToFile(zipHandle, outputFile) end

---Returns information about the zip archive's open entry.
---@param zipHandle userdata
---@return integer retval
---@return string name
---@return integer index
---@return integer isFolder
---@return number size
---@return number crc32
function reaper.JS_Zip_Entry_Info(zipHandle) end

---Opens an entry by name in the zip archive.
---For zip archive opened in 'w' or 'a' mode the function will append a new entry. In readonly mode the function tries to locate an existing entry.
---Returns 0 on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param entryName string
---@return integer retval
function reaper.JS_Zip_Entry_OpenByName(zipHandle, entryName) end

---Extracts an existing Zip file to the specified folder.
---Returns the number of extracted files on success, negative number (< 0) on error.
---@param zipFile string
---@param outputFolder string
---@return integer retval
function reaper.JS_Zip_Extract(zipFile, outputFolder) end

---Opens a zip archive using the given mode, which can be either "READ" or "WRITE" (or simply 'r' or 'w').
--- * READ: Opens an existing archive for reading/extracting.
--- * WRITE: Opens an archive for writing/deleting. If the file doesn't exist, an empty archive will created.
---compressionLevel is only relevant for WRITE mode, and ranges from 0 (fastest, no compression) to 9 (slowest, best compression), with a default of 6.
---If successful, returns 0 and a handle to the Zip archive. If failed, returns a negative error code. If the file is already open -- in the given mode -- the existing handle will be returned.
---NOTES:
--- * The Zip API functions support Unicode file names and entry names.
--- * The original zip specification did not support Unicode. Some applications still use this outdated specification by default, or try to use the local code page. This may lead to incompatibility and incorrect retrieval of file or entry names.
---@param zipFile string
---@param mode string
---@param compressionLevel integer
---@return identifier retval
---@return integer retval
function reaper.JS_Zip_Open(zipFile, mode, compressionLevel) end

---Get paths. Returns a string of the form "start:fx#1.fx#2...;track:fxs;...;end:fxs" where track is the track number and fx is the fx index. The string is truncated to pathStringOut_sz. 1-based indexing is used. If no MediaTrack* start is provided, all monitored input tracks are used. If no MediaTrack* end is provided, all hardware output tracks are used. If includeFx is true, the fx indices are included.
---@param includeFx boolean
---@param startIn  MediaTrack
---@param endIn MediaTrack
---@return string pathString
function reaper.Llm_GetPaths(includeFx, startIn, endIn) end

---Get version. Returns the version of the plugin as integers and the commit hash as a string. The string is truncated to commitOut_sz.
---@return integer major
---@return integer minor
---@return integer patch
---@return integer build
---@return string commit
function reaper.Llm_GetVersion() end

---Set keep pdc
---@param enable boolean
function reaper.Llm_SetKeepPdc(enable) end

---Set parameter change. Set val1 = val2 to clear change. Set parameter_index = -666 to clear all changes. Use this function to set parameter changes between values val1 and val2 for fx_name and parameter_index instead of disabling the effect. Use custom fx names to identify individual fx.
---@param fx_name string
---@param parameter_index integer
---@param val1 number
---@param val2 number
function reaper.Llm_SetParameterChange(fx_name, parameter_index, val1, val2) end

---Set safed. Set isSet = true to safe fx name. Set isSet = false to unsafe fx name.
---@param fx_name string 
---@param isSet boolean
---@return string fx_name
function reaper.Llm_SetSafed(fx_name, isSet) end

---Get MIDI input or output dev ID. type 0 is input dev, type 1 is output dev. device < 0 returns number of MCULive devices.
---@param device integer
---@param type integer
---@return integer retval
function reaper.MCULive_GetDevice(device, type) end

---Returns zero-indexed fader parameter value. 0 = lastpos, 1 = lasttouch, 2 = lastmove (any fader)
---@param device integer
---@param faderIdx integer
---@param param integer
---@return number retval
function reaper.MCULive_GetFaderValue(device, faderIdx, param) end

---Maps MCU Live device# button# to REAPER command ID. E.g. reaper.MCULive_Map(0,0x5b, 40340) maps MCU Rewind to "Track: Unsolo all tracks". Or remap button to another button if your MCU button layout doesnt play nicely with default MCULive mappings. By default range 0x00 .. 0x2d is in use. Button numbers are second column (prefixed with 0x) e.g. '90 5e' 0x5e for 'transport : play', roughly. 
---mcu documentation: 
---mcu=>pc: 
---  the mcu seems to send, when it boots (or is reset) f0 00 00 66 14 01 58 59 5a 57 18 61 05 57 18 61 05 f7 
---  ex vv vv    :   volume fader move, x=0..7, 8=master, vv vv is int14 
---  b0 1x vv    :   pan fader move, x=0..7, vv has 40 set if negative, low bits 0-31 are move amount 
---  b0 3c vv    :   jog wheel move, 01 or 41 
---  to the extent the buttons below have leds, you can set them by sending these messages, with 7f for on, 1 for blink, 0 for off. 
---  90 0x vv    :   rec arm push x=0..7 (vv:..) 
---  90 0x vv    :   solo push x=8..f (vv:..) 
---  90 1x vv    :   mute push x=0..7 (vv:..) 
---  90 1x vv    :   selected push x=8..f (vv:..) 
---  90 2x vv    :   pan knob push, x=0..7 (vv:..) 
---  90 28 vv    :   assignment track 
---  90 29 vv    :   assignment send 
---  90 2a vv    :   assignment pan/surround 
---  90 2b vv    :   assignment plug-in 
---  90 2c vv    :   assignment eq 
---  90 2d vv    :   assignment instrument 
---  90 2e vv    :   bank down button (vv: 00=release, 7f=push) 
---  90 2f vv    :   channel down button (vv: ..) 
---  90 30 vv    :   bank up button (vv:..) 
---  90 31 vv    :   channel up button (vv:..) 
---  90 32 vv    :   flip button 
---  90 33 vv    :   global view button 
---  90 34 vv    :   name/value display button 
---  90 35 vv    :   smpte/beats mode switch (vv:..) 
---  90 36 vv    :   f1 
---  90 37 vv    :   f2 
---  90 38 vv    :   f3 
---  90 39 vv    :   f4 
---  90 3a vv    :   f5 
---  90 3b vv    :   f6 
---  90 3c vv    :   f7 
---  90 3d vv    :   f8 
---  90 3e vv    :   global view : midi tracks 
---  90 3f vv    :   global view : inputs 
---  90 40 vv    :   global view : audio tracks 
---  90 41 vv    :   global view : audio instrument 
---  90 42 vv    :   global view : aux 
---  90 43 vv    :   global view : busses 
---  90 44 vv    :   global view : outputs 
---  90 45 vv    :   global view : user 
---  90 46 vv    :   shift modifier (vv:..) 
---  90 47 vv    :   option modifier 
---  90 48 vv    :   control modifier 
---  90 49 vv    :   alt modifier 
---  90 4a vv    :   automation read/off 
---  90 4b vv    :   automation write 
---  90 4c vv    :   automation trim 
---  90 4d vv    :   automation touch 
---  90 4e vv    :   automation latch 
---  90 4f vv    :   automation group 
---  90 50 vv    :   utilities save 
---  90 51 vv    :   utilities undo 
---  90 52 vv    :   utilities cancel 
---  90 53 vv    :   utilities enter 
---  90 54 vv    :   marker 
---  90 55 vv    :   nudge 
---  90 56 vv    :   cycle 
---  90 57 vv    :   drop 
---  90 58 vv    :   replace 
---  90 59 vv    :   click 
---  90 5a vv    :   solo 
---  90 5b vv    :   transport rewind (vv:..) 
---  90 5c vv    :   transport ffwd (vv:..) 
---  90 5d vv    :   transport pause (vv:..) 
---  90 5e vv    :   transport play (vv:..) 
---  90 5f vv    :   transport record (vv:..) 
---  90 60 vv    :   up arrow button  (vv:..) 
---  90 61 vv    :   down arrow button 1 (vv:..) 
---  90 62 vv    :   left arrow button 1 (vv:..) 
---  90 63 vv    :   right arrow button 1 (vv:..) 
---  90 64 vv    :   zoom button (vv:..) 
---  90 65 vv    :   scrub button (vv:..) 
---  90 6x vv    :   fader touch x=8..f 
---  90 70 vv    :   master fader touch 
---pc=>mcu: 
---  f0 00 00 66 14 12 xx <data> f7   : update lcd. xx=offset (0-112), string. display is 55 chars wide, second line begins at 56, though. 
---  f0 00 00 66 14 08 00 f7          : reset mcu 
---  f0 00 00 66 14 20 0x 03 f7       : put track in vu meter mode, x=track   
---  90 73 vv : rude solo light (vv: 7f=on, 00=off, 01=blink) 
---  b0 3x vv : pan display, x=0..7, vv=1..17 (hex) or so 
---  b0 4x vv : right to left of leds. if 0x40 set in vv, dot below char is set (x=0..11) 
---  d0 yx    : update vu meter, y=track, x=0..d=volume, e=clip on, f=clip off 
---  ex vv vv : set volume fader, x=track index, 8=master
---@param device integer
---@param button integer
---@param command_id integer
---@param isRemap boolean
---@return integer retval
function reaper.MCULive_Map(device, button, command_id, isRemap) end

---Sends MIDI message to device. If string is provided, individual bytes are not sent. Returns number of sent bytes.
---@param device integer
---@param status integer
---@param data1 integer
---@param data2 integer
---@param msgIn? string
---@return integer retval
function reaper.MCULive_SendMIDIMessage(device, status, data1, data2, msgIn) end

---Buttons function as press only by default. Set false for press and release function.
---@param device integer
---@param button integer
---@param isSet boolean
---@return integer retval
function reaper.MCULive_SetButtonPressOnly(device, button, isSet) end

---Enables/disables default out-of-the-box operation.
---@param device integer
---@param isSet boolean
function reaper.MCULive_SetDefault(device, isSet) end

---Set encoder to value 0 ... 1.0. Type 0 = linear, 1 = track volume, 2 = pan. Returns scaled value.
---@param device integer
---@param encIdx integer
---@param val number
---@param type integer
---@return integer retval
function reaper.MCULive_SetEncoderValue(device, encIdx, val, type) end

---Set meter value 0 ... 1.0. Type 0 = linear, 1 = track volume (with decay).
---@param device integer
---@param meterIdx integer
---@param val number
---@param type integer
---@return integer retval
function reaper.MCULive_SetMeterValue(device, meterIdx, val, type) end

---This function combines all other NF_Peak/RMS functions in a single one and additionally returns peak RMS positions. Lua example code here. Note: It's recommended to use this function with ReaScript/Lua as it provides reaper.array objects. If using this function with other scripting languages, you must provide arrays in the reaper.array format.
---@param item MediaItem
---@param windowSize number
---@param reaper_array_peaks userdata
---@param reaper_array_peakpositions userdata
---@param reaper_array_RMSs userdata
---@param reaper_array_RMSpositions userdata
---@return boolean retval
function reaper.NF_AnalyzeMediaItemPeakAndRMS(item, windowSize, reaper_array_peaks, reaper_array_peakpositions, reaper_array_RMSs, reaper_array_RMSpositions) end

---Same as NF_AnalyzeTakeLoudness but additionally returns shortTermMaxPos and momentaryMaxPos (in absolute project time). Note: shortTermMaxPos and momentaryMaxPos indicate the beginning of time intervalls, (3 sec. and 0.4 sec. resp.).
---@param take MediaItem_Take
---@param analyzeTruePeak boolean
---@return boolean retval
---@return number lufsIntegrated
---@return number range
---@return number truePeak
---@return number truePeakPos
---@return number shortTermMax
---@return number momentaryMax
---@return number shortTermMaxPos
---@return number momentaryMaxPos
function reaper.NF_AnalyzeTakeLoudness2(take, analyzeTruePeak) end

---Returns true on success.
---@param base64Str string
---@return boolean retval
---@return string decodedStr
function reaper.NF_Base64_Decode(base64Str) end

---Returns true if global startup action was cleared successfully.
---@return boolean retval
function reaper.NF_ClearGlobalStartupAction() end

---Returns true if project track selection action was cleared successfully.
---@return boolean retval
function reaper.NF_ClearProjectTrackSelectionAction() end

---Gets action description and command ID number (for native actions) or named command IDs / identifier strings (for extension actions /ReaScripts) if global startup action is set, otherwise empty string. Returns false on failure.
---@return boolean retval
---@return string desc
---@return string cmdId
function reaper.NF_GetGlobalStartupAction() end

---Returns the greatest max. peak value in dBFS of all active channels of an audio item active take, post item gain, post take volume envelope, post-fade, pre fader, pre item FX. 
--- Returns -150.0 if MIDI take or empty item.
---@param item MediaItem
---@return number retval
function reaper.NF_GetMediaItemMaxPeak(item) end

---Returns the greatest overall (non-windowed) dB RMS peak level of all active channels of an audio item active take, post item gain, post take volume envelope, post-fade, pre fader, pre item FX. 
--- Returns -150.0 if MIDI take or empty item.
---@param item MediaItem
---@return number retval
function reaper.NF_GetMediaItemPeakRMS_NonWindowed(item) end

---Gets action description and command ID number (for native actions) or named command IDs / identifier strings (for extension actions /ReaScripts) if project startup action is set, otherwise empty string. Returns false on failure.
---@return boolean retval
---@return string desc
---@return string cmdId
function reaper.NF_GetProjectStartupAction() end

---Returns SWS/S&M marker/region subtitle. markerRegionIdx: Refers to index that can be passed to EnumProjectMarkers (not displayed marker/region index). Returns empty string if marker/region with specified index not found or marker/region subtitle not set. Lua code example here.
---@param markerRegionIdx integer
---@return string retval
function reaper.NF_GetSWSMarkerRegionSub(markerRegionIdx) end

---Get SWS analysis/normalize options. See NF_SetSWS_RMSoptions.
---@return number target
---@return number windowSize
function reaper.NF_GetSWS_RMSoptions() end

---Returns the bitrate of an audio file in kb/s if available (0 otherwise). For supported filetypes see TagLib::AudioProperties::bitrate.
---@param fn string
---@return integer retval
function reaper.NF_ReadAudioFileBitrate(fn) end

---Returns true if global startup action was set successfully (i.e. valid action ID). Note: For SWS / S&M actions and macros / scripts, you must use identifier strings (e.g. "_SWS_ABOUT", "_f506bc780a0ab34b8fdedb67ed5d3649"), not command IDs (e.g. "47145").
---Tip: to copy such identifiers, right-click the action in the Actions window > Copy selected action cmdID / identifier string.
---NOnly works for actions / scripts from Main action section.
---@param str string
---@return boolean retval
function reaper.NF_SetGlobalStartupAction(str) end

---Returns true if project track selection action was set successfully (i.e. valid action ID). Note: For SWS / S&M actions and macros / scripts, you must use identifier strings (e.g. "_SWS_ABOUT", "_f506bc780a0ab34b8fdedb67ed5d3649"), not command IDs (e.g. "47145").
---Tip: to copy such identifiers, right-click the action in the Actions window > Copy selected action cmdID / identifier string.
---Only works for actions / scripts from Main action section. Project must be saved after setting project track selection action to be persistent.
---@param str string
---@return boolean retval
function reaper.NF_SetProjectTrackSelectionAction(str) end

---@param track MediaTrack
---@param str string
function reaper.NF_SetSWSTrackNotes(track, str) end

---Deprecated, see TakeFX_GetNamedConfigParm/'fx_ident' (v6.37+). See BR_TrackFX_GetFXModuleName. fx: counted consecutively across all takes (zero-based).
---@param item MediaItem
---@param fx integer
---@return boolean retval
---@return string name
function reaper.NF_TakeFX_GetFXModuleName(item, fx) end

---Equivalent to win32 API GetSystemMetrics(). Note: Only SM_C[XY]SCREEN, SM_C[XY][HV]SCROLL and SM_CYMENU are currently supported on macOS and Linux as of REAPER 6.68. Check the SWELL source code for up-to-date support information (swell-wnd.mm, swell-wnd-generic.cpp).
---@param nIndex integer
---@return integer retval
function reaper.NF_Win32_GetSystemMetrics(nIndex) end

---[NVK] Counts the number of NVK Folder Items in a given project. 0 = active project.
---@param project ReaProject
---@return integer retval
function reaper.NVK_CountFolderItems(project) end

---[NVK] Counts the number of NVK Folder Items on a given track.
---@param track MediaTrack
---@return integer retval
function reaper.NVK_CountTrackFolderItems(track) end

---[NVK] Gets the NVK Folder Item at the given index in the given project. 0 = active project.
---@param project ReaProject
---@param index integer
---@return MediaItem retval
function reaper.NVK_GetFolderItem(project, index) end

---[NVK] Gets the selected NVK Folder Item at the given index in the given project. 0 = active project.
---@param project ReaProject
---@param index integer
---@return MediaItem retval
function reaper.NVK_GetSelectedFolderItem(project, index) end

---[NVK] Returns the version of the NVK Reaper API.
---@return string retval
function reaper.NVK_GetVersion() end

---[NVK] Checks if the given NVK Folder Item is selected.
---@param item MediaItem
---@return boolean retval
function reaper.NVK_IsFolderItemSelected(item) end

---[NVK] Selects all NVK Folder Items in the given project. 0 = active project. selected = true to select, false to unselect, defaults to true.
---@param project ReaProject
---@param selectedIn? boolean
function reaper.NVK_SelectAllFolderItems(project, selectedIn) end

---[NVK] Sets the given NVK Folder Item to be selected (true) or unselected (false).
---@param item MediaItem
---@param selected boolean
function reaper.NVK_SetFolderItemSelected(item, selected) end

---Show the about dialog of the given repository. Returns true if the repository exists in the user configuration.
---The repository index is downloaded asynchronously if the cached copy doesn't exist or is older than one week.
---@param repoName string
---@return boolean retval
function reaper.ReaPack_AboutRepository(repoName) end

---Opens the package browser with the given filter string.
---@param filter string
function reaper.ReaPack_BrowsePackages(filter) end

---Enumerate the files owned by the given package. Returns false when there is no more data.
---sections: 0=not in action list, &1=main, &2=midi editor, &4=midi inline editor
---type: see ReaPack_GetEntryInfo.
---@param entry PackageEntry
---@param index integer
---@return boolean retval
---@return string path
---@return integer sections
---@return integer type
function reaper.ReaPack_EnumOwnedFiles(entry, index) end

---Get the repository name, category, package name, package description, package type, the currently installed version, author name, flags (&1=Pinned, &2=BleedingEdge) and how many files are owned by the given package entry.
---type: 1=script, 2=extension, 3=effect, 4=data, 5=theme, 6=langpack, 7=webinterface
---@param entry PackageEntry
---@return boolean retval
---@return string repo
---@return string cat
---@return string pkg
---@return string desc
---@return integer type
---@return string ver
---@return string author
---@return integer flags
---@return integer fileCount
function reaper.ReaPack_GetEntryInfo(entry) end

---Get the infos of the given repository.
---autoInstall: 0=manual, 1=when sychronizing, 2=obey user setting
---@param name string
---@return boolean retval
---@return string url
---@return boolean enabled
---@return integer autoInstall
function reaper.ReaPack_GetRepositoryInfo(name) end

---[S&M] Deprecated, see CreateTrackSend (v5.15pre1+). Adds a receive. Returns false if nothing updated.
---type -1=Default type (user preferences), 0=Post-Fader (Post-Pan), 1=Pre-FX, 2=deprecated, 3=Pre-Fader (Post-FX).
---Note: obeys default sends preferences, supports frozen tracks, etc..
---@param src MediaTrack
---@param dest MediaTrack
---@param type integer
---@return boolean retval
function reaper.SNM_AddReceive(src, dest, type) end

---[S&M] Instantiates a new "fast string". You must delete this string, see SNM_DeleteFastString.
---@param str string
---@return WDL_FastString retval
function reaper.SNM_CreateFastString(str) end

---[S&M] Returns a floating-point preference (look in project prefs first, then in general prefs). Returns errvalue if failed (e.g. varname not found).
---@param varname string
---@param errvalue number
---@return number retval
function reaper.SNM_GetDoubleConfigVar(varname, errvalue) end

---[S&M] Gets the "fast string" content.
---@param str WDL_FastString
---@return string retval
function reaper.SNM_GetFastString(str) end

---[S&M] Returns an integer preference (look in project prefs first, then in general prefs). Returns errvalue if failed (e.g. varname not found).
---@param varname string
---@param errvalue integer
---@return integer retval
function reaper.SNM_GetIntConfigVar(varname, errvalue) end

---[S&M] Reads a 64-bit integer preference split in two 32-bit integers (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found).
---@param varname string
---@return boolean retval
---@return integer high
---@return integer low
function reaper.SNM_GetLongConfigVar(varname) end

---[S&M] Gets a take by GUID as string. The GUID must be enclosed in braces {}. To get take GUID as string, see BR_GetMediaItemTakeGUID
---@param project ReaProject
---@param guid string
---@return MediaItem_Take retval
function reaper.SNM_GetMediaItemTakeByGUID(project, guid) end

---[S&M] Gets or sets the state of a track, an item or an envelope. The state chunk size is unlimited. Returns false if failed.
---When getting a track state (and when you are not interested in FX data), you can use wantminimalstate=true to radically reduce the length of the state. Do not set such minimal states back though, this is for read-only applications!
---Note: unlike the native GetSetObjectState, calling to FreeHeapPtr() is not required.
---@param obj userdata
---@param state WDL_FastString
---@param setnewvalue boolean
---@param wantminimalstate boolean
---@return boolean retval
function reaper.SNM_GetSetObjectState(obj, state, setnewvalue, wantminimalstate) end

---[S&M] Gets or sets a take source state. Returns false if failed.
---Note: this function cannot deal with empty takes, see SNM_GetSetSourceState.
---@param take MediaItem_Take
---@param state WDL_FastString
---@param setnewvalue boolean
---@return boolean retval
function reaper.SNM_GetSetSourceState2(take, state, setnewvalue) end

---[S&M] Deprecated, see TrackFX_{CopyToTrack,Delete} (v5.95+). Move or removes a track FX. Returns true if tr has been updated.
---fxId: fx index in chain or -1 for the selected fx. what: 0 to remove, -1 to move fx up in chain, 1 to move fx down in chain.
---@param tr MediaTrack
---@param fxId integer
---@param what integer
---@return boolean retval
function reaper.SNM_MoveOrRemoveTrackFX(tr, fxId, what) end

---[S&M] Deprecated, see RemoveTrackSend (v5.15pre1+). Removes a receive. Returns false if nothing updated.
---@param tr MediaTrack
---@param rcvidx integer
---@return boolean retval
function reaper.SNM_RemoveReceive(tr, rcvidx) end

---[S&M] Select a bookmark of the Resources window. Returns the related bookmark id (or -1 if failed).
---@param name string
---@return integer retval
function reaper.SNM_SelectResourceBookmark(name) end

---[S&M] See SNM_SetDoubleConfigVar.
---@param proj ReaProject
---@param varname string
---@param newvalue number
---@return boolean retval
function reaper.SNM_SetDoubleConfigVarEx(proj, varname, newvalue) end

---[S&M] Sets an integer preference (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found or newvalue out of range).
---@param varname string
---@param newvalue integer
---@return boolean retval
function reaper.SNM_SetIntConfigVar(varname, newvalue) end

---[S&M] Sets a 64-bit integer preference from two 32-bit integers (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found).
---@param varname string
---@param newHighValue integer
---@param newLowValue integer
---@return boolean retval
function reaper.SNM_SetLongConfigVar(varname, newHighValue, newLowValue) end

---[S&M] Deprecated, see SetProjectMarker4 -- Same function as SetProjectMarker3() except it can set empty names "".
---@param proj ReaProject
---@param num integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color integer
---@return boolean retval
function reaper.SNM_SetProjectMarker(proj, num, isrgn, pos, rgnend, name, color) end

---[S&M] Tags a media file thanks to TagLib. Supported tags: "artist", "album", "genre", "comment", "title", "track" (track number) or "year". Use an empty tagval to clear a tag. When a file is opened in REAPER, turn it offline before using this function. Returns false if nothing updated. See SNM_ReadMediaFileTag.
---@param fn string
---@param tag string
---@param tagval string
---@return boolean retval
function reaper.SNM_TagMediaFile(fn, tag, tagval) end

---Focuses the active/open MIDI editor.
function reaper.SN_FocusMIDIEditor() end

---[ULT] Deprecated, see GetSetMediaItemInfo_String (v5.95+). Set item notes.
---@param item MediaItem
---@param note string
function reaper.ULT_SetMediaItemNote(item, note) end

---Destroys writer
---@param writer AudioWriter
function reaper.Xen_AudioWriter_Destroy(writer) end

---Get interleaved audio data from media source
---@param src PCM_source
---@param destbuf userdata
---@param destbufoffset integer
---@param numframes integer
---@param numchans integer
---@param samplerate number
---@param sourceposition number
---@return integer retval
function reaper.Xen_GetMediaSourceSamples(src, destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition) end

---Stop audio preview. id -1 stops all.
---@param preview_id integer
---@return integer retval
function reaper.Xen_StopSourcePreview(preview_id) end

---Get the current http communication port from Soundminer.
---@return integer retval
function reaper.sm_getPort() end

---Return's metadata for a record.
---@param filepath string 
---@return string retval
---@return string filepath
function reaper.sm_metadata(filepath) end

---Bring back the current sounds on display from Soundminer for nvk_CREATE.
---@param offset integer
---@param maxlimit integer
---@return string retval
function reaper.sm_nvk_CREATE_current(offset, maxlimit) end

---Set's whether the cursor position in reaper should auto advance to the end of the clip after spotting or not.
---@param flag boolean
function reaper.sm_setadvance(flag) end

---Return's Soundminer app version and extension version. App version will be blank on connection error. (Not launched or http interface not running).
---ReaScript/EEL2 Built-in Function List
---@return string retval
function reaper.sm_version() end
