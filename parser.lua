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
---@class (exact) unsupported: boolean?

]]
local footer = [[---is_new_value,filename,sectionID,cmdID,mode,resolution,val,contextstr = reaper.get_action_context()
---Returns contextual information about the script, typically MIDI/OSC input values.
---val will be set to a relative or absolute value depending on mode (=0: absolute mode, >0: relative modes).
---resolution=127 for 7-bit resolution, =16383 for 14-bit resolution.
---sectionID, and cmdID will be set to -1 if the script is not part of the action list.
---mode, resolution and val will be set to -1 if the script was not triggered via MIDI/OSC.
---contextstr may be empty or one of:<br>
---
---* midi:XX[:YY] (one or two bytes hex)
---* [wheel|hwheel|mtvert|mthorz|mtzoom|mtrot|mediakbd]:flags
---* key:flags:keycode
---* osc:/msg[:f=FloatValue|:s=StringValue]
---* KBD_OnMainActionEx
---
---(flags may include V=virtkey, S=shift, A=alt/option, C=control/command, W=win/control)
---@return boolean is_new_value
---@return string filename
---@return integer sectionID
---@return integer cmdID
---@return integer mode
---@return integer resolution
---@return number val
---@return string contextstr
function reaper.get_action_context() end

---Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to runloop().
---Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
---@param function function
---@return boolean retval
function reaper.defer(function) end

---Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to defer().
---Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
---@param function function
---@return boolean retval
function reaper.runloop(function) end

---Adds code to be executed when the script finishes or is ended by the user. Typically used to clean up after the user terminates defer() or runloop() code.
---@param function function
---@return boolean retval
function reaper.atexit(function) end

---Sets action options for the script.
---* flag&1: script will auto-terminate if re-launched while already running
---* flag&2: if (flag&1) is set, script will re-launch after auto-terminating
---* flag&4: set script toggle state on
---* flag&8: set script toggle state off
---@param flag integer
function reaper.set_action_options(flag) end

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

local snippets_header = [[	"REAPER.ATEXIT lua": {
		"prefix": "r.atexit",
		"scope": "lua",
		"body": "r.atexit(${1:function})$0",
		"description": "Adds code to be executed when the script finishes or is ended by the user. Typically used to clean up after the user terminates defer() or runloop() code."
	},
	"REAPER.DEFER lua": {
		"prefix": "r.defer",
		"scope": "lua",
		"body": "r.defer(${1:function})$0",
		"description": "Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to runloop().Note that no undo point will be automatically created when the script finishes, unless you create it explicitly."
	},
	"REAPER.GET_ACTION_CONTEXT lua": {
		"prefix": "r.get_action_context",
		"scope": "lua",
		"body": "r.get_action_context()$0",
		"description": "is_new_value,filename,sectionID,cmdID,mode,resolution,val = r.get_action_context()Returns contextual information about the script, typically MIDI/OSC input values.val will be set to a relative or absolute value depending on mode (=0: absolute mode, >0: relative modes). resolution=127 for 7-bit resolution, =16383 for 14-bit resolution.Notes: sectionID, and cmdID will be set to -1 if the script is not part of the action list. mode, resolution and val will be set to -1 if the script was not triggered via MIDI/OSC."
	},
	"GFX.R lua": {
		"prefix": "gfx.r",
		"scope": "lua",
		"body": "gfx.r$0",
		"description": "These represent the current red, green, blue, and alpha components used by drawing operations (0.0..1.0). "
	},
	"GFX.G lua": {
		"prefix": "gfx.g",
		"scope": "lua",
		"body": "gfx.g$0",
		"description": "These represent the current red, green, blue, and alpha components used by drawing operations (0.0..1.0). "
	},
	"GFX.B lua": {
		"prefix": "gfx.b",
		"scope": "lua",
		"body": "gfx.b$0",
		"description": "These represent the current red, green, blue, and alpha components used by drawing operations (0.0..1.0). "
	},
	"GFX.A lua": {
		"prefix": "gfx.a",
		"scope": "lua",
		"body": "gfx.a$0",
		"description": "These represent the current red, green, blue, and alpha components used by drawing operations (0.0..1.0). "
	},
	"GFX.W lua": {
		"prefix": "gfx.w",
		"scope": "lua",
		"body": "gfx.w$0",
		"description": "These are set to the current width and height of the UI framebuffer. "
	},
	"GFX.H lua": {
		"prefix": "gfx.h",
		"scope": "lua",
		"body": "gfx.h$0",
		"description": "These are set to the current width and height of the UI framebuffer. "
	},
	"GFX.X lua": {
		"prefix": "gfx.x",
		"scope": "lua",
		"body": "gfx.x$0",
		"description": "These set the \"current\" graphics position in x,y. You can set these yourselves, and many of the drawing functions update them as well. "
	},
	"GFX.Y lua": {
		"prefix": "gfx.y",
		"scope": "lua",
		"body": "gfx.y$0",
		"description": "These set the \"current\" graphics position in x,y. You can set these yourselves, and many of the drawing functions update them as well. "
	},
	"GFX.MODE lua": {
		"prefix": "gfx.mode",
		"scope": "lua",
		"body": "gfx.mode$0",
		"description": "Set to 0 for default options. Add 1.0 for additive blend mode (if you wish to do subtractive, set gfx.a to negative and use gfx.mode as additive). Add 2.0 to disable source alpha for gfx.blit(). Add 4.0 to disable filtering for gfx.blit(). "
	},
	"GFX.CLEAR lua": {
		"prefix": "gfx.clear",
		"scope": "lua",
		"body": "gfx.clear$0",
		"description": "If set to a value greater than -1.0, this will result in the framebuffer being cleared to that color. the color for this one is packed RGB (0..255), i.e. red+green*256+blue*65536. The default is 0 (black). "
	},
	"GFX.DEST lua": {
		"prefix": "gfx.dest",
		"scope": "lua",
		"body": "gfx.dest$0",
		"description": "Defaults to -1, set to 0..1024-1 to have drawing operations go to an offscreen buffer (or loaded image)."
	},
	"GFX.TEXTH lua": {
		"prefix": "gfx.texth",
		"scope": "lua",
		"body": "gfx.texth$0",
		"description": "Set to the height of a line of text in the current font. Do not modify this variable."
	},
	"GFX.EXT_RETINA lua": {
		"prefix": "gfx.ext_retina",
		"scope": "lua",
		"body": "gfx.ext_retina$0",
		"description": "If set to 1.0 on initialization, will be updated to 2.0 if high resolution display is supported, and if so gfx.w/gfx.h/etc will be doubled."
	},
	"GFX.MOUSE_X lua": {
		"prefix": "gfx.mouse_x",
		"scope": "lua",
		"body": "gfx.mouse_x$0",
		"description": "gfx.mouse_x and gfx.mouse_y are set to the coordinates of the mouse relative to the graphics window."
	},
	"GFX.MOUSE_Y lua": {
		"prefix": "gfx.mouse_y",
		"scope": "lua",
		"body": "gfx.mouse_y$0",
		"description": "gfx.mouse_x and gfx.mouse_y are set to the coordinates of the mouse relative to the graphics window."
	},
	"GFX.MOUSE_WHEEL lua": {
		"prefix": "gfx.mouse_wheel",
		"scope": "lua",
		"body": "gfx.mouse_wheel$0",
		"description": "mouse wheel (and horizontal wheel) positions. These will change typically by 120 or a multiple thereof, the caller should clear the state to 0 after reading it."
	},
	"GFX.MOUSE_HWHEEL lua": {
		"prefix": "gfx.mouse_hwheel",
		"scope": "lua",
		"body": "gfx.mouse_hwheel$0",
		"description": "mouse wheel (and horizontal wheel) positions. These will change typically by 120 or a multiple thereof, the caller should clear the state to 0 after reading it."
	},
	"GFX.ARC lua": {
		"prefix": "gfx.arc",
		"scope": "lua",
		"body": "gfx.arc(${1:x}, ${2:y}, ${3:r}, ${4:ang1}, ${5:ang2}, ${6:[,antialias]})$0",
		"description": "Draws an arc of the circle centered at x,y, with ang1/ang2 being specified in radians."
	},
	"GFX.BLIT lua": {
		"prefix": "gfx.blit",
		"scope": "lua",
		"body": "gfx.blit(${1:source}, ${2:scale}, ${3:rotation})$0",
		"description": "If three parameters are specified, copies the entirity of the source bitmap to gfx.x,gfx.y using current opacity and copy mode (set with gfx.a, gfx.mode). You can specify scale (1.0 is unscaled) and rotation (0.0 is not rotated, angles are in radians).For the \"source\" parameter specify -1 to use the main framebuffer as source, or an image index (see gfx.loadimg())."
	},
	"GFX.BLITEXT lua": {
		"prefix": "gfx.blitext",
		"scope": "lua",
		"body": "gfx.blitext(${1:source}, ${2:coordinatelist}, ${3:rotation})$0",
		"description": "Deprecated, use gfx.blit instead."
	},
	"GFX.BLURTO lua": {
		"prefix": "gfx.blurto",
		"scope": "lua",
		"body": "gfx.blurto(${1:x}, ${2:y})$0",
		"description": "Blurs the region of the screen between gfx.x,gfx.y and x,y, and updates gfx.x,gfx.y to x,y."
	},
	"GFX.CIRCLE lua": {
		"prefix": "gfx.circle",
		"scope": "lua",
		"body": "gfx.circle(${1:x}, ${2:y}, ${3:r}, ${4:[,fill,antialias]})$0",
		"description": "Draws a circle, optionally filling/antialiasing. "
	},
	"GFX.CLIENTTOSCREEN lua": {
		"prefix": "gfx.clienttoscreen",
		"scope": "lua",
		"body": "gfx.clienttoscreen(${1:x}, ${2:y})$0",
		"description": "Converts the coordinates x,y to screen coordinates, returns those values."
	},
	"GFX.DELTABLIT lua": {
		"prefix": "gfx.deltablit",
		"scope": "lua",
		"body": "gfx.deltablit(${1:srcimg}, ${2:srcx}, ${3:srcy}, ${4:srcw}, ${5:srch}, ${6:destx}, ${7:desty}, ${8:destw}, ${9:desth}, ${10:dsdx}, ${11:dtdx}, ${12:dsdy}, ${13:dtdy}, ${14:dsdxdy}, ${15:dtdxdy})$0",
		"description": "Blits from srcimg(srcx,srcy,srcw,srch) to destination (destx,desty,destw,desth). Source texture coordinates are s/t, dsdx represents the change in s coordinate for each x pixel, dtdy represents the change in t coordinate for each y pixel, etc. dsdxdy represents the change in dsdx for each line. "
	},
	"GFX.DOCK lua": {
		"prefix": "gfx.dock",
		"scope": "lua",
		"body": "gfx.dock(${1:v}, ${2:[,wx,wy,ww,wh]})$0",
		"description": "Call with v=-1 to query docked state, otherwise v>=0 to set docked state. State is &1 if docked, second byte is docker index (or last docker index if undocked). If wx-wh specified, additional values will be returned with the undocked window position/size"
	},
	"GFX.DRAWCHAR lua": {
		"prefix": "gfx.drawchar",
		"scope": "lua",
		"body": "gfx.drawchar(${1:char})$0",
		"description": "Draws the character (can be a numeric ASCII code as well), to gfx.x, gfx.y, and moves gfx.x over by the size of the character."
	},
	"GFX.DRAWNUMBER lua": {
		"prefix": "gfx.drawnumber",
		"scope": "lua",
		"body": "gfx.drawnumber(${1:n}, ${2:ndigits})$0",
		"description": "Draws the number n with ndigits of precision to gfx.x, gfx.y, and updates gfx.x to the right side of the drawing. The text height is gfx.texth."
	},
	"GFX.DRAWSTR lua": {
		"prefix": "gfx.drawstr",
		"scope": "lua",
		"body": "gfx.drawstr(\"${1:str}\", ${2:[,flags,right,bottom]})$0",
		"description": "Draws a string at gfx.x, gfx.y, and updates gfx.x/gfx.y so that subsequent draws will occur in a similar place.If flags, right ,bottom passed in:flags&1: center horizontallyflags&2: right justifyflags&4: center verticallyflags&8: bottom justifyflags&256: ignore right/bottom, otherwise text is clipped to (gfx.x, gfx.y, right, bottom)"
	},
	"GFX.GETCHAR lua": {
		"prefix": "gfx.getchar",
		"scope": "lua",
		"body": "gfx.getchar(${1:[char]})$0",
		"description": "If char is 0 or omitted, returns a character from the keyboard queue, or 0 if no character is available, or -1 if the graphics window is not open. If char is specified and nonzero, that character's status will be checked, and the function will return greater than 0 if it is pressed.Common values are standard ASCII, such as 'a', 'A', '=' and '1', but for many keys multi-byte values are used, including 'home', 'up', 'down', 'left', 'rght', 'f1'.. 'f12', 'pgup', 'pgdn', 'ins', and 'del'. Modified and special keys can also be returned, including:Ctrl/Cmd+A..Ctrl+Z as 1..26Ctrl/Cmd+Alt+A..Z as 257..282Alt+A..Z as 'A'+256..'Z'+25627 for ESC13 for Enter' ' for space"
	},
	"GFX.GETDROPFILE lua": {
		"prefix": "gfx.getdropfile",
		"scope": "lua",
		"body": "gfx.getdropfile(${1:idx})$0",
		"description": "Returns success,string for dropped file index idx. call gfx.dropfile(-1) to clear the list when finished."
	},
	"GFX.GETFONT lua": {
		"prefix": "gfx.getfont",
		"scope": "lua",
		"body": "gfx.getfont()$0",
		"description": "Returns current font index, and the actual font face used by this font (if available)."
	},
	"GFX.GETIMGDIM lua": {
		"prefix": "gfx.getimgdim",
		"scope": "lua",
		"body": "gfx.getimgdim(${1:handle})$0",
		"description": "Retreives the dimensions of an image specified by handle, returns w, h pair."
	},
	"GFX.GETPIXEL lua": {
		"prefix": "gfx.getpixel",
		"scope": "lua",
		"body": "gfx.getpixel()$0",
		"description": "Returns r,g,b values [0..1] of the pixel at (gfx.x,gfx.y)"
	},
	"GFX.GRADRECT lua": {
		"prefix": "gfx.gradrect",
		"scope": "lua",
		"body": "gfx.gradrect(${1:x}, ${2:y}, ${3:w}, ${4:h}, ${5:r}, ${6:g}, ${7:b}, ${8:a}, ${9:[, drdx, dgdx, dbdx, dadx, drdy, dgdy, dbdy, dady]})$0",
		"description": "Fills a gradient rectangle with the color and alpha specified. drdx-dadx reflect the adjustment (per-pixel) applied for each pixel moved to the right, drdy-dady are the adjustment applied for each pixel moved toward the bottom. Normally drdx=adjustamount/w, drdy=adjustamount/h, etc."
	},
	"GFX.INIT lua": {
		"prefix": "gfx.init",
		"scope": "lua",
		"body": "gfx.init(\"${1:name}\", ${2:[,width,height,dockstate,xpos,ypos]})$0",
		"description": "Initializes the graphics window with title name. Suggested width and height can be specified.Once the graphics window is open, gfx.update() should be called periodically. "
	},
	"GFX.LINE lua": {
		"prefix": "gfx.line",
		"scope": "lua",
		"body": "gfx.line(${1:x}, ${2:y}, ${3:x2}, ${4:y2}, ${5:[,aa]})$0",
		"description": "Draws a line from x,y to x2,y2, and if aa is not specified or 0.5 or greater, it will be antialiased. "
	},
	"GFX.LINETO lua": {
		"prefix": "gfx.lineto",
		"scope": "lua",
		"body": "gfx.lineto(${1:x}, ${2:y}, ${3:[,aa]})$0",
		"description": "Draws a line from gfx.x,gfx.y to x,y. If aa is 0.5 or greater, then antialiasing is used. Updates gfx.x and gfx.y to x,y."
	},
	"GFX.LOADIMG lua": {
		"prefix": "gfx.loadimg",
		"scope": "lua",
		"body": "gfx.loadimg(${1:image}, \"${2:filename}\")$0",
		"description": "Load image from filename into slot 0..1024-1 specified by image. Returns the image index if success, otherwise -1 if failure. The image will be resized to the dimensions of the image file. "
	},
	"GFX.MEASURECHAR lua": {
		"prefix": "gfx.measurechar",
		"scope": "lua",
		"body": "gfx.measurechar(${1:char})$0",
		"description": "Measures the drawing dimensions of a character with the current font (as set by gfx.setfont). Returns width and height of character."
	},
	"GFX.MEASURESTR lua": {
		"prefix": "gfx.measurestr",
		"scope": "lua",
		"body": "gfx.measurestr(\"${1:str}\")$0",
		"description": "Measures the drawing dimensions of a string with the current font (as set by gfx.setfont). Returns width and height of string."
	},
	"GFX.MULADDRECT lua": {
		"prefix": "gfx.muladdrect",
		"scope": "lua",
		"body": "gfx.muladdrect(${1:x}, ${2:y}, ${3:w}, ${4:h}, ${5:mul_r}, ${6:mul_g}, ${7:mul_b}, ${8:[,mul_a,add_r,add_g,add_b,add_a]})$0",
		"description": "Multiplies each pixel by mul_* and adds add_*, and updates in-place. Useful for changing brightness/contrast, or other effects."
	},
	"GFX.PRINTF lua": {
		"prefix": "gfx.printf",
		"scope": "lua",
		"body": "gfx.printf(\"${1:format}\", ${2:[, ...]})$0",
		"description": "Formats and draws a string at gfx.x, gfx.y, and updates gfx.x/gfx.y accordingly (the latter only if the formatted string contains newline). For more information on format strings, see sprintf()"
	},
	"GFX.QUIT lua": {
		"prefix": "gfx.quit",
		"scope": "lua",
		"body": "gfx.quit()$0",
		"description": "Closes the graphics window."
	},
	"GFX.RECT lua": {
		"prefix": "gfx.rect",
		"scope": "lua",
		"body": "gfx.rect(${1:x}, ${2:y}, ${3:w}, ${4:h}, ${5:[,filled]})$0",
		"description": "Fills a rectangle at x,y, w,h pixels in dimension, filled by default. "
	},
	"GFX.RECTTO lua": {
		"prefix": "gfx.rectto",
		"scope": "lua",
		"body": "gfx.rectto(${1:x}, ${2:y})$0",
		"description": "Fills a rectangle from gfx.x,gfx.y to x,y. Updates gfx.x,gfx.y to x,y. "
	},
	"GFX.ROUNDRECT lua": {
		"prefix": "gfx.roundrect",
		"scope": "lua",
		"body": "gfx.roundrect(${1:x}, ${2:y}, ${3:w}, ${4:h}, ${5:radius}, ${6:[,antialias]})$0",
		"description": "Draws a rectangle with rounded corners. "
	},
	"GFX.SCREENTOCLIENT lua": {
		"prefix": "gfx.screentoclient",
		"scope": "lua",
		"body": "gfx.screentoclient(${1:x}, ${2:y})$0",
		"description": "Converts the screen coordinates x,y to client coordinates, returns those values."
	},
	"GFX.SET lua": {
		"prefix": "gfx.set",
		"scope": "lua",
		"body": "gfx.set(${1:r}, ${2:[,g,b,a,mode,dest]})$0",
		"description": "Sets gfx.r/gfx.g/gfx.b/gfx.a/gfx.mode, sets gfx.dest if final parameter specified"
	},
	"GFX.SETCURSOR lua": {
		"prefix": "gfx.setcursor",
		"scope": "lua",
		"body": "gfx.setcursor(${1:resource_id}, ${2:custom_cursor_name})$0",
		"description": "Sets the mouse cursor. resource_id is a value like 32512 (for an arrow cursor), custom_cursor_name is a string like \"arrow\" (for the REAPER custom arrow cursor). resource_id must be nonzero, but custom_cursor_name is optional."
	},
	"GFX.SETFONT lua": {
		"prefix": "gfx.setfont",
		"scope": "lua",
		"body": "gfx.setfont(${1:idx}, \"${2:[,fontface, sz, flags]}\")$0",
		"description": "Can select a font and optionally configure it. idx=0 for default bitmapped font, no configuration is possible for this font. idx=1..16 for a configurable font, specify fontface such as \"Arial\", sz of 8-100, and optionally specify flags, which is a multibyte character, which can include 'i' for italics, 'u' for underline, or 'b' for bold. These flags may or may not be supported depending on the font and OS. After calling gfx.setfont(), gfx.texth may be updated to reflect the new average line height."
	},
	"GFX.SETIMGDIM lua": {
		"prefix": "gfx.setimgdim",
		"scope": "lua",
		"body": "gfx.setimgdim(${1:image}, ${2:w}, ${3:h})$0",
		"description": "Resize image referenced by index 0..1024-1, width and height must be 0-2048. The contents of the image will be undefined after the resize."
	},
	"GFX.SETPIXEL lua": {
		"prefix": "gfx.setpixel",
		"scope": "lua",
		"body": "gfx.setpixel(${1:r}, ${2:g}, ${3:b})$0",
		"description": "Writes a pixel of r,g,b to gfx.x,gfx.y."
	},
	"GFX.SHOWMENU lua": {
		"prefix": "gfx.showmenu",
		"scope": "lua",
		"body": "gfx.showmenu(\"${1:str}\")$0",
		"description": "Shows a popup menu at gfx.x,gfx.y. str is a list of fields separated by | characters. Each field represents a menu item.Fields can start with special characters:# : grayed out! : checked> : this menu item shows a submenu< : last item in the current submenuAn empty field will appear as a separator in the menu. gfx.showmenu returns 0 if the user selected nothing from the menu, 1 if the first field is selected, etc.Example:gfx.showmenu(\"first item, followed by separator||!second item, checked|>third item which spawns a submenu|#first item in submenu, grayed out|<second and last item in submenu|fourth item in top menu\")"
	},
	"GFX.TRANSFORMBLIT lua": {
		"prefix": "gfx.transformblit",
		"scope": "lua",
		"body": "gfx.transformblit(${1:srcimg}, ${2:destx}, ${3:desty}, ${4:destw}, ${5:desth}, ${6:div_w}, ${7:div_h}, ${8:table})$0",
		"description": "Blits to destination at (destx,desty), size (destw,desth). div_w and div_h should be 2..64, and table should point to a table of 2*div_w*div_h values (table can be a regular table or (for less overhead) a r.array). Each pair in the table represents a S,T coordinate in the source image, and the table is treated as a left-right, top-bottom list of texture coordinates, which will then be rendered to the destination."
	},
	"GFX.TRIANGLE lua": {
		"prefix": "gfx.triangle",
		"scope": "lua",
		"body": "gfx.triangle(${1:x1}, ${2:y1}, ${3:x2}, ${4:y2}, ${5:x3}, ${6:y3}, ${7:[x4,y4...]})$0",
		"description": "Draws a filled triangle, or any convex polygon. "
	},
	"GFX.UPDATE lua": {
		"prefix": "gfx.update",
		"scope": "lua",
		"body": "gfx.update()$0",
		"description": "Updates the graphics display, if opened"
	},
	"REAPER.NEW_ARRAY lua": {
		"prefix": "r.new_array",
		"scope": "lua",
		"body": "r.new_array(${1:[table|array][size]})$0",
		"description": "Creates a new r.array object of maximum and initial size size, if specified, or from the size/values of a table/array. Both size and table/array can be specified, the size parameter will override the table/array size."
	},
	"REAPER.RUNLOOP lua": {
		"prefix": "r.runloop",
		"scope": "lua",
		"body": "r.runloop(${1:function})$0",
		"description": "Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to defer().Note that no undo point will be automatically created when the script finishes, unless you create it explicitly."
	},
	"{REAPER.ARRAY}.CLEAR lua": {
		"prefix": "{r.array}.clear",
		"scope": "lua",
		"body": "{r.array}.clear(${1:[value, offset, size]})$0",
		"description": "Sets the value of zero or more items in the array. If value not specified, 0.0 is used. offset is 1-based, if size omitted then the maximum amount available will be set."
	},
	"{REAPER.ARRAY}.CONVOLVE lua": {
		"prefix": "{r.array}.convolve",
		"scope": "lua",
		"body": "{r.array}.convolve(${1:[src, srcoffs, size, destoffs]})$0",
		"description": "Convolves complex value pairs from r.array, starting at 1-based srcoffs, reading/writing to 1-based destoffs. size is in normal items (so it must be even)"
	},
	"{REAPER.ARRAY}.COPY lua": {
		"prefix": "{r.array}.copy",
		"scope": "lua",
		"body": "{r.array}.copy(${1:[src, srcoffs, size, destoffs]})$0",
		"description": "Copies values from r.array or table, starting at 1-based srcoffs, writing to 1-based destoffs."
	},
	"{REAPER.ARRAY}.FFT lua": {
		"prefix": "{r.array}.fft",
		"scope": "lua",
		"body": "{r.array}.fft(${1:size}, ${2:[, permute, offset]})$0",
		"description": "Performs a forward FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled following the FFT to be in normal order."
	},
	"{REAPER.ARRAY}.FFT_REAL lua": {
		"prefix": "{r.array}.fft_real",
		"scope": "lua",
		"body": "{r.array}.fft_real(${1:size}, ${2:[, permute, offset]})$0",
		"description": "Performs a forward real->complex FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled following the FFT to be in normal order."
	},
	"{REAPER.ARRAY}.GET_ALLOC lua": {
		"prefix": "{r.array}.get_alloc",
		"scope": "lua",
		"body": "{r.array}.get_alloc()$0",
		"description": "Returns the maximum (allocated) size of the array."
	},
	"{REAPER.ARRAY}.IFFT lua": {
		"prefix": "{r.array}.ifft",
		"scope": "lua",
		"body": "{r.array}.ifft(${1:size}, ${2:[, permute, offset]})$0",
		"description": "Performs a backwards FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled before the IFFT to be in fft-order."
	},
	"{REAPER.ARRAY}.IFFT_REAL lua": {
		"prefix": "{r.array}.ifft_real",
		"scope": "lua",
		"body": "{r.array}.ifft_real(${1:size}, ${2:[, permute, offset]})$0",
		"description": "Performs a backwards complex->real FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled before the IFFT to be in fft-order."
	},
	"{REAPER.ARRAY}.MULTIPLY lua": {
		"prefix": "{r.array}.multiply",
		"scope": "lua",
		"body": "{r.array}.multiply(${1:[src, srcoffs, size, destoffs]})$0",
		"description": "Multiplies values from r.array, starting at 1-based srcoffs, reading/writing to 1-based destoffs."
	},
	"{REAPER.ARRAY}.RESIZE lua": {
		"prefix": "{r.array}.resize",
		"scope": "lua",
		"body": "{r.array}.resize(${1:size})$0",
		"description": "Resizes an array object to size. size must be [0..max_size]."
	},
	"{REAPER.ARRAY}.TABLE lua": {
		"prefix": "{r.array}.table",
		"scope": "lua",
		"body": "{r.array}.table(${1:[offset, size]})$0",
		"description": "Returns a new table with values from items in the array. Offset is 1-based and if size is omitted all available values are used."
	},
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
				if
					(func.func_name:match("^reaper%.ImGui") or func.func_name:match("^reaper%.AK"))
					and func.func_name ~= "reaper.ImGui_GetBuiltinPath"
				then
				-- Skip this definition.
				else
					table.insert(funcs, func)
				end
			end
		end

		pos = next_anchor_pos or (#html + 1)
	end

	return funcs
end

--[[

---@param gGUID string 
---@return string gGUID
function reaper.genGuid(gGUID) end

should be

---@return string retval
function reaper.genGuid() end
-------------------------
seems like most functions which return a string have the variable changed to retval
buf
hashNeed128
filenamebuf
typebuf
action
author
notes
GUID
destNeed64
out
strNeed64
gGUID
fn
guidString
double
class
---------------
GetSet_ArrangeView2: start_time and end_time are optional
GetThemeColor: flags is optional
LocalizeString: flags is optional
Main_SaveProjectEx: forceSaveAsIn is optional
SetCursorContext: envIn is optional
ShowPopupMenu: everything except name and y optional? seems odd that x would be optional
JS_Composite_Unlink: bitmap is optional
JS_Window_Create: ownerHWND is optional
JS_Window_SetParent: parentHWND is optional
JS_Window_SetZOrder: insertAfterHWND is optional
JS_Zip_Close: zipHandle is optional
---------------
GetItemEditingTime2 is missing first return value in sexan defs
---------------
functions missing in sexan defs:
GetSetTempoTimeSigMarkerFlag
GetSetTrackGroupMembershipEx
---------------
less thans (<) are flipped in sexan defs
---------------
my_getViewport is missing return values in reaper documentation
---------------
SetThemeColor includes a ton of current RGB colors that probably aren't necessary
---------------
BR_GetMouseCursorContext has a completely jank chart in the description
---------------
unsupported is replaced with optional boolean
]]

local param_type_substitutions = {
	{ "ReaProject", "ReaProject|nil|0" },
	{ "KbdSectionInfo", "KbdSectionInfo|integer" },
	{ "desttrIn", "desttrIn?" },
	{ "%s+$", "" }, -- remove trailing space
}

local optional_params = {
	GetSet_ArrangeView2 = {
		start_time = true,
		end_time = true,
	},
	GetThemeColor = {
		flags = true,
	},
	LocalizeString = {
		flags = true,
	},
	Main_SaveProjectEx = {
		forceSaveAsIn = true,
	},
	SetCursorContext = {
		envIn = true,
	},
	ShowPopupMenu = {
		x = true,
		y = true,
		hwndParent = true,
		ctx = true,
		ctx2 = true,
		ctx3 = true,
	},
	JS_Composite_Unlink = {
		bitmap = true,
	},
	JS_Window_Create = {
		ownerHWND = true,
	},
	JS_Window_SetParent = {
		parentHWND = true,
	},
	JS_Window_SetZOrder = {
		insertAfterHWND = true,
	},
	JS_Zip_Close = {
		zipHandle = true,
	},
}

local manual_overrides = {
	genGuid = [[---Generates a new GUID string e.g. {35C37676-7CFF-7E46-BB14-FA0CC7C04BEB}
---@return string gGUID
function reaper.genGuid() end]],
	my_getViewport = [[---@param r_left integer
---@param r_top integer
---@param r_right integer
---@param r_bot integer
---@param sr_left integer
---@param sr_top integer
---@param sr_right integer
---@param sr_bot integer
---@param wantWorkArea boolean
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.my_getViewport(r_left, r_top, r_right, r_bot, sr_left, sr_top, sr_right, sr_bot, wantWorkArea) end]],
	["reaper.BR_GetMouseCursorContext"] = [[---[BR] Get mouse cursor context. Each parameter returns information in a form of string as specified in the table below.
---
---+------------+----------------+------------------------------------------------+
---| Window     | Segment        | Details                                        |
---+------------+----------------+------------------------------------------------+
---| unknown    | ""             | ""                                             |
---+------------+----------------+------------------------------------------------+
---| ruler      | region_lane    | ""                                             |
---|            | marker_lane    | ""                                             |
---|            | tempo_lane     | ""                                             |
---|            | timeline       | ""                                             |
---+------------+----------------+------------------------------------------------+
---| transport  | ""             | ""                                             |
---+------------+----------------+------------------------------------------------+
---| tcp        | track          | ""                                             |
---|            | envelope       | ""                                             |
---|            | empty          | ""                                             |
---+------------+----------------+------------------------------------------------+
---| mcp        | track          | ""                                             |
---|            | empty          | ""                                             |
---+------------+----------------+------------------------------------------------+
---| arrange    | track          | empty, item, item_stretch_marker,              |
---|            |                | env_point, env_segment                         |
---|            | envelope       | empty, env_point, env_segment                  |
---|            | empty          | ""                                             |
---+------------+----------------+------------------------------------------------+
---| midi_editor| unknown        | ""                                             |
---|            | ruler          | ""                                             |
---|            | piano          | ""                                             |
---|            | notes          | ""                                             |
---|            | cc_lane        | cc_selector, cc_lane                           |
---+------------+----------------+------------------------------------------------+
---To get more info on stuff that was found under mouse cursor see BR_GetMouseCursorContext_Envelope, BR_GetMouseCursorContext_Item, BR_GetMouseCursorContext_MIDI, BR_GetMouseCursorContext_Position, BR_GetMouseCursorContext_Take, BR_GetMouseCursorContext_Track 
---@return string window
---@return string segment
---@return string details
function reaper.BR_GetMouseCursorContext() end]],
}

local snippets = {}
local snippets_overrides = {
	genGuid = {
		prefix = "reaper.genGuid",
		scope = "lua",
		body = "reaper.genGuid()$0",
		description = "Generates a new GUID string e.g. {35C37676-7CFF-7E46-BB14-FA0CC7C04BEB}",
	},
	my_getViewport = {
		prefix = "reaper.my_getViewport",
		scope = "lua",
		body = "reaper.my_getViewport(${1:r_left}, ${2:r_top}, ${3:r_right}, ${4:r_bot}, ${5:sr_left}, ${6:sr_top}, ${7:sr_right}, ${8:sr_bot}, ${9:wantWorkArea})$0",
		description = "Get the current viewport and the work area",
	},
	BR_GetMouseCursorContext = {
		prefix = "reaper.BR_GetMouseCursorContext",
		scope = "lua",
		body = "reaper.BR_GetMouseCursorContext()$0",
		description = "Get mouse cursor context. Each parameter returns information in a form of string as specified in the table below.",
	},
}
--[[
{ [short_name] = { 
	prefix = "r." .. short_name,
	scope = "lua",
	body = "r." .. short_name .. "${1:param}, ${2:param})$0",
	description = description,
	},
}
]]
--------------------------------------------------------------------------------
-- Generate the annotated Lua stub for a given parsed function.
local function generate_stub(func)
	local short_name = func.func_name:gsub("^reaper%.", "", 1)
	local snippet_name = "r." .. short_name
	if snippets_overrides[short_name] then
		snippets[short_name] = snippets_overrides[short_name]
	end
	if manual_overrides[short_name] then
		return manual_overrides[func.func_name]
	end
	local snippet = {
		prefix = snippet_name,
		scope = "lua",
	}
	local lines = {}
	local description = {}
	if func.description and #func.description > 0 then
		for line in func.description:gmatch("[^\n]+") do
			-- remove SetThemeColor additional info
			if not line:find("^-- current RGB") and not line:find("^-- blendmode") then
				table.insert(lines, "---" .. line)
				table.insert(description, line)
			end
		end
	end
	snippet.description = table.concat(description, "\n")
	snippet.body = snippet_name .. "("
	local body_params = {}
	for i, p in ipairs(func.params) do
		local optional = optional_params[short_name] and optional_params[short_name][p.name] or p.optional
		local p_type = p.type
		for _, sub in ipairs(param_type_substitutions) do
			p_type = p_type:gsub(sub[1], sub[2], 1)
		end
		table.insert(lines, string.format("---@param %s %s", p.name, p_type .. (optional and "?" or "")))
		if p.type == "ReaProject" then
			table.insert(body_params, "0")
		else
			table.insert(body_params, string.format("${%s:%s}", i, p.name))
		end
	end
	snippet.body = snippet.body .. table.concat(body_params, ", ") .. ")$0"
	local retvals = {}
	for i, ret in ipairs(func.ret_types or {}) do
		local trimmed_type = ret.type:gsub("%s+$", "")
		local rettype = trimmed_type .. (ret.optional and "?" or "")
		rettype = rettype:gsub("identifier", "userdata", 1)
		local retname = ret.name
		if retname == "retval" then
			if ret.type == "string" then
				retname = "str"
			elseif ret.type == "number" then
				retname = "num"
			else
				retname = "rv"
			end
		end
		table.insert(lines, string.format("---@return %s %s", rettype, retname))
		table.insert(retvals, retname)
	end
	if #retvals > 1 and func.func_name:find("Get") then
		snippet.body = table.concat(retvals, ", ") .. " = " .. snippet.body
	end
	local param_names = {}
	for _, p in ipairs(func.params) do
		table.insert(param_names, p.name)
	end
	table.insert(lines, string.format("function %s(%s) end", func.func_name, table.concat(param_names, ", ")))
	snippets[short_name] = snippet
	return table.concat(lines, "\n")
end

local function snippets_to_json()
	local str = "{\n"
	str = str .. snippets_header
	local keys = {}
	for k in pairs(snippets) do
		table.insert(keys, k)
	end
	table.sort(keys)
	local key_tbl = {}
	for _, k in ipairs(keys) do
		local snippet = snippets[k]
		table.insert(
			key_tbl,
			string.format(
				'\t"%s lua": {\n\t\t"prefix": "%s",\n\t\t"scope": "lua",\n\t\t"body": "%s",\n\t\t"description": "%s"\n\t}',
				k,
				snippet.prefix,
				snippet.body,
				snippet.description
					:gsub("\\'", "'")
					:gsub("\\", "\\\\")
					:gsub("\n", "\\n")
					:gsub('"', "'")
					:gsub("\t", "\\t")
					:gsub("\r", "\\r")
					:gsub("\\n\\n", "\\n")
			)
		)
	end
	str = str .. table.concat(key_tbl, ",\n")
	str = str .. "\n}"
	return str
end

local function defs_to_snippets(defs)
	for desc, func, args in defs:gmatch("(.-)\nfunction%s+(.-)%((.-)%)%s*end\n") do
		local args_tbl = {}
		local i = 1
		for arg in args:gmatch("[^,]+") do
			arg = arg:gsub("%s", "")
			if arg == "ctx" then
				table.insert(args_tbl, "ctx")
			else
				table.insert(args_tbl, string.format("${%s:%s}", i, arg))
			end
			if func == "ImGui.SameLine" then -- special case since we don't really use the other args
				break
			end
			i = i + 1
		end
		local desc_tbl = {}
		local fields_found = false
		for line in desc:gmatch("([^\n]+)") do
			if line:find("^--- @") then
				fields_found = true
			elseif fields_found then
				desc_tbl = {} -- reset since fields should only be at the end
			elseif line == "---" or line == "--- ---" then
				-- ignore
			else
				line = line:gsub("\\", "") -- remove unnecessary escapes
				table.insert(desc_tbl, line:match("^%s*%-%-%-%s*(.+)%s*$"))
			end
		end
		snippets[func:gsub("%.", "_")] = {
			prefix = func,
			scope = "lua",
			body = func .. "(" .. table.concat(args_tbl, ", ") .. ")$0",
			description = table.concat(desc_tbl, "\\n"),
		}
	end
end

local r = reaper

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

local function read_file(path)
	local file = io.open(path, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return content
	else
		r.ShowMessageBox("Could not open file: " .. path, "Error", 0)
	end
end

local html_defs = read_file(file_path)
--------------------------------------------------------------------------------
-- Main: Parse the input HTML and generate stubs.
local funcs = parse_all(html_defs)
local output = { header }
for _, func in ipairs(funcs) do
	table.insert(output, generate_stub(func))
	table.insert(output, "") -- add a blank line between functions
end
table.insert(output, footer)

local script_path = debug.getinfo(1, "S").source:match("@(.*)[\\/].*$")
local output_path = script_path .. "/reaper_defs.lua"
local snippets_path = script_path .. "/snippets.json"
local imgui_path = script_path .. "/imgui_defs.lua"
local nvim_path = os.getenv("HOME") .. "/.config/nvim/snippets/lua/reascript-api.json"

defs_to_snippets(read_file(imgui_path))
local snippets_str = snippets_to_json()

local function write_file(path, content)
	local file = io.open(path, "w")
	if file then
		file:write(content)
		file:close()
		reaper.ShowConsoleMsg("File written to: " .. path)
	else
		reaper.ShowMessageBox("Could not write to file: " .. path, "Error", 0)
	end
	return file
end

write_file(output_path, table.concat(output, "\n"))
write_file(snippets_path, snippets_str)
if r.file_exists(nvim_path) then
	write_file(nvim_path, snippets_str)
end
