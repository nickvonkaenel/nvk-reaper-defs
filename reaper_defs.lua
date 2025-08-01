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
---@class (exact) ProjectMarker : userdata
---@class (exact) unsupported: boolean?

---creates a new media item.
---@param tr MediaTrack
---@return MediaItem rv
function reaper.AddMediaItemToTrack(tr) end

---Returns the index of the created marker/region, or -1 on failure. Supply wantidx>=0 if you want a particular index number, but you'll get a different index number a region and wantidx is already in use.
---@param proj ReaProject|nil|0
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param wantidx integer
---@return integer rv
function reaper.AddProjectMarker(proj, isrgn, pos, rgnend, name, wantidx) end

---Returns the index of the created marker/region, or -1 on failure. Supply wantidx>=0 if you want a particular index number, but you'll get a different index number a region and wantidx is already in use. color should be 0 (default color), or ColorToNative(r,g,b)|0x1000000
---@param proj ReaProject|nil|0
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param wantidx integer
---@param color integer
---@return integer rv
function reaper.AddProjectMarker2(proj, isrgn, pos, rgnend, name, wantidx, color) end

---Add a ReaScript (return the new command ID, or 0 if failed) or remove a ReaScript (return >0 on success). Use commit==true when adding/removing a single script. When bulk adding/removing n scripts, you can optimize the n-1 first calls with commit==false and commit==true for the last call.
---@param add boolean
---@param sectionID integer
---@param scriptfn string
---@param commit boolean
---@return integer rv
function reaper.AddRemoveReaScript(add, sectionID, scriptfn, commit) end

---creates a new take in an item
---@param item MediaItem
---@return MediaItem_Take rv
function reaper.AddTakeToMediaItem(item) end

---Deprecated. Use SetTempoTimeSigMarker with ptidx=-1.
---@param proj ReaProject|nil|0
---@param timepos number
---@param bpm number
---@param timesig_num integer
---@param timesig_denom integer
---@param lineartempochange boolean
---@return boolean rv
function reaper.AddTempoTimeSigMarker(proj, timepos, bpm, timesig_num, timesig_denom, lineartempochange) end

---forceset=0,doupd=true,centermode=-1 for default
---@param amt number
---@param forceset integer
---@param doupd boolean
---@param centermode integer
function reaper.adjustZoom(amt, forceset, doupd, centermode) end

---@param proj ReaProject|nil|0
---@return boolean rv
function reaper.AnyTrackSolo(proj) end

---Returns true if function_name exists in the REAPER API
---@param function_name string
---@return boolean rv
function reaper.APIExists(function_name) end

---Displays a message window if the API was successfully called.
function reaper.APITest() end

---nudgeflag: &1=set to value (otherwise nudge by value), &2=snap
---nudgewhat: 0=position, 1=left trim, 2=left edge, 3=right edge, 4=contents, 5=duplicate, 6=edit cursor
---nudgeunit: 0=ms, 1=seconds, 2=grid, 3=256th notes, ..., 15=whole notes, 16=measures.beats (1.15 = 1 measure + 1.5 beats), 17=samples, 18=frames, 19=pixels, 20=item lengths, 21=item selections
---value: amount to nudge by, or value to set to
---reverse: in nudge mode, nudges left (otherwise ignored)
---copies: in nudge duplicate mode, number of copies (otherwise ignored)
---@param project ReaProject|nil|0
---@param nudgeflag integer
---@param nudgewhat integer
---@param nudgeunits integer
---@param value number
---@param reverse boolean
---@param copies integer
---@return boolean rv
function reaper.ApplyNudge(project, nudgeflag, nudgewhat, nudgeunits, value, reverse, copies) end

---arms a command (or disarms if 0 passed) in section sectionname (empty string for main)
---@param cmd integer
---@param sectionname string
function reaper.ArmCommand(cmd, sectionname) end

---open all audio and MIDI devices, if not open
function reaper.Audio_Init() end

---is in pre-buffer? threadsafe
---@return integer rv
function reaper.Audio_IsPreBuffer() end

---is audio running at all? threadsafe
---@return integer rv
function reaper.Audio_IsRunning() end

---close all audio and MIDI devices, if open
function reaper.Audio_Quit() end

---Returns true if the underlying samples (track or media item take) have changed, but does not update the audio accessor, so the user can selectively call AudioAccessorValidateState only when needed. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param accessor AudioAccessor
---@return boolean rv
function reaper.AudioAccessorStateChanged(accessor) end

---Force the accessor to reload its state from the underlying track or media item take. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param accessor AudioAccessor
function reaper.AudioAccessorUpdate(accessor) end

---Validates the current state of the audio accessor -- must ONLY call this from the main thread. Returns true if the state changed.
---@param accessor AudioAccessor
---@return boolean rv
function reaper.AudioAccessorValidateState(accessor) end

----1 = bypass all if not all bypassed,otherwise unbypass all
---@param bypass integer
function reaper.BypassFxAllTracks(bypass) end

---Calculates loudness statistics of media via dry run render. Statistics will be displayed to the user; call GetSetProjectInfo_String("RENDER_STATS") to retrieve via API. Returns 1 if loudness was calculated successfully, -1 if user canceled the dry run render.
---@param mediasource PCM_source
---@return integer rv
function reaper.CalcMediaSrcLoudness(mediasource) end

---Calculate normalize adjustment for source media. normalizeTo: 0=LUFS-I, 1=RMS-I, 2=peak, 3=true peak, 4=LUFS-M max, 5=LUFS-S max. normalizeTarget: dBFS or LUFS value. normalizeStart, normalizeEnd: time bounds within source media for normalization calculation. If normalizationStart=0 and normalizationEnd=0, the full duration of the media will be used for the calculation.
---@param source PCM_source
---@param normalizeTo integer
---@param normalizeTarget number
---@param normalizeStart number
---@param normalizeEnd number
---@return number num
function reaper.CalculateNormalization(source, normalizeTo, normalizeTarget, normalizeStart, normalizeEnd) end

function reaper.ClearAllRecArmed() end

---Clear the ReaScript console. See ShowConsoleMsg
function reaper.ClearConsole() end

---resets the global peak caches
function reaper.ClearPeakCache() end

---Extract RGB values from an OS dependent color. See ColorToNative.
---@param col integer
---@return integer r
---@return integer g
---@return integer b
function reaper.ColorFromNative(col) end

---Make an OS dependent color from RGB values (e.g. RGB() macro on Windows). r,g and b are in [0..255]. See ColorFromNative.
---@param r integer
---@param g integer
---@param b integer
---@return integer rv
function reaper.ColorToNative(r, g, b) end

---Returns the number of shortcuts that exist for the given command ID.
---see GetActionShortcutDesc, DeleteActionShortcut, DoActionShortcutDialog.
---@param section KbdSectionInfo|integer
---@param cmdID integer
---@return integer rv
function reaper.CountActionShortcuts(section, cmdID) end

---Returns the number of automation items on this envelope. See GetSetAutomationItemInfo
---@param env TrackEnvelope
---@return integer rv
function reaper.CountAutomationItems(env) end

---Returns the number of points in the envelope. See CountEnvelopePointsEx.
---@param envelope TrackEnvelope
---@return integer rv
function reaper.CountEnvelopePoints(envelope) end

---Returns the number of points in the envelope.
---autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration,
---even if the automation item is trimmed so that not all points are visible.
---Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations.
---See GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@return integer rv
function reaper.CountEnvelopePointsEx(envelope, autoitem_idx) end

---count the number of items in the project (proj=0 for active project)
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.CountMediaItems(proj) end

---num_markersOut and num_regionsOut may be NULL.
---@param proj ReaProject|nil|0
---@return integer rv
---@return integer num_markers
---@return integer num_regions
function reaper.CountProjectMarkers(proj) end

---Discouraged, because GetSelectedMediaItem can be inefficient if media items are added, rearranged, or deleted in between calls. Instead see CountMediaItems, GetMediaItem, IsMediaItemSelected.
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.CountSelectedMediaItems(proj) end

---Count the number of selected tracks in the project (proj=0 for active project). This function ignores the master track, see CountSelectedTracks2.
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.CountSelectedTracks(proj) end

---Count the number of selected tracks in the project (proj=0 for active project).
---@param proj ReaProject|nil|0
---@param wantmaster boolean
---@return integer rv
function reaper.CountSelectedTracks2(proj, wantmaster) end

---See GetTakeEnvelope
---@param take MediaItem_Take
---@return integer rv
function reaper.CountTakeEnvelopes(take) end

---count the number of takes in the item
---@param item MediaItem
---@return integer rv
function reaper.CountTakes(item) end

---Count the number of FX parameter knobs displayed on the track control panel.
---@param project ReaProject|nil|0
---@param track MediaTrack
---@return integer rv
function reaper.CountTCPFXParms(project, track) end

---Count the number of tempo/time signature markers in the project. See GetTempoTimeSigMarker, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.CountTempoTimeSigMarkers(proj) end

---see GetTrackEnvelope
---@param track MediaTrack
---@return integer rv
function reaper.CountTrackEnvelopes(track) end

---count the number of items in the track
---@param track MediaTrack
---@return integer rv
function reaper.CountTrackMediaItems(track) end

---count the number of tracks in the project (proj=0 for active project)
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.CountTracks(proj) end

---Create a new MIDI media item, containing no MIDI events. Time is in seconds unless qn is set.
---@param track MediaTrack
---@param starttime number
---@param endtime number
---@param qnIn boolean?
---@return MediaItem rv
function reaper.CreateNewMIDIItemInProj(track, starttime, endtime, qnIn) end

---Create an audio accessor object for this take. Must only call from the main thread. See CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param take MediaItem_Take
---@return AudioAccessor rv
function reaper.CreateTakeAudioAccessor(take) end

---Create an audio accessor object for this track. Must only call from the main thread. See CreateTakeAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param track MediaTrack
---@return AudioAccessor rv
function reaper.CreateTrackAudioAccessor(track) end

---Create a send/receive (desttrInOptional!=NULL), or a hardware output (desttrInOptional==NULL) with default properties, return >=0 on success (== new send/receive index). See RemoveTrackSend, GetSetTrackSendInfo, GetTrackSendInfo_Value, SetTrackSendInfo_Value.
---@param tr MediaTrack
---@param desttrIn MediaTrack?
---@return integer rv
function reaper.CreateTrackSend(tr, desttrIn) end

---Run a command from the Crossfade Editor section of the actions list.
---@param command integer
function reaper.CrossfadeEditor_OnCommand(command) end

---Show or hide the Crossfade Editor window
---@param show boolean
function reaper.CrossfadeEditor_Show(show) end

---call this to force flushing of the undo states after using CSurf_On*Change()
---@param force boolean
function reaper.CSurf_FlushUndo(force) end

---@param trackid MediaTrack
---@param isPan integer
---@return boolean rv
function reaper.CSurf_GetTouchState(trackid, isPan) end

function reaper.CSurf_GoEnd() end

function reaper.CSurf_GoStart() end

---@param mcpView boolean
---@return integer rv
function reaper.CSurf_NumTracks(mcpView) end

---@param whichdir integer
---@param wantzoom boolean
function reaper.CSurf_OnArrow(whichdir, wantzoom) end

---@param seekplay integer
function reaper.CSurf_OnFwd(seekplay) end

---@param trackid MediaTrack
---@param en integer
---@return boolean rv
function reaper.CSurf_OnFXChange(trackid, en) end

---@param trackid MediaTrack
---@param monitor integer
---@return integer rv
function reaper.CSurf_OnInputMonitorChange(trackid, monitor) end

---@param trackid MediaTrack
---@param monitor integer
---@param allowgang boolean
---@return integer rv
function reaper.CSurf_OnInputMonitorChangeEx(trackid, monitor, allowgang) end

---@param trackid MediaTrack
---@param mute integer
---@return boolean rv
function reaper.CSurf_OnMuteChange(trackid, mute) end

---@param trackid MediaTrack
---@param mute integer
---@param allowgang boolean
---@return boolean rv
function reaper.CSurf_OnMuteChangeEx(trackid, mute, allowgang) end

---@param trackid MediaTrack
---@param pan number
---@param relative boolean
---@return number num
function reaper.CSurf_OnPanChange(trackid, pan, relative) end

---@param trackid MediaTrack
---@param pan number
---@param relative boolean
---@param allowGang boolean
---@return number num
function reaper.CSurf_OnPanChangeEx(trackid, pan, relative, allowGang) end

function reaper.CSurf_OnPause() end

function reaper.CSurf_OnPlay() end

---@param playrate number
function reaper.CSurf_OnPlayRateChange(playrate) end

---@param trackid MediaTrack
---@param recarm integer
---@return boolean rv
function reaper.CSurf_OnRecArmChange(trackid, recarm) end

---@param trackid MediaTrack
---@param recarm integer
---@param allowgang boolean
---@return boolean rv
function reaper.CSurf_OnRecArmChangeEx(trackid, recarm, allowgang) end

function reaper.CSurf_OnRecord() end

---@param trackid MediaTrack
---@param recv_index integer
---@param pan number
---@param relative boolean
---@return number num
function reaper.CSurf_OnRecvPanChange(trackid, recv_index, pan, relative) end

---@param trackid MediaTrack
---@param recv_index integer
---@param volume number
---@param relative boolean
---@return number num
function reaper.CSurf_OnRecvVolumeChange(trackid, recv_index, volume, relative) end

---@param seekplay integer
function reaper.CSurf_OnRew(seekplay) end

---@param seekplay integer
---@param dir integer
function reaper.CSurf_OnRewFwd(seekplay, dir) end

---@param xdir integer
---@param ydir integer
function reaper.CSurf_OnScroll(xdir, ydir) end

---@param trackid MediaTrack
---@param selected integer
---@return boolean rv
function reaper.CSurf_OnSelectedChange(trackid, selected) end

---@param trackid MediaTrack
---@param send_index integer
---@param pan number
---@param relative boolean
---@return number num
function reaper.CSurf_OnSendPanChange(trackid, send_index, pan, relative) end

---@param trackid MediaTrack
---@param send_index integer
---@param volume number
---@param relative boolean
---@return number num
function reaper.CSurf_OnSendVolumeChange(trackid, send_index, volume, relative) end

---@param trackid MediaTrack
---@param solo integer
---@return boolean rv
function reaper.CSurf_OnSoloChange(trackid, solo) end

---@param trackid MediaTrack
---@param solo integer
---@param allowgang boolean
---@return boolean rv
function reaper.CSurf_OnSoloChangeEx(trackid, solo, allowgang) end

function reaper.CSurf_OnStop() end

---@param bpm number
function reaper.CSurf_OnTempoChange(bpm) end

---@param trackid MediaTrack
function reaper.CSurf_OnTrackSelection(trackid) end

---@param trackid MediaTrack
---@param volume number
---@param relative boolean
---@return number num
function reaper.CSurf_OnVolumeChange(trackid, volume, relative) end

---@param trackid MediaTrack
---@param volume number
---@param relative boolean
---@param allowGang boolean
---@return number num
function reaper.CSurf_OnVolumeChangeEx(trackid, volume, relative, allowGang) end

---@param trackid MediaTrack
---@param width number
---@param relative boolean
---@return number num
function reaper.CSurf_OnWidthChange(trackid, width, relative) end

---@param trackid MediaTrack
---@param width number
---@param relative boolean
---@param allowGang boolean
---@return number num
function reaper.CSurf_OnWidthChangeEx(trackid, width, relative, allowGang) end

---@param xdir integer
---@param ydir integer
function reaper.CSurf_OnZoom(xdir, ydir) end

function reaper.CSurf_ResetAllCachedVolPanStates() end

---@param amt number
function reaper.CSurf_ScrubAmt(amt) end

---@param mode integer
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetAutoMode(mode, ignoresurf) end

---@param play boolean
---@param pause boolean
---@param rec boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetPlayState(play, pause, rec, ignoresurf) end

---@param rep boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetRepeatState(rep, ignoresurf) end

---@param trackid MediaTrack
---@param mute boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceMute(trackid, mute, ignoresurf) end

---@param trackid MediaTrack
---@param pan number
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfacePan(trackid, pan, ignoresurf) end

---@param trackid MediaTrack
---@param recarm boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceRecArm(trackid, recarm, ignoresurf) end

---@param trackid MediaTrack
---@param selected boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceSelected(trackid, selected, ignoresurf) end

---@param trackid MediaTrack
---@param solo boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceSolo(trackid, solo, ignoresurf) end

---@param trackid MediaTrack
---@param volume number
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceVolume(trackid, volume, ignoresurf) end

function reaper.CSurf_SetTrackListChange() end

---@param idx integer
---@param mcpView boolean
---@return MediaTrack rv
function reaper.CSurf_TrackFromID(idx, mcpView) end

---@param track MediaTrack
---@param mcpView boolean
---@return integer rv
function reaper.CSurf_TrackToID(track, mcpView) end

---@param x number
---@return number num
function reaper.DB2SLIDER(x) end

---Delete the specific shortcut for the given command ID.
---See CountActionShortcuts, GetActionShortcutDesc, DoActionShortcutDialog.
---@param section KbdSectionInfo|integer
---@param cmdID integer
---@param shortcutidx integer
---@return boolean rv
function reaper.DeleteActionShortcut(section, cmdID, shortcutidx) end

---Delete an envelope point. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done.
---autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration,
---even if the automation item is trimmed so that not all points are visible.
---Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations.
---See CountEnvelopePointsEx, GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param ptidx integer
---@return boolean rv
function reaper.DeleteEnvelopePointEx(envelope, autoitem_idx, ptidx) end

---Delete a range of envelope points. See DeleteEnvelopePointRangeEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param time_start number
---@param time_end number
---@return boolean rv
function reaper.DeleteEnvelopePointRange(envelope, time_start, time_end) end

---Delete a range of envelope points. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param time_start number
---@param time_end number
---@return boolean rv
function reaper.DeleteEnvelopePointRangeEx(envelope, autoitem_idx, time_start, time_end) end

---Delete the extended state value for a specific section and key. persist=true means the value should remain deleted the next time REAPER is opened. See SetExtState, GetExtState, HasExtState.
---@param section string
---@param key string
---@param persist boolean
function reaper.DeleteExtState(section, key, persist) end

---Delete a marker.  proj==NULL for the active project.
---@param proj ReaProject|nil|0
---@param markrgnindexnumber integer
---@param isrgn boolean
---@return boolean rv
function reaper.DeleteProjectMarker(proj, markrgnindexnumber, isrgn) end

---Differs from DeleteProjectMarker only in that markrgnidx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than representing the displayed marker/region ID number (see SetProjectMarker4).
---@param proj ReaProject|nil|0
---@param markrgnidx integer
---@return boolean rv
function reaper.DeleteProjectMarkerByIndex(proj, markrgnidx) end

---Delete a take marker. Note that idx will change for all following take markers. See GetNumTakeMarkers, GetTakeMarker, SetTakeMarker
---@param take MediaItem_Take
---@param idx integer
---@return boolean rv
function reaper.DeleteTakeMarker(take, idx) end

---Deletes one or more stretch markers. Returns number of stretch markers deleted.
---@param take MediaItem_Take
---@param idx integer
---@param countIn integer?
---@return integer rv
function reaper.DeleteTakeStretchMarkers(take, idx, countIn) end

---Delete a tempo/time signature marker.
---@param project ReaProject|nil|0
---@param markerindex integer
---@return boolean rv
function reaper.DeleteTempoTimeSigMarker(project, markerindex) end

---deletes a track
---@param tr MediaTrack
function reaper.DeleteTrack(tr) end

---@param tr MediaTrack
---@param it MediaItem
---@return boolean rv
function reaper.DeleteTrackMediaItem(tr, it) end

---Destroy an audio accessor. Must only call from the main thread. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param accessor AudioAccessor
function reaper.DestroyAudioAccessor(accessor) end

---Open the action shortcut dialog to edit or add a shortcut for the given command ID. If (shortcutidx >= 0 && shortcutidx < CountActionShortcuts()), that specific shortcut will be replaced, otherwise a new shortcut will be added.
---See CountActionShortcuts, GetActionShortcutDesc, DeleteActionShortcut.
---@param hwnd HWND
---@param section KbdSectionInfo|integer
---@param cmdID integer
---@param shortcutidx integer
---@return boolean rv
function reaper.DoActionShortcutDialog(hwnd, section, cmdID, shortcutidx) end

---updates preference for docker window ident_str to be in dock whichDock on next open
---@param ident_str string
---@param whichDock integer
function reaper.Dock_UpdateDockID(ident_str, whichDock) end

----1=not found, 0=bottom, 1=left, 2=top, 3=right, 4=floating
---@param whichDock integer
---@return integer rv
function reaper.DockGetPosition(whichDock) end

---returns dock index that contains hwnd, or -1
---@param hwnd HWND
---@return integer rv
---@return boolean isFloatingDocker
function reaper.DockIsChildOfDock(hwnd) end

---@param hwnd HWND
function reaper.DockWindowActivate(hwnd) end

---@param hwnd HWND
---@param name string
---@param pos integer
---@param allowShow boolean
function reaper.DockWindowAdd(hwnd, name, pos, allowShow) end

---@param hwnd HWND
---@param name string
---@param identstr string
---@param allowShow boolean
function reaper.DockWindowAddEx(hwnd, name, identstr, allowShow) end

function reaper.DockWindowRefresh() end

---@param hwnd HWND
function reaper.DockWindowRefreshForHWND(hwnd) end

---@param hwnd HWND
function reaper.DockWindowRemove(hwnd) end

---Open the tempo/time signature marker editor dialog.
---@param project ReaProject|nil|0
---@param markerindex integer
---@return boolean rv
function reaper.EditTempoTimeSigMarker(project, markerindex) end

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

---List the files in the "path" directory. Returns NULL/nil when all files have been listed. Use fileindex = -1 to force re-read of directory (invalidate cache). See EnumerateSubdirectories
---@param path string
---@param fileindex integer
---@return string str
function reaper.EnumerateFiles(path, fileindex) end

---List the subdirectories in the "path" directory. Use subdirindex = -1 to force re-read of directory (invalidate cache). Returns NULL/nil when all subdirectories have been listed. See EnumerateFiles
---@param path string
---@param subdirindex integer
---@return string str
function reaper.EnumerateSubdirectories(path, subdirindex) end

---Enumerates installed FX. Returns true if successful, sets nameOut and identOut to name and ident of FX at index.
---@param index integer
---@return boolean rv
---@return string name
---@return string ident
function reaper.EnumInstalledFX(index) end

---Start querying modes at 0, returns FALSE when no more modes possible, sets strOut to NULL if a mode is currently unsupported
---@param mode integer
---@return boolean rv
---@return string str
function reaper.EnumPitchShiftModes(mode) end

---Returns submode name, or NULL
---@param mode integer
---@param submode integer
---@return string str
function reaper.EnumPitchShiftSubModes(mode, submode) end

---@param idx integer
---@return integer rv
---@return boolean isrgn
---@return number pos
---@return number rgnend
---@return string name
---@return integer markrgnindexnumber
function reaper.EnumProjectMarkers(idx) end

---@param proj ReaProject|nil|0
---@param idx integer
---@return integer rv
---@return boolean isrgn
---@return number pos
---@return number rgnend
---@return string name
---@return integer markrgnindexnumber
function reaper.EnumProjectMarkers2(proj, idx) end

---@param proj ReaProject|nil|0
---@param idx integer
---@return integer rv
---@return boolean isrgn
---@return number pos
---@return number rgnend
---@return string name
---@return integer markrgnindexnumber
---@return integer color
function reaper.EnumProjectMarkers3(proj, idx) end

---idx=-1 for current project,projfn can be NULL if not interested in filename. use idx 0x40000000 for currently rendering project, if any.
---@param idx integer
---@return ReaProject rv
---@return string? projfn
function reaper.EnumProjects(idx) end

---Enumerate the data stored with the project for a specific extname. Returns false when there is no more data. See SetProjExtState, GetProjExtState.
---@param proj ReaProject|nil|0
---@param extname string
---@param idx integer
---@return boolean rv
---@return string? key
---@return string? val
function reaper.EnumProjExtState(proj, extname, idx) end

---Enumerate which tracks will be rendered within this region when using the region render matrix. When called with rendertrack==0, the function returns the first track that will be rendered (which may be the master track); rendertrack==1 will return the next track rendered, and so on. The function returns NULL when there are no more tracks that will be rendered within this region.
---@param proj ReaProject|nil|0
---@param regionindex integer
---@param rendertrack integer
---@return MediaTrack rv
function reaper.EnumRegionRenderMatrix(proj, regionindex, rendertrack) end

---returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
---@param track integer
---@param programNumber integer
---@param programName string
---@return boolean rv
---@return string programName
function reaper.EnumTrackMIDIProgramNames(track, programNumber, programName) end

---returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
---@param proj ReaProject|nil|0
---@param track MediaTrack
---@param programNumber integer
---@param programName string
---@return boolean rv
---@return string programName
function reaper.EnumTrackMIDIProgramNamesEx(proj, track, programNumber, programName) end

---Get the effective envelope value at a given time position. samplesRequested is how long the caller expects until the next call to Envelope_Evaluate (often, the buffer block size). The return value is how many samples beyond that time position that the returned values are valid. dVdS is the change in value per sample (first derivative), ddVdS is the second derivative, dddVdS is the third derivative. See GetEnvelopeScalingMode.
---@param envelope TrackEnvelope
---@param time number
---@param samplerate number
---@param samplesRequested integer
---@return integer rv
---@return number value
---@return number dVdS
---@return number ddVdS
---@return number dddVdS
function reaper.Envelope_Evaluate(envelope, time, samplerate, samplesRequested) end

---Formats the value of an envelope to a user-readable form
---@param env TrackEnvelope
---@param value number
---@return string buf
function reaper.Envelope_FormatValue(env, value) end

---If take envelope, gets the take from the envelope. If FX, indexOut set to FX index, index2Out set to parameter index, otherwise -1.
---@param env TrackEnvelope
---@return MediaItem_Take rv
---@return integer index
---@return integer index2
function reaper.Envelope_GetParentTake(env) end

---If track envelope, gets the track from the envelope. If FX, indexOut set to FX index, index2Out set to parameter index, otherwise -1.
---@param env TrackEnvelope
---@return MediaTrack rv
---@return integer index
---@return integer index2
function reaper.Envelope_GetParentTrack(env) end

---Sort envelope points by time. See SetEnvelopePoint, InsertEnvelopePoint.
---@param envelope TrackEnvelope
---@return boolean rv
function reaper.Envelope_SortPoints(envelope) end

---Sort envelope points by time. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. See SetEnvelopePoint, InsertEnvelopePoint.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@return boolean rv
function reaper.Envelope_SortPointsEx(envelope, autoitem_idx) end

---Executes command line, returns NULL on total failure, otherwise the return value, a newline, and then the output of the command. If timeoutmsec is 0, command will be allowed to run indefinitely (recommended for large amounts of returned output). timeoutmsec is -1 for no wait/terminate, -2 for no wait and minimize
---@param cmdline string
---@param timeoutmsec integer
---@return string str
function reaper.ExecProcess(cmdline, timeoutmsec) end

---returns true if path points to a valid, readable file
---@param path string
---@return boolean rv
function reaper.file_exists(path) end

---Find the tempo/time signature marker that falls at or before this time position (the marker that is in effect as of this time position).
---@param project ReaProject|nil|0
---@param time number
---@return integer rv
function reaper.FindTempoTimeSigMarker(project, time) end

---Format tpos (which is time in seconds) as hh:mm:ss.sss. See format_timestr_pos, format_timestr_len.
---@param tpos number
---@param buf string
---@return string buf
function reaper.format_timestr(tpos, buf) end

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

---time formatting mode overrides: -1=proj default.
---0=time
---1=measures.beats + time
---2=measures.beats
---3=seconds
---4=samples
---5=h:m:s:f
---@param tpos number
---@param buf string
---@param modeoverride integer
---@return string buf
function reaper.format_timestr_pos(tpos, buf, modeoverride) end

---Generates a new GUID string e.g. {35C37676-7CFF-7E46-BB14-FA0CC7C04BEB}
---@return string gGUID
function reaper.genGuid() end

---gets ini configuration variable value as string
---@param name string
---@return boolean rv
---@return string buf
function reaper.get_config_var_string(name) end

---Get reaper.ini full filename.
---@return string str
function reaper.get_ini_file() end

---Get the text description of a specific shortcut for the given command ID.
---See CountActionShortcuts,DeleteActionShortcut,DoActionShortcutDialog.
---@param section KbdSectionInfo|integer
---@param cmdID integer
---@param shortcutidx integer
---@return boolean rv
---@return string desc
function reaper.GetActionShortcutDesc(section, cmdID, shortcutidx) end

---get the active take in this item
---@param item MediaItem
---@return MediaItem_Take rv
function reaper.GetActiveTake(item) end

---returns the bitwise OR of all project play states (1=playing, 2=pause, 4=recording)
---@param ignoreProject ReaProject|nil|0
---@return integer rv
function reaper.GetAllProjectPlayStates(ignoreProject) end

---Returns app version which may include an OS/arch signifier, such as: "6.17" (windows 32-bit), "6.17/x64" (windows 64-bit), "6.17/OSX64" (macOS 64-bit Intel), "6.17/OSX" (macOS 32-bit), "6.17/macOS-arm64", "6.17/linux-x86_64", "6.17/linux-i686", "6.17/linux-aarch64", "6.17/linux-armv7l", etc
---@return string str
function reaper.GetAppVersion() end

---gets the currently armed command and section name (returns 0 if nothing armed). section name is empty-string for main section.
---@return integer rv
---@return string sec
function reaper.GetArmedCommand() end

---Get the end time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorStartTime, GetAudioAccessorSamples.
---@param accessor AudioAccessor
---@return number num
function reaper.GetAudioAccessorEndTime(accessor) end

---Deprecated. See AudioAccessorStateChanged instead.
---@param accessor AudioAccessor
---@param hashNeed128 string
---@return string hashNeed128
function reaper.GetAudioAccessorHash(accessor, hashNeed128) end

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
---@return integer rv
function reaper.GetAudioAccessorSamples(accessor, samplerate, numchannels, starttime_sec, numsamplesperchannel, samplebuffer) end

---Get the start time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor, CreateTrackAudioAccessor, DestroyAudioAccessor, AudioAccessorStateChanged, GetAudioAccessorEndTime, GetAudioAccessorSamples.
---@param accessor AudioAccessor
---@return number num
function reaper.GetAudioAccessorStartTime(accessor) end

---get information about the currently open audio device. attribute can be MODE, IDENT_IN, IDENT_OUT, BSIZE, SRATE, BPS. returns false if unknown attribute or device not open.
---@param attribute string
---@return boolean rv
---@return string desc
function reaper.GetAudioDeviceInfo(attribute) end

---gets the dock ID desired by ident_str, if any
---@param ident_str string
---@return integer rv
function reaper.GetConfigWantsDock(ident_str) end

---returns current project if in load/save (usually only used from project_config_extension_t)
---@return ReaProject rv
function reaper.GetCurrentProjectInLoadSave() end

---return the current cursor context: 0 if track panels, 1 if items, 2 if envelopes, otherwise unknown
---@return integer rv
function reaper.GetCursorContext() end

---0 if track panels, 1 if items, 2 if envelopes, otherwise unknown (unlikely when want_last_valid is true)
---@param want_last_valid boolean
---@return integer rv
function reaper.GetCursorContext2(want_last_valid) end

---edit cursor position
---@return number num
function reaper.GetCursorPosition() end

---edit cursor position
---@param proj ReaProject|nil|0
---@return number num
function reaper.GetCursorPositionEx(proj) end

---see GetDisplayedMediaItemColor2.
---@param item MediaItem
---@return integer rv
function reaper.GetDisplayedMediaItemColor(item) end

---Returns the custom take, item, or track color that is used (according to the user preference) to color the media item. The returned color is OS dependent|0x01000000 (i.e. ColorToNative(r,g,b)|0x01000000), so a return of zero means "no color", not black.
---@param item MediaItem
---@param take MediaItem_Take
---@return integer rv
function reaper.GetDisplayedMediaItemColor2(item, take) end

---@alias GetEnvelopeInfo_Value_Param
---| "'I_TCPY'" int : Y offset of envelope relative to parent track (may be separate lane or overlap with track contents)
---| "'I_TCPH'" int : visible height of envelope
---| "'I_TCPY_USED'" int : Y offset of envelope relative to parent track, exclusive of padding
---| "'I_TCPH_USED'" int : visible height of envelope, exclusive of padding
---| "'P_TRACK'" MediaTrack * : parent track pointer (if any)
---| "'P_DESTTRACK'" MediaTrack * : destination track pointer, if on a send
---| "'P_ITEM'" MediaItem * : parent item pointer (if any)
---| "'P_TAKE'" MediaItem_Take * : parent take pointer (if any)
---| "'I_SEND_IDX'" int : 1-based index of send in P_TRACK, or 0 if not a send
---| "'I_HWOUT_IDX'" int : 1-based index of hardware output in P_TRACK or 0 if not a hardware output
---| "'I_RECV_IDX'" int : 1-based index of receive in P_DESTTRACK or 0 if not a send/receive

---Gets an envelope numerical-value attribute:
---I_TCPY : int : Y offset of envelope relative to parent track (may be separate lane or overlap with track contents)
---I_TCPH : int : visible height of envelope
---I_TCPY_USED : int : Y offset of envelope relative to parent track, exclusive of padding
---I_TCPH_USED : int : visible height of envelope, exclusive of padding
---P_TRACK : MediaTrack * : parent track pointer (if any)
---P_DESTTRACK : MediaTrack * : destination track pointer, if on a send
---P_ITEM : MediaItem * : parent item pointer (if any)
---P_TAKE : MediaItem_Take * : parent take pointer (if any)
---I_SEND_IDX : int : 1-based index of send in P_TRACK, or 0 if not a send
---I_HWOUT_IDX : int : 1-based index of hardware output in P_TRACK or 0 if not a hardware output
---I_RECV_IDX : int : 1-based index of receive in P_DESTTRACK or 0 if not a send/receive
---@param env TrackEnvelope
---@param parmname GetEnvelopeInfo_Value_Param
---@return number num
function reaper.GetEnvelopeInfo_Value(env, parmname) end

---@param env TrackEnvelope
---@return boolean rv
---@return string buf
function reaper.GetEnvelopeName(env) end

---Get the attributes of an envelope point. See GetEnvelopePointEx.
---@param envelope TrackEnvelope
---@param ptidx integer
---@return boolean rv
---@return number time
---@return number value
---@return integer shape
---@return number tension
---@return boolean selected
function reaper.GetEnvelopePoint(envelope, ptidx) end

---Returns the envelope point at or immediately prior to the given time position. See GetEnvelopePointByTimeEx.
---@param envelope TrackEnvelope
---@param time number
---@return integer rv
function reaper.GetEnvelopePointByTime(envelope, time) end

---Returns the envelope point at or immediately prior to the given time position.
---autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration,
---even if the automation item is trimmed so that not all points are visible.
---Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations.
---See GetEnvelopePointEx, SetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param time number
---@return integer rv
function reaper.GetEnvelopePointByTimeEx(envelope, autoitem_idx, time) end

---Get the attributes of an envelope point.
---autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration,
---even if the automation item is trimmed so that not all points are visible.
---Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations.
---See CountEnvelopePointsEx, SetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param ptidx integer
---@return boolean rv
---@return number time
---@return number value
---@return integer shape
---@return number tension
---@return boolean selected
function reaper.GetEnvelopePointEx(envelope, autoitem_idx, ptidx) end

---Returns the envelope scaling mode: 0=no scaling, 1=fader scaling. All API functions deal with raw envelope point values, to convert raw from/to scaled values see ScaleFromEnvelopeMode, ScaleToEnvelopeMode.
---@param env TrackEnvelope
---@return integer rv
function reaper.GetEnvelopeScalingMode(env) end

---Gets the RPPXML state of an envelope, returns true if successful. Undo flag is a performance/caching hint.
---@param env TrackEnvelope
---@param str string
---@param isundo boolean
---@return boolean rv
---@return string str
function reaper.GetEnvelopeStateChunk(env, str, isundo) end

---gets information on the UI state of an envelope: returns &1 if automation/modulation is playing back, &2 if automation is being actively written, &4 if the envelope recently had an effective automation mode change
---@param env TrackEnvelope
---@return integer rv
function reaper.GetEnvelopeUIState(env) end

---returns path of REAPER.exe (not including EXE), i.e. C:\Program Files\REAPER
---@return string str
function reaper.GetExePath() end

---Get the extended state value for a specific section and key. See SetExtState, DeleteExtState, HasExtState.
---@param section string
---@param key string
---@return string str
function reaper.GetExtState(section, key) end

---This function is deprecated (returns GetFocusedFX2()&3), see GetTouchedOrFocusedFX.
---@return integer rv
---@return integer tracknumber
---@return integer itemnumber
---@return integer fxnumber
function reaper.GetFocusedFX() end

---Return value has 1 set if track FX, 2 if take/item FX, 4 set if FX is no longer focused but still open. tracknumber==0 means the master track, 1 means track 1, etc. itemnumber is zero-based (or -1 if not an item). For interpretation of fxnumber, see GetLastTouchedFX. Deprecated, see GetTouchedOrFocusedFX
---@return integer rv
---@return integer tracknumber
---@return integer itemnumber
---@return integer fxnumber
function reaper.GetFocusedFX2() end

---returns free disk space in megabytes, pathIdx 0 for normal, 1 for alternate.
---@param proj ReaProject|nil|0
---@param pathidx integer
---@return integer rv
function reaper.GetFreeDiskSpaceForRecordPath(proj, pathidx) end

---Returns the FX parameter envelope. If the envelope does not exist and create=true, the envelope will be created. If the envelope already exists and is bypassed and create=true, then the envelope will be unbypassed.
---@param track MediaTrack
---@param fxindex integer
---@param parameterindex integer
---@param create boolean
---@return TrackEnvelope rv
function reaper.GetFXEnvelope(track, fxindex, parameterindex, create) end

---return -1=no override, 0=trim/read, 1=read, 2=touch, 3=write, 4=latch, 5=bypass
---@return integer rv
function reaper.GetGlobalAutomationOverride() end

---returns pixels/second
---@return number num
function reaper.GetHZoomLevel() end

---returns approximate input level if available, 0-511 mono inputs, |1024 for stereo pairs, 4096+devidx*32 for MIDI devices
---@param input_id integer
---@return number num
function reaper.GetInputActivityLevel(input_id) end

---@param channelIndex integer
---@return string str
function reaper.GetInputChannelName(channelIndex) end

---Gets the audio device input/output latency in samples
---@return integer inputlatency
---@return integer outputLatency
function reaper.GetInputOutputLatency() end

---returns time of relevant edit, set which_item to the pcm_source (if applicable), flags (if specified) will be set to 1 for edge resizing, 2 for fade change, 4 for item move, 8 for item slip edit (edit cursor time or start of item)
---@return number num
---@return PCM_source which_item
---@return integer flags
function reaper.GetItemEditingTime2() end

---Returns the first item at the screen coordinates specified. If allow_locked is false, locked items are ignored. If takeOutOptional specified, returns the take hit. See GetThingFromPoint.
---@param screen_x integer
---@param screen_y integer
---@param allow_locked boolean
---@return MediaItem rv
---@return MediaItem_Take take
function reaper.GetItemFromPoint(screen_x, screen_y, allow_locked) end

---@param item MediaItem
---@return ReaProject rv
function reaper.GetItemProjectContext(item) end

---Gets the RPPXML state of an item, returns true if successful. Undo flag is a performance/caching hint.
---@param item MediaItem
---@param str string
---@param isundo boolean
---@return boolean rv
---@return string str
function reaper.GetItemStateChunk(item, str, isundo) end

---@return string str
function reaper.GetLastColorThemeFile() end

---Get the last project marker before time, and/or the project region that includes time. markeridx and regionidx are returned not necessarily as the displayed marker/region index, but as the index that can be passed to EnumProjectMarkers. Either or both of markeridx and regionidx may be NULL. See EnumProjectMarkers.
---@param proj ReaProject|nil|0
---@param time number
---@return integer markeridx
---@return integer regionidx
function reaper.GetLastMarkerAndCurRegion(proj, time) end

---Returns true if the last touched FX parameter is valid, false otherwise. The low word of tracknumber is the 1-based track index -- 0 means the master track, 1 means track 1, etc. If the high word of tracknumber is nonzero, it refers to the 1-based item index (1 is the first item on the track, etc). For track FX, the low 24 bits of fxnumber refer to the FX index in the chain, and if the next 8 bits are 01, then the FX is record FX. For item FX, the low word defines the FX index in the chain, and the high word defines the take number. Deprecated, see GetTouchedOrFocusedFX.
---@return boolean rv
---@return integer tracknumber
---@return integer fxnumber
---@return integer paramnumber
function reaper.GetLastTouchedFX() end

---@return MediaTrack rv
function reaper.GetLastTouchedTrack() end

---@return HWND rv
function reaper.GetMainHwnd() end

---&1=master mute,&2=master solo. This is deprecated as you can just query the master track as well.
---@return integer rv
function reaper.GetMasterMuteSoloFlags() end

---@param proj ReaProject|nil|0
---@return MediaTrack rv
function reaper.GetMasterTrack(proj) end

---returns &1 if the master track is visible in the TCP, &2 if NOT visible in the mixer. See SetMasterTrackVisibility.
---@return integer rv
function reaper.GetMasterTrackVisibility() end

---returns max dev for midi inputs/outputs
---@return integer rv
function reaper.GetMaxMidiInputs() end

---@return integer rv
function reaper.GetMaxMidiOutputs() end

---Get text-based metadata from a media file for a given identifier. Call with identifier="" to list all identifiers contained in the file, separated by newlines. May return "[Binary data]" for metadata that REAPER doesn't handle.
---@param mediaSource PCM_source
---@param identifier string
---@return integer rv
---@return string buf
function reaper.GetMediaFileMetadata(mediaSource, identifier) end

---get an item from a project by item count (zero-based) (proj=0 for active project)
---@param proj ReaProject|nil|0
---@param itemidx integer
---@return MediaItem rv
function reaper.GetMediaItem(proj, itemidx) end

---Get parent track of media item
---@param item MediaItem
---@return MediaTrack rv
function reaper.GetMediaItem_Track(item) end

---@alias GetMediaItemInfo_Value_Param
---| "'B_MUTE'" bool * : muted (item solo overrides). setting this value will clear C_MUTE_SOLO.
---| "'B_MUTE_ACTUAL'" bool * : muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
---| "'C_LANEPLAYS'" char * : on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only)
---| "'C_MUTE_SOLO'" char * : solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API.
---| "'B_LOOPSRC'" bool * : loop source
---| "'B_ALLTAKESPLAY'" bool * : all takes play
---| "'B_UISEL'" bool * : selected in arrange view
---| "'C_BEATATTACHMODE'" char * : item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1
---| "'C_AUTOSTRETCH'" : char * : auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
---| "'C_LOCK'" char * : locked, &1=locked
---| "'D_VOL'" double * : item volume,  0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
---| "'D_POSITION'" double * : item position in seconds
---| "'D_LENGTH'" double * : item length in seconds
---| "'D_SNAPOFFSET'" double * : item snap offset in seconds
---| "'D_FADEINLEN'" double * : item manual fadein length in seconds
---| "'D_FADEOUTLEN'" double * : item manual fadeout length in seconds
---| "'D_FADEINDIR'" double * : item fadein curvature, -1..1
---| "'D_FADEOUTDIR'" double * : item fadeout curvature, -1..1
---| "'D_FADEINLEN_AUTO'" double * : item auto-fadein length in seconds, -1=no auto-fadein
---| "'D_FADEOUTLEN_AUTO'" double * : item auto-fadeout length in seconds, -1=no auto-fadeout
---| "'C_FADEINSHAPE'" int * : fadein shape, 0..6, 0=linear
---| "'C_FADEOUTSHAPE'" int * : fadeout shape, 0..6, 0=linear
---| "'I_GROUPID'" int * : group ID, 0=no group
---| "'I_LASTY'" int * : Y-position (relative to top of track) in pixels (read-only)
---| "'I_LASTH'" int * : height in pixels (read-only)
---| "'I_CUSTOMCOLOR'" int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---| "'I_CURTAKE'" int * : active take number
---| "'IP_ITEMNUMBER'" int : item number on this track (read-only, returns the item number directly)
---| "'F_FREEMODE_Y'" float * : free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track
---| "'F_FREEMODE_H'" float * : free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height
---| "'I_FIXEDLANE'" int * : fixed lane of item (fine to call with setNewValue, but returned value is read-only)
---| "'B_FIXEDLANE_HIDDEN'" bool * : true if displaying only one fixed lane and this item is in a different lane (read-only)
---| "'P_TRACK'" MediaTrack * : (read-only)

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
---@param parmname GetMediaItemInfo_Value_Param
---@return number num
function reaper.GetMediaItemInfo_Value(item, parmname) end

---@param item MediaItem
---@return integer rv
function reaper.GetMediaItemNumTakes(item) end

---@param item MediaItem
---@param tk integer
---@return MediaItem_Take rv
function reaper.GetMediaItemTake(item, tk) end

---Get parent item of media item take
---@param take MediaItem_Take
---@return MediaItem rv
function reaper.GetMediaItemTake_Item(take) end

---Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.
---@param take MediaItem_Take
---@param peakrate number
---@param starttime number
---@param numchannels integer
---@param numsamplesperchannel integer
---@param want_extra_type integer
---@param buf reaper.array
---@return integer rv
function reaper.GetMediaItemTake_Peaks(take, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf) end

---Get media source of media item take
---@param take MediaItem_Take
---@return PCM_source rv
function reaper.GetMediaItemTake_Source(take) end

---Get parent track of media item take
---@param take MediaItem_Take
---@return MediaTrack rv
function reaper.GetMediaItemTake_Track(take) end

---@param project ReaProject|nil|0
---@param guidGUID string
---@return MediaItem_Take rv
function reaper.GetMediaItemTakeByGUID(project, guidGUID) end

---@alias GetMediaItemTakeInfo_Value_Param
---| "'D_STARTOFFS'" double * : start offset in source media, in seconds
---| "'D_VOL'" double * : take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
---| "'D_PAN'" double * : take pan, -1..1
---| "'D_PANLAW'" double * : take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
---| "'D_PLAYRATE'" double * : take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
---| "'D_PITCH'" double * : take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
---| "'B_PPITCH'" bool * : preserve pitch when changing playback rate
---| "'I_LASTY'" int * : Y-position (relative to top of track) in pixels (read-only)
---| "'I_LASTH'" int * : height in pixels (read-only)
---| "'I_CHANMODE'" int * : channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
---| "'I_PITCHMODE'" int * : pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
---| "'I_STRETCHFLAGS'" int * : stretch marker flags (&7 mask for mode override: 0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
---| "'F_STRETCHFADESIZE'" float * : stretch marker fade size in seconds (0.0025 default)
---| "'I_RECPASSID'" int * : record pass ID
---| "'I_TAKEFX_NCH'" int * : number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only)
---| "'I_CUSTOMCOLOR'" int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---| "'IP_SPECEDIT:CNT'" int : spectral edit count (read-only)
---| "'IP_SPECEDIT:DELETE:x'" int : read or write this key to remove the spectral edit specified
---| "'IP_SPECEDIT:ADD'" int : read or write this key to add a new spectral edit (returns index)
---| "'IP_SPECEDIT:SORT'" int : read or write this key to re-sort spectral edits (be sure to do this following a position change or insert of new edit)
---| "'I_SPECEDIT:FFT_SIZE'" int * : FFT size used by spectral edits for this take
---| "'D_SPECEDIT:x:POSITION'" double * : position of spectral edit start (changing this requires a resort of spectral edits)
---| "'D_SPECEDIT:x:LENGTH'" double * : length of spectral edit
---| "'F_SPECEDIT:x:GAIN'" float * : gain of spectral edit
---| "'F_SPECEDIT:x:FADE_IN'" float * : fade-in size 0..1
---| "'F_SPECEDIT:x:FADE_OUT'" float * : fade-out size 0..1
---| "'F_SPECEDIT:x:FADE_LOW'" float * : fade-lf size 0..1
---| "'F_SPECEDIT:x:FADE_HI'" float * : fade-hf size 0..1
---| "'I_SPECEDIT:x:CHAN'" int * : channel index, -1 for omni
---| "'I_SPECEDIT:x:FLAGS'" int * : flags, &1=bypassed, &2=solo
---| "'F_SPECEDIT:x:GATE_THRESH'" float * : gate threshold
---| "'F_SPECEDIT:x:GATE_FLOOR'" float * : gate floor
---| "'F_SPECEDIT:x:COMP_THRESH'" float * : comp threshold
---| "'F_SPECEDIT:x:COMP_RATIO'" float * : comp ratio
---| "'B_SPECEDIT:x:SELECTED'" bool * : selection state
---| "'I_SPECEDIT:x:TOPFREQ_CNT'" int * : (read-only) number of top frequency-points
---| "'I_SPECEDIT:x:TOPFREQ_ADD:pos:val'" int * : reading or writing will insert top frequency-point with position/value pair, returns index
---| "'I_SPECEDIT:x:TOPFREQ_DEL:y'" int * : reading or writing will delete top frequency-point y. there will always be at least one point.
---| "'F_SPECEDIT:x:TOPFREQ_POS:y'" float * : (read-only) get position of top frequency-point y
---| "'F_SPECEDIT:x:TOPFREQ_FREQ:y'" float * : (read-only) get frequency of top frequency-point y
---| "'I_SPECEDIT:x:BOTFREQ_CNT'" int * : number of bottom frequency-points
---| "'I_SPECEDIT:x:BOTFREQ_ADD:pos:val'" int * : reading or writing will insert bottom frequency-point with position/value pair, returns index
---| "'I_SPECEDIT:x:BOTFREQ_DEL:y'" int * : reading or writing will delete bottom frequency-point y. there will always be at least one point.
---| "'F_SPECEDIT:x:BOTFREQ_POS:y'" float * : (read-only) get position of bottom frequency-point y
---| "'F_SPECEDIT:x:BOTFREQ_FREQ:y'" float * : (read-only) get frequency of bottom frequency-point y
---| "'IP_TAKENUMBER'" int : take number (read-only, returns the take number directly)
---| "'P_TRACK'" pointer to MediaTrack (read-only)
---| "'P_ITEM'" pointer to MediaItem (read-only)
---| "'P_SOURCE'" PCM_source *. Note that if setting this, you should first retrieve the old source, set the new, THEN delete the old.

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
---IP_SPECEDIT:CNT : int : spectral edit count (read-only)
---IP_SPECEDIT:DELETE:x : int : read or write this key to remove the spectral edit specified
---IP_SPECEDIT:ADD : int : read or write this key to add a new spectral edit (returns index)
---IP_SPECEDIT:SORT : int : read or write this key to re-sort spectral edits (be sure to do this following a position change or insert of new edit)
---I_SPECEDIT:FFT_SIZE : int * : FFT size used by spectral edits for this take
---D_SPECEDIT:x:POSITION : double * : position of spectral edit start (changing this requires a resort of spectral edits)
---D_SPECEDIT:x:LENGTH : double * : length of spectral edit
---F_SPECEDIT:x:GAIN : float * : gain of spectral edit
---F_SPECEDIT:x:FADE_IN : float * : fade-in size 0..1
---F_SPECEDIT:x:FADE_OUT : float * : fade-out size 0..1
---F_SPECEDIT:x:FADE_LOW : float * : fade-lf size 0..1
---F_SPECEDIT:x:FADE_HI : float * : fade-hf size 0..1
---I_SPECEDIT:x:CHAN : int * : channel index, -1 for omni
---I_SPECEDIT:x:FLAGS : int * : flags, &1=bypassed, &2=solo
---F_SPECEDIT:x:GATE_THRESH : float * : gate threshold
---F_SPECEDIT:x:GATE_FLOOR : float * : gate floor
---F_SPECEDIT:x:COMP_THRESH : float * : comp threshold
---F_SPECEDIT:x:COMP_RATIO : float * : comp ratio
---B_SPECEDIT:x:SELECTED : bool * : selection state
---I_SPECEDIT:x:TOPFREQ_CNT : int * : (read-only) number of top frequency-points
---I_SPECEDIT:x:TOPFREQ_ADD:pos:val : int * : reading or writing will insert top frequency-point with position/value pair, returns index
---I_SPECEDIT:x:TOPFREQ_DEL:y : int * : reading or writing will delete top frequency-point y. there will always be at least one point.
---F_SPECEDIT:x:TOPFREQ_POS:y : float * : (read-only) get position of top frequency-point y
---F_SPECEDIT:x:TOPFREQ_FREQ:y : float * : (read-only) get frequency of top frequency-point y
---I_SPECEDIT:x:BOTFREQ_CNT : int * : number of bottom frequency-points
---I_SPECEDIT:x:BOTFREQ_ADD:pos:val : int * : reading or writing will insert bottom frequency-point with position/value pair, returns index
---I_SPECEDIT:x:BOTFREQ_DEL:y : int * : reading or writing will delete bottom frequency-point y. there will always be at least one point.
---F_SPECEDIT:x:BOTFREQ_POS:y : float * : (read-only) get position of bottom frequency-point y
---F_SPECEDIT:x:BOTFREQ_FREQ:y : float * : (read-only) get frequency of bottom frequency-point y
---IP_TAKENUMBER : int : take number (read-only, returns the take number directly)
---P_TRACK : pointer to MediaTrack (read-only)
---P_ITEM : pointer to MediaItem (read-only)
---P_SOURCE : PCM_source *. Note that if setting this, you should first retrieve the old source, set the new, THEN delete the old.
---@param take MediaItem_Take
---@param parmname GetMediaItemTakeInfo_Value_Param
---@return number num
function reaper.GetMediaItemTakeInfo_Value(take, parmname) end

---@param item MediaItem
---@return MediaTrack rv
function reaper.GetMediaItemTrack(item) end

---Copies the media source filename to filenamebuf. Note that in-project MIDI media sources have no associated filename. See GetMediaSourceParent.
---@param source PCM_source
---@return string filenamebuf
function reaper.GetMediaSourceFileName(source) end

---Returns the length of the source media. If the media source is beat-based, the length will be in quarter notes, otherwise it will be in seconds.
---@param source PCM_source
---@return number num
---@return boolean lengthIsQN
function reaper.GetMediaSourceLength(source) end

---Returns the number of channels in the source media.
---@param source PCM_source
---@return integer rv
function reaper.GetMediaSourceNumChannels(source) end

---Returns the parent source, or NULL if src is the root source. This can be used to retrieve the parent properties of sections or reversed sources for example.
---@param src PCM_source
---@return PCM_source rv
function reaper.GetMediaSourceParent(src) end

---Returns the sample rate. MIDI source media will return zero.
---@param source PCM_source
---@return integer rv
function reaper.GetMediaSourceSampleRate(source) end

---copies the media source type ("WAV", "MIDI", etc) to typebuf
---@param source PCM_source
---@return string typebuf
function reaper.GetMediaSourceType(source) end

---@alias GetMediaTrackInfo_Value_Param
---| "'B_MUTE'" bool * : muted
---| "'B_PHASE'" bool * : track phase inverted
---| "'B_RECMON_IN_EFFECT'" bool * : record monitoring in effect (current audio-thread playback state, read-only)
---| "'IP_TRACKNUMBER'" int : track number 1-based, 0=not found, -1=master track (read-only, returns the int directly)
---| "'I_SOLO'" int * : soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place
---| "'B_SOLO_DEFEAT'" bool * : when set, if anything else is soloed and this track is not muted, this track acts soloed
---| "'I_FXEN'" int * : fx enabled, 0=bypassed, !0=fx active
---| "'I_RECARM'" int * : record armed, 0=not record armed, 1=record armed
---| "'I_RECINPUT'" int * : record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023) are input start channel (ReaRoute/Loopback start at 512). If 2048 is set, input is multichannel input (using track channel count), or if 1024 is set, input is stereo input, otherwise input is mono.
---| "'I_RECMODE'" int * : record mode, 0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation, 4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7=midi overdub, 8=midi replace
---| "'I_RECMODE_FLAGS'" int * : record mode flags, &3=output recording mode (0=post fader, 1=pre-fx, 2=post-fx/pre-fader)
---| "'I_RECMON'" int * : record monitoring, 0=off, 1=normal, 2=not when playing (tape style)
---| "'I_RECMONITEMS'" int * : monitor items while recording, 0=off, 1=on
---| "'B_AUTO_RECARM'" bool * : automatically set record arm when selected (does not immediately affect recarm state, script should set directly if desired)
---| "'I_VUMODE'" int * : track vu mode, &1:disabled, &30==0:stereo peaks, &30==2:multichannel peaks, &30==4:stereo RMS, &30==8:combined RMS, &30==12:LUFS-M, &30==16:LUFS-S (readout=max), &30==20:LUFS-S (readout=current), &32:LUFS calculation on channels 1+2 only
---| "'I_AUTOMODE'" int * : track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch
---| "'I_NCHAN'" int * : number of track channels, 2-128, even numbers only
---| "'I_SELECTED'" int * : track selected, 0=unselected, 1=selected
---| "'I_WNDH'" int * : current TCP window height in pixels including envelopes (read-only)
---| "'I_TCPH'" int * : current TCP window height in pixels not including envelopes (read-only)
---| "'I_TCPY'" int * : current TCP window Y-position in pixels relative to top of arrange view (read-only)
---| "'I_MCPX'" int * : current MCP X-position in pixels relative to mixer container (read-only)
---| "'I_MCPY'" int * : current MCP Y-position in pixels relative to mixer container (read-only)
---| "'I_MCPW'" int * : current MCP width in pixels (read-only)
---| "'I_MCPH'" int * : current MCP height in pixels (read-only)
---| "'I_FOLDERDEPTH'" int * : folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc
---| "'I_FOLDERCOMPACT'" int * : folder collapsed state (only valid on folders), 0=normal, 1=collapsed, 2=fully collapsed
---| "'I_MIDIHWOUT'" int * : track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31)
---| "'I_MIDI_INPUT_CHANMAP'" int * : -1 maps to source channel, otherwise 1-16 to map to MIDI channel
---| "'I_MIDI_CTL_CHAN'" int * : -1 no link, 0-15 link to MIDI volume/pan on channel, 16 link to MIDI volume/pan on all channels
---| "'I_MIDI_TRACKSEL_FLAG'" int * : MIDI editor track list options: &1=expand media items, &2=exclude from list, &4=auto-pruned
---| "'I_PERFFLAGS'" int * : track performance flags, &1=no media buffering, &2=no anticipative FX
---| "'I_CUSTOMCOLOR'" int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---| "'I_HEIGHTOVERRIDE'" int * : custom height override for TCP window, 0 for none, otherwise size in pixels
---| "'I_SPACER'" int * : 1=TCP track spacer above this trackB_HEIGHTLOCK : bool * : track height lock (must set I_HEIGHTOVERRIDE before locking)
---| "'D_VOL'" double * : trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
---| "'D_PAN'" double * : trim pan of track, -1..1
---| "'D_WIDTH'" double * : width of track, -1..1
---| "'D_DUALPANL'" double * : dualpan position 1, -1..1, only if I_PANMODE==6
---| "'D_DUALPANR'" double * : dualpan position 2, -1..1, only if I_PANMODE==6
---| "'I_PANMODE'" int * : pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan
---| "'D_PANLAW'" double * : pan law of track, <0=project default, 0.5=-6dB, 0.707..=-3dB, 1=+0dB, 1.414..=-3dB with gain compensation, 2=-6dB with gain compensation, etc
---| "'I_PANLAW_FLAGS'" int * : pan law flags, 0=sine taper, 1=hybrid taper with deprecated behavior when gain compensation enabled, 2=linear taper, 3=hybrid taper
---| "'B_SHOWINMIXER'" bool * : track control panel visible in mixer (do not use on master track)
---| "'B_SHOWINTCP'" bool * : track control panel visible in arrange view (do not use on master track)
---| "'B_MAINSEND'" bool * : track sends audio to parent
---| "'C_MAINSEND_OFFS'" char * : channel offset of track send to parent
---| "'C_MAINSEND_NCH'" char * : channel count of track send to parent (0=use all child track channels, 1=use one channel only)
---| "'I_FREEMODE'" int * : 1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing)
---| "'I_NUMFIXEDLANES'" int * : number of track fixed lanes (fine to call with setNewValue, but returned value is read-only)
---| "'C_LANESCOLLAPSED'" char * : fixed lane collapse state (1=lanes collapsed, 2=track displays as non-fixed-lanes but hidden lanes exist)
---| "'C_LANESETTINGS'" char * : fixed lane settings (&1=auto-remove empty lanes at bottom, &2=do not auto-comp new recording, &4=newly recorded lanes play exclusively (else add lanes in layers), &8=big lanes (else small lanes), &16=add new recording at bottom (else record into first available lane), &32=hide lane buttons
---| "'C_LANEPLAYS:N'" char * :  on fixed lane tracks, 0=lane N does not play, 1=lane N plays exclusively, 2=lane N plays and other lanes also play (fine to call with setNewValue, but returned value is read-only)
---| "'C_ALLLANESPLAY'" char * : on fixed lane tracks, 0=no lanes play, 1=all lanes play, 2=some lanes play (fine to call with setNewValue 0 or 1, but returned value is read-only)
---| "'C_BEATATTACHMODE'" char * : track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only)
---| "'F_MCP_FXSEND_SCALE'" float * : scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed)
---| "'F_MCP_FXPARM_SCALE'" float * : scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed)
---| "'F_MCP_SENDRGN_SCALE'" float * : scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed)
---| "'F_TCP_FXPARM_SCALE'" float * : scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed)
---| "'I_PLAY_OFFSET_FLAG'" int * : track media playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds)
---| "'D_PLAY_OFFSET'" double * : track media playback offset, units depend on I_PLAY_OFFSET_FLAG
---| "'P_PARTRACK'" MediaTrack * : parent track (read-only)
---| "'P_PROJECT'" ReaProject * : parent project (read-only)

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
---@param parmname GetMediaTrackInfo_Value_Param
---@return number num
function reaper.GetMediaTrackInfo_Value(tr, parmname) end

---returns true if device present
---@param dev integer
---@param nameout string
---@return boolean rv
---@return string nameout
function reaper.GetMIDIInputName(dev, nameout) end

---returns true if device present
---@param dev integer
---@param nameout string
---@return boolean rv
---@return string nameout
function reaper.GetMIDIOutputName(dev, nameout) end

---Get the leftmost track visible in the mixer
---@return MediaTrack rv
function reaper.GetMixerScroll() end

---Get the current mouse modifier assignment for a specific modifier key assignment, in a specific context.
---action will be filled in with the command ID number for a built-in mouse modifier
---or built-in REAPER command ID, or the custom action ID string.
---Note: the action string may have a space and 'c' or 'm' appended to it to specify command ID vs mouse modifier ID.
---See SetMouseModifier for more information.
---@param context string
---@param modifier_flag integer
---@return string action
function reaper.GetMouseModifier(context, modifier_flag) end

---get mouse position in screen coordinates
---@return integer x
---@return integer y
function reaper.GetMousePosition() end

---Return number of normal audio hardware inputs available
---@return integer rv
function reaper.GetNumAudioInputs() end

---Return number of normal audio hardware outputs available
---@return integer rv
function reaper.GetNumAudioOutputs() end

---returns max number of real midi hardware inputs
---@return integer rv
function reaper.GetNumMIDIInputs() end

---returns max number of real midi hardware outputs
---@return integer rv
function reaper.GetNumMIDIOutputs() end

---Returns number of take markers. See GetTakeMarker, SetTakeMarker, DeleteTakeMarker
---@param take MediaItem_Take
---@return integer rv
function reaper.GetNumTakeMarkers(take) end

---Returns number of tracks in current project, see CountTracks()
---@return integer rv
function reaper.GetNumTracks() end

---Returns "Win32", "Win64", "OSX32", "OSX64", "macOS-arm64", or "Other".
---@return string str
function reaper.GetOS() end

---@param channelIndex integer
---@return string str
function reaper.GetOutputChannelName(channelIndex) end

---returns output latency in seconds
---@return number num
function reaper.GetOutputLatency() end

---@param track MediaTrack
---@return MediaTrack rv
function reaper.GetParentTrack(track) end

---get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
---@param fn string
---@return string buf
function reaper.GetPeakFileName(fn) end

---get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
---@param fn string
---@param buf string
---@param forWrite boolean
---@return string buf
function reaper.GetPeakFileNameEx(fn, buf, forWrite) end

---Like GetPeakFileNameEx, but you can specify peaksfileextension such as ".reapeaks"
---@param fn string
---@param buf string
---@param forWrite boolean
---@param peaksfileextension string
---@return string buf
function reaper.GetPeakFileNameEx2(fn, buf, forWrite, peaksfileextension) end

---returns latency-compensated actual-what-you-hear position
---@return number num
function reaper.GetPlayPosition() end

---returns position of next audio block being processed
---@return number num
function reaper.GetPlayPosition2() end

---returns position of next audio block being processed
---@param proj ReaProject|nil|0
---@return number num
function reaper.GetPlayPosition2Ex(proj) end

---returns latency-compensated actual-what-you-hear position
---@param proj ReaProject|nil|0
---@return number num
function reaper.GetPlayPositionEx(proj) end

---&1=playing, &2=paused, &4=is recording
---@return integer rv
function reaper.GetPlayState() end

---&1=playing, &2=paused, &4=is recording
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.GetPlayStateEx(proj) end

---returns length of project (maximum of end of media item, markers, end of regions, tempo map
---@param proj ReaProject|nil|0
---@return number num
function reaper.GetProjectLength(proj) end

---@param proj ReaProject|nil|0
---@return string buf
function reaper.GetProjectName(proj) end

---Get the project recording path.
---@return string buf
function reaper.GetProjectPath() end

---Get the project recording path.
---@param proj ReaProject|nil|0
---@return string buf
function reaper.GetProjectPathEx(proj) end

---returns an integer that changes when the project state changes
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.GetProjectStateChangeCount(proj) end

---Gets project time offset in seconds (project settings - project start time). If rndframe is true, the offset is rounded to a multiple of the project frame size.
---@param proj ReaProject|nil|0
---@param rndframe boolean
---@return number num
function reaper.GetProjectTimeOffset(proj, rndframe) end

---deprecated
---@return number bpm
---@return number bpi
function reaper.GetProjectTimeSignature() end

---Gets basic time signature (beats per minute, numerator of time signature in bpi)
---this does not reflect tempo envelopes but is purely what is set in the project settings.
---@param proj ReaProject|nil|0
---@return number bpm
---@return number bpi
function reaper.GetProjectTimeSignature2(proj) end

---Get the value previously associated with this extname and key, the last time the project was saved. See SetProjExtState, EnumProjExtState.
---@param proj ReaProject|nil|0
---@param extname string
---@param key string
---@return integer rv
---@return string val
function reaper.GetProjExtState(proj, extname, key) end

---returns path where ini files are stored, other things are in subdirectories.
---@return string str
function reaper.GetResourcePath() end

---get the currently selected envelope, returns NULL/nil if no envelope is selected
---@param proj ReaProject|nil|0
---@return TrackEnvelope rv
function reaper.GetSelectedEnvelope(proj) end

---Discouraged, because GetSelectedMediaItem can be inefficient if media items are added, rearranged, or deleted in between calls. Instead see CountMediaItems, GetMediaItem, IsMediaItemSelected.
---@param proj ReaProject|nil|0
---@param selitem integer
---@return MediaItem rv
function reaper.GetSelectedMediaItem(proj, selitem) end

---Get a selected track from a project (proj=0 for active project) by selected track count (zero-based). This function ignores the master track, see GetSelectedTrack2.
---@param proj ReaProject|nil|0
---@param seltrackidx integer
---@return MediaTrack rv
function reaper.GetSelectedTrack(proj, seltrackidx) end

---Get a selected track from a project (proj=0 for active project) by selected track count (zero-based).
---@param proj ReaProject|nil|0
---@param seltrackidx integer
---@param wantmaster boolean
---@return MediaTrack rv
function reaper.GetSelectedTrack2(proj, seltrackidx, wantmaster) end

---get the currently selected track envelope, returns NULL/nil if no envelope is selected
---@param proj ReaProject|nil|0
---@return TrackEnvelope rv
function reaper.GetSelectedTrackEnvelope(proj) end

---Gets or sets the arrange view start/end time for screen coordinates. use screen_x_start=screen_x_end=0 to use the full arrange view's start/end time
---@param proj ReaProject|nil|0
---@param isSet boolean
---@param screen_x_start integer
---@param screen_x_end integer
---@param start_time number?
---@param end_time number?
---@return number start_time
---@return number end_time
function reaper.GetSet_ArrangeView2(proj, isSet, screen_x_start, screen_x_end, start_time, end_time) end

---@param isSet boolean
---@param isLoop boolean
---@param start number
---@param end number
---@param allowautoseek boolean
---@return number start
---@return number end
function reaper.GetSet_LoopTimeRange(isSet, isLoop, start, end, allowautoseek) end

---@param proj ReaProject|nil|0
---@param isSet boolean
---@param isLoop boolean
---@param start number
---@param end number
---@param allowautoseek boolean
---@return number start
---@return number end
function reaper.GetSet_LoopTimeRange2(proj, isSet, isLoop, start, end, allowautoseek) end

---@alias GetSetAutomationItemInfo_Param
---| "'D_POOL_ID'" double * : automation item pool ID (as an integer); edits are propagated to all other automation items that share a pool ID
---| "'D_POSITION'" double * : automation item timeline position in seconds
---| "'D_LENGTH'" double * : automation item length in seconds
---| "'D_STARTOFFS'" double * : automation item start offset in seconds
---| "'D_PLAYRATE'" double * : automation item playback rate
---| "'D_BASELINE'" double * : automation item baseline value in the range [0,1]
---| "'D_AMPLITUDE'" double * : automation item amplitude in the range [-1,1]
---| "'D_LOOPSRC'" double * : nonzero if the automation item contents are looped
---| "'D_UISEL'" double * : nonzero if the automation item is selected in the arrange view
---| "'D_POOL_QNLEN'" double * : automation item pooled source length in quarter notes (setting will affect all pooled instances)

---Get or set automation item information. autoitem_idx=0 for the first automation item on an envelope, 1 for the second item, etc. desc can be any of the following:
---D_POOL_ID : double * : automation item pool ID (as an integer); edits are propagated to all other automation items that share a pool ID
---D_POSITION : double * : automation item timeline position in seconds
---D_LENGTH : double * : automation item length in seconds
---D_STARTOFFS : double * : automation item start offset in seconds
---D_PLAYRATE : double * : automation item playback rate
---D_BASELINE : double * : automation item baseline value in the range [0,1]
---D_AMPLITUDE : double * : automation item amplitude in the range [-1,1]
---D_LOOPSRC : double * : nonzero if the automation item contents are looped
---D_UISEL : double * : nonzero if the automation item is selected in the arrange view
---D_POOL_QNLEN : double * : automation item pooled source length in quarter notes (setting will affect all pooled instances)
---@param env TrackEnvelope
---@param autoitem_idx integer
---@param desc GetSetAutomationItemInfo_Param
---@param value number
---@param is_set boolean
---@return number num
function reaper.GetSetAutomationItemInfo(env, autoitem_idx, desc, value, is_set) end

---@alias GetSetAutomationItemInfo_String_Param
---| "'P_POOL_NAME'" char * : name of the underlying automation item pool
---| "'P_POOL_EXT:xyz'" char * : extension-specific persistent data

---Get or set automation item information. autoitem_idx=0 for the first automation item on an envelope, 1 for the second item, etc. returns true on success. desc can be any of the following:
---P_POOL_NAME : char * : name of the underlying automation item pool
---P_POOL_EXT:xyz : char * : extension-specific persistent data
---@param env TrackEnvelope
---@param autoitem_idx integer
---@param desc GetSetAutomationItemInfo_String_Param
---@param valuestrNeedBig string
---@param is_set boolean
---@return boolean rv
---@return string valuestrNeedBig
function reaper.GetSetAutomationItemInfo_String(env, autoitem_idx, desc, valuestrNeedBig, is_set) end

---@alias GetSetEnvelopeInfo_String_Param
---| "'ACTIVE'" active state (bool as a string "0" or "1")
---| "'ARM'" armed state (bool...)
---| "'VISIBLE'" visible state (bool...)
---| "'SHOWLANE'" show envelope in separate lane (bool...)
---| "'GUID'" (read-only) GUID as a string {xyz-....}
---| "'P_EXT:xyz'" extension-specific persistent data

---Gets/sets an attribute string:
---ACTIVE : active state (bool as a string "0" or "1")
---ARM : armed state (bool...)
---VISIBLE : visible state (bool...)
---SHOWLANE : show envelope in separate lane (bool...)
---GUID : (read-only) GUID as a string {xyz-....}
---P_EXT:xyz : extension-specific persistent data
---Note that when writing some of these attributes you will need to manually update the arrange and/or track panels, see TrackList_AdjustWindows
---@param env TrackEnvelope
---@param parmname GetSetEnvelopeInfo_String_Param
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean rv
---@return string stringNeedBig
function reaper.GetSetEnvelopeInfo_String(env, parmname, stringNeedBig, setNewValue) end

---deprecated -- see SetEnvelopeStateChunk, GetEnvelopeStateChunk
---@param env TrackEnvelope
---@param str string
---@return boolean rv
---@return string str
function reaper.GetSetEnvelopeState(env, str) end

---deprecated -- see SetEnvelopeStateChunk, GetEnvelopeStateChunk
---@param env TrackEnvelope
---@param str string
---@param isundo boolean
---@return boolean rv
---@return string str
function reaper.GetSetEnvelopeState2(env, str, isundo) end

---deprecated -- see SetItemStateChunk, GetItemStateChunk
---@param item MediaItem
---@param str string
---@return boolean rv
---@return string str
function reaper.GetSetItemState(item, str) end

---deprecated -- see SetItemStateChunk, GetItemStateChunk
---@param item MediaItem
---@param str string
---@param isundo boolean
---@return boolean rv
---@return string str
function reaper.GetSetItemState2(item, str, isundo) end

---@alias GetSetMediaItemInfo_String_Param
---| "'P_NOTES'" char * : item note text (do not write to returned pointer, use setNewValue to update)
---| "'P_EXT:xyz'" char * : extension-specific persistent data
---| "'GUID'" GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
---| "'P_EXT:alt'"
---| "'P_EXT:character'"
---| "'P_EXT:description'"
---| "'P_EXT:line'"
---| "'P_EXT:log'"
---| "'P_EXT:nvk_AUTODOPPLER'"
---| "'P_EXT:nvk_automute'"
---| "'P_EXT:nvk_CREATE_STRING'"
---| "'P_EXT:nvk_fade'"
---| "'P_EXT:nvk_item_s'"
---| "'P_EXT:nvk_item_type'"
---| "'P_EXT:nvk_render_preset'"
---| "'P_EXT:parenthetical'"
---| "'P_EXT:nvk_TOGGLE_VOL'"

---Gets/sets an item attribute string:
---P_NOTES : char * : item note text (do not write to returned pointer, use setNewValue to update)
---P_EXT:xyz : char * : extension-specific persistent data
---GUID : GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
---@param item MediaItem
---@param parmname GetSetMediaItemInfo_String_Param
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean rv
---@return string stringNeedBig
function reaper.GetSetMediaItemInfo_String(item, parmname, stringNeedBig, setNewValue) end

---@alias GetSetMediaItemTakeInfo_String_Param
---| "'P_NAME'" char * : take name
---| "'P_EXT:xyz'" char * : extension-specific persistent data
---| "'GUID'" GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
---| "'P_EXT:nvk_CREATE_TakeProcessor'"
---| "'P_EXT:nvk_fade_overshoot'"
---| "'P_EXT:nvk_take_source_type_v2'"

---Gets/sets a take attribute string:
---P_NAME : char * : take name
---P_EXT:xyz : char * : extension-specific persistent data
---GUID : GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
---@param tk MediaItem_Take
---@param parmname GetSetMediaItemTakeInfo_String_Param
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean rv
---@return string stringNeedBig
function reaper.GetSetMediaItemTakeInfo_String(tk, parmname, stringNeedBig, setNewValue) end

---@alias GetSetMediaTrackInfo_String_Param
---| "'P_NAME'" char * : track name (on master returns NULL)
---| "'P_ICON'" const char * : track icon (full filename, or relative to resource_path/data/track_icons)
---| "'P_LANENAME:n'" char * : lane name (returns NULL for non-fixed-lane-tracks)
---| "'P_MCP_LAYOUT'" const char * : layout name
---| "'P_RAZOREDITS'" const char * : list of razor edit areas, as space-separated triples of start time, end time, and envelope GUID string.
---| "'P_RAZOREDITS_EXT'" const char * : list of razor edit areas, as comma-separated sets of space-separated tuples of start time, end time, optional: envelope GUID string, fixed/fipm top y-position, fixed/fipm bottom y-position.
---| "'P_TCP_LAYOUT'" const char * : layout name
---| "'P_EXT:xyz'" char * : extension-specific persistent data
---| "'P_UI_RECT:tcp.mute'" char * : read-only, allows querying screen position + size of track WALTER elements (tcp.size queries screen position and size of entire TCP, etc).
---| "'GUID'" GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
---| "'P_EXT:CHARACTERS'"
---| "'P_EXT:nvk_AUTODOPPLER'"
---| "'P_EXT:nvk_TRACK_AUTOMUTE'"
---| "'P_EXT:SCENES'"
---| "'P_EXT:nvk_track_color'"

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
---@param parmname GetSetMediaTrackInfo_String_Param
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean rv
---@return string stringNeedBig
function reaper.GetSetMediaTrackInfo_String(tr, parmname, stringNeedBig, setNewValue) end

---deprecated, see GetSetProjectInfo_String with desc="PROJECT_AUTHOR"
---@param proj ReaProject|nil|0
---@param set boolean
---@param author string
---@return string author
function reaper.GetSetProjectAuthor(proj, set, author) end

---Get or set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc. swingmode can be 1 for swing enabled, swingamt is -1..1. swingmode can be 3 for measure-grid. Returns grid configuration flags
---@param project ReaProject|nil|0
---@param set boolean
---@param division number?
---@param swingmode integer?
---@param swingamt number?
---@return integer rv
---@return number? division
---@return integer? swingmode
---@return number? swingamt
function reaper.GetSetProjectGrid(project, set, division, swingmode, swingamt) end

---@alias GetSetProjectInfo_Param
---| "'RENDER_SETTINGS'" (&(1|2)==0)=master mix, &1=stems+master mix, &2=stems only, &4=multichannel tracks to multichannel files, &8=use render matrix, &16=tracks with only mono media to mono files, &32=selected media items, &64=selected media items via master, &128=selected tracks via master, &256=embed transients if format supports, &512=embed metadata if format supports, &1024=embed take markers if format supports, &2048=2nd pass render, &4096=render razor edits, &8192=pre-fader stems (not if via master), &16384=only stem channels sent to parent, &32768=preserve source metadata if possible, &(1<<16)=preserve source start offset if possible, &(2<<16)=preserve source media sample rate if possible, &(4<<16)=if rendering selected items or razor edits, render as a single file, &(8<<16)=parallel render via master, &(16<<16)=delay render start to allow FX to initialize and load samples
---| "'RENDER_BOUNDSFLAG'" 0=custom time bounds, 1=entire project, 2=time selection, 3=all project regions, 4=selected media items, 5=selected project regions, 6=all project markers, 7=selected project markers
---| "'RENDER_CHANNELS'" number of channels in rendered file
---| "'RENDER_SRATE'" sample rate of rendered file (or 0 for project sample rate)
---| "'RENDER_STARTPOS'" render start time when RENDER_BOUNDSFLAG=0
---| "'RENDER_ENDPOS'" render end time when RENDER_BOUNDSFLAG=0
---| "'RENDER_TAILFLAG'" apply render tail setting when rendering: &1=custom time bounds, &2=entire project, &4=time selection, &8=all project markers/regions, &16=selected media items, &32=selected project markers/regions
---| "'RENDER_TAILMS'" tail length in ms to render (only used if RENDER_BOUNDSFLAG and RENDER_TAILFLAG are set)
---| "'RENDER_ADDTOPROJ'" &1=add rendered files to project, &2=do not render files that are likely silent
---| "'RENDER_DITHER'" &1=dither, &2=noise shaping, &4=dither stems, &8=noise shaping on stems, &16=disable all
---| "'RENDER_NORMALIZE'" &1=enable normalization, (&14==0)=LUFS-I, (&14==2)=RMS, (&14==4)=peak, (&14==6)=true peak, (&14==8)=LUFS-M max, (&14==10)=LUFS-S max, &16=adjust mono media -3dB, &(16|(8<<16))=adjust mono media +3dB, (&(32|4096|(16<<16))==32)=normalize as if files play together, (&(32|4096|(16<<16))==4096)=normalize to loudest file, (&(32|4096|(16<<16))==(32|4096))=normalize as if files play together (common gain), (&(32|4096|(16<<16))==(16<<16))=normalize to master mix, &64=enable brickwall limit, &128=brickwall limit true peak, (&(256|2048)==256)=only normalize files that are too loud, (&(256|2048)==2048)=only normalize files that are too quiet, &512=apply fade-in, &1024=apply fade-out, &16384=trim starting silence, &32768=trim ending silence, &(1<<16)=pad start with silence, &(2<<16)=pad end with silence, &(4<<16)=disable all render postprocessing, (&((32<<16)|(64<<16))==(32<<16))=limit as if files play together, (&((32<<16)|(64<<16))==(64<<16))=limit to master mix
---| "'RENDER_NORMALIZE_TARGET'" render normalization target (0.5 means -6.02dB, requires RENDER_NORMALIZE&1)
---| "'RENDER_BRICKWALL'" render brickwall limit (0.5 means -6.02dB, requires RENDER_NORMALIZE&64)
---| "'RENDER_FADEIN'" render fade-in (0.001 means 1 ms, requires RENDER_NORMALIZE&512)
---| "'RENDER_FADEOUT'" render fade-out (0.001 means 1 ms, requires RENDER_NORMALIZE&1024)
---| "'RENDER_FADEINSHAPE'" render fade-in shape
---| "'RENDER_FADEOUTSHAPE'" render fade-out shape
---| "'RENDER_PADSTART'" pad render start with silence (0.001 means 1ms, requires RENDER_NORMALIZE&(1<<16))
---| "'RENDER_PADEND'" pad render end with silence (0.001 means 1ms, requires RENDER_NORMALIZE&(2<<16))
---| "'RENDER_TRIMSTART'" trim render start threshold (0.5 means -6.02dB, requires RENDER_NORMALIZE&16384)
---| "'RENDER_TRIMEND'" trim render end threshold (0.5 means -6.02dB, requires RENDER_NORMALIZE&32768)
---| "'RENDER_DELAY'" seconds to delay start of render to allow FX to initialize and load samples (requires RENDER_SETTINGS&(16<<16))
---| "'PROJECT_SRATE'" sample rate (ignored unless PROJECT_SRATE_USE set)
---| "'PROJECT_SRATE_USE'" set to 1 if project sample rate is used

---Get or set project information.
---RENDER_SETTINGS : (&(1|2)==0)=master mix, &1=stems+master mix, &2=stems only, &4=multichannel tracks to multichannel files, &8=use render matrix, &16=tracks with only mono media to mono files, &32=selected media items, &64=selected media items via master, &128=selected tracks via master, &256=embed transients if format supports, &512=embed metadata if format supports, &1024=embed take markers if format supports, &2048=2nd pass render, &4096=render razor edits, &8192=pre-fader stems (not if via master), &16384=only stem channels sent to parent, &32768=preserve source metadata if possible, &(1<<16)=preserve source start offset if possible, &(2<<16)=preserve source media sample rate if possible, &(4<<16)=if rendering selected items or razor edits, render as a single file, &(8<<16)=parallel render via master, &(16<<16)=delay render start to allow FX to initialize and load samples
---RENDER_BOUNDSFLAG : 0=custom time bounds, 1=entire project, 2=time selection, 3=all project regions, 4=selected media items, 5=selected project regions, 6=all project markers, 7=selected project markers
---RENDER_CHANNELS : number of channels in rendered file
---RENDER_SRATE : sample rate of rendered file (or 0 for project sample rate)
---RENDER_STARTPOS : render start time when RENDER_BOUNDSFLAG=0
---RENDER_ENDPOS : render end time when RENDER_BOUNDSFLAG=0
---RENDER_TAILFLAG : apply render tail setting when rendering: &1=custom time bounds, &2=entire project, &4=time selection, &8=all project markers/regions, &16=selected media items, &32=selected project markers/regions
---RENDER_TAILMS : tail length in ms to render (only used if RENDER_BOUNDSFLAG and RENDER_TAILFLAG are set)
---RENDER_ADDTOPROJ : &1=add rendered files to project, &2=do not render files that are likely silent
---RENDER_DITHER : &1=dither, &2=noise shaping, &4=dither stems, &8=noise shaping on stems, &16=disable all
---RENDER_NORMALIZE: &1=enable normalization, (&14==0)=LUFS-I, (&14==2)=RMS, (&14==4)=peak, (&14==6)=true peak, (&14==8)=LUFS-M max, (&14==10)=LUFS-S max, &16=adjust mono media -3dB, &(16|(8<<16))=adjust mono media +3dB, (&(32|4096|(16<<16))==32)=normalize as if files play together, (&(32|4096|(16<<16))==4096)=normalize to loudest file, (&(32|4096|(16<<16))==(32|4096))=normalize as if files play together (common gain), (&(32|4096|(16<<16))==(16<<16))=normalize to master mix, &64=enable brickwall limit, &128=brickwall limit true peak, (&(256|2048)==256)=only normalize files that are too loud, (&(256|2048)==2048)=only normalize files that are too quiet, &512=apply fade-in, &1024=apply fade-out, &16384=trim starting silence, &32768=trim ending silence, &(1<<16)=pad start with silence, &(2<<16)=pad end with silence, &(4<<16)=disable all render postprocessing, (&((32<<16)|(64<<16))==(32<<16))=limit as if files play together, (&((32<<16)|(64<<16))==(64<<16))=limit to master mix
---RENDER_NORMALIZE_TARGET: render normalization target (0.5 means -6.02dB, requires RENDER_NORMALIZE&1)
---RENDER_BRICKWALL: render brickwall limit (0.5 means -6.02dB, requires RENDER_NORMALIZE&64)
---RENDER_FADEIN: render fade-in (0.001 means 1 ms, requires RENDER_NORMALIZE&512)
---RENDER_FADEOUT: render fade-out (0.001 means 1 ms, requires RENDER_NORMALIZE&1024)
---RENDER_FADEINSHAPE: render fade-in shape
---RENDER_FADEOUTSHAPE: render fade-out shape
---RENDER_PADSTART: pad render start with silence (0.001 means 1ms, requires RENDER_NORMALIZE&(1<<16))
---RENDER_PADEND: pad render end with silence (0.001 means 1ms, requires RENDER_NORMALIZE&(2<<16))
---RENDER_TRIMSTART: trim render start threshold (0.5 means -6.02dB, requires RENDER_NORMALIZE&16384)
---RENDER_TRIMEND: trim render end threshold (0.5 means -6.02dB, requires RENDER_NORMALIZE&32768)
---RENDER_DELAY: seconds to delay start of render to allow FX to initialize and load samples (requires RENDER_SETTINGS&(16<<16))
---PROJECT_SRATE : sample rate (ignored unless PROJECT_SRATE_USE set)
---PROJECT_SRATE_USE : set to 1 if project sample rate is used
---@param project ReaProject|nil|0
---@param desc GetSetProjectInfo_Param
---@param value number
---@param is_set boolean
---@return number num
function reaper.GetSetProjectInfo(project, desc, value, is_set) end

---@alias GetSetProjectInfo_String_Param
---| "'PROJECT_NAME'" project file name (read-only, is_set will be ignored)
---| "'PROJECT_TITLE'" title field from Project Settings/Notes dialog
---| "'PROJECT_AUTHOR'" author field from Project Settings/Notes dialog
---| "'TRACK_GROUP_NAME:X'" track group name, X should be 1..64
---| "'MARKER_GUID:X'" get the GUID (unique ID) of the marker or region with index X, where X is the index passed to EnumProjectMarkers, not necessarily the displayed number (read-only)
---| "'MARKER_INDEX_FROM_GUID:{GUID}'" get the GUID index of the marker or region with GUID {GUID} (read-only)
---| "'OPENCOPY_CFGIDX'" integer for the configuration of format to use when creating copies/applying FX. 0=wave (auto-depth), 1=APPLYFX_FORMAT, 2=RECORD_FORMAT
---| "'RECORD_PATH'" recording directory -- may be blank or a relative path, to get the effective path see GetProjectPathEx()
---| "'RECORD_PATH_SECONDARY'" secondary recording directory
---| "'RECORD_FORMAT'" base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
---| "'APPLYFX_FORMAT'" base64-encoded sink configuration (see project files, etc). Used only if RECFMT_OPENCOPY is set to 1. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
---| "'RECTAG'" project recording tag wildcard ($rectag). Can be used in Preferences/Audio/Recording to auto-name recorded files.
---| "'RENDER_FILE'" render directory
---| "'RENDER_PATTERN'" render file name (may contain wildcards)
---| "'RENDER_METADATA'" get or set the metadata saved with the project (not metadata embedded in project media). Example, ID3 album name metadata: valuestr="ID3:TALB" to get, valuestr="ID3:TALB|my album name" to set. Call with valuestr="" and is_set=false to get a semicolon-separated list of defined project metadata identifiers.
---| "'RENDER_TARGETS'" semicolon separated list of files that would be written if the project is rendered using the most recent render settings
---| "'RENDER_STATS'" (read-only) semicolon separated list of statistics for the most recently rendered files. call with valuestr="XXX" to run an action (for example, "42437"=dry run render selected items) before returning statistics.
---| "'RENDER_FORMAT'" base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
---| "'RENDER_FORMAT2'" base64-encoded secondary sink configuration. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type, or "" to disable secondary render.

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
---RECTAG : project recording tag wildcard ($rectag). Can be used in Preferences/Audio/Recording to auto-name recorded files.
---RENDER_FILE : render directory
---RENDER_PATTERN : render file name (may contain wildcards)
---RENDER_METADATA : get or set the metadata saved with the project (not metadata embedded in project media). Example, ID3 album name metadata: valuestr="ID3:TALB" to get, valuestr="ID3:TALB|my album name" to set. Call with valuestr="" and is_set=false to get a semicolon-separated list of defined project metadata identifiers.
---RENDER_TARGETS : semicolon separated list of files that would be written if the project is rendered using the most recent render settings
---RENDER_STATS : (read-only) semicolon separated list of statistics for the most recently rendered files. call with valuestr="XXX" to run an action (for example, "42437"=dry run render selected items) before returning statistics.
---RENDER_FORMAT : base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type.
---RENDER_FORMAT2 : base64-encoded secondary sink configuration. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type, or "" to disable secondary render.
---&nbsp;&nbsp;&nbsp;&nbsp;Formats available on this machine:
---&nbsp;&nbsp;&nbsp;&nbsp;"wave" "aiff" "caff" "raw " "mp3l" "wvpk" "OggS" "flac" "ddp " "iso " "oggv" "FFMP" "XAVF" "GIF " "LCF "
---@param project ReaProject|nil|0
---@param desc GetSetProjectInfo_String_Param
---@param valuestrNeedBig string
---@param is_set boolean
---@return boolean rv
---@return string valuestrNeedBig
function reaper.GetSetProjectInfo_String(project, desc, valuestrNeedBig, is_set) end

---gets or sets project notes, notesNeedBig_sz is ignored when setting
---@param proj ReaProject|nil|0
---@param set boolean
---@param notes string
---@return string notes
function reaper.GetSetProjectNotes(proj, set, notes) end

----1 == query,0=clear,1=set,>1=toggle . returns new value
---@param val integer
---@return integer rv
function reaper.GetSetRepeat(val) end

----1 == query,0=clear,1=set,>1=toggle . returns new value
---@param proj ReaProject|nil|0
---@param val integer
---@return integer rv
function reaper.GetSetRepeatEx(proj, val) end

---Gets or sets the attribute flag of a tempo/time signature marker. flag &1=sets time signature and starts new measure, &2=does not set tempo, &4=allow previous partial measure if starting new measure, &8=set new metronome pattern if starting new measure, &16=reset ruler grid if starting new measure
---@param project ReaProject|nil|0
---@param point_index integer
---@param flag integer
---@param is_set boolean
---@return integer rv
function reaper.GetSetTempoTimeSigMarkerFlag(project, point_index, flag, is_set) end

---Gets or modifies the group membership for a track. Returns group state prior to call (each bit represents one of the 32 group numbers). if setmask has bits set, those bits in setvalue will be applied to group. Group can be one of:
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
---@param setmask integer
---@param setvalue integer
---@return integer rv
function reaper.GetSetTrackGroupMembership(tr, groupname, setmask, setvalue) end

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
---@return integer rv
function reaper.GetSetTrackGroupMembershipEx(tr, groupname, offset, setmask, setvalue) end

---Gets or modifies the group membership for a track. Returns group state prior to call (each bit represents one of the high 32 group numbers). if setmask has bits set, those bits in setvalue will be applied to group. Group can be one of:
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
---@param setmask integer
---@param setvalue integer
---@return integer rv
function reaper.GetSetTrackGroupMembershipHigh(tr, groupname, setmask, setvalue) end

---@alias GetSetTrackSendInfo_String_Param
---| "'P_EXT:xyz'" char * : extension-specific persistent data

---Gets/sets a send attribute string:
---P_EXT:xyz : char * : extension-specific persistent data
---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@param parmname GetSetTrackSendInfo_String_Param
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean rv
---@return string stringNeedBig
function reaper.GetSetTrackSendInfo_String(tr, category, sendidx, parmname, stringNeedBig, setNewValue) end

---deprecated -- see SetTrackStateChunk, GetTrackStateChunk
---@param track MediaTrack
---@param str string
---@return boolean rv
---@return string str
function reaper.GetSetTrackState(track, str) end

---deprecated -- see SetTrackStateChunk, GetTrackStateChunk
---@param track MediaTrack
---@param str string
---@param isundo boolean
---@return boolean rv
---@return string str
function reaper.GetSetTrackState2(track, str, isundo) end

---@param src PCM_source
---@return ReaProject rv
function reaper.GetSubProjectFromSource(src) end

---get a take from an item by take count (zero-based)
---@param item MediaItem
---@param takeidx integer
---@return MediaItem_Take rv
function reaper.GetTake(item, takeidx) end

---@param take MediaItem_Take
---@param envidx integer
---@return TrackEnvelope rv
function reaper.GetTakeEnvelope(take, envidx) end

---@param take MediaItem_Take
---@param envname string
---@return TrackEnvelope rv
function reaper.GetTakeEnvelopeByName(take, envname) end

---Get information about a take marker. Returns the position in media item source time, or -1 if the take marker does not exist. See GetNumTakeMarkers, SetTakeMarker, DeleteTakeMarker
---@param take MediaItem_Take
---@param idx integer
---@return number num
---@return string name
---@return integer? color
function reaper.GetTakeMarker(take, idx) end

---returns NULL if the take is not valid
---@param take MediaItem_Take
---@return string str
function reaper.GetTakeName(take) end

---Returns number of stretch markers in take
---@param take MediaItem_Take
---@return integer rv
function reaper.GetTakeNumStretchMarkers(take) end

---Gets information on a stretch marker, idx is 0..n. Returns -1 if stretch marker not valid. posOut will be set to position in item, srcposOutOptional will be set to source media position. Returns index. if input index is -1, the following marker is found using position (or source position if position is -1). If position/source position are used to find marker position, their values are not updated.
---@param take MediaItem_Take
---@param idx integer
---@return integer rv
---@return number pos
---@return number? srcpos
function reaper.GetTakeStretchMarker(take, idx) end

---See SetTakeStretchMarkerSlope
---@param take MediaItem_Take
---@param idx integer
---@return number num
function reaper.GetTakeStretchMarkerSlope(take, idx) end

---Get information about a specific FX parameter knob (see CountTCPFXParms).
---@param project ReaProject|nil|0
---@param track MediaTrack
---@param index integer
---@return boolean rv
---@return integer fxindex
---@return integer parmidx
function reaper.GetTCPFXParm(project, track, index) end

---finds the playrate and target length to insert this item stretched to a round power-of-2 number of bars, between 1/8 and 256
---@param source PCM_source
---@param srcscale number
---@param position number
---@param mult number
---@return boolean rv
---@return number rate
---@return number targetlen
function reaper.GetTempoMatchPlayRate(source, srcscale, position, mult) end

---Get information about a tempo/time signature marker. See CountTempoTimeSigMarkers, SetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param proj ReaProject|nil|0
---@param ptidx integer
---@return boolean rv
---@return number timepos
---@return integer measurepos
---@return number beatpos
---@return number bpm
---@return integer timesig_num
---@return integer timesig_denom
---@return boolean lineartempo
function reaper.GetTempoTimeSigMarker(proj, ptidx) end

---Returns the theme color specified, or -1 on failure. If the low bit of flags is set, the color as originally specified by the theme (before any transformations) is returned, otherwise the current (possibly transformed and modified) color is returned. See SetThemeColor for a list of valid ini_key.
---@param ini_key string
---@param flags integer?
---@return integer rv
function reaper.GetThemeColor(ini_key, flags) end

---Hit tests a point in screen coordinates. Updates infoOut with information such as "arrange", "fx_chain", "fx_0" (first FX in chain, floating), "spacer_0" (spacer before first track). If a track panel is hit, string will begin with "tcp" or "mcp" or "tcp.mute" etc (future versions may append additional information). May return NULL with valid info string to indicate non-track thing.
---@param screen_x integer
---@param screen_y integer
---@return MediaTrack rv
---@return string info
function reaper.GetThingFromPoint(screen_x, screen_y) end

---See GetToggleCommandStateEx.
---@param command_id integer
---@return integer rv
function reaper.GetToggleCommandState(command_id) end

---For the main action context, the MIDI editor, or the media explorer, returns the toggle state of the action. 0=off, 1=on, -1=NA because the action does not have on/off states. For the MIDI editor, the action state for the most recently focused window will be returned.
---@param section_id integer
---@param command_id integer
---@return integer rv
function reaper.GetToggleCommandStateEx(section_id, command_id) end

---gets a tooltip window,in case you want to ask it for font information. Can return NULL.
---@return HWND rv
function reaper.GetTooltipWindow() end

---mode can be 0 to query last touched parameter, or 1 to query currently focused FX. Returns false if failed. If successful, trackIdxOut will be track index (-1 is master track, 0 is first track). itemidxOut will be 0-based item index if an item, or -1 if not an item. takeidxOut will be 0-based take index. fxidxOut will be FX index, potentially with 0x2000000 set to signify container-addressing, or with 0x1000000 set to signify record-input FX. parmOut will be set to the parameter index if querying last-touched. parmOut will have 1 set if querying focused state and FX is no longer focused but still open.
---@param mode integer
---@return boolean rv
---@return integer trackidx
---@return integer itemidx
---@return integer takeidx
---@return integer fxidx
---@return integer parm
function reaper.GetTouchedOrFocusedFX(mode) end

---get a track from a project by track count (zero-based) (proj=0 for active project)
---@param proj ReaProject|nil|0
---@param trackidx integer
---@return MediaTrack rv
function reaper.GetTrack(proj, trackidx) end

---return the track mode, regardless of global override
---@param tr MediaTrack
---@return integer rv
function reaper.GetTrackAutomationMode(tr) end

---Returns the track custom color as OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). Black is returned as 0x1000000, no color setting is returned as 0.
---@param track MediaTrack
---@return integer rv
function reaper.GetTrackColor(track) end

---@param track MediaTrack
---@return integer rv
function reaper.GetTrackDepth(track) end

---@param track MediaTrack
---@param envidx integer
---@return TrackEnvelope rv
function reaper.GetTrackEnvelope(track, envidx) end

---Gets a built-in track envelope by configuration chunk name, like "<VOLENV", or GUID string, like "{B577250D-146F-B544-9B34-F24FBE488F1F}".
---@param tr MediaTrack
---@param cfgchunkname_or_guid string
---@return TrackEnvelope rv
function reaper.GetTrackEnvelopeByChunkName(tr, cfgchunkname_or_guid) end

---@param track MediaTrack
---@param envname string
---@return TrackEnvelope rv
function reaper.GetTrackEnvelopeByName(track, envname) end

---Returns the track from the screen coordinates specified. If the screen coordinates refer to a window associated to the track (such as FX), the track will be returned. infoOutOptional will be set to 1 if it is likely an envelope, 2 if it is likely a track FX. For a free item positioning or fixed lane track, the second byte of infoOutOptional will be set to the (approximate, for fipm tracks) item lane underneath the mouse. See GetThingFromPoint.
---@param screen_x integer
---@param screen_y integer
---@return MediaTrack rv
---@return integer? info
function reaper.GetTrackFromPoint(screen_x, screen_y) end

---@param tr MediaTrack
---@return string GUID
function reaper.GetTrackGUID(tr) end

---@param tr MediaTrack
---@param itemidx integer
---@return MediaItem rv
function reaper.GetTrackMediaItem(tr, itemidx) end

---Get all MIDI lyrics on the track. Lyrics will be returned as one string with tabs between each word. flag&1: double tabs at the end of each measure and triple tabs when skipping measures, flag&2: each lyric is preceded by its beat position in the project (example with flag=2: "1.1.2\tLyric for measure 1 beat 2\t2.1.1\tLyric for measure 2 beat 1	"). See SetTrackMIDILyrics
---@param track MediaTrack
---@param flag integer
---@return boolean rv
---@return string buf
function reaper.GetTrackMIDILyrics(track, flag) end

---see GetTrackMIDINoteNameEx
---@param track integer
---@param pitch integer
---@param chan integer
---@return string str
function reaper.GetTrackMIDINoteName(track, pitch, chan) end

---Get note/CC name. pitch 128 for CC0 name, 129 for CC1 name, etc. See SetTrackMIDINoteNameEx
---@param proj ReaProject|nil|0
---@param track MediaTrack
---@param pitch integer
---@param chan integer
---@return string str
function reaper.GetTrackMIDINoteNameEx(proj, track, pitch, chan) end

---@param proj ReaProject|nil|0
---@param track MediaTrack
---@return integer note_lo
---@return integer note_hi
function reaper.GetTrackMIDINoteRange(proj, track) end

---Returns "MASTER" for master track, "Track N" if track has no name.
---@param track MediaTrack
---@return boolean rv
---@return string buf
function reaper.GetTrackName(track) end

---@param tr MediaTrack
---@return integer rv
function reaper.GetTrackNumMediaItems(tr) end

---returns number of sends/receives/hardware outputs - category is <0 for receives, 0=sends, >0 for hardware outputs
---@param tr MediaTrack
---@param category integer
---@return integer rv
function reaper.GetTrackNumSends(tr, category) end

---See GetTrackSendName.
---@param track MediaTrack
---@param recv_index integer
---@return boolean rv
---@return string buf
function reaper.GetTrackReceiveName(track, recv_index) end

---See GetTrackSendUIMute.
---@param track MediaTrack
---@param recv_index integer
---@return boolean rv
---@return boolean mute
function reaper.GetTrackReceiveUIMute(track, recv_index) end

---See GetTrackSendUIVolPan.
---@param track MediaTrack
---@param recv_index integer
---@return boolean rv
---@return number volume
---@return number pan
function reaper.GetTrackReceiveUIVolPan(track, recv_index) end

---@alias GetTrackSendInfo_Value_Param
---| "'B_MUTE'" bool *
---| "'B_PHASE'" bool * : true to flip phase
---| "'B_MONO'" bool *
---| "'D_VOL'" double * : 1.0 = +0dB etc
---| "'D_PAN'" double * : -1..+1
---| "'D_PANLAW'" double * : 1.0=+0.0db, 0.5=-6dB, -1.0 = projdef etc
---| "'I_SENDMODE'" int * : 0=post-fader, 1=pre-fx, 2=post-fx (deprecated), 3=post-fx
---| "'I_AUTOMODE'" int * : automation mode (-1=use track automode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch)
---| "'I_SRCCHAN'" int * : -1 for no audio send. Low 10 bits specify channel offset, and higher bits specify channel count. (srcchan>>10) == 0 for stereo, 1 for mono, 2 for 4 channel, 3 for 6 channel, etc.
---| "'I_DSTCHAN'" int * : low 10 bits are destination index, &1024 set to mix to mono.
---| "'I_MIDIFLAGS'" int * : low 5 bits=source channel 0=all, 1-16, 31=MIDI send disabled, next 5 bits=dest channel, 0=orig, 1-16=chan. &1024 for faders-send MIDI vol/pan. (>>14)&255 = src bus (0 for all, 1 for normal, 2+). (>>22)&255=destination bus (0 for all, 1 for normal, 2+)
---| "'P_DESTTRACK'" MediaTrack * : destination track, only applies for sends/recvs (read-only)
---| "'P_SRCTRACK'" MediaTrack * : source track, only applies for sends/recvs (read-only)
---| "'P_ENV:<envchunkname'" TrackEnvelope * : call with :<VOLENV, :<PANENV, etc appended (read-only)

---Get send/receive/hardware output numerical-value attributes.
---category is <0 for receives, 0=sends, >0 for hardware outputs
---parameter names:
---B_MUTE : bool *
---B_PHASE : bool * : true to flip phase
---B_MONO : bool *
---D_VOL : double * : 1.0 = +0dB etc
---D_PAN : double * : -1..+1
---D_PANLAW : double * : 1.0=+0.0db, 0.5=-6dB, -1.0 = projdef etc
---I_SENDMODE : int * : 0=post-fader, 1=pre-fx, 2=post-fx (deprecated), 3=post-fx
---I_AUTOMODE : int * : automation mode (-1=use track automode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch)
---I_SRCCHAN : int * : -1 for no audio send. Low 10 bits specify channel offset, and higher bits specify channel count. (srcchan>>10) == 0 for stereo, 1 for mono, 2 for 4 channel, 3 for 6 channel, etc.
---I_DSTCHAN : int * : low 10 bits are destination index, &1024 set to mix to mono.
---I_MIDIFLAGS : int * : low 5 bits=source channel 0=all, 1-16, 31=MIDI send disabled, next 5 bits=dest channel, 0=orig, 1-16=chan. &1024 for faders-send MIDI vol/pan. (>>14)&255 = src bus (0 for all, 1 for normal, 2+). (>>22)&255=destination bus (0 for all, 1 for normal, 2+)
---P_DESTTRACK : MediaTrack * : destination track, only applies for sends/recvs (read-only)
---P_SRCTRACK : MediaTrack * : source track, only applies for sends/recvs (read-only)
---P_ENV:<envchunkname : TrackEnvelope * : call with :<VOLENV, :<PANENV, etc appended (read-only)
---See CreateTrackSend, RemoveTrackSend, GetTrackNumSends.
---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@param parmname GetTrackSendInfo_Value_Param
---@return number num
function reaper.GetTrackSendInfo_Value(tr, category, sendidx, parmname) end

---send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveName.
---@param track MediaTrack
---@param send_index integer
---@return boolean rv
---@return string buf
function reaper.GetTrackSendName(track, send_index) end

---send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveUIMute.
---@param track MediaTrack
---@param send_index integer
---@return boolean rv
---@return boolean mute
function reaper.GetTrackSendUIMute(track, send_index) end

---send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveUIVolPan.
---@param track MediaTrack
---@param send_index integer
---@return boolean rv
---@return number volume
---@return number pan
function reaper.GetTrackSendUIVolPan(track, send_index) end

---Gets track state, returns track name.
---flags will be set to:
---&1=folder
---&2=selected
---&4=has fx enabled
---&8=muted
---&16=soloed
---&32=SIP'd (with &16)
---&64=rec armed
---&128=rec monitoring on
---&256=rec monitoring auto
---&512=hide from TCP
---&1024=hide from MCP
---@param track MediaTrack
---@return string str
---@return integer flags
function reaper.GetTrackState(track) end

---Gets the RPPXML state of a track, returns true if successful. Undo flag is a performance/caching hint.
---@param track MediaTrack
---@param str string
---@param isundo boolean
---@return boolean rv
---@return string str
function reaper.GetTrackStateChunk(track, str, isundo) end

---@param track MediaTrack
---@return boolean rv
---@return boolean mute
function reaper.GetTrackUIMute(track) end

---@param track MediaTrack
---@return boolean rv
---@return number pan1
---@return number pan2
---@return integer panmode
function reaper.GetTrackUIPan(track) end

---@param track MediaTrack
---@return boolean rv
---@return number volume
---@return number pan
function reaper.GetTrackUIVolPan(track) end

---retrieves the last timestamps of audio xrun (yellow-flash, if available), media xrun (red-flash), and the current time stamp (all milliseconds)
---@return integer audio_xrun
---@return integer media_xrun
---@return integer curtime
function reaper.GetUnderrunTime() end

---returns true if the user selected a valid file, false if the user canceled the dialog
---@param filenameNeed4096 string
---@param title string
---@param defext string
---@return boolean rv
---@return string filenameNeed4096
function reaper.GetUserFileNameForRead(filenameNeed4096, title, defext) end

---Get values from the user.
---If a caption begins with *, for example "*password", the edit field will not display the input text.
---Maximum fields is 16. Values are returned as a comma-separated string. Returns false if the user canceled the dialog. You can supply special extra information via additional caption fields: extrawidth=XXX to increase text field width, separator=X to use a different separator for returned fields.
---@param title string
---@param num_inputs integer
---@param captions_csv string
---@param retvals_csv string
---@return boolean rv
---@return string retvals_csv
function reaper.GetUserInputs(title, num_inputs, captions_csv, retvals_csv) end

---Go to marker. If use_timeline_order==true, marker_index 1 refers to the first marker on the timeline.  If use_timeline_order==false, marker_index 1 refers to the first marker with the user-editable index of 1.
---@param proj ReaProject|nil|0
---@param marker_index integer
---@param use_timeline_order boolean
function reaper.GoToMarker(proj, marker_index, use_timeline_order) end

---Seek to region after current region finishes playing (smooth seek). If use_timeline_order==true, region_index 1 refers to the first region on the timeline.  If use_timeline_order==false, region_index 1 refers to the first region with the user-editable index of 1.
---@param proj ReaProject|nil|0
---@param region_index integer
---@param use_timeline_order boolean
function reaper.GoToRegion(proj, region_index, use_timeline_order) end

---Runs the system color chooser dialog.  Returns 0 if the user cancels the dialog.
---@param hwnd HWND
---@return integer rv
---@return integer color
function reaper.GR_SelectColor(hwnd) end

---this is just like win32 GetSysColor() but can have overrides.
---@param t integer
---@return integer rv
function reaper.GSC_mainwnd(t) end

---dest should be at least 64 chars long to be safe
---@param gGUID string
---@param destNeed64 string
---@return string destNeed64
function reaper.guidToString(gGUID, destNeed64) end

---Returns true if there exists an extended state value for a specific section and key. See SetExtState, GetExtState, DeleteExtState.
---@param section string
---@param key string
---@return boolean rv
function reaper.HasExtState(section, key) end

---returns name of track plugin that is supplying MIDI programs,or NULL if there is none
---@param track integer
---@return string str
function reaper.HasTrackMIDIPrograms(track) end

---returns name of track plugin that is supplying MIDI programs,or NULL if there is none
---@param proj ReaProject|nil|0
---@param track MediaTrack
---@return string str
function reaper.HasTrackMIDIProgramsEx(proj, track) end

---@param helpstring string
---@param is_temporary_help boolean
function reaper.Help_Set(helpstring, is_temporary_help) end

---@param in string
---@param out string
---@return string out
function reaper.image_resolve_fn(in, out) end

---Insert a new automation item. pool_id < 0 collects existing envelope points into the automation item; if pool_id is >= 0 the automation item will be a new instance of that pool (which will be created as an empty instance if it does not exist). Returns the index of the item, suitable for passing to other automation item API functions. See GetSetAutomationItemInfo.
---@param env TrackEnvelope
---@param pool_id integer
---@param position number
---@param length number
---@return integer rv
function reaper.InsertAutomationItem(env, pool_id, position, length) end

---Insert an envelope point. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. See InsertEnvelopePointEx.
---@param envelope TrackEnvelope
---@param time number
---@param value number
---@param shape integer
---@param tension number
---@param selected boolean
---@param noSortIn boolean?
---@return boolean rv
function reaper.InsertEnvelopePoint(envelope, time, value, shape, tension, selected, noSortIn) end

---Insert an envelope point. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done.
---autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration,
---even if the automation item is trimmed so that not all points are visible.
---Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations.
---See CountEnvelopePointsEx, GetEnvelopePointEx, SetEnvelopePointEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param time number
---@param value number
---@param shape integer
---@param tension number
---@param selected boolean
---@param noSortIn boolean?
---@return boolean rv
function reaper.InsertEnvelopePointEx(envelope, autoitem_idx, time, value, shape, tension, selected, noSortIn) end

---mode: 0=add to current track, 1=add new track, 3=add to selected items as takes, &4=stretch/loop to fit time sel, &8=try to match tempo 1x, &16=try to match tempo 0.5x, &32=try to match tempo 2x, &64=don't preserve pitch when matching tempo, &128=no loop/section if startpct/endpct set, &256=force loop regardless of global preference for looping imported items, &512=use high word as absolute track index if mode&3==0 or mode&2048, &1024=insert into reasamplomatic on a new track (add 1 to insert on last selected track), &2048=insert into open reasamplomatic instance (add 512 to use high word as absolute track index), &4096=move to source preferred position (BWF start offset), &8192=reverse. &16384=apply ripple according to project setting
---@param file string
---@param mode integer
---@return integer rv
function reaper.InsertMedia(file, mode) end

---See InsertMedia.
---@param file string
---@param mode integer
---@param startpct number
---@param endpct number
---@param pitchshift number
---@return integer rv
function reaper.InsertMediaSection(file, mode, startpct, endpct, pitchshift) end

---inserts a track at idx,of course this will be clamped to 0..GetNumTracks(). wantDefaults=TRUE for default envelopes/FX,otherwise no enabled fx/env. Superseded, see InsertTrackInProject
---@param idx integer
---@param wantDefaults boolean
function reaper.InsertTrackAtIndex(idx, wantDefaults) end

---inserts a track in project proj at idx, this will be clamped to 0..CountTracks(proj). flags&1 for default envelopes/FX, otherwise no enabled fx/envelopes will be added.
---@param proj ReaProject|nil|0
---@param idx integer
---@param flags integer
function reaper.InsertTrackInProject(proj, idx, flags) end

---Tests a file extension (i.e. "wav" or "mid") to see if it's a media extension.
---If wantOthers is set, then "RPP", "TXT" and other project-type formats will also pass.
---@param ext string
---@param wantOthers boolean
---@return boolean rv
function reaper.IsMediaExtension(ext, wantOthers) end

---@param item MediaItem
---@return boolean rv
function reaper.IsMediaItemSelected(item) end

---Is the project dirty (needing save)? Always returns 0 if 'undo/prompt to save' is disabled in preferences.
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.IsProjectDirty(proj) end

---@param track MediaTrack
---@return boolean rv
function reaper.IsTrackSelected(track) end

---If mixer==true, returns true if the track is visible in the mixer.  If mixer==false, returns true if the track is visible in the track control panel.
---@param track MediaTrack
---@param mixer boolean
---@return boolean rv
function reaper.IsTrackVisible(track, mixer) end

---creates a joystick device
---@param guidGUID string
---@return joystick_device rv
function reaper.joystick_create(guidGUID) end

---destroys a joystick device
---@param device joystick_device
function reaper.joystick_destroy(device) end

---enumerates installed devices, returns GUID as a string
---@param index integer
---@return string str
---@return string? namestr
function reaper.joystick_enum(index) end

---returns axis value (-1..1)
---@param dev joystick_device
---@param axis integer
---@return number num
function reaper.joystick_getaxis(dev, axis) end

---returns button pressed mask, 1=first button, 2=second...
---@param dev joystick_device
---@return integer rv
function reaper.joystick_getbuttonmask(dev) end

---returns button count
---@param dev joystick_device
---@return integer rv
---@return integer? axes
---@return integer? povs
function reaper.joystick_getinfo(dev) end

---returns POV value (usually 0..655.35, or 655.35 on error)
---@param dev joystick_device
---@param pov integer
---@return number num
function reaper.joystick_getpov(dev, pov) end

---Updates joystick state from hardware, returns true if successful (joystick_get* will not be valid until joystick_update() is called successfully)
---@param dev joystick_device
---@return boolean rv
function reaper.joystick_update(dev) end

---@param section KbdSectionInfo|integer
---@param idx integer
---@return integer rv
---@return string name
function reaper.kbd_enumerateActions(section, idx) end

---@param cmd integer
---@param section KbdSectionInfo|integer
---@return string str
function reaper.kbd_getTextFromCmd(cmd, section) end

---Returns false if the line is entirely offscreen.
---@param pX1 integer
---@param pY1 integer
---@param pX2 integer
---@param pY2 integer
---@param xLo integer
---@param yLo integer
---@param xHi integer
---@param yHi integer
---@return boolean rv
---@return integer pX1
---@return integer pY1
---@return integer pX2
---@return integer pY2
function reaper.LICE_ClipLine(pX1, pY1, pX2, pY2, xLo, yLo, xHi, yHi) end

---Returns a localized version of src_string, in section section. flags can have 1 set to only localize if sprintf-style formatting matches the original.
---@param src_string string
---@param section string
---@param flags integer?
---@return string str
function reaper.LocalizeString(src_string, section, flags) end

---Move the loop selection left or right. Returns true if snap is enabled.
---@param project ReaProject|nil|0
---@param direction integer
---@return boolean rv
function reaper.Loop_OnArrow(project, direction) end

---See Main_OnCommandEx.
---@param command integer
---@param flag integer
function reaper.Main_OnCommand(command, flag) end

---Performs an action belonging to the main action section. To perform non-native actions (ReaScripts, custom or extension plugins' actions) safely, see NamedCommandLookup().
---@param command integer
---@param flag integer
---@param proj ReaProject|nil|0
function reaper.Main_OnCommandEx(command, flag, proj) end

---opens a project. will prompt the user to save unless name is prefixed with 'noprompt:'. If name is prefixed with 'template:', project file will be loaded as a template.
---If passed a .RTrackTemplate file, adds the template to the existing project.
---@param name string
function reaper.Main_openProject(name) end

---Save the project.
---@param proj ReaProject|nil|0
---@param forceSaveAsIn boolean
function reaper.Main_SaveProject(proj, forceSaveAsIn) end

---Save the project. options: &1=save selected tracks as track template, &2=include media with track template, &4=include envelopes with track template, &8=if not saving template, set as the new project filename for this ReaProject. See Main_openProject, Main_SaveProject.
---@param proj ReaProject|nil|0
---@param filename string
---@param options integer
function reaper.Main_SaveProjectEx(proj, filename, options) end

---@param ignoremask integer
function reaper.Main_UpdateLoopInfo(ignoremask) end

---Marks project as dirty (needing save) if 'undo/prompt to save' is enabled in preferences.
---@param proj ReaProject|nil|0
function reaper.MarkProjectDirty(proj) end

---If track is supplied, item is ignored
---@param track MediaTrack
---@param item MediaItem
function reaper.MarkTrackItemsDirty(track, item) end

---@param project ReaProject|nil|0
---@return number num
function reaper.Master_GetPlayRate(project) end

---@param time_s number
---@param proj ReaProject|nil|0
---@return number num
function reaper.Master_GetPlayRateAtTime(time_s, proj) end

---@return number num
function reaper.Master_GetTempo() end

---Convert play rate to/from a value between 0 and 1, representing the position on the project playrate slider.
---@param playrate number
---@param isnormalized boolean
---@return number num
function reaper.Master_NormalizePlayRate(playrate, isnormalized) end

---Convert the tempo to/from a value between 0 and 1, representing bpm in the range of 40-296 bpm.
---@param bpm number
---@param isnormalized boolean
---@return number num
function reaper.Master_NormalizeTempo(bpm, isnormalized) end

---type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL : ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
---@param msg string
---@param title string
---@param type integer
---@return integer rv
function reaper.MB(msg, title, type) end

---Get information about the most recently previewed Media Explorer file. filename: last played file name. filemode: &1:insert on new track, &2:insert into sampler, &8:tempo sync 1x, &16:tempo sync 0.5x, &32:tempo sync 2x, &64:do not preserve pitch when changing playrate, &128:loop selection exists, &256:time selection exists, &512:apply pitch/rate adjustment on insert, &1024:apply volume adjustment on insert, &2048:apply normalization on insert, &8192:reverse preview. startpct/endpct: time selection in [0.0, 1.0]. pitchshift/voladj/rateadj: current pitch/volume/playrate preview adjustments. srcbpm: source media tempo. extrainfo: currently unused.
---@return boolean rv
---@return string filename
---@return integer filemode
---@return number selstart
---@return number selend
---@return number pitchshift
---@return number voladj
---@return number rateadj
---@return number sourcebpm
---@return string extrainfo
function reaper.MediaExplorerGetLastPlayedFileInfo() end

---Returns 1 if the track holds the item, 2 if the track is a folder containing the track that holds the item, etc.
---@param item MediaItem
---@param track MediaTrack
---@return integer rv
function reaper.MediaItemDescendsFromTrack(item, track) end

---Get a string that only changes when menu/toolbar entries are added or removed (not re-ordered). Can be used to determine if a customized menu/toolbar differs from the default, or if the default changed after a menu/toolbar was customized. flag==0: current default menu/toolbar; flag==1: current customized menu/toolbar; flag==2: default menu/toolbar at the time the current menu/toolbar was most recently customized, if it was customized in REAPER v7.08 or later.
---@param menuname string
---@param flag integer
---@return boolean rv
---@return string hash
function reaper.Menu_GetHash(menuname, flag) end

---Count the number of notes, CC events, and text/sysex events in a given MIDI item.
---@param take MediaItem_Take
---@return integer rv
---@return integer notecnt
---@return integer ccevtcnt
---@return integer textsyxevtcnt
function reaper.MIDI_CountEvts(take) end

---Delete a MIDI CC event.
---@param take MediaItem_Take
---@param ccidx integer
---@return boolean rv
function reaper.MIDI_DeleteCC(take, ccidx) end

---Delete a MIDI event.
---@param take MediaItem_Take
---@param evtidx integer
---@return boolean rv
function reaper.MIDI_DeleteEvt(take, evtidx) end

---Delete a MIDI note.
---@param take MediaItem_Take
---@param noteidx integer
---@return boolean rv
function reaper.MIDI_DeleteNote(take, noteidx) end

---Delete a MIDI text or sysex event.
---@param take MediaItem_Take
---@param textsyxevtidx integer
---@return boolean rv
function reaper.MIDI_DeleteTextSysexEvt(take, textsyxevtidx) end

---Disable sorting for all MIDI insert, delete, get and set functions, until MIDI_Sort is called.
---@param take MediaItem_Take
function reaper.MIDI_DisableSort(take) end

---Returns the index of the next selected MIDI CC event after ccidx (-1 if there are no more selected events).
---@param take MediaItem_Take
---@param ccidx integer
---@return integer rv
function reaper.MIDI_EnumSelCC(take, ccidx) end

---Returns the index of the next selected MIDI event after evtidx (-1 if there are no more selected events).
---@param take MediaItem_Take
---@param evtidx integer
---@return integer rv
function reaper.MIDI_EnumSelEvts(take, evtidx) end

---Returns the index of the next selected MIDI note after noteidx (-1 if there are no more selected events).
---@param take MediaItem_Take
---@param noteidx integer
---@return integer rv
function reaper.MIDI_EnumSelNotes(take, noteidx) end

---Returns the index of the next selected MIDI text/sysex event after textsyxidx (-1 if there are no more selected events).
---@param take MediaItem_Take
---@param textsyxidx integer
---@return integer rv
function reaper.MIDI_EnumSelTextSysexEvts(take, textsyxidx) end

---Get all MIDI data. MIDI buffer is returned as a list of { int offset, char flag, int msglen, unsigned char msg[] }.
---offset: MIDI ticks from previous event
---flag: &1=selected &2=muted
---flag high 4 bits for CC shape: &16=linear, &32=slow start/end, &16|32=fast start, &64=fast end, &64|16=bezier
---msg: the MIDI message.
---A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier curve data for the previous MIDI event: 1 byte for the bezier type (usually 0) and 4 bytes for the bezier tension as a float.
---For tick intervals longer than a 32 bit word can represent, zero-length meta events may be placed between valid events.
---See MIDI_SetAllEvts.
---@param take MediaItem_Take
---@return boolean rv
---@return string buf
function reaper.MIDI_GetAllEvts(take) end

---Get MIDI CC event properties.
---@param take MediaItem_Take
---@param ccidx integer
---@return boolean rv
---@return boolean selected
---@return boolean muted
---@return number ppqpos
---@return integer chanmsg
---@return integer chan
---@return integer msg2
---@return integer msg3
function reaper.MIDI_GetCC(take, ccidx) end

---Get CC shape and bezier tension. See MIDI_GetCC, MIDI_SetCCShape
---@param take MediaItem_Take
---@param ccidx integer
---@return boolean rv
---@return integer shape
---@return number beztension
function reaper.MIDI_GetCCShape(take, ccidx) end

---Get MIDI event properties.
---@param take MediaItem_Take
---@param evtidx integer
---@return boolean rv
---@return boolean selected
---@return boolean muted
---@return number ppqpos
---@return string msg
function reaper.MIDI_GetEvt(take, evtidx) end

---Returns the most recent MIDI editor grid size for this MIDI take, in QN. Swing is between 0 and 1. Note length is 0 if it follows the grid size.
---@param take MediaItem_Take
---@return number num
---@return number? swing
---@return number? noteLen
function reaper.MIDI_GetGrid(take) end

---Get a string that only changes when the MIDI data changes. If notesonly==true, then the string changes only when the MIDI notes change. See MIDI_GetTrackHash
---@param take MediaItem_Take
---@param notesonly boolean
---@return boolean rv
---@return string hash
function reaper.MIDI_GetHash(take, notesonly) end

---Get MIDI note properties.
---@param take MediaItem_Take
---@param noteidx integer
---@return boolean rv
---@return boolean selected
---@return boolean muted
---@return number startppqpos
---@return number endppqpos
---@return integer chan
---@return integer pitch
---@return integer vel
function reaper.MIDI_GetNote(take, noteidx) end

---Returns the MIDI tick (ppq) position corresponding to the end of the measure.
---@param take MediaItem_Take
---@param ppqpos number
---@return number num
function reaper.MIDI_GetPPQPos_EndOfMeasure(take, ppqpos) end

---Returns the MIDI tick (ppq) position corresponding to the start of the measure.
---@param take MediaItem_Take
---@param ppqpos number
---@return number num
function reaper.MIDI_GetPPQPos_StartOfMeasure(take, ppqpos) end

---Returns the MIDI tick (ppq) position corresponding to a specific project time in quarter notes.
---@param take MediaItem_Take
---@param projqn number
---@return number num
function reaper.MIDI_GetPPQPosFromProjQN(take, projqn) end

---Returns the MIDI tick (ppq) position corresponding to a specific project time in seconds.
---@param take MediaItem_Take
---@param projtime number
---@return number num
function reaper.MIDI_GetPPQPosFromProjTime(take, projtime) end

---Returns the project time in quarter notes corresponding to a specific MIDI tick (ppq) position.
---@param take MediaItem_Take
---@param ppqpos number
---@return number num
function reaper.MIDI_GetProjQNFromPPQPos(take, ppqpos) end

---Returns the project time in seconds corresponding to a specific MIDI tick (ppq) position.
---@param take MediaItem_Take
---@param ppqpos number
---@return number num
function reaper.MIDI_GetProjTimeFromPPQPos(take, ppqpos) end

---Gets a recent MIDI input event from the global history. idx=0 for the most recent event, which also latches to the latest MIDI event state (to get a more recent list, calling with idx=0 is necessary). idx=1 next most recent event, returns a non-zero sequence number for the event, or zero if no more events. tsOut will be set to the timestamp in samples relative to the current position (0 is current, -48000 is one second ago, etc). devIdxOut will have the low 16 bits set to the input device index, and 0x10000 will be set if device was enabled only for control. projPosOut will be set to project position in seconds if project was playing back at time of event, otherwise -1. Large SysEx events will not be included in this event list.
---@param idx integer
---@return integer rv
---@return string buf
---@return integer ts
---@return integer devIdx
---@return number projPos
---@return integer projLoopCnt
function reaper.MIDI_GetRecentInputEvent(idx) end

---Get the active scale in the media source, if any. root 0=C, 1=C#, etc. scale &0x1=root, &0x2=minor 2nd, &0x4=major 2nd, &0x8=minor 3rd, &0xF=fourth, etc.
---@param take MediaItem_Take
---@return boolean rv
---@return integer root
---@return integer scale
---@return string name
function reaper.MIDI_GetScale(take) end

---Get MIDI meta-event properties. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event. For all other meta-messages, type is returned as -2 and msg returned as all zeroes. See MIDI_GetEvt.
---@param take MediaItem_Take
---@param textsyxevtidx integer
---@param selected boolean?
---@param muted boolean?
---@param ppqpos number?
---@param type integer?
---@param msg string?
---@return boolean rv
---@return boolean? selected
---@return boolean? muted
---@return number? ppqpos
---@return integer? type
---@return string? msg
function reaper.MIDI_GetTextSysexEvt(take, textsyxevtidx, selected, muted, ppqpos, type, msg) end

---Get a string that only changes when the MIDI data changes. If notesonly==true, then the string changes only when the MIDI notes change. See MIDI_GetHash
---@param track MediaTrack
---@param notesonly boolean
---@return boolean rv
---@return string hash
function reaper.MIDI_GetTrackHash(track, notesonly) end

---Opens MIDI devices as configured in preferences. force_reinit_input and force_reinit_output force a particular device index to close/re-open (pass -1 to not force any devices to reopen).
---@param force_reinit_input integer
---@param force_reinit_output integer
function reaper.midi_init(force_reinit_input, force_reinit_output) end

---Insert a new MIDI CC event.
---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param ppqpos number
---@param chanmsg integer
---@param chan integer
---@param msg2 integer
---@param msg3 integer
---@return boolean rv
function reaper.MIDI_InsertCC(take, selected, muted, ppqpos, chanmsg, chan, msg2, msg3) end

---Insert a new MIDI event.
---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param ppqpos number
---@param bytestr string
---@return boolean rv
function reaper.MIDI_InsertEvt(take, selected, muted, ppqpos, bytestr) end

---Insert a new MIDI note. Set noSort if inserting multiple events, then call MIDI_Sort when done.
---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param startppqpos number
---@param endppqpos number
---@param chan integer
---@param pitch integer
---@param vel integer
---@param noSortIn boolean?
---@return boolean rv
function reaper.MIDI_InsertNote(take, selected, muted, startppqpos, endppqpos, chan, pitch, vel, noSortIn) end

---Insert a new MIDI text or sysex event. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event.
---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param ppqpos number
---@param type integer
---@param bytestr string
---@return boolean rv
function reaper.MIDI_InsertTextSysexEvt(take, selected, muted, ppqpos, type, bytestr) end

---Synchronously updates any open MIDI editors for MIDI take
---@param tk MediaItem_Take
function reaper.MIDI_RefreshEditors(tk) end

---Reset (close and re-open) all MIDI devices
function reaper.midi_reinit() end

---Select or deselect all MIDI content.
---@param take MediaItem_Take
---@param select boolean
function reaper.MIDI_SelectAll(take, select) end

---Set all MIDI data. MIDI buffer is passed in as a list of { int offset, char flag, int msglen, unsigned char msg[] }.
---offset: MIDI ticks from previous event
---flag: &1=selected &2=muted
---flag high 4 bits for CC shape: &16=linear, &32=slow start/end, &16|32=fast start, &64=fast end, &64|16=bezier
---msg: the MIDI message.
---A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier curve data for the previous MIDI event: 1 byte for the bezier type (usually 0) and 4 bytes for the bezier tension as a float.
---For tick intervals longer than a 32 bit word can represent, zero-length meta events may be placed between valid events.
---See MIDI_GetAllEvts.
---@param take MediaItem_Take
---@param buf string
---@return boolean rv
function reaper.MIDI_SetAllEvts(take, buf) end

---Set MIDI CC event properties. Properties passed as NULL will not be set. set noSort if setting multiple events, then call MIDI_Sort when done.
---@param take MediaItem_Take
---@param ccidx integer
---@param selectedIn boolean?
---@param mutedIn boolean?
---@param ppqposIn number?
---@param chanmsgIn integer?
---@param chanIn integer?
---@param msg2In integer?
---@param msg3In integer?
---@param noSortIn boolean?
---@return boolean rv
function reaper.MIDI_SetCC(take, ccidx, selectedIn, mutedIn, ppqposIn, chanmsgIn, chanIn, msg2In, msg3In, noSortIn) end

---Set CC shape and bezier tension. set noSort if setting multiple events, then call MIDI_Sort when done. See MIDI_SetCC, MIDI_GetCCShape
---@param take MediaItem_Take
---@param ccidx integer
---@param shape integer
---@param beztension number
---@param noSortIn boolean?
---@return boolean rv
function reaper.MIDI_SetCCShape(take, ccidx, shape, beztension, noSortIn) end

---Set MIDI event properties. Properties passed as NULL will not be set.  set noSort if setting multiple events, then call MIDI_Sort when done.
---@param take MediaItem_Take
---@param evtidx integer
---@param selectedIn boolean?
---@param mutedIn boolean?
---@param ppqposIn number?
---@param msg string?
---@param noSortIn boolean?
---@return boolean rv
function reaper.MIDI_SetEvt(take, evtidx, selectedIn, mutedIn, ppqposIn, msg, noSortIn) end

---Set the start/end positions of a media item that contains a MIDI take.
---@param item MediaItem
---@param startQN number
---@param endQN number
---@return boolean rv
function reaper.MIDI_SetItemExtents(item, startQN, endQN) end

---Set MIDI note properties. Properties passed as NULL (or negative values) will not be set. Set noSort if setting multiple events, then call MIDI_Sort when done. Setting multiple note start positions at once is done more safely by deleting and re-inserting the notes.
---@param take MediaItem_Take
---@param noteidx integer
---@param selectedIn boolean?
---@param mutedIn boolean?
---@param startppqposIn number?
---@param endppqposIn number?
---@param chanIn integer?
---@param pitchIn integer?
---@param velIn integer?
---@param noSortIn boolean?
---@return boolean rv
function reaper.MIDI_SetNote(take, noteidx, selectedIn, mutedIn, startppqposIn, endppqposIn, chanIn, pitchIn, velIn, noSortIn) end

---Set MIDI text or sysex event properties. Properties passed as NULL will not be set. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event. set noSort if setting multiple events, then call MIDI_Sort when done.
---@param take MediaItem_Take
---@param textsyxevtidx integer
---@param selectedIn boolean?
---@param mutedIn boolean?
---@param ppqposIn number?
---@param typeIn integer?
---@param msg string?
---@param noSortIn boolean?
---@return boolean rv
function reaper.MIDI_SetTextSysexEvt(take, textsyxevtidx, selectedIn, mutedIn, ppqposIn, typeIn, msg, noSortIn) end

---Sort MIDI events after multiple calls to MIDI_SetNote, MIDI_SetCC, etc.
---@param take MediaItem_Take
function reaper.MIDI_Sort(take) end

---list the takes that are currently being edited in this MIDI editor, starting with the active take. See MIDIEditor_GetTake
---@param midieditor HWND
---@param takeindex integer
---@param editable_only boolean
---@return MediaItem_Take rv
function reaper.MIDIEditor_EnumTakes(midieditor, takeindex, editable_only) end

---get a pointer to the focused MIDI editor window
---see MIDIEditor_GetMode, MIDIEditor_OnCommand
---@return HWND rv
function reaper.MIDIEditor_GetActive() end

---get the mode of a MIDI editor (0=piano roll, 1=event list, -1=invalid editor)
---see MIDIEditor_GetActive, MIDIEditor_OnCommand
---@param midieditor HWND
---@return integer rv
function reaper.MIDIEditor_GetMode(midieditor) end

---Get settings from a MIDI editor. setting_desc can be:
---snap_enabled: returns 0 or 1
---active_note_row: returns 0-127
---last_clicked_cc_lane: returns 0-127=CC, 0x100|(0-31)=14-bit CC, 0x200=velocity, 0x201=pitch, 0x202=program, 0x203=channel pressure, 0x204=bank/program select, 0x205=text, 0x206=sysex, 0x207=off velocity, 0x208=notation events, 0x209=aftertouch, 0x210=media item lane
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
---@return integer rv
function reaper.MIDIEditor_GetSetting_int(midieditor, setting_desc) end

---Get settings from a MIDI editor. setting_desc can be:
---last_clicked_cc_lane: returns text description ("velocity", "pitch", etc)
---scale: returns the scale record, for example "102034050607" for a major scale
---list_X: if viewing list view, returns string describing event at row X (0-based). String will have a list of key=value pairs, e.g. 'pos=4.0 len=4.0 offvel=127 msg=90317F'. pos/len times are in QN, len/offvel may not be present if event is not a note. other keys which may be present include pos_pq/len_pq, sel, mute, ccval14, ccshape, ccbeztension.
---if setting_desc is unsupported, the function returns false.
---See MIDIEditor_GetActive, MIDIEditor_GetSetting_int
---@param midieditor HWND
---@param setting_desc string
---@return boolean rv
---@return string buf
function reaper.MIDIEditor_GetSetting_str(midieditor, setting_desc) end

---get the take that is currently being edited in this MIDI editor. see MIDIEditor_EnumTakes
---@param midieditor HWND
---@return MediaItem_Take rv
function reaper.MIDIEditor_GetTake(midieditor) end

---Send an action command to the last focused MIDI editor. Returns false if there is no MIDI editor open, or if the view mode (piano roll or event list) does not match the input.
---see MIDIEditor_OnCommand
---@param command_id integer
---@param islistviewcommand boolean
---@return boolean rv
function reaper.MIDIEditor_LastFocused_OnCommand(command_id, islistviewcommand) end

---Send an action command to a MIDI editor. Returns false if the supplied MIDI editor pointer is not valid (not an open MIDI editor).
---see MIDIEditor_GetActive, MIDIEditor_LastFocused_OnCommand
---@param midieditor HWND
---@param command_id integer
---@return boolean rv
function reaper.MIDIEditor_OnCommand(midieditor, command_id) end

---Set settings for a MIDI editor. setting_desc can be:
---active_note_row: 0-127
---See MIDIEditor_GetSetting_int
---@param midieditor HWND
---@param setting_desc string
---@param setting integer
---@return boolean rv
function reaper.MIDIEditor_SetSetting_int(midieditor, setting_desc, setting) end

---Get or set MIDI editor settings for this track. pitchwheelrange: semitones up or down. flags &1: snap pitch lane edits to semitones if pitchwheel range is defined.
---@param track MediaTrack
---@param pitchwheelrange integer
---@param flags integer
---@param is_set boolean
---@return integer pitchwheelrange
---@return integer flags
function reaper.MIDIEditorFlagsForTrack(track, pitchwheelrange, flags, is_set) end

---@param strNeed64 string
---@param pan number
---@return string strNeed64
function reaper.mkpanstr(strNeed64, pan) end

---@param strNeed64 string
---@param vol number
---@param pan number
---@return string strNeed64
function reaper.mkvolpanstr(strNeed64, vol, pan) end

---@param strNeed64 string
---@param vol number
---@return string strNeed64
function reaper.mkvolstr(strNeed64, vol) end

---@param adjamt number
---@param dosel boolean
function reaper.MoveEditCursor(adjamt, dosel) end

---returns TRUE if move succeeded
---@param item MediaItem
---@param desttr MediaTrack
---@return boolean rv
function reaper.MoveMediaItemToTrack(item, desttr) end

---@param mute boolean
function reaper.MuteAllTracks(mute) end

---@param r_left integer
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
function reaper.my_getViewport(r_left, r_top, r_right, r_bot, sr_left, sr_top, sr_right, sr_bot, wantWorkArea) end

---Get the command ID number for named command that was registered by an extension such as "_SWS_ABOUT" or "_113088d11ae641c193a2b7ede3041ad5" for a ReaScript or a custom action.
---@param command_name string
---@return integer rv
function reaper.NamedCommandLookup(command_name) end

---direct way to simulate pause button hit
function reaper.OnPauseButton() end

---direct way to simulate pause button hit
---@param proj ReaProject|nil|0
function reaper.OnPauseButtonEx(proj) end

---direct way to simulate play button hit
function reaper.OnPlayButton() end

---direct way to simulate play button hit
---@param proj ReaProject|nil|0
function reaper.OnPlayButtonEx(proj) end

---direct way to simulate stop button hit
function reaper.OnStopButton() end

---direct way to simulate stop button hit
---@param proj ReaProject|nil|0
function reaper.OnStopButtonEx(proj) end

---@param fn string
---@return boolean rv
function reaper.OpenColorThemeFile(fn) end

---Opens mediafn in the Media Explorer, play=true will play the file immediately (or toggle playback if mediafn was already open), =false will just select it.
---@param mediafn string
---@param play boolean
---@return HWND rv
function reaper.OpenMediaExplorer(mediafn, play) end

---Send an OSC message directly to REAPER. The value argument may be NULL. The message will be matched against the default OSC patterns.
---@param message string
---@param valueIn number?
function reaper.OscLocalMessageToHost(message, valueIn) end

---Parse hh:mm:ss.sss time string, return time in seconds (or 0.0 on error). See parse_timestr_pos, parse_timestr_len.
---@param buf string
---@return number num
function reaper.parse_timestr(buf) end

---time formatting mode overrides: -1=proj default.
---0=time
---1=measures.beats + time
---2=measures.beats
---3=seconds
---4=samples
---5=h:m:s:f
---@param buf string
---@param offset number
---@param modeoverride integer
---@return number num
function reaper.parse_timestr_len(buf, offset, modeoverride) end

---Parse time string, time formatting mode overrides: -1=proj default.
---0=time
---1=measures.beats + time
---2=measures.beats
---3=seconds
---4=samples
---5=h:m:s:f
---@param buf string
---@param modeoverride integer
---@return number num
function reaper.parse_timestr_pos(buf, modeoverride) end

---@param str string
---@return number num
function reaper.parsepanstr(str) end

---@param idx integer
---@return integer rv
---@return string descstr
function reaper.PCM_Sink_Enum(idx) end

---@param data string
---@return string str
function reaper.PCM_Sink_GetExtension(data) end

---@param cfg string
---@param hwndParent HWND
---@return HWND rv
function reaper.PCM_Sink_ShowConfig(cfg, hwndParent) end

---Calls and returns PCM_source::PeaksBuild_Begin() if mode=0, PeaksBuild_Run() if mode=1, and PeaksBuild_Finish() if mode=2. Normal use is to call PCM_Source_BuildPeaks(src,0), and if that returns nonzero, call PCM_Source_BuildPeaks(src,1) periodically until it returns zero (it returns the percentage of the file remaining), then call PCM_Source_BuildPeaks(src,2) to finalize. If PCM_Source_BuildPeaks(src,0) returns zero, then no further action is necessary.
---@param src PCM_source
---@param mode integer
---@return integer rv
function reaper.PCM_Source_BuildPeaks(src, mode) end

---See PCM_Source_CreateFromFileEx.
---@param filename string
---@return PCM_source rv
function reaper.PCM_Source_CreateFromFile(filename) end

---Create a PCM_source from filename, and override pref of MIDI files being imported as in-project MIDI events.
---@param filename string
---@param forcenoMidiImp boolean
---@return PCM_source rv
function reaper.PCM_Source_CreateFromFileEx(filename, forcenoMidiImp) end

---Create a PCM_source from a "type" (use this if you're going to load its state via LoadState/ProjectStateContext).
---Valid types include "WAVE", "MIDI", or whatever plug-ins define as well.
---@param sourcetype string
---@return PCM_source rv
function reaper.PCM_Source_CreateFromType(sourcetype) end

---Deletes a PCM_source -- be sure that you remove any project reference before deleting a source
---@param src PCM_source
function reaper.PCM_Source_Destroy(src) end

---Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.
---@param src PCM_source
---@param peakrate number
---@param starttime number
---@param numchannels integer
---@param numsamplesperchannel integer
---@param want_extra_type integer
---@param buf reaper.array
---@return integer rv
function reaper.PCM_Source_GetPeaks(src, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf) end

---If a section/reverse block, retrieves offset/len/reverse. return true if success
---@param src PCM_source
---@return boolean rv
---@return number offs
---@return number len
---@return boolean rev
function reaper.PCM_Source_GetSectionInfo(src) end

---@param amt integer
function reaper.PluginWantsAlwaysRunFx(amt) end

---adds prevent_count to the UI refresh prevention state; always add then remove the same amount, or major disfunction will occur
---@param prevent_count integer
function reaper.PreventUIRefresh(prevent_count) end

---Uses the action list to choose an action. Call with session_mode=1 to create a session (init_id will be the initial action to select, or 0), then poll with session_mode=0, checking return value for user-selected action (will return 0 if no action selected yet, or -1 if the action window is no longer available). When finished, call with session_mode=-1.
---@param session_mode integer
---@param init_id integer
---@param section_id integer
---@return integer rv
function reaper.PromptForAction(session_mode, init_id, section_id) end

---Causes REAPER to display the error message after the current ReaScript finishes. If called within a Lua context and errmsg has a ! prefix, script execution will be terminated.
---@param errmsg string
function reaper.ReaScriptError(errmsg) end

---returns positive value on success, 0 on failure.
---@param path string
---@param ignored integer
---@return integer rv
function reaper.RecursiveCreateDirectory(path, ignored) end

---garbage-collects extra open files and closes them. if flags has 1 set, this is done incrementally (call this from a regular timer, if desired). if flags has 2 set, files are aggressively closed (they may need to be re-opened very soon). returns number of files closed by this call.
---@param flags integer
---@return integer rv
function reaper.reduce_open_files(flags) end

---See RefreshToolbar2.
---@param command_id integer
function reaper.RefreshToolbar(command_id) end

---Refresh the toolbar button states of a toggle action.
---@param section_id integer
---@param command_id integer
function reaper.RefreshToolbar2(section_id, command_id) end

---Makes a filename "in" relative to the current project, if any.
---@param in string
---@param out string
---@return string out
function reaper.relative_fn(in, out) end

---Remove a send/receive/hardware output, return true on success. category is <0 for receives, 0=sends, >0 for hardware outputs. See CreateTrackSend, GetSetTrackSendInfo, GetTrackSendInfo_Value, SetTrackSendInfo_Value, GetTrackNumSends.
---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@return boolean rv
function reaper.RemoveTrackSend(tr, category, sendidx) end

---Not available while playing back.
---@param source_filename string
---@param target_filename string
---@param start_percent number
---@param end_percent number
---@param playrate number
---@return boolean rv
function reaper.RenderFileSection(source_filename, target_filename, start_percent, end_percent, playrate) end

---Moves all selected tracks to immediately above track specified by index beforeTrackIdx, returns false if no tracks were selected. makePrevFolder=0 for normal, 1 = as child of track preceding track specified by beforeTrackIdx, 2 = if track preceding track specified by beforeTrackIdx is last track in folder, extend folder
---@param beforeTrackIdx integer
---@param makePrevFolder integer
---@return boolean rv
function reaper.ReorderSelectedTracks(beforeTrackIdx, makePrevFolder) end

---@param mode integer
---@return string str
function reaper.Resample_EnumModes(mode) end

---See resolve_fn2.
---@param in string
---@param out string
---@return string out
function reaper.resolve_fn(in, out) end

---Resolves a filename "in" by using project settings etc. If no file found, out will be a copy of in.
---@param in string
---@param out string
---@param checkSubDir string?
---@return string out
function reaper.resolve_fn2(in, out, checkSubDir) end

---Resolve a wildcard string. Any wildcards that are valid in the Big Clock can be resolved using this function. Pass in timePosition=-1 to use the current project playback position.
---@param project ReaProject|nil|0
---@param timePosition number
---@param wildcards string
---@param resolvedString string
---@return string resolvedString
function reaper.ResolveWildcards(project, timePosition, wildcards, resolvedString) end

---Get the named command for the given command ID. The returned string will not start with '_' (e.g. it will return "SWS_ABOUT"), it will be NULL if command_id is a native action.
---@param command_id integer
---@return string str
function reaper.ReverseNamedCommandLookup(command_id) end

---See GetEnvelopeScalingMode.
---@param scaling_mode integer
---@param val number
---@return number num
function reaper.ScaleFromEnvelopeMode(scaling_mode, val) end

---See GetEnvelopeScalingMode.
---@param scaling_mode integer
---@param val number
---@return number num
function reaper.ScaleToEnvelopeMode(scaling_mode, val) end

---@param uniqueID integer
---@return KbdSectionInfo rv
function reaper.SectionFromUniqueID(uniqueID) end

---@param proj ReaProject|nil|0
---@param selected boolean
function reaper.SelectAllMediaItems(proj, selected) end

---@param proj ReaProject|nil|0
function reaper.SelectProjectInstance(proj) end

---Sends a MIDI message to output device specified by output. Message is sent in immediate mode. Lua example of how to pack the message string:
---sysex = { 0xF0, 0x00, 0xF7 }
---msg = ""
---for i=1, #sysex do msg = msg .. string.char(sysex[i]) end
---@param output integer
---@param msg string
function reaper.SendMIDIMessageToHardware(output, msg) end

---set this take active in this media item
---@param take MediaItem_Take
function reaper.SetActiveTake(take) end

---sets all or selected tracks to mode.
---@param mode integer
---@param onlySel boolean
function reaper.SetAutomationMode(mode, onlySel) end

---set current BPM in project, set wantUndo=true to add undo point
---@param __proj ReaProject|nil|0
---@param bpm number
---@param wantUndo boolean
function reaper.SetCurrentBPM(__proj, bpm, wantUndo) end

---You must use this to change the focus programmatically. mode=0 to focus track panels, 1 to focus the arrange window, 2 to focus the arrange window and select env (or env==NULL to clear the current track/take envelope selection)
---@param mode integer
---@param envIn TrackEnvelope?
function reaper.SetCursorContext(mode, envIn) end

---@param time number
---@param moveview boolean
---@param seekplay boolean
function reaper.SetEditCurPos(time, moveview, seekplay) end

---@param proj ReaProject|nil|0
---@param time number
---@param moveview boolean
---@param seekplay boolean
function reaper.SetEditCurPos2(proj, time, moveview, seekplay) end

---Set attributes of an envelope point. Values that are not supplied will be ignored. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. See SetEnvelopePointEx.
---@param envelope TrackEnvelope
---@param ptidx integer
---@param timeIn number?
---@param valueIn number?
---@param shapeIn integer?
---@param tensionIn number?
---@param selectedIn boolean?
---@param noSortIn boolean?
---@return boolean rv
function reaper.SetEnvelopePoint(envelope, ptidx, timeIn, valueIn, shapeIn, tensionIn, selectedIn, noSortIn) end

---Set attributes of an envelope point. Values that are not supplied will be ignored. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done.
---autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
---For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration,
---even if the automation item is trimmed so that not all points are visible.
---Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations.
---See CountEnvelopePointsEx, GetEnvelopePointEx, InsertEnvelopePointEx, DeleteEnvelopePointEx.
---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param ptidx integer
---@param timeIn number?
---@param valueIn number?
---@param shapeIn integer?
---@param tensionIn number?
---@param selectedIn boolean?
---@param noSortIn boolean?
---@return boolean rv
function reaper.SetEnvelopePointEx(envelope, autoitem_idx, ptidx, timeIn, valueIn, shapeIn, tensionIn, selectedIn, noSortIn) end

---Sets the RPPXML state of an envelope, returns true if successful. Undo flag is a performance/caching hint.
---@param env TrackEnvelope
---@param str string
---@param isundo boolean
---@return boolean rv
function reaper.SetEnvelopeStateChunk(env, str, isundo) end

---Set the extended state value for a specific section and key. persist=true means the value should be stored and reloaded the next time REAPER is opened. Note that with persist=true set, the value will be encoded as a text line in an .ini file and may behaved in unexpected ways if it contains any newlines: do not pass a string with newlines to this function. To save arbitrary data persistently, use base64 encoding or similar. See GetExtState, DeleteExtState, HasExtState.
---@param section string
---@param key string
---@param value string
---@param persist boolean
function reaper.SetExtState(section, key, value, persist) end

---mode: see GetGlobalAutomationOverride
---@param mode integer
function reaper.SetGlobalAutomationOverride(mode) end

---Sets the RPPXML state of an item, returns true if successful. Undo flag is a performance/caching hint.
---@param item MediaItem
---@param str string
---@param isundo boolean
---@return boolean rv
function reaper.SetItemStateChunk(item, str, isundo) end

---set &1 to show the master track in the TCP, &2 to HIDE in the mixer. Returns the previous visibility state. See GetMasterTrackVisibility.
---@param flag integer
---@return integer rv
function reaper.SetMasterTrackVisibility(flag) end

---@alias SetMediaItemInfo_Value_Param
---| "'B_MUTE'" bool * : muted (item solo overrides). setting this value will clear C_MUTE_SOLO.
---| "'B_MUTE_ACTUAL'" bool * : muted (ignores solo). setting this value will not affect C_MUTE_SOLO.
---| "'C_LANEPLAYS'" char * : on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only)
---| "'C_MUTE_SOLO'" char * : solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API.
---| "'B_LOOPSRC'" bool * : loop source
---| "'B_ALLTAKESPLAY'" bool * : all takes play
---| "'B_UISEL'" bool * : selected in arrange view
---| "'C_BEATATTACHMODE'" char * : item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1
---| "'C_AUTOSTRETCH'" : char * : auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1
---| "'C_LOCK'" char * : locked, &1=locked
---| "'D_VOL'" double * : item volume,  0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
---| "'D_POSITION'" double * : item position in seconds
---| "'D_LENGTH'" double * : item length in seconds
---| "'D_SNAPOFFSET'" double * : item snap offset in seconds
---| "'D_FADEINLEN'" double * : item manual fadein length in seconds
---| "'D_FADEOUTLEN'" double * : item manual fadeout length in seconds
---| "'D_FADEINDIR'" double * : item fadein curvature, -1..1
---| "'D_FADEOUTDIR'" double * : item fadeout curvature, -1..1
---| "'D_FADEINLEN_AUTO'" double * : item auto-fadein length in seconds, -1=no auto-fadein
---| "'D_FADEOUTLEN_AUTO'" double * : item auto-fadeout length in seconds, -1=no auto-fadeout
---| "'C_FADEINSHAPE'" int * : fadein shape, 0..6, 0=linear
---| "'C_FADEOUTSHAPE'" int * : fadeout shape, 0..6, 0=linear
---| "'I_GROUPID'" int * : group ID, 0=no group
---| "'I_LASTY'" int * : Y-position (relative to top of track) in pixels (read-only)
---| "'I_LASTH'" int * : height in pixels (read-only)
---| "'I_CUSTOMCOLOR'" int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---| "'I_CURTAKE'" int * : active take number
---| "'IP_ITEMNUMBER'" int : item number on this track (read-only, returns the item number directly)
---| "'F_FREEMODE_Y'" float * : free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track
---| "'F_FREEMODE_H'" float * : free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height
---| "'I_FIXEDLANE'" int * : fixed lane of item (fine to call with setNewValue, but returned value is read-only)
---| "'B_FIXEDLANE_HIDDEN'" bool * : true if displaying only one fixed lane and this item is in a different lane (read-only)

---Set media item numerical-value attributes.
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
---@param item MediaItem
---@param parmname SetMediaItemInfo_Value_Param
---@param newvalue number
---@return boolean rv
function reaper.SetMediaItemInfo_Value(item, parmname, newvalue) end

---Redraws the screen only if refreshUI == true.
---See UpdateArrange().
---@param item MediaItem
---@param length number
---@param refreshUI boolean
---@return boolean rv
function reaper.SetMediaItemLength(item, length, refreshUI) end

---Redraws the screen only if refreshUI == true.
---See UpdateArrange().
---@param item MediaItem
---@param position number
---@param refreshUI boolean
---@return boolean rv
function reaper.SetMediaItemPosition(item, position, refreshUI) end

---@param item MediaItem
---@param selected boolean
function reaper.SetMediaItemSelected(item, selected) end

---Set media source of media item take. The old source will not be destroyed, it is the caller's responsibility to retrieve it and destroy it after. If source already exists in any project, it will be duplicated before being set. C/C++ code should not use this and instead use GetSetMediaItemTakeInfo() with P_SOURCE to manage ownership directly.
---@param take MediaItem_Take
---@param source PCM_source
---@return boolean rv
function reaper.SetMediaItemTake_Source(take, source) end

---@alias SetMediaItemTakeInfo_Value_Param
---| "'D_STARTOFFS'" double * : start offset in source media, in seconds
---| "'D_VOL'" double * : take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped
---| "'D_PAN'" double * : take pan, -1..1
---| "'D_PANLAW'" double * : take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc
---| "'D_PLAYRATE'" double * : take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc
---| "'D_PITCH'" double * : take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc
---| "'B_PPITCH'" bool * : preserve pitch when changing playback rate
---| "'I_LASTY'" int * : Y-position (relative to top of track) in pixels (read-only)
---| "'I_LASTH'" int * : height in pixels (read-only)
---| "'I_CHANMODE'" int * : channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right
---| "'I_PITCHMODE'" int * : pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter
---| "'I_STRETCHFLAGS'" int * : stretch marker flags (&7 mask for mode override: 0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo)
---| "'F_STRETCHFADESIZE'" float * : stretch marker fade size in seconds (0.0025 default)
---| "'I_RECPASSID'" int * : record pass ID
---| "'I_TAKEFX_NCH'" int * : number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only)
---| "'I_CUSTOMCOLOR'" int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---| "'IP_SPECEDIT:CNT'" int : spectral edit count (read-only)
---| "'IP_SPECEDIT:DELETE:x'" int : read or write this key to remove the spectral edit specified
---| "'IP_SPECEDIT:ADD'" int : read or write this key to add a new spectral edit (returns index)
---| "'IP_SPECEDIT:SORT'" int : read or write this key to re-sort spectral edits (be sure to do this following a position change or insert of new edit)
---| "'I_SPECEDIT:FFT_SIZE'" int * : FFT size used by spectral edits for this take
---| "'D_SPECEDIT:x:POSITION'" double * : position of spectral edit start (changing this requires a resort of spectral edits)
---| "'D_SPECEDIT:x:LENGTH'" double * : length of spectral edit
---| "'F_SPECEDIT:x:GAIN'" float * : gain of spectral edit
---| "'F_SPECEDIT:x:FADE_IN'" float * : fade-in size 0..1
---| "'F_SPECEDIT:x:FADE_OUT'" float * : fade-out size 0..1
---| "'F_SPECEDIT:x:FADE_LOW'" float * : fade-lf size 0..1
---| "'F_SPECEDIT:x:FADE_HI'" float * : fade-hf size 0..1
---| "'I_SPECEDIT:x:CHAN'" int * : channel index, -1 for omni
---| "'I_SPECEDIT:x:FLAGS'" int * : flags, &1=bypassed, &2=solo
---| "'F_SPECEDIT:x:GATE_THRESH'" float * : gate threshold
---| "'F_SPECEDIT:x:GATE_FLOOR'" float * : gate floor
---| "'F_SPECEDIT:x:COMP_THRESH'" float * : comp threshold
---| "'F_SPECEDIT:x:COMP_RATIO'" float * : comp ratio
---| "'B_SPECEDIT:x:SELECTED'" bool * : selection state
---| "'I_SPECEDIT:x:TOPFREQ_CNT'" int * : (read-only) number of top frequency-points
---| "'I_SPECEDIT:x:TOPFREQ_ADD:pos:val'" int * : reading or writing will insert top frequency-point with position/value pair, returns index
---| "'I_SPECEDIT:x:TOPFREQ_DEL:y'" int * : reading or writing will delete top frequency-point y. there will always be at least one point.
---| "'F_SPECEDIT:x:TOPFREQ_POS:y'" float * : (read-only) get position of top frequency-point y
---| "'F_SPECEDIT:x:TOPFREQ_FREQ:y'" float * : (read-only) get frequency of top frequency-point y
---| "'I_SPECEDIT:x:BOTFREQ_CNT'" int * : number of bottom frequency-points
---| "'I_SPECEDIT:x:BOTFREQ_ADD:pos:val'" int * : reading or writing will insert bottom frequency-point with position/value pair, returns index
---| "'I_SPECEDIT:x:BOTFREQ_DEL:y'" int * : reading or writing will delete bottom frequency-point y. there will always be at least one point.
---| "'F_SPECEDIT:x:BOTFREQ_POS:y'" float * : (read-only) get position of bottom frequency-point y
---| "'F_SPECEDIT:x:BOTFREQ_FREQ:y'" float * : (read-only) get frequency of bottom frequency-point y
---| "'IP_TAKENUMBER'" int : take number (read-only, returns the take number directly)

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
---IP_SPECEDIT:CNT : int : spectral edit count (read-only)
---IP_SPECEDIT:DELETE:x : int : read or write this key to remove the spectral edit specified
---IP_SPECEDIT:ADD : int : read or write this key to add a new spectral edit (returns index)
---IP_SPECEDIT:SORT : int : read or write this key to re-sort spectral edits (be sure to do this following a position change or insert of new edit)
---I_SPECEDIT:FFT_SIZE : int * : FFT size used by spectral edits for this take
---D_SPECEDIT:x:POSITION : double * : position of spectral edit start (changing this requires a resort of spectral edits)
---D_SPECEDIT:x:LENGTH : double * : length of spectral edit
---F_SPECEDIT:x:GAIN : float * : gain of spectral edit
---F_SPECEDIT:x:FADE_IN : float * : fade-in size 0..1
---F_SPECEDIT:x:FADE_OUT : float * : fade-out size 0..1
---F_SPECEDIT:x:FADE_LOW : float * : fade-lf size 0..1
---F_SPECEDIT:x:FADE_HI : float * : fade-hf size 0..1
---I_SPECEDIT:x:CHAN : int * : channel index, -1 for omni
---I_SPECEDIT:x:FLAGS : int * : flags, &1=bypassed, &2=solo
---F_SPECEDIT:x:GATE_THRESH : float * : gate threshold
---F_SPECEDIT:x:GATE_FLOOR : float * : gate floor
---F_SPECEDIT:x:COMP_THRESH : float * : comp threshold
---F_SPECEDIT:x:COMP_RATIO : float * : comp ratio
---B_SPECEDIT:x:SELECTED : bool * : selection state
---I_SPECEDIT:x:TOPFREQ_CNT : int * : (read-only) number of top frequency-points
---I_SPECEDIT:x:TOPFREQ_ADD:pos:val : int * : reading or writing will insert top frequency-point with position/value pair, returns index
---I_SPECEDIT:x:TOPFREQ_DEL:y : int * : reading or writing will delete top frequency-point y. there will always be at least one point.
---F_SPECEDIT:x:TOPFREQ_POS:y : float * : (read-only) get position of top frequency-point y
---F_SPECEDIT:x:TOPFREQ_FREQ:y : float * : (read-only) get frequency of top frequency-point y
---I_SPECEDIT:x:BOTFREQ_CNT : int * : number of bottom frequency-points
---I_SPECEDIT:x:BOTFREQ_ADD:pos:val : int * : reading or writing will insert bottom frequency-point with position/value pair, returns index
---I_SPECEDIT:x:BOTFREQ_DEL:y : int * : reading or writing will delete bottom frequency-point y. there will always be at least one point.
---F_SPECEDIT:x:BOTFREQ_POS:y : float * : (read-only) get position of bottom frequency-point y
---F_SPECEDIT:x:BOTFREQ_FREQ:y : float * : (read-only) get frequency of bottom frequency-point y
---IP_TAKENUMBER : int : take number (read-only, returns the take number directly)
---@param take MediaItem_Take
---@param parmname SetMediaItemTakeInfo_Value_Param
---@param newvalue number
---@return boolean rv
function reaper.SetMediaItemTakeInfo_Value(take, parmname, newvalue) end

---@alias SetMediaTrackInfo_Value_Param
---| "'B_MUTE'" bool * : muted
---| "'B_PHASE'" bool * : track phase inverted
---| "'B_RECMON_IN_EFFECT'" bool * : record monitoring in effect (current audio-thread playback state, read-only)
---| "'IP_TRACKNUMBER'" int : track number 1-based, 0=not found, -1=master track (read-only, returns the int directly)
---| "'I_SOLO'" int * : soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place
---| "'B_SOLO_DEFEAT'" bool * : when set, if anything else is soloed and this track is not muted, this track acts soloed
---| "'I_FXEN'" int * : fx enabled, 0=bypassed, !0=fx active
---| "'I_RECARM'" int * : record armed, 0=not record armed, 1=record armed
---| "'I_RECINPUT'" int * : record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023) are input start channel (ReaRoute/Loopback start at 512). If 2048 is set, input is multichannel input (using track channel count), or if 1024 is set, input is stereo input, otherwise input is mono.
---| "'I_RECMODE'" int * : record mode, 0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation, 4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7=midi overdub, 8=midi replace
---| "'I_RECMODE_FLAGS'" int * : record mode flags, &3=output recording mode (0=post fader, 1=pre-fx, 2=post-fx/pre-fader)
---| "'I_RECMON'" int * : record monitoring, 0=off, 1=normal, 2=not when playing (tape style)
---| "'I_RECMONITEMS'" int * : monitor items while recording, 0=off, 1=on
---| "'B_AUTO_RECARM'" bool * : automatically set record arm when selected (does not immediately affect recarm state, script should set directly if desired)
---| "'I_VUMODE'" int * : track vu mode, &1:disabled, &30==0:stereo peaks, &30==2:multichannel peaks, &30==4:stereo RMS, &30==8:combined RMS, &30==12:LUFS-M, &30==16:LUFS-S (readout=max), &30==20:LUFS-S (readout=current), &32:LUFS calculation on channels 1+2 only
---| "'I_AUTOMODE'" int * : track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch
---| "'I_NCHAN'" int * : number of track channels, 2-128, even numbers only
---| "'I_SELECTED'" int * : track selected, 0=unselected, 1=selected
---| "'I_WNDH'" int * : current TCP window height in pixels including envelopes (read-only)
---| "'I_TCPH'" int * : current TCP window height in pixels not including envelopes (read-only)
---| "'I_TCPY'" int * : current TCP window Y-position in pixels relative to top of arrange view (read-only)
---| "'I_MCPX'" int * : current MCP X-position in pixels relative to mixer container (read-only)
---| "'I_MCPY'" int * : current MCP Y-position in pixels relative to mixer container (read-only)
---| "'I_MCPW'" int * : current MCP width in pixels (read-only)
---| "'I_MCPH'" int * : current MCP height in pixels (read-only)
---| "'I_FOLDERDEPTH'" int * : folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc
---| "'I_FOLDERCOMPACT'" int * : folder collapsed state (only valid on folders), 0=normal, 1=collapsed, 2=fully collapsed
---| "'I_MIDIHWOUT'" int * : track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31)
---| "'I_MIDI_INPUT_CHANMAP'" int * : -1 maps to source channel, otherwise 1-16 to map to MIDI channel
---| "'I_MIDI_CTL_CHAN'" int * : -1 no link, 0-15 link to MIDI volume/pan on channel, 16 link to MIDI volume/pan on all channels
---| "'I_MIDI_TRACKSEL_FLAG'" int * : MIDI editor track list options: &1=expand media items, &2=exclude from list, &4=auto-pruned
---| "'I_PERFFLAGS'" int * : track performance flags, &1=no media buffering, &2=no anticipative FX
---| "'I_CUSTOMCOLOR'" int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color
---| "'I_HEIGHTOVERRIDE'" int * : custom height override for TCP window, 0 for none, otherwise size in pixels
---| "'I_SPACER'" int * : 1=TCP track spacer above this trackB_HEIGHTLOCK : bool * : track height lock (must set I_HEIGHTOVERRIDE before locking)
---| "'D_VOL'" double * : trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc
---| "'D_PAN'" double * : trim pan of track, -1..1
---| "'D_WIDTH'" double * : width of track, -1..1
---| "'D_DUALPANL'" double * : dualpan position 1, -1..1, only if I_PANMODE==6
---| "'D_DUALPANR'" double * : dualpan position 2, -1..1, only if I_PANMODE==6
---| "'I_PANMODE'" int * : pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan
---| "'D_PANLAW'" double * : pan law of track, <0=project default, 0.5=-6dB, 0.707..=-3dB, 1=+0dB, 1.414..=-3dB with gain compensation, 2=-6dB with gain compensation, etc
---| "'I_PANLAW_FLAGS'" int * : pan law flags, 0=sine taper, 1=hybrid taper with deprecated behavior when gain compensation enabled, 2=linear taper, 3=hybrid taper
---| "'B_SHOWINMIXER'" bool * : track control panel visible in mixer (do not use on master track)
---| "'B_SHOWINTCP'" bool * : track control panel visible in arrange view (do not use on master track)
---| "'B_MAINSEND'" bool * : track sends audio to parent
---| "'C_MAINSEND_OFFS'" char * : channel offset of track send to parent
---| "'C_MAINSEND_NCH'" char * : channel count of track send to parent (0=use all child track channels, 1=use one channel only)
---| "'I_FREEMODE'" int * : 1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing)
---| "'I_NUMFIXEDLANES'" int * : number of track fixed lanes (fine to call with setNewValue, but returned value is read-only)
---| "'C_LANESCOLLAPSED'" char * : fixed lane collapse state (1=lanes collapsed, 2=track displays as non-fixed-lanes but hidden lanes exist)
---| "'C_LANESETTINGS'" char * : fixed lane settings (&1=auto-remove empty lanes at bottom, &2=do not auto-comp new recording, &4=newly recorded lanes play exclusively (else add lanes in layers), &8=big lanes (else small lanes), &16=add new recording at bottom (else record into first available lane), &32=hide lane buttons
---| "'C_LANEPLAYS:N'" char * :  on fixed lane tracks, 0=lane N does not play, 1=lane N plays exclusively, 2=lane N plays and other lanes also play (fine to call with setNewValue, but returned value is read-only)
---| "'C_ALLLANESPLAY'" char * : on fixed lane tracks, 0=no lanes play, 1=all lanes play, 2=some lanes play (fine to call with setNewValue 0 or 1, but returned value is read-only)
---| "'C_BEATATTACHMODE'" char * : track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only)
---| "'F_MCP_FXSEND_SCALE'" float * : scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed)
---| "'F_MCP_FXPARM_SCALE'" float * : scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed)
---| "'F_MCP_SENDRGN_SCALE'" float * : scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed)
---| "'F_TCP_FXPARM_SCALE'" float * : scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed)
---| "'I_PLAY_OFFSET_FLAG'" int * : track media playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds)
---| "'D_PLAY_OFFSET'" double * : track media playback offset, units depend on I_PLAY_OFFSET_FLAG

---Set track numerical-value attributes.
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
---@param tr MediaTrack
---@param parmname SetMediaTrackInfo_Value_Param
---@param newvalue number
---@return boolean rv
function reaper.SetMediaTrackInfo_Value(tr, parmname, newvalue) end

---Set the MIDI editor grid division. 0.25=quarter note, 1.0/3.0=half note tripet, etc. Sets the swing enabled/strength from the arrange settings.
---@param project ReaProject|nil|0
---@param division number
function reaper.SetMIDIEditorGrid(project, division) end

---Scroll the mixer so that leftmosttrack is the leftmost visible track. Returns the leftmost track after scrolling, which may be different from the passed-in track if there are not enough tracks to its right.
---@param leftmosttrack MediaTrack
---@return MediaTrack rv
function reaper.SetMixerScroll(leftmosttrack) end

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

---Set exactly one track selected, deselect all others
---@param track MediaTrack
function reaper.SetOnlyTrackSelected(track) end

---Set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc.
---@param project ReaProject|nil|0
---@param division number
function reaper.SetProjectGrid(project, division) end

---Note: this function can't clear a marker's name (an empty string will leave the name unchanged), see SetProjectMarker4.
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@return boolean rv
function reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos, rgnend, name) end

---Note: this function can't clear a marker's name (an empty string will leave the name unchanged), see SetProjectMarker4.
---@param proj ReaProject|nil|0
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@return boolean rv
function reaper.SetProjectMarker2(proj, markrgnindexnumber, isrgn, pos, rgnend, name) end

---Note: this function can't clear a marker's name (an empty string will leave the name unchanged), see SetProjectMarker4.
---@param proj ReaProject|nil|0
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color integer
---@return boolean rv
function reaper.SetProjectMarker3(proj, markrgnindexnumber, isrgn, pos, rgnend, name, color) end

---color should be 0 to not change, or ColorToNative(r,g,b)|0x1000000, flags&1 to clear name
---@param proj ReaProject|nil|0
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color integer
---@param flags integer
---@return boolean rv
function reaper.SetProjectMarker4(proj, markrgnindexnumber, isrgn, pos, rgnend, name, color, flags) end

---See SetProjectMarkerByIndex2.
---@param proj ReaProject|nil|0
---@param markrgnidx integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param IDnumber integer
---@param name string
---@param color integer
---@return boolean rv
function reaper.SetProjectMarkerByIndex(proj, markrgnidx, isrgn, pos, rgnend, IDnumber, name, color) end

---Differs from SetProjectMarker4 in that markrgnidx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3), rather than representing the displayed marker/region ID number (see SetProjectMarker3). IDnumber < 0 to ignore. Function will fail if attempting to set a duplicate ID number for a region (duplicate ID numbers for markers are OK). flags&1 to clear name. If flags&2, markers will not be re-sorted, and after making updates, you MUST call SetProjectMarkerByIndex2 with markrgnidx=-1 and flags&2 to force re-sort/UI updates.
---@param proj ReaProject|nil|0
---@param markrgnidx integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param IDnumber integer
---@param name string
---@param color integer
---@param flags integer
---@return boolean rv
function reaper.SetProjectMarkerByIndex2(proj, markrgnidx, isrgn, pos, rgnend, IDnumber, name, color, flags) end

---Save a key/value pair for a specific extension, to be restored the next time this specific project is loaded. Typically extname will be the name of a reascript or extension section. If key is NULL or "", all extended data for that extname will be deleted.  If val is NULL or "", the data previously associated with that key will be deleted. Returns the size of the state for this extname. See GetProjExtState, EnumProjExtState.
---@param proj ReaProject|nil|0
---@param extname string
---@param key string
---@param value string
---@return integer rv
function reaper.SetProjExtState(proj, extname, key, value) end

---Add (flag > 0) or remove (flag < 0) a track from this region when using the region render matrix. If adding, flag==2 means force mono, flag==4 means force stereo, flag==N means force N/2 channels.
---@param proj ReaProject|nil|0
---@param regionindex integer
---@param track MediaTrack
---@param flag integer
function reaper.SetRegionRenderMatrix(proj, regionindex, track, flag) end

---Inserts or updates a take marker. If idx<0, a take marker will be added, otherwise an existing take marker will be updated. Returns the index of the new or updated take marker (which may change if srcPos is updated). See GetNumTakeMarkers, GetTakeMarker, DeleteTakeMarker
---@param take MediaItem_Take
---@param idx integer
---@param nameIn string
---@param srcposIn number?
---@param colorIn integer?
---@return integer rv
function reaper.SetTakeMarker(take, idx, nameIn, srcposIn, colorIn) end

---Adds or updates a stretch marker. If idx<0, stretch marker will be added. If idx>=0, stretch marker will be updated. When adding, if srcposInOptional is omitted, source position will be auto-calculated. When updating a stretch marker, if srcposInOptional is omitted, srcpos will not be modified. Position/srcposition values will be constrained to nearby stretch markers. Returns index of stretch marker, or -1 if did not insert (or marker already existed at time).
---@param take MediaItem_Take
---@param idx integer
---@param pos number
---@param srcposIn number?
---@return integer rv
function reaper.SetTakeStretchMarker(take, idx, pos, srcposIn) end

---See GetTakeStretchMarkerSlope
---@param take MediaItem_Take
---@param idx integer
---@param slope number
---@return boolean rv
function reaper.SetTakeStretchMarkerSlope(take, idx, slope) end

---Set parameters of a tempo/time signature marker. Provide either timepos (with measurepos=-1, beatpos=-1), or measurepos and beatpos (with timepos=-1). If timesig_num and timesig_denom are zero, the previous time signature will be used. ptidx=-1 will insert a new tempo/time signature marker. See CountTempoTimeSigMarkers, GetTempoTimeSigMarker, AddTempoTimeSigMarker.
---@param proj ReaProject|nil|0
---@param ptidx integer
---@param timepos number
---@param measurepos integer
---@param beatpos number
---@param bpm number
---@param timesig_num integer
---@param timesig_denom integer
---@param lineartempo boolean
---@return boolean rv
function reaper.SetTempoTimeSigMarker(proj, ptidx, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom, lineartempo) end

---Temporarily updates the theme color to the color specified (or the theme default color if -1 is specified). Returns -1 on failure, otherwise returns the color (or transformed-color). Note that the UI is not updated by this, the caller should call UpdateArrange() etc as necessary. If the low bit of flags is set, any color transformations are bypassed. To read a value see GetThemeColor.
---Currently valid ini_keys:
---col_main_bg2 : Main window/transport background
---col_main_text2 : Main window/transport text
---col_main_textshadow : Main window text shadow (ignored if too close to text color)
---col_main_3dhl : Main window 3D highlight
---col_main_3dsh : Main window 3D shadow
---col_main_resize2 : Main window pane resize mouseover
---col_main_text : Themed window text
---col_main_bg : Themed window background
---col_main_editbk : Themed window edit background
---col_nodarkmodemiscwnd : Do not use window theming on macOS dark mode
----- bool 00000000
---col_transport_editbk : Transport edit background
---col_toolbar_text : Toolbar button text
---col_toolbar_text_on : Toolbar button enabled text
---col_toolbar_frame : Toolbar frame when floating or docked
---toolbararmed_color : Toolbar button armed color
---toolbararmed_drawmode : Toolbar button armed fill mode
---io_text : I/O window text
---io_3dhl : I/O window 3D highlight
---io_3dsh : I/O window 3D shadow
---genlist_bg : Window list background
---genlist_fg : Window list text
---genlist_grid : Window list grid lines
---genlist_selbg : Window list selected row
---genlist_selfg : Window list selected text
---genlist_seliabg : Window list selected row (inactive)
---genlist_seliafg : Window list selected text (inactive)
---genlist_hilite : Window list highlighted text
---genlist_hilite_sel : Window list highlighted selected text
---col_buttonbg : Button background
---col_tcp_text : Track panel text
---col_tcp_textsel : Track panel (selected) text
---col_seltrack : Selected track control panel background
---col_seltrack2 : Unselected track control panel background (enabled with a checkbox above)
---tcplocked_color : Locked track control panel overlay color
---tcplocked_drawmode : Locked track control panel fill mode
---col_tracklistbg : Empty track list area
---col_mixerbg : Empty mixer list area
---col_arrangebg : Empty arrange view area
---arrange_vgrid : Empty arrange view area vertical grid shading
---col_fadearm : Fader background when automation recording
---col_fadearm2 : Fader background when automation playing
---col_fadearm3 : Fader background when in inactive touch/latch
---col_tl_fg : Timeline foreground
---col_tl_fg2 : Timeline foreground (secondary markings)
---col_tl_bg : Timeline background
---col_tl_bgsel : Time selection color
---timesel_drawmode : Time selection fill mode
---col_tl_bgsel2 : Timeline background (in loop points)
---col_trans_bg : Transport status background
---col_trans_fg : Transport status text
---playrate_edited : Project play rate control when not 1.0
---selitem_dot : Media item selection indicator
---col_mi_label : Media item label
---col_mi_label_sel : Media item label (selected)
---col_mi_label_float : Floating media item label
---col_mi_label_float_sel : Floating media item label (selected)
---col_mi_bg2 : Media item background (odd tracks)
---col_mi_bg : Media item background (even tracks)
---col_tr1_itembgsel : Media item background selected (odd tracks)
---col_tr2_itembgsel : Media item background selected (even tracks)
---itembg_drawmode : Media item background fill mode
---col_tr1_peaks : Media item peaks (odd tracks)
---col_tr2_peaks : Media item peaks (even tracks)
---col_tr1_ps2 : Media item peaks when selected (odd tracks)
---col_tr2_ps2 : Media item peaks when selected (even tracks)
---col_peaksedge : Media item peaks edge highlight (odd tracks)
---col_peaksedge2 : Media item peaks edge highlight (even tracks)
---col_peaksedgesel : Media item peaks edge highlight when selected (odd tracks)
---col_peaksedgesel2 : Media item peaks edge highlight when selected (even tracks)
---cc_chase_drawmode : Media item MIDI CC peaks fill mode
---col_peaksfade : Media item peaks when active in crossfade editor (fade-out)
---col_peaksfade2 : Media item peaks when active in crossfade editor (fade-in)
---col_mi_fades : Media item fade/volume controls
---fadezone_color : Media item fade quiet zone fill color
---fadezone_drawmode : Media item fade quiet zone fill mode
---fadearea_color : Media item fade full area fill color
---fadearea_drawmode : Media item fade full area fill mode
---col_mi_fade2 : Media item edges of controls
---col_mi_fade2_drawmode : Media item edges of controls blend mode
---item_grouphl : Media item edge when selected via grouping
---col_offlinetext : Media item "offline" text
---col_stretchmarker : Media item stretch marker line
---col_stretchmarker_h0 : Media item stretch marker handle (1x)
---col_stretchmarker_h1 : Media item stretch marker handle (>1x)
---col_stretchmarker_h2 : Media item stretch marker handle (-- current RGB: 189,19,19
---col_stretchmarker_b : Media item stretch marker handle edge
---col_stretchmarkerm : Media item stretch marker blend mode
---col_stretchmarker_text : Media item stretch marker text
---col_stretchmarker_tm : Media item transient guide handle
---take_marker : Media item take marker
---take_marker_sel : Media item take marker when item selected
---selitem_tag : Selected media item bar color
---activetake_tag : Active media item take bar color
---col_tr1_bg : Track background (odd tracks)
---col_tr2_bg : Track background (even tracks)
---selcol_tr1_bg : Selected track background (odd tracks)
---selcol_tr2_bg : Selected track background (even tracks)
---track_lane_tabcol : Track fixed lane button
---track_lanesolo_tabcol : Track fixed lane button when only this lane plays
---track_lanesolo_text : Track fixed lane button text
---track_lane_gutter : Track fixed lane add area
---track_lane_gutter_drawmode : Track fixed lane add fill mode
---col_tr1_divline : Track divider line (odd tracks)
---col_tr2_divline : Track divider line (even tracks)
---col_envlane1_divline : Envelope lane divider line (odd tracks)
---col_envlane2_divline : Envelope lane divider line (even tracks)
---mute_overlay_col : Muted/unsoloed track/item overlay color
---mute_overlay_mode : Muted/unsoloed track/item overlay mode
---inactive_take_overlay_col : Inactive take/lane overlay color
---inactive_take_overlay_mode : Inactive take/lane overlay mode
---locked_overlay_col : Locked track/item overlay color
---locked_overlay_mode : Locked track/item overlay mode
---marquee_fill : Marquee fill
---marquee_drawmode : Marquee fill mode
---marquee_outline : Marquee outline
---marqueezoom_fill : Marquee zoom fill
---marqueezoom_drawmode : Marquee zoom fill mode
---marqueezoom_outline : Marquee zoom outline
---areasel_fill : Razor edit area fill
---areasel_drawmode : Razor edit area fill mode
---areasel_outline : Razor edit area outline
---areasel_outlinemode : Razor edit area outline mode
---linkedlane_fill : Fixed lane comp area fill
---linkedlane_fillmode : Fixed lane comp area fill mode
---linkedlane_outline : Fixed lane comp area outline
---linkedlane_outlinemode : Fixed lane comp area outline mode
---linkedlane_unsynced : Fixed lane comp lane unsynced media item
---linkedlane_unsynced_mode : Fixed lane comp lane unsynced media item mode
---col_cursor : Edit cursor
---col_cursor2 : Edit cursor (alternate)
---playcursor_color : Play cursor
---playcursor_drawmode : Play cursor mode
---col_gridlines2 : Grid lines (start of measure)
---col_gridlines2dm : Grid lines (start of measure) - draw mode
---col_gridlines3 : Grid lines (start of beats)
---col_gridlines3dm : Grid lines (start of beats) - draw mode
---col_gridlines : Grid lines (in between beats)
---col_gridlines1dm : Grid lines (in between beats) - draw mode
---guideline_color : Editing guide line
---guideline_drawmode : Editing guide mode
---mouseitem_color : Mouse position indicator
---mouseitem_mode : Mouse position indicator mode
---region : Regions
---region_lane_bg : Region lane background
---region_lane_text : Region text
---region_edge : Region edge
---region_edge_sel : Region text and edge (selected)
---marker : Markers
---marker_lane_bg : Marker lane background
---marker_lane_text : Marker text
---marker_edge : Marker edge
---marker_edge_sel : Marker text and edge (selected)
---col_tsigmark : Time signature change marker
---ts_lane_bg : Time signature lane background
---ts_lane_text : Time signature lane text
---timesig_sel_bg : Time signature marker selected background
---col_routinghl1 : Routing matrix row highlight
---col_routinghl2 : Routing matrix column highlight
---col_routingact : Routing matrix input activity highlight
---col_vudoint : Theme has interlaced VU meters
----- bool 00000000
---col_vuclip : VU meter clip indicator
---col_vudbscale : VU meters dB scales (not record armed)
----- bool 00000001
---col_vudbscale2 : VU meters dB scales (record armed)
----- bool 00000001
---col_vutop : VU meter top
---col_vumid : VU meter middle
---col_vubot : VU meter bottom
---col_vuintcol : VU meter interlace/edge color
---vu_gr_bgcol : VU meter gain reduction background
---vu_gr_fgcol : VU meter gain reduction indicator
---col_vumidi : VU meter midi activity
---col_vuind1 : VU (indicator) - no signal
---col_vuind2 : VU (indicator) - low signal
---col_vuind3 : VU (indicator) - med signal
---col_vuind4 : VU (indicator) - hot signal
---mcp_sends_normal : Sends text: normal
---mcp_sends_muted : Sends text: muted
---mcp_send_midihw : Sends text: MIDI hardware
---mcp_sends_levels : Sends level
---mcp_fx_normal : FX insert text: normal
---mcp_fx_bypassed : FX insert text: bypassed
---mcp_fx_offlined : FX insert text: offline
---mcp_fxparm_normal : FX parameter text: normal
---mcp_fxparm_bypassed : FX parameter text: bypassed
---mcp_fxparm_offlined : FX parameter text: offline
---tcp_list_scrollbar : List scrollbar (track panel)
---tcp_list_scrollbar_mode : List scrollbar (track panel) - draw mode
---tcp_list_scrollbar_mouseover : List scrollbar mouseover (track panel)
---tcp_list_scrollbar_mouseover_mode : List scrollbar mouseover (track panel) - draw mode
---mcp_list_scrollbar : List scrollbar (mixer panel)
---mcp_list_scrollbar_mode : List scrollbar (mixer panel) - draw mode
---mcp_list_scrollbar_mouseover : List scrollbar mouseover (mixer panel)
---mcp_list_scrollbar_mouseover_mode : List scrollbar mouseover (mixer panel) - draw mode
---midi_rulerbg : MIDI editor ruler background
---midi_rulerfg : MIDI editor ruler text
---midi_grid2 : MIDI editor grid line (start of measure)
---midi_griddm2 : MIDI editor grid line (start of measure) - draw mode
---midi_grid3 : MIDI editor grid line (start of beats)
---midi_griddm3 : MIDI editor grid line (start of beats) - draw mode
---midi_grid1 : MIDI editor grid line (between beats)
---midi_griddm1 : MIDI editor grid line (between beats) - draw mode
---midi_trackbg1 : MIDI editor background color (naturals)
---midi_trackbg2 : MIDI editor background color (sharps/flats)
---midi_trackbg_outer1 : MIDI editor background color, out of bounds (naturals)
---midi_trackbg_outer2 : MIDI editor background color, out of bounds (sharps/flats)
---midi_selpitch1 : MIDI editor background color, selected pitch (naturals)
---midi_selpitch2 : MIDI editor background color, selected pitch (sharps/flats)
---midi_selbg : MIDI editor time selection color
---midi_selbg_drawmode : MIDI editor time selection fill mode
---midi_gridhc : MIDI editor CC horizontal center line
---midi_gridhcdm : MIDI editor CC horizontal center line - draw mode
---midi_gridh : MIDI editor CC horizontal line
---midi_gridhdm : MIDI editor CC horizontal line - draw mode
---midi_ccbut : MIDI editor CC lane add/remove buttons
---midi_ccbut_text : MIDI editor CC lane button text
---midi_ccbut_arrow : MIDI editor CC lane button arrow
---midioct : MIDI editor octave line color
---midi_inline_trackbg1 : MIDI inline background color (naturals)
---midi_inline_trackbg2 : MIDI inline background color (sharps/flats)
---midioct_inline : MIDI inline octave line color
---midi_endpt : MIDI editor end marker
---midi_notebg : MIDI editor note, unselected (midi_note_colormap overrides)
---midi_notefg : MIDI editor note, selected (midi_note_colormap overrides)
---midi_notemute : MIDI editor note, muted, unselected (midi_note_colormap overrides)
---midi_notemute_sel : MIDI editor note, muted, selected (midi_note_colormap overrides)
---midi_itemctl : MIDI editor note controls
---midi_ofsn : MIDI editor note (offscreen)
---midi_ofsnsel : MIDI editor note (offscreen, selected)
---midi_editcurs : MIDI editor cursor
---midi_pkey1 : MIDI piano key color (naturals background, sharps/flats text)
---midi_pkey2 : MIDI piano key color (sharps/flats background, naturals text)
---midi_pkey3 : MIDI piano key color (selected)
---midi_noteon_flash : MIDI piano key note-on flash
---midi_leftbg : MIDI piano pane background
---midifont_col_light_unsel : MIDI editor note text and control color, unselected (light)
---midifont_col_dark_unsel : MIDI editor note text and control color, unselected (dark)
---midifont_mode_unsel : MIDI editor note text and control mode, unselected
---midifont_col_light : MIDI editor note text and control color (light)
---midifont_col_dark : MIDI editor note text and control color (dark)
---midifont_mode : MIDI editor note text and control mode
---score_bg : MIDI notation editor background
---score_fg : MIDI notation editor staff/notation/text
---score_sel : MIDI notation editor selected staff/notation/text
---score_timesel : MIDI notation editor time selection
---score_loop : MIDI notation editor loop points, selected pitch
---midieditorlist_bg : MIDI list editor background
---midieditorlist_fg : MIDI list editor text
---midieditorlist_grid : MIDI list editor grid lines
---midieditorlist_selbg : MIDI list editor selected row
---midieditorlist_selfg : MIDI list editor selected text
---midieditorlist_seliabg : MIDI list editor selected row (inactive)
---midieditorlist_seliafg : MIDI list editor selected text (inactive)
---midieditorlist_bg2 : MIDI list editor background (secondary)
---midieditorlist_fg2 : MIDI list editor text (secondary)
---midieditorlist_selbg2 : MIDI list editor selected row (secondary)
---midieditorlist_selfg2 : MIDI list editor selected text (secondary)
---col_explorer_sel : Media explorer selection
---col_explorer_seldm : Media explorer selection mode
---col_explorer_seledge : Media explorer selection edge
---explorer_grid : Media explorer grid, markers
---explorer_pitchtext : Media explorer pitch detection text
---docker_shadow : Tab control shadow
---docker_selface : Tab control selected tab
---docker_unselface : Tab control unselected tab
---docker_text : Tab control text
---docker_text_sel : Tab control text selected tab
---docker_bg : Tab control background
---windowtab_bg : Tab control background in windows
---auto_item_unsel : Envelope: Unselected automation item
---col_env1 : Envelope: Volume (pre-FX)
---col_env2 : Envelope: Volume
---env_trim_vol : Envelope: Trim Volume
---col_env3 : Envelope: Pan (pre-FX)
---col_env4 : Envelope: Pan
---env_track_mute : Envelope: Mute
---col_env5 : Envelope: Master playrate
---col_env6 : Envelope: Master tempo
---col_env7 : Envelope: Width / Send volume
---col_env8 : Envelope: Send pan
---col_env9 : Envelope: Send volume 2
---col_env10 : Envelope: Send pan 2
---env_sends_mute : Envelope: Send mute
---col_env11 : Envelope: Audio hardware output volume
---col_env12 : Envelope: Audio hardware output pan
---col_env13 : Envelope: FX parameter 1
---col_env14 : Envelope: FX parameter 2
---col_env15 : Envelope: FX parameter 3
---col_env16 : Envelope: FX parameter 4
---env_item_vol : Envelope: Item take volume
---env_item_pan : Envelope: Item take pan
---env_item_mute : Envelope: Item take mute
---env_item_pitch : Envelope: Item take pitch
---wiring_grid2 : Wiring: Background
---wiring_grid : Wiring: Background grid lines
---wiring_border : Wiring: Box border
---wiring_tbg : Wiring: Box background
---wiring_ticon : Wiring: Box foreground
---wiring_recbg : Wiring: Record section background
---wiring_recitem : Wiring: Record section foreground
---wiring_media : Wiring: Media
---wiring_recv : Wiring: Receives
---wiring_send : Wiring: Sends
---wiring_fader : Wiring: Fader
---wiring_parent : Wiring: Master/Parent
---wiring_parentwire_border : Wiring: Master/Parent wire border
---wiring_parentwire_master : Wiring: Master/Parent to master wire
---wiring_parentwire_folder : Wiring: Master/Parent to parent folder wire
---wiring_pin_normal : Wiring: Pins normal
---wiring_pin_connected : Wiring: Pins connected
---wiring_pin_disconnected : Wiring: Pins disconnected
---wiring_horz_col : Wiring: Horizontal pin connections
---wiring_sendwire : Wiring: Send hanging wire
---wiring_hwoutwire : Wiring: Hardware output wire
---wiring_recinputwire : Wiring: Record input wire
---wiring_hwout : Wiring: System hardware outputs
---wiring_recinput : Wiring: System record inputs
---wiring_activity : Wiring: Activity lights
---autogroup : Automatic track group
---group_0 : Group #1
---group_1 : Group #2
---group_2 : Group #3
---group_3 : Group #4
---group_4 : Group #5
---group_5 : Group #6
---group_6 : Group #7
---group_7 : Group #8
---group_8 : Group #9
---group_9 : Group #10
---group_10 : Group #11
---group_11 : Group #12
---group_12 : Group #13
---group_13 : Group #14
---group_14 : Group #15
---group_15 : Group #16
---group_16 : Group #17
---group_17 : Group #18
---group_18 : Group #19
---group_19 : Group #20
---group_20 : Group #21
---group_21 : Group #22
---group_22 : Group #23
---group_23 : Group #24
---group_24 : Group #25
---group_25 : Group #26
---group_26 : Group #27
---group_27 : Group #28
---group_28 : Group #29
---group_29 : Group #30
---group_30 : Group #31
---group_31 : Group #32
---group_32 : Group #33
---group_33 : Group #34
---group_34 : Group #35
---group_35 : Group #36
---group_36 : Group #37
---group_37 : Group #38
---group_38 : Group #39
---group_39 : Group #40
---group_40 : Group #41
---group_41 : Group #42
---group_42 : Group #43
---group_43 : Group #44
---group_44 : Group #45
---group_45 : Group #46
---group_46 : Group #47
---group_47 : Group #48
---group_48 : Group #49
---group_49 : Group #50
---group_50 : Group #51
---group_51 : Group #52
---group_52 : Group #53
---group_53 : Group #54
---group_54 : Group #55
---group_55 : Group #56
---group_56 : Group #57
---group_57 : Group #58
---group_58 : Group #59
---group_59 : Group #60
---group_60 : Group #61
---group_61 : Group #62
---group_62 : Group #63
---group_63 : Group #64
---@param ini_key string
---@param color integer
---@param flags integer
---@return integer rv
function reaper.SetThemeColor(ini_key, color, flags) end

---Updates the toggle state of an action, returns true if succeeded. Only ReaScripts can have their toggle states changed programmatically. See RefreshToolbar2.
---@param section_id integer
---@param command_id integer
---@param state integer
---@return boolean rv
function reaper.SetToggleCommandState(section_id, command_id, state) end

---@param tr MediaTrack
---@param mode integer
function reaper.SetTrackAutomationMode(tr, mode) end

---Set the custom track color, color is OS dependent (i.e. ColorToNative(r,g,b). To unset the track color, see SetMediaTrackInfo_Value I_CUSTOMCOLOR
---@param track MediaTrack
---@param color integer
function reaper.SetTrackColor(track, color) end

---Set all MIDI lyrics on the track. Lyrics will be stuffed into any MIDI items found in range. Flag is unused at present. str is passed in as beat position, tab, text, tab (example with flag=2: "1.1.2\tLyric for measure 1 beat 2\t2.1.1\tLyric for measure 2 beat 1	"). See GetTrackMIDILyrics
---@param track MediaTrack
---@param flag integer
---@param str string
---@return boolean rv
function reaper.SetTrackMIDILyrics(track, flag, str) end

---channel < 0 assigns these note names to all channels.
---@param track integer
---@param pitch integer
---@param chan integer
---@param name string
---@return boolean rv
function reaper.SetTrackMIDINoteName(track, pitch, chan, name) end

---channel < 0 assigns note name to all channels. pitch 128 assigns name for CC0, pitch 129 for CC1, etc.
---@param proj ReaProject|nil|0
---@param track MediaTrack
---@param pitch integer
---@param chan integer
---@param name string
---@return boolean rv
function reaper.SetTrackMIDINoteNameEx(proj, track, pitch, chan, name) end

---@param track MediaTrack
---@param selected boolean
function reaper.SetTrackSelected(track, selected) end

---@alias SetTrackSendInfo_Value_Param
---| "'B_MUTE'" bool *
---| "'B_PHASE'" bool * : true to flip phase
---| "'B_MONO'" bool *
---| "'D_VOL'" double * : 1.0 = +0dB etc
---| "'D_PAN'" double * : -1..+1
---| "'D_PANLAW'" double * : 1.0=+0.0db, 0.5=-6dB, -1.0 = projdef etc
---| "'I_SENDMODE'" int * : 0=post-fader, 1=pre-fx, 2=post-fx (deprecated), 3=post-fx
---| "'I_AUTOMODE'" int * : automation mode (-1=use track automode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch)
---| "'I_SRCCHAN'" int * : -1 for no audio send. Low 10 bits specify channel offset, and higher bits specify channel count. (srcchan>>10) == 0 for stereo, 1 for mono, 2 for 4 channel, 3 for 6 channel, etc.
---| "'I_DSTCHAN'" int * : low 10 bits are destination index, &1024 set to mix to mono.
---| "'I_MIDIFLAGS'" int * : low 5 bits=source channel 0=all, 1-16, 31=MIDI send disabled, next 5 bits=dest channel, 0=orig, 1-16=chan. &1024 for faders-send MIDI vol/pan. (>>14)&255 = src bus (0 for all, 1 for normal, 2+). (>>22)&255=destination bus (0 for all, 1 for normal, 2+)

---Set send/receive/hardware output numerical-value attributes, return true on success.
---category is <0 for receives, 0=sends, >0 for hardware outputs
---parameter names:
---B_MUTE : bool *
---B_PHASE : bool * : true to flip phase
---B_MONO : bool *
---D_VOL : double * : 1.0 = +0dB etc
---D_PAN : double * : -1..+1
---D_PANLAW : double * : 1.0=+0.0db, 0.5=-6dB, -1.0 = projdef etc
---I_SENDMODE : int * : 0=post-fader, 1=pre-fx, 2=post-fx (deprecated), 3=post-fx
---I_AUTOMODE : int * : automation mode (-1=use track automode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch)
---I_SRCCHAN : int * : -1 for no audio send. Low 10 bits specify channel offset, and higher bits specify channel count. (srcchan>>10) == 0 for stereo, 1 for mono, 2 for 4 channel, 3 for 6 channel, etc.
---I_DSTCHAN : int * : low 10 bits are destination index, &1024 set to mix to mono.
---I_MIDIFLAGS : int * : low 5 bits=source channel 0=all, 1-16, 31=MIDI send disabled, next 5 bits=dest channel, 0=orig, 1-16=chan. &1024 for faders-send MIDI vol/pan. (>>14)&255 = src bus (0 for all, 1 for normal, 2+). (>>22)&255=destination bus (0 for all, 1 for normal, 2+)
---See CreateTrackSend, RemoveTrackSend, GetTrackNumSends.
---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@param parmname SetTrackSendInfo_Value_Param
---@param newvalue number
---@return boolean rv
function reaper.SetTrackSendInfo_Value(tr, category, sendidx, parmname, newvalue) end

---send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1 for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
---@param track MediaTrack
---@param send_idx integer
---@param pan number
---@param isend integer
---@return boolean rv
function reaper.SetTrackSendUIPan(track, send_idx, pan, isend) end

---send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1 for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
---@param track MediaTrack
---@param send_idx integer
---@param vol number
---@param isend integer
---@return boolean rv
function reaper.SetTrackSendUIVol(track, send_idx, vol, isend) end

---Sets the RPPXML state of a track, returns true if successful. Undo flag is a performance/caching hint.
---@param track MediaTrack
---@param str string
---@param isundo boolean
---@return boolean rv
function reaper.SetTrackStateChunk(track, str, isundo) end

---monitor: 0=no monitoring, 1=monitoring, 2=auto-monitoring. returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param monitor integer
---@param igngroupflags integer
---@return integer rv
function reaper.SetTrackUIInputMonitor(track, monitor, igngroupflags) end

---mute: <0 toggles, >0 sets mute, 0=unsets mute. returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param mute integer
---@param igngroupflags integer
---@return integer rv
function reaper.SetTrackUIMute(track, mute, igngroupflags) end

---igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param pan number
---@param relative boolean
---@param done boolean
---@param igngroupflags integer
---@return number num
function reaper.SetTrackUIPan(track, pan, relative, done, igngroupflags) end

---polarity (AKA phase): <0 toggles, 0=normal, >0=inverted. returns new value or -1 if error.igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param polarity integer
---@param igngroupflags integer
---@return integer rv
function reaper.SetTrackUIPolarity(track, polarity, igngroupflags) end

---recarm: <0 toggles, >0 sets recarm, 0=unsets recarm. returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param recarm integer
---@param igngroupflags integer
---@return integer rv
function reaper.SetTrackUIRecArm(track, recarm, igngroupflags) end

---solo: <0 toggles, 1 sets solo (default mode), 0=unsets solo, 2 sets solo (non-SIP), 4 sets solo (SIP). returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param solo integer
---@param igngroupflags integer
---@return integer rv
function reaper.SetTrackUISolo(track, solo, igngroupflags) end

---igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param volume number
---@param relative boolean
---@param done boolean
---@param igngroupflags integer
---@return number num
function reaper.SetTrackUIVolume(track, volume, relative, done, igngroupflags) end

---igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
---@param track MediaTrack
---@param width number
---@param relative boolean
---@param done boolean
---@param igngroupflags integer
---@return number num
function reaper.SetTrackUIWidth(track, width, relative, done, igngroupflags) end

---@param section KbdSectionInfo|integer
---@param callerWnd HWND
function reaper.ShowActionList(section, callerWnd) end

---Show a message to the user (also useful for debugging). Send "\n" for newline, "" to clear the console. Prefix string with "!SHOW:" and text will be added to console without opening the window. See ClearConsole
---@param msg string
function reaper.ShowConsoleMsg(msg) end

---type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL : ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
---@param msg string
---@param title string
---@param type integer
---@return integer rv
function reaper.ShowMessageBox(msg, title, type) end

---shows a context menu, valid names include: track_input, track_panel, track_area, track_routing, item, ruler, envelope, envelope_point, envelope_item. ctxOptional can be a track pointer for track_*, item pointer for item* (but is optional). for envelope_point, ctx2Optional has point index, ctx3Optional has item index (0=main envelope, 1=first AI). for envelope_item, ctx2Optional has AI index (1=first AI)
---@param name string
---@param x integer?
---@param y integer?
---@param hwndParent HWND?
---@param ctx userdata?
---@param ctx2 integer?
---@param ctx3 integer?
function reaper.ShowPopupMenu(name, x, y, hwndParent, ctx, ctx2, ctx3) end

---@param y number
---@return number num
function reaper.SLIDER2DB(y) end

---@param project ReaProject|nil|0
---@param time_pos number
---@return number num
function reaper.SnapToGrid(project, time_pos) end

---solo=2 for SIP
---@param solo integer
function reaper.SoloAllTracks(solo) end

---gets the splash window, in case you want to display a message over it. Returns NULL when the splash window is not displayed.
---@return HWND rv
function reaper.Splash_GetWnd() end

---the original item becomes the left-hand split, the function returns the right-hand split (or NULL if the split failed)
---@param item MediaItem
---@param position number
---@return MediaItem rv
function reaper.SplitMediaItem(item, position) end

---@param str string
---@param gGUID string
---@return string gGUID
function reaper.stringToGuid(str, gGUID) end

---Stuffs a 3 byte MIDI message into either the Virtual MIDI Keyboard queue, or the MIDI-as-control input queue, or sends to a MIDI hardware output. mode=0 for VKB, 1 for control (actions map etc), 2 for VKB-on-current-channel; 16 for external MIDI device 0, 17 for external MIDI device 1, etc; see GetNumMIDIOutputs, GetMIDIOutputName.
---@param mode integer
---@param msg1 integer
---@param msg2 integer
---@param msg3 integer
function reaper.StuffMIDIMessage(mode, msg1, msg2, msg3) end

---Adds or queries the position of a named FX in a take. See TrackFX_AddByName() for information on fxname and instantiate. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fxname string
---@param instantiate integer
---@return integer rv
function reaper.TakeFX_AddByName(take, fxname, instantiate) end

---Copies (or moves) FX from src_take to dest_take. Can be used with src_take=dest_take to reorder. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param src_take MediaItem_Take
---@param src_fx integer
---@param dest_take MediaItem_Take
---@param dest_fx integer
---@param is_move boolean
function reaper.TakeFX_CopyToTake(src_take, src_fx, dest_take, dest_fx, is_move) end

---Copies (or moves) FX from src_take to dest_track. dest_fx can have 0x1000000 set to reference input FX. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param src_take MediaItem_Take
---@param src_fx integer
---@param dest_track MediaTrack
---@param dest_fx integer
---@param is_move boolean
function reaper.TakeFX_CopyToTrack(src_take, src_fx, dest_track, dest_fx, is_move) end

---Remove a FX from take chain (returns true on success) FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean rv
function reaper.TakeFX_Delete(take, fx) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean rv
function reaper.TakeFX_EndParamEdit(take, fx, param) end

---Note: only works with FX that support Cockos VST extensions. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param val number
---@return boolean rv
---@return string buf
function reaper.TakeFX_FormatParamValue(take, fx, param, val) end

---Note: only works with FX that support Cockos VST extensions. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param value number
---@param buf string
---@return boolean rv
---@return string buf
function reaper.TakeFX_FormatParamValueNormalized(take, fx, param, value, buf) end

---returns index of effect visible in chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
---@param take MediaItem_Take
---@return integer rv
function reaper.TakeFX_GetChainVisible(take) end

---@param take MediaItem_Take
---@return integer rv
function reaper.TakeFX_GetCount(take) end

---See TakeFX_SetEnabled FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean rv
function reaper.TakeFX_GetEnabled(take, fx) end

---Returns the FX parameter envelope. If the envelope does not exist and create=true, the envelope will be created. If the envelope already exists and is bypassed and create=true, then the envelope will be unbypassed. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fxindex integer
---@param parameterindex integer
---@param create boolean
---@return TrackEnvelope rv
function reaper.TakeFX_GetEnvelope(take, fxindex, parameterindex, create) end

---returns HWND of floating window for effect index, if any FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param index integer
---@return HWND rv
function reaper.TakeFX_GetFloatingWindow(take, index) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean rv
---@return string buf
function reaper.TakeFX_GetFormattedParamValue(take, fx, param) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return string GUID
function reaper.TakeFX_GetFXGUID(take, fx) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean rv
---@return string buf
function reaper.TakeFX_GetFXName(take, fx) end

---Gets the number of input/output pins for FX if available, returns plug-in type or -1 on error FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return integer rv
---@return integer inputPins
---@return integer outputPins
function reaper.TakeFX_GetIOSize(take, fx) end

---gets plug-in specific named configuration value (returns true on success). see TrackFX_GetNamedConfigParm FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param parmname string
---@return boolean rv
---@return string buf
function reaper.TakeFX_GetNamedConfigParm(take, fx, parmname) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return integer rv
function reaper.TakeFX_GetNumParams(take, fx) end

---See TakeFX_SetOffline FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean rv
function reaper.TakeFX_GetOffline(take, fx) end

---Returns true if this FX UI is open in the FX chain window or a floating window. See TakeFX_SetOpen FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean rv
function reaper.TakeFX_GetOpen(take, fx) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number num
---@return number minval
---@return number maxval
function reaper.TakeFX_GetParam(take, fx, param) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean rv
---@return number step
---@return number smallstep
---@return number largestep
---@return boolean istoggle
function reaper.TakeFX_GetParameterStepSizes(take, fx, param) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number num
---@return number minval
---@return number maxval
---@return number midval
function reaper.TakeFX_GetParamEx(take, fx, param) end

---gets the parameter index from an identifying string (:wet, :bypass, or a string returned from GetParamIdent), or -1 if unknown. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param ident_str string
---@return integer rv
function reaper.TakeFX_GetParamFromIdent(take, fx, ident_str) end

---gets an identifying string for the parameter FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean rv
---@return string buf
function reaper.TakeFX_GetParamIdent(take, fx, param) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean rv
---@return string buf
function reaper.TakeFX_GetParamName(take, fx, param) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number num
function reaper.TakeFX_GetParamNormalized(take, fx, param) end

---gets the effective channel mapping bitmask for a particular pin. high32Out will be set to the high 32 bits. Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param isoutput integer
---@param pin integer
---@return integer rv
---@return integer high32
function reaper.TakeFX_GetPinMappings(take, fx, isoutput, pin) end

---Get the name of the preset currently showing in the REAPER dropdown, or the full path to a factory preset file for VST3 plug-ins (.vstpreset). See TakeFX_SetPreset. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return boolean rv
---@return string presetname
function reaper.TakeFX_GetPreset(take, fx) end

---Returns current preset index, or -1 if error. numberOfPresetsOut will be set to total number of presets available. See TakeFX_SetPresetByIndex FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return integer rv
---@return integer numberOfPresets
function reaper.TakeFX_GetPresetIndex(take, fx) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@return string fn
function reaper.TakeFX_GetUserPresetFilename(take, fx) end

---presetmove==1 activates the next preset, presetmove==-1 activates the previous preset, etc. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param presetmove integer
---@return boolean rv
function reaper.TakeFX_NavigatePresets(take, fx, presetmove) end

---See TakeFX_GetEnabled FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param enabled boolean
function reaper.TakeFX_SetEnabled(take, fx, enabled) end

---gets plug-in specific named configuration value (returns true on success). see TrackFX_SetNamedConfigParm FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param parmname string
---@param value string
---@return boolean rv
function reaper.TakeFX_SetNamedConfigParm(take, fx, parmname, value) end

---See TakeFX_GetOffline FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param offline boolean
function reaper.TakeFX_SetOffline(take, fx, offline) end

---Open this FX UI. See TakeFX_GetOpen FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param open boolean
function reaper.TakeFX_SetOpen(take, fx, open) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param val number
---@return boolean rv
function reaper.TakeFX_SetParam(take, fx, param, val) end

---FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param value number
---@return boolean rv
function reaper.TakeFX_SetParamNormalized(take, fx, param, value) end

---sets the channel mapping bitmask for a particular pin. returns false if unsupported (not all types of plug-ins support this capability). Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param isoutput integer
---@param pin integer
---@param low32bits integer
---@param hi32bits integer
---@return boolean rv
function reaper.TakeFX_SetPinMappings(take, fx, isoutput, pin, low32bits, hi32bits) end

---Activate a preset with the name shown in the REAPER dropdown. Full paths to .vstpreset files are also supported for VST3 plug-ins. See TakeFX_GetPreset. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param presetname string
---@return boolean rv
function reaper.TakeFX_SetPreset(take, fx, presetname) end

---Sets the preset idx, or the factory preset (idx==-2), or the default user preset (idx==-1). Returns true on success. See TakeFX_GetPresetIndex. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param fx integer
---@param idx integer
---@return boolean rv
function reaper.TakeFX_SetPresetByIndex(take, fx, idx) end

---showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating window(index valid), =3 for show floating window (index valid) FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param take MediaItem_Take
---@param index integer
---@param showFlag integer
function reaper.TakeFX_Show(take, index, showFlag) end

---Returns true if the active take contains MIDI.
---@param take MediaItem_Take
---@return boolean rv
function reaper.TakeIsMIDI(take) end

---Gets theme layout information. section can be 'global' for global layout override, 'seclist' to enumerate a list of layout sections, otherwise a layout section such as 'mcp', 'tcp', 'trans', etc. idx can be -1 to query the current value, -2 to get the description of the section (if not global), -3 will return the current context DPI-scaling (256=normal, 512=retina, etc), or 0..x. returns false if failed.
---@param section string
---@param idx integer
---@return boolean rv
---@return string name
function reaper.ThemeLayout_GetLayout(section, idx) end

---returns theme layout parameter. return value is cfg-name, or nil/empty if out of range.
---@param wp integer
---@return string str
---@return string? desc
---@return integer? value
---@return integer? defValue
---@return integer? minValue
---@return integer? maxValue
function reaper.ThemeLayout_GetParameter(wp) end

---Refreshes all layouts
function reaper.ThemeLayout_RefreshAll() end

---Sets theme layout override for a particular section -- section can be 'global' or 'mcp' etc. If setting global layout, prefix a ! to the layout string to clear any per-layout overrides. Returns false if failed.
---@param section string
---@param layout string
---@return boolean rv
function reaper.ThemeLayout_SetLayout(section, layout) end

---sets theme layout parameter to value. persist=true in order to have change loaded on next theme load. note that the caller should update layouts via ??? to make changes visible.
---@param wp integer
---@param value integer
---@param persist boolean
---@return boolean rv
function reaper.ThemeLayout_SetParameter(wp, value, persist) end

---Gets a precise system timestamp in seconds
---@return number num
function reaper.time_precise() end

---convert a beat position (or optionally a beats+measures if measures is non-NULL) to time.
---@param proj ReaProject|nil|0
---@param tpos number
---@param measuresIn integer?
---@return number num
function reaper.TimeMap2_beatsToTime(proj, tpos, measuresIn) end

---get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
---@param proj ReaProject|nil|0
---@param time number
---@return number num
function reaper.TimeMap2_GetDividedBpmAtTime(proj, time) end

---when does the next time map (tempo or time sig) change occur
---@param proj ReaProject|nil|0
---@param time number
---@return number num
function reaper.TimeMap2_GetNextChangeTime(proj, time) end

---converts project QN position to time.
---@param proj ReaProject|nil|0
---@param qn number
---@return number num
function reaper.TimeMap2_QNToTime(proj, qn) end

---convert a time into beats.
---if measures is non-NULL, measures will be set to the measure count, return value will be beats since measure.
---if cml is non-NULL, will be set to current measure length in beats (i.e. time signature numerator)
---if fullbeats is non-NULL, and measures is non-NULL, fullbeats will get the full beat count (same value returned if measures is NULL).
---if cdenom is non-NULL, will be set to the current time signature denominator.
---@param proj ReaProject|nil|0
---@param tpos number
---@return number num
---@return integer? measures
---@return integer? cml
---@return number? fullbeats
---@return integer? cdenom
function reaper.TimeMap2_timeToBeats(proj, tpos) end

---converts project time position to QN position.
---@param proj ReaProject|nil|0
---@param tpos number
---@return number num
function reaper.TimeMap2_timeToQN(proj, tpos) end

---Gets project framerate, and optionally whether it is drop-frame timecode
---@param proj ReaProject|nil|0
---@return number num
---@return boolean dropFrame
function reaper.TimeMap_curFrameRate(proj) end

---get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
---@param time number
---@return number num
function reaper.TimeMap_GetDividedBpmAtTime(time) end

---Get the QN position and time signature information for the start of a measure. Return the time in seconds of the measure start.
---@param proj ReaProject|nil|0
---@param measure integer
---@return number num
---@return number qn_start
---@return number qn_end
---@return integer timesig_num
---@return integer timesig_denom
---@return number tempo
function reaper.TimeMap_GetMeasureInfo(proj, measure) end

---Fills in a string representing the active metronome pattern. For example, in a 7/8 measure divided 3+4, the pattern might be "ABCABCD". For backwards compatibility, by default the function will return 1 for each primary beat and 2 for each non-primary beat, so "1221222" in this example, and does not support triplets. If buf is set to "EXTENDED", the function will return the full string as displayed in the pattern editor, including all beat types and triplet representations. Pass in "SET:string" with a correctly formed pattern string matching the current time signature numerator to set the click pattern. The time signature numerator can be deduced from the returned string, and the function returns the time signature denominator.
---@param proj ReaProject|nil|0
---@param time number
---@param pattern string
---@return integer rv
---@return string pattern
function reaper.TimeMap_GetMetronomePattern(proj, time, pattern) end

---get the effective time signature and tempo
---@param proj ReaProject|nil|0
---@param time number
---@return integer timesig_num
---@return integer timesig_denom
---@return number tempo
function reaper.TimeMap_GetTimeSigAtTime(proj, time) end

---Find which measure the given QN position falls in.
---@param proj ReaProject|nil|0
---@param qn number
---@return integer rv
---@return number? qnMeasureStart
---@return number? qnMeasureEnd
function reaper.TimeMap_QNToMeasures(proj, qn) end

---converts project QN position to time.
---@param qn number
---@return number num
function reaper.TimeMap_QNToTime(qn) end

---Converts project quarter note count (QN) to time. QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_QNToTime
---@param proj ReaProject|nil|0
---@param qn number
---@return number num
function reaper.TimeMap_QNToTime_abs(proj, qn) end

---converts project QN position to time.
---@param tpos number
---@return number num
function reaper.TimeMap_timeToQN(tpos) end

---Converts project time position to quarter note count (QN). QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_timeToQN
---@param proj ReaProject|nil|0
---@param tpos number
---@return number num
function reaper.TimeMap_timeToQN_abs(proj, tpos) end

---send_idx<0 for receives, >=0 for hw ouputs, >=nb_of_hw_ouputs for sends.
---@param track MediaTrack
---@param send_idx integer
---@return boolean rv
function reaper.ToggleTrackSendUIMute(track, send_idx) end

---Returns meter hold state, in dB*0.01 (0 = +0dB, -0.01 = -1dB, 0.02 = +2dB, etc). If clear is set, clears the meter hold. If channel==1024 or channel==1025, returns loudness values if this is the master track or this track's VU meters are set to display loudness.
---@param track MediaTrack
---@param channel integer
---@param clear boolean
---@return number num
function reaper.Track_GetPeakHoldDB(track, channel, clear) end

---Returns peak meter value (1.0=+0dB, 0.0=-inf) for channel. If channel==1024 or channel==1025, returns loudness values if this is the master track or this track's VU meters are set to display loudness.
---@param track MediaTrack
---@param channel integer
---@return number num
function reaper.Track_GetPeakInfo(track, channel) end

---displays tooltip at location, or removes if empty string
---@param fmt string
---@param xpos integer
---@param ypos integer
---@param topmost boolean
function reaper.TrackCtl_SetToolTip(fmt, xpos, ypos, topmost) end

---Adds or queries the position of a named FX from the track FX chain (recFX=false) or record input FX/monitoring FX (recFX=true, monitoring FX are on master track). Specify a negative value for instantiate to always create a new effect, 0 to only query the first instance of an effect, or a positive value to add an instance if one is not found. If instantiate is <= -1000, it is used for the insertion position (-1000 is first item in chain, -1001 is second, etc). fxname can have prefix to specify type: VST3:,VST2:,VST:,AU:,JS:, or DX:, or FXADD: which adds selected items from the currently-open FX browser, FXADD:2 to limit to 2 FX added, or FXADD:2e to only succeed if exactly 2 FX are selected. Returns -1 on failure or the new position in chain on success. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fxname string
---@param recFX boolean
---@param instantiate integer
---@return integer rv
function reaper.TrackFX_AddByName(track, fxname, recFX, instantiate) end

---Copies (or moves) FX from src_track to dest_take. src_fx can have 0x1000000 set to reference input FX. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param src_track MediaTrack
---@param src_fx integer
---@param dest_take MediaItem_Take
---@param dest_fx integer
---@param is_move boolean
function reaper.TrackFX_CopyToTake(src_track, src_fx, dest_take, dest_fx, is_move) end

---Copies (or moves) FX from src_track to dest_track. Can be used with src_track=dest_track to reorder, FX indices have 0x1000000 set to reference input FX. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param src_track MediaTrack
---@param src_fx integer
---@param dest_track MediaTrack
---@param dest_fx integer
---@param is_move boolean
function reaper.TrackFX_CopyToTrack(src_track, src_fx, dest_track, dest_fx, is_move) end

---Remove a FX from track chain (returns true on success) FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean rv
function reaper.TrackFX_Delete(track, fx) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean rv
function reaper.TrackFX_EndParamEdit(track, fx, param) end

---Note: only works with FX that support Cockos VST extensions. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@param val number
---@return boolean rv
---@return string buf
function reaper.TrackFX_FormatParamValue(track, fx, param, val) end

---Note: only works with FX that support Cockos VST extensions. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@param value number
---@param buf string
---@return boolean rv
---@return string buf
function reaper.TrackFX_FormatParamValueNormalized(track, fx, param, value, buf) end

---Get the index of the first track FX insert that matches fxname. If the FX is not in the chain and instantiate is true, it will be inserted. See TrackFX_GetInstrument, TrackFX_GetEQ. Deprecated in favor of TrackFX_AddByName.
---@param track MediaTrack
---@param fxname string
---@param instantiate boolean
---@return integer rv
function reaper.TrackFX_GetByName(track, fxname, instantiate) end

---returns index of effect visible in chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
---@param track MediaTrack
---@return integer rv
function reaper.TrackFX_GetChainVisible(track) end

---@param track MediaTrack
---@return integer rv
function reaper.TrackFX_GetCount(track) end

---See TrackFX_SetEnabled FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean rv
function reaper.TrackFX_GetEnabled(track, fx) end

---Get the index of ReaEQ in the track FX chain. If ReaEQ is not in the chain and instantiate is true, it will be inserted. See TrackFX_GetInstrument, TrackFX_GetByName.
---@param track MediaTrack
---@param instantiate boolean
---@return integer rv
function reaper.TrackFX_GetEQ(track, instantiate) end

---Returns true if the EQ band is enabled.
---Returns false if the band is disabled, or if track/fxidx is not ReaEQ.
---Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass.
---Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc.
---See TrackFX_GetEQ, TrackFX_GetEQParam, TrackFX_SetEQParam, TrackFX_SetEQBandEnabled. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fxidx integer
---@param bandtype integer
---@param bandidx integer
---@return boolean rv
function reaper.TrackFX_GetEQBandEnabled(track, fxidx, bandtype, bandidx) end

---Returns false if track/fxidx is not ReaEQ.
---Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass.
---Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc.
---Paramtype (ignored for master gain): 0=freq, 1=gain, 2=Q.
---See TrackFX_GetEQ, TrackFX_SetEQParam, TrackFX_GetEQBandEnabled, TrackFX_SetEQBandEnabled. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fxidx integer
---@param paramidx integer
---@return boolean rv
---@return integer bandtype
---@return integer bandidx
---@return integer paramtype
---@return number normval
function reaper.TrackFX_GetEQParam(track, fxidx, paramidx) end

---returns HWND of floating window for effect index, if any FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param index integer
---@return HWND rv
function reaper.TrackFX_GetFloatingWindow(track, index) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean rv
---@return string buf
function reaper.TrackFX_GetFormattedParamValue(track, fx, param) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return string GUID
function reaper.TrackFX_GetFXGUID(track, fx) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean rv
---@return string buf
function reaper.TrackFX_GetFXName(track, fx) end

---Get the index of the first track FX insert that is a virtual instrument, or -1 if none. See TrackFX_GetEQ, TrackFX_GetByName.
---@param track MediaTrack
---@return integer rv
function reaper.TrackFX_GetInstrument(track) end

---Gets the number of input/output pins for FX if available, returns plug-in type or -1 on error FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return integer rv
---@return integer inputPins
---@return integer outputPins
function reaper.TrackFX_GetIOSize(track, fx) end

---gets plug-in specific named configuration value (returns true on success). 
---Supported values for read:
---pdc : PDC latency
---in_pin_X : name of input pin X
---out_pin_X : name of output pin X
---fx_type : type string
---fx_ident : type-specific identifier
---fx_name : name of FX (also supported as original_name)
---GainReduction_dB : [ReaComp + other supported compressors]
---is_instrument : 1 if instrument, 0 if not (v7.40+)
---parent_container : FX ID of parent container, if any (v7.06+)
---container_count : [Container] number of FX in container
---container_item.X : FX ID of item in container (first item is container_item.0) (v7.06+)
---param.X.container_map.hint_id : unique ID of mapping (preserved if mapping order changes)
---param.X.container_map.delete : read this value in order to remove the mapping for this parameter
---container_map.add : read from this value to add a new container parameter mapping -- will return new parameter index (accessed via param.X.container_map.*)
---container_map.add.FXID.PARMIDX : read from this value to add/get container parameter mapping for FXID/PARMIDX -- will return the parameter index (accessed via param.X.container_map.*). FXID can be a full address (must be a child of the container) or a 0-based sub-index (v7.06+).
---container_map.get.FXID.PARMIDX : read from this value to get container parameter mapping for FXID/PARMIDX -- will return the parameter index (accessed via param.X.container_map.*). FXID can be a full address (must be a child of the container) or a 0-based sub-index (v7.06+).
---chain_pdc_actual : returns the actual chain latency in samples, only valid after playback has commenced, may be rounded up to block size.
---chain_pdc_reporting : returns the reported chain latency, always valid, not rounded to block size.
---Supported values for read/write:
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
---@return boolean rv
---@return string buf
function reaper.TrackFX_GetNamedConfigParm(track, fx, parmname) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return integer rv
function reaper.TrackFX_GetNumParams(track, fx) end

---See TrackFX_SetOffline FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean rv
function reaper.TrackFX_GetOffline(track, fx) end

---Returns true if this FX UI is open in the FX chain window or a floating window. See TrackFX_SetOpen FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean rv
function reaper.TrackFX_GetOpen(track, fx) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return number num
---@return number minval
---@return number maxval
function reaper.TrackFX_GetParam(track, fx, param) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean rv
---@return number step
---@return number smallstep
---@return number largestep
---@return boolean istoggle
function reaper.TrackFX_GetParameterStepSizes(track, fx, param) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return number num
---@return number minval
---@return number maxval
---@return number midval
function reaper.TrackFX_GetParamEx(track, fx, param) end

---gets the parameter index from an identifying string (:wet, :bypass, :delta, or a string returned from GetParamIdent), or -1 if unknown. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param ident_str string
---@return integer rv
function reaper.TrackFX_GetParamFromIdent(track, fx, ident_str) end

---gets an identifying string for the parameter FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean rv
---@return string buf
function reaper.TrackFX_GetParamIdent(track, fx, param) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean rv
---@return string buf
function reaper.TrackFX_GetParamName(track, fx, param) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@return number num
function reaper.TrackFX_GetParamNormalized(track, fx, param) end

---gets the effective channel mapping bitmask for a particular pin. high32Out will be set to the high 32 bits. Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param tr MediaTrack
---@param fx integer
---@param isoutput integer
---@param pin integer
---@return integer rv
---@return integer high32
function reaper.TrackFX_GetPinMappings(tr, fx, isoutput, pin) end

---Get the name of the preset currently showing in the REAPER dropdown, or the full path to a factory preset file for VST3 plug-ins (.vstpreset). See TrackFX_SetPreset. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return boolean rv
---@return string presetname
function reaper.TrackFX_GetPreset(track, fx) end

---Returns current preset index, or -1 if error. numberOfPresetsOut will be set to total number of presets available. See TrackFX_SetPresetByIndex FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return integer rv
---@return integer numberOfPresets
function reaper.TrackFX_GetPresetIndex(track, fx) end

---returns index of effect visible in record input chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
---@param track MediaTrack
---@return integer rv
function reaper.TrackFX_GetRecChainVisible(track) end

---returns count of record input FX. To access record input FX, use a FX indices [0x1000000..0x1000000+n). On the master track, this accesses monitoring FX rather than record input FX.
---@param track MediaTrack
---@return integer rv
function reaper.TrackFX_GetRecCount(track) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@return string fn
function reaper.TrackFX_GetUserPresetFilename(track, fx) end

---presetmove==1 activates the next preset, presetmove==-1 activates the previous preset, etc. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param presetmove integer
---@return boolean rv
function reaper.TrackFX_NavigatePresets(track, fx, presetmove) end

---See TrackFX_GetEnabled FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param enabled boolean
function reaper.TrackFX_SetEnabled(track, fx, enabled) end

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
---@return boolean rv
function reaper.TrackFX_SetEQBandEnabled(track, fxidx, bandtype, bandidx, enable) end

---Returns false if track/fxidx is not ReaEQ. Targets a band matching bandtype.
---Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass.
---Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc.
---Paramtype (ignored for master gain): 0=freq, 1=gain, 2=Q.
---See TrackFX_GetEQ, TrackFX_GetEQParam, TrackFX_GetEQBandEnabled, TrackFX_SetEQBandEnabled. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fxidx integer
---@param bandtype integer
---@param bandidx integer
---@param paramtype integer
---@param val number
---@param isnorm boolean
---@return boolean rv
function reaper.TrackFX_SetEQParam(track, fxidx, bandtype, bandidx, paramtype, val, isnorm) end

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
---@return boolean rv
function reaper.TrackFX_SetNamedConfigParm(track, fx, parmname, value) end

---See TrackFX_GetOffline FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param offline boolean
function reaper.TrackFX_SetOffline(track, fx, offline) end

---Open this FX UI. See TrackFX_GetOpen FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param open boolean
function reaper.TrackFX_SetOpen(track, fx, open) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@param val number
---@return boolean rv
function reaper.TrackFX_SetParam(track, fx, param, val) end

---FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param param integer
---@param value number
---@return boolean rv
function reaper.TrackFX_SetParamNormalized(track, fx, param, value) end

---sets the channel mapping bitmask for a particular pin. returns false if unsupported (not all types of plug-ins support this capability). Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param tr MediaTrack
---@param fx integer
---@param isoutput integer
---@param pin integer
---@param low32bits integer
---@param hi32bits integer
---@return boolean rv
function reaper.TrackFX_SetPinMappings(tr, fx, isoutput, pin, low32bits, hi32bits) end

---Activate a preset with the name shown in the REAPER dropdown. Full paths to .vstpreset files are also supported for VST3 plug-ins. See TrackFX_GetPreset. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param presetname string
---@return boolean rv
function reaper.TrackFX_SetPreset(track, fx, presetname) end

---Sets the preset idx, or the factory preset (idx==-2), or the default user preset (idx==-1). Returns true on success. See TrackFX_GetPresetIndex. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param fx integer
---@param idx integer
---@return boolean rv
function reaper.TrackFX_SetPresetByIndex(track, fx, idx) end

---showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating window(index valid), =3 for show floating window (index valid) FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
---@param track MediaTrack
---@param index integer
---@param showFlag integer
function reaper.TrackFX_Show(track, index, showFlag) end

---@param isMinor boolean
function reaper.TrackList_AdjustWindows(isMinor) end

function reaper.TrackList_UpdateAllExternalSurfaces() end

---call to start a new block
function reaper.Undo_BeginBlock() end

---call to start a new block
---@param proj ReaProject|nil|0
function reaper.Undo_BeginBlock2(proj) end

---returns string of next action,if able,NULL if not
---@param proj ReaProject|nil|0
---@return string str
function reaper.Undo_CanRedo2(proj) end

---returns string of last action,if able,NULL if not
---@param proj ReaProject|nil|0
---@return string str
function reaper.Undo_CanUndo2(proj) end

---nonzero if success
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.Undo_DoRedo2(proj) end

---nonzero if success
---@param proj ReaProject|nil|0
---@return integer rv
function reaper.Undo_DoUndo2(proj) end

---call to end the block,with extra flags if any,and a description
---@param descchange string
---@param extraflags integer
function reaper.Undo_EndBlock(descchange, extraflags) end

---call to end the block,with extra flags if any,and a description
---@param proj ReaProject|nil|0
---@param descchange string
---@param extraflags integer
function reaper.Undo_EndBlock2(proj, descchange, extraflags) end

---limited state change to items
---@param descchange string
function reaper.Undo_OnStateChange(descchange) end

---limited state change to items
---@param proj ReaProject|nil|0
---@param descchange string
function reaper.Undo_OnStateChange2(proj, descchange) end

---@param proj ReaProject|nil|0
---@param name string
---@param item MediaItem
function reaper.Undo_OnStateChange_Item(proj, name, item) end

---trackparm=-1 by default,or if updating one fx chain,you can specify track index
---@param descchange string
---@param whichStates integer
---@param trackparm integer
function reaper.Undo_OnStateChangeEx(descchange, whichStates, trackparm) end

---trackparm=-1 by default,or if updating one fx chain,you can specify track index
---@param proj ReaProject|nil|0
---@param descchange string
---@param whichStates integer
---@param trackparm integer
function reaper.Undo_OnStateChangeEx2(proj, descchange, whichStates, trackparm) end

---Redraw the arrange view
function reaper.UpdateArrange() end

---@param item MediaItem
function reaper.UpdateItemInProject(item) end

---Recalculate lane arrangement for fixed lane tracks, including auto-removing empty lanes at the bottom of the track
---@param proj ReaProject|nil|0
---@return boolean rv
function reaper.UpdateItemLanes(proj) end

---Redraw the arrange view and ruler
function reaper.UpdateTimeline() end

---see ValidatePtr2
---@param pointer userdata
---@param ctypename string
---@return boolean rv
function reaper.ValidatePtr(pointer, ctypename) end

---Return true if the pointer is a valid object of the right type in proj (proj is ignored if pointer is itself a project). Supported types are: ReaProject*, MediaTrack*, MediaItem*, MediaItem_Take*, TrackEnvelope* and PCM_source*.
---@param proj ReaProject|nil|0
---@param pointer userdata
---@param ctypename string
---@return boolean rv
function reaper.ValidatePtr2(proj, pointer, ctypename) end

---Opens the prefs to a page, use pageByName if page is 0.
---@param page integer
---@param pageByName string
function reaper.ViewPrefs(page, pageByName) end

---[BR] Allocate envelope object from track or take envelope pointer. Always call BR_EnvFree when done to release the object and commit changes if needed.
--- takeEnvelopesUseProjectTime: take envelope points' positions are counted from take position, not project start time. If you want to work with project time instead, pass this as true.
---For further manipulation see BR_EnvCountPoints, BR_EnvDeletePoint, BR_EnvFind, BR_EnvFindNext, BR_EnvFindPrevious, BR_EnvGetParentTake, BR_EnvGetParentTrack, BR_EnvGetPoint, BR_EnvGetProperties, BR_EnvSetPoint, BR_EnvSetProperties, BR_EnvValueAtPos.
---@param envelope TrackEnvelope
---@param takeEnvelopesUseProjectTime boolean
---@return BR_Envelope rv
function reaper.BR_EnvAlloc(envelope, takeEnvelopesUseProjectTime) end

---[BR] Count envelope points in the envelope object allocated with BR_EnvAlloc.
---@param envelope BR_Envelope
---@return integer rv
function reaper.BR_EnvCountPoints(envelope) end

---[BR] Delete envelope point by index (zero-based) in the envelope object allocated with BR_EnvAlloc. Returns true on success.
---@param envelope BR_Envelope
---@param id integer
---@return boolean rv
function reaper.BR_EnvDeletePoint(envelope, id) end

---[BR] Find envelope point at time position in the envelope object allocated with BR_EnvAlloc. Pass delta > 0 to search surrounding range - in that case the closest point to position within delta will be searched for. Returns envelope point id (zero-based) on success or -1 on failure.
---@param envelope BR_Envelope
---@param position number
---@param delta number
---@return integer rv
function reaper.BR_EnvFind(envelope, position, delta) end

---[BR] Find next envelope point after time position in the envelope object allocated with BR_EnvAlloc. Returns envelope point id (zero-based) on success or -1 on failure.
---@param envelope BR_Envelope
---@param position number
---@return integer rv
function reaper.BR_EnvFindNext(envelope, position) end

---[BR] Find previous envelope point before time position in the envelope object allocated with BR_EnvAlloc. Returns envelope point id (zero-based) on success or -1 on failure.
---@param envelope BR_Envelope
---@param position number
---@return integer rv
function reaper.BR_EnvFindPrevious(envelope, position) end

---[BR] Free envelope object allocated with BR_EnvAlloc and commit changes if needed. Returns true if changes were committed successfully. Note that when envelope object wasn't modified nothing will get committed even if commit = true - in that case function returns false.
---@param envelope BR_Envelope
---@param commit boolean
---@return boolean rv
function reaper.BR_EnvFree(envelope, commit) end

---[BR] If envelope object allocated with BR_EnvAlloc is take envelope, returns parent media item take, otherwise NULL.
---@param envelope BR_Envelope
---@return MediaItem_Take rv
function reaper.BR_EnvGetParentTake(envelope) end

---[BR] Get parent track of envelope object allocated with BR_EnvAlloc. If take envelope, returns NULL.
---@param envelope BR_Envelope
---@return MediaTrack rv
function reaper.BR_EnvGetParentTrack(envelope) end

---[BR] Get envelope point by id (zero-based) from the envelope object allocated with BR_EnvAlloc. Returns true on success.
---@param envelope BR_Envelope
---@param id integer
---@return boolean rv
---@return number position
---@return number value
---@return integer shape
---@return boolean selected
---@return number bezier
function reaper.BR_EnvGetPoint(envelope, id) end

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

---[BR] Set envelope point by id (zero-based) in the envelope object allocated with BR_EnvAlloc. To create point instead, pass id = -1. Note that if new point is inserted or existing point's time position is changed, points won't automatically get sorted. To do that, see BR_EnvSortPoints.
---Returns true on success.
---@param envelope BR_Envelope
---@param id integer
---@param position number
---@param value number
---@param shape integer
---@param selected boolean
---@param bezier number
---@return boolean rv
function reaper.BR_EnvSetPoint(envelope, id, position, value, shape, selected, bezier) end

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
---@param automationItemsOptionsIn integer?
function reaper.BR_EnvSetProperties(envelope, active, visible, armed, inLane, laneHeight, defaultShape, faderScaling, automationItemsOptionsIn) end

---[BR] Sort envelope points by position. The only reason to call this is if sorted points are explicitly needed after editing them with BR_EnvSetPoint. Note that you do not have to call this before doing BR_EnvFree since it does handle unsorted points too.
---@param envelope BR_Envelope
function reaper.BR_EnvSortPoints(envelope) end

---[BR] Get envelope value at time position for the envelope object allocated with BR_EnvAlloc.
---@param envelope BR_Envelope
---@param position number
---@return number num
function reaper.BR_EnvValueAtPos(envelope, position) end

---[BR] Deprecated, see GetSet_ArrangeView2 (REAPER v5.12pre4+) -- Get start and end time position of arrange view. To set arrange view instead, see BR_SetArrangeView.
---@param proj ReaProject|nil|0
---@return number startTime
---@return number endTime
function reaper.BR_GetArrangeView(proj) end

---[BR] Get closest grid division to position. Note that this functions is different from SnapToGrid in two regards. SnapToGrid() needs snap enabled to work and this one works always. Secondly, grid divisions are different from grid lines because some grid lines may be hidden due to zoom level - this function ignores grid line visibility and always searches for the closest grid division at given position. For more grid division functions, see BR_GetNextGridDivision and BR_GetPrevGridDivision.
---@param position number
---@return number num
function reaper.BR_GetClosestGridDivision(position) end

---[BR] Get current theme information. themePathOut is set to full theme path and themeNameOut is set to theme name excluding any path info and extension
---@return string themePath
---@return string themeName
function reaper.BR_GetCurrentTheme() end

---[BR] Get media item from GUID string. Note that the GUID must be enclosed in braces {}. To get item's GUID as a string, see BR_GetMediaItemGUID.
---@param proj ReaProject|nil|0
---@param guidStringIn string
---@return MediaItem rv
function reaper.BR_GetMediaItemByGUID(proj, guidStringIn) end

---[BR] Get media item GUID as a string (guidStringOut_sz should be at least 64). To get media item back from GUID string, see BR_GetMediaItemByGUID.
---@param item MediaItem
---@return string guidString
function reaper.BR_GetMediaItemGUID(item) end

---[BR] Get currently loaded image resource and its flags for a given item. Returns false if there is no image resource set. To set image resource, see BR_SetMediaItemImageResource.
---@param item MediaItem
---@return boolean rv
---@return string image
---@return integer imageFlags
function reaper.BR_GetMediaItemImageResource(item) end

---[BR] Get media item take GUID as a string (guidStringOut_sz should be at least 64). To get take from GUID string, see SNM_GetMediaItemTakeByGUID.
---@param take MediaItem_Take
---@return string guidString
function reaper.BR_GetMediaItemTakeGUID(take) end

---[BR] Get take media source properties as they appear in Item properties. Returns false if take can't have them (MIDI items etc.).
---To set source properties, see BR_SetMediaSourceProperties.
---@param take MediaItem_Take
---@return boolean rv
---@return boolean section
---@return number start
---@return number length
---@return number fade
---@return boolean reverse
function reaper.BR_GetMediaSourceProperties(take) end

---[BR] Get media track from GUID string. Note that the GUID must be enclosed in braces {}. To get track's GUID as a string, see GetSetMediaTrackInfo_String.
---@param proj ReaProject|nil|0
---@param guidStringIn string
---@return MediaTrack rv
function reaper.BR_GetMediaTrackByGUID(proj, guidStringIn) end

---[BR] Get media track freeze count (if track isn't frozen at all, returns 0).
---@param track MediaTrack
---@return integer rv
function reaper.BR_GetMediaTrackFreezeCount(track) end

---[BR] Deprecated, see GetSetMediaTrackInfo_String (v5.95+). Get media track GUID as a string (guidStringOut_sz should be at least 64). To get media track back from GUID string, see BR_GetMediaTrackByGUID.
---@param track MediaTrack
---@return string guidString
function reaper.BR_GetMediaTrackGUID(track) end

---[BR] Deprecated, see GetSetMediaTrackInfo (REAPER v5.02+). Get media track layouts for MCP and TCP. Empty string ("") means that layout is set to the default layout. To set media track layouts, see BR_SetMediaTrackLayouts.
---@param track MediaTrack
---@return string mcpLayoutName
---@return string tcpLayoutName
function reaper.BR_GetMediaTrackLayouts(track) end

---[BR] Get track envelope for send/receive/hardware output.
---category is <0 for receives, 0=sends, >0 for hardware outputs
---sendidx is zero-based (see GetTrackNumSends to count track sends/receives/hardware outputs)
---envelopeType determines which envelope is returned (0=volume, 1=pan, 2=mute)
---Note: To get or set other send attributes, see BR_GetSetTrackSendInfo and BR_GetMediaTrackSendInfo_Track.
---@param track MediaTrack
---@param category integer
---@param sendidx integer
---@param envelopeType integer
---@return TrackEnvelope rv
function reaper.BR_GetMediaTrackSendInfo_Envelope(track, category, sendidx, envelopeType) end

---[BR] Get source or destination media track for send/receive.
---category is <0 for receives, 0=sends
---sendidx is zero-based (see GetTrackNumSends to count track sends/receives)
---trackType determines which track is returned (0=source track, 1=destination track)
---Note: To get or set other send attributes, see BR_GetSetTrackSendInfo and BR_GetMediaTrackSendInfo_Envelope.
---@param track MediaTrack
---@param category integer
---@param sendidx integer
---@param trackType integer
---@return MediaTrack rv
function reaper.BR_GetMediaTrackSendInfo_Track(track, category, sendidx, trackType) end

---[BR] Get MIDI take source length in PPQ. In case the take isn't MIDI, return value will be -1.
---@param take MediaItem_Take
---@return number num
function reaper.BR_GetMidiSourceLenPPQ(take) end

---[BR] Get MIDI take pool GUID as a string (guidStringOut_sz should be at least 64). Returns true if take is pooled.
---@param take MediaItem_Take
---@return boolean rv
---@return string guidString
function reaper.BR_GetMidiTakePoolGUID(take) end

---[BR] Get "ignore project tempo" information for MIDI take. Returns true if take can ignore project tempo (no matter if it's actually ignored), otherwise false.
---@param take MediaItem_Take
---@return boolean rv
---@return boolean ignoreProjTempo
---@return number bpm
---@return integer num
---@return integer den
function reaper.BR_GetMidiTakeTempoInfo(take) end

---[BR] Get mouse cursor context. Each parameter returns information in a form of string as specified in the table below.
---To get more info on stuff that was found under mouse cursor see BR_GetMouseCursorContext_Envelope, BR_GetMouseCursorContext_Item, BR_GetMouseCursorContext_MIDI, BR_GetMouseCursorContext_Position, BR_GetMouseCursorContext_Take, BR_GetMouseCursorContext_Track 
---Window Segment Details                                            unknown          ""            ""                                                             ruler            region_lane     ""                                                                                                                        marker_lane     ""                                                                                                                        tempo_lane      ""                                                                                                                        timeline        ""                                                             transport        ""            ""                                                             tcp              track           ""                                                                                                                        envelope        ""                                                                                                                        empty           ""                                                             mcp              track           ""                                                                                                                        empty           ""                                                             arrange          track           empty,
---item, item_stretch_marker,
---env_point, env_segment                                                              envelope        empty, env_point, env_segment                                                                                               empty           ""                                                             midi_editor      unknown         ""                                                                                                                        ruler           ""                                                                                                                        piano           ""                                                                                                                        notes           ""                                                                                                                        cc_lane         cc_selector, cc_lane
---@return string window
---@return string segment
---@return string details
function reaper.BR_GetMouseCursorContext() end

---[BR] Returns envelope that was captured with the last call to BR_GetMouseCursorContext. In case the envelope belongs to take, takeEnvelope will be true.
---@return TrackEnvelope rv
---@return boolean takeEnvelope
function reaper.BR_GetMouseCursorContext_Envelope() end

---[BR] Returns item under mouse cursor that was captured with the last call to BR_GetMouseCursorContext. Note that the function will return item even if mouse cursor is over some other track lane element like stretch marker or envelope. This enables for easier identification of items when you want to ignore elements within the item.
---@return MediaItem rv
function reaper.BR_GetMouseCursorContext_Item() end

---[BR] Returns midi editor under mouse cursor that was captured with the last call to BR_GetMouseCursorContext.
---inlineEditor: if mouse was captured in inline MIDI editor, this will be true (consequentially, returned MIDI editor will be NULL)
---noteRow: note row or piano key under mouse cursor (0-127)
---ccLane: CC lane under mouse cursor (CC0-127=CC, 0x100|(0-31)=14-bit CC, 0x200=velocity, 0x201=pitch, 0x202=program, 0x203=channel pressure, 0x204=bank/program select, 0x205=text, 0x206=sysex, 0x207=off velocity, 0x208=notation events)
---ccLaneVal: value in CC lane under mouse cursor (0-127 or 0-16383)
---ccLaneId: lane position, counting from the top (0 based)
---Note: due to API limitations, if mouse is over inline MIDI editor with some note rows hidden, noteRow will be -1
---@return userdata rv
---@return boolean inlineEditor
---@return integer noteRow
---@return integer ccLane
---@return integer ccLaneVal
---@return integer ccLaneId
function reaper.BR_GetMouseCursorContext_MIDI() end

---[BR] Returns project time position in arrange/ruler/midi editor that was captured with the last call to BR_GetMouseCursorContext.
---@return number num
function reaper.BR_GetMouseCursorContext_Position() end

---[BR] Returns id of a stretch marker under mouse cursor that was captured with the last call to BR_GetMouseCursorContext.
---@return integer rv
function reaper.BR_GetMouseCursorContext_StretchMarker() end

---[BR] Returns take under mouse cursor that was captured with the last call to BR_GetMouseCursorContext.
---@return MediaItem_Take rv
function reaper.BR_GetMouseCursorContext_Take() end

---[BR] Returns track under mouse cursor that was captured with the last call to BR_GetMouseCursorContext.
---@return MediaTrack rv
function reaper.BR_GetMouseCursorContext_Track() end

---[BR] Get next grid division after the time position. For more grid divisions function, see BR_GetClosestGridDivision and BR_GetPrevGridDivision.
---@param position number
---@return number num
function reaper.BR_GetNextGridDivision(position) end

---[BR] Get previous grid division before the time position. For more grid division functions, see BR_GetClosestGridDivision and BR_GetNextGridDivision.
---@param position number
---@return number num
function reaper.BR_GetPrevGridDivision(position) end

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
---@return number num
function reaper.BR_GetSetTrackSendInfo(track, category, sendidx, parmname, setNewValue, newValue) end

---[BR] Returns FX count for supplied take
---@param take MediaItem_Take
---@return integer rv
function reaper.BR_GetTakeFXCount(take) end

---[SWS] Check if take has MIDI inline editor open and returns true or false.
---@param take MediaItem_Take
---@return boolean rv
function reaper.BR_IsMidiOpenInInlineEditor(take) end

---[BR] Check if take is MIDI take, in case MIDI take is in-project MIDI source data, inProjectMidiOut will be true, otherwise false.
---@param take MediaItem_Take
---@return boolean rv
---@return boolean inProjectMidi
function reaper.BR_IsTakeMidi(take) end

---[BR] Get media item under mouse cursor. Position is mouse cursor position in arrange.
---@return MediaItem rv
---@return number position
function reaper.BR_ItemAtMouseCursor() end

---[BR] Remove CC lane in midi editor. Top visible CC lane is laneId 0. Returns true on success
---@param midiEditor userdata
---@param laneId integer
---@return boolean rv
function reaper.BR_MIDI_CCLaneRemove(midiEditor, laneId) end

---[BR] Replace CC lane in midi editor. Top visible CC lane is laneId 0. Returns true on success.
---Valid CC lanes: CC0-127=CC, 0x100|(0-31)=14-bit CC, 0x200=velocity, 0x201=pitch, 0x202=program, 0x203=channel pressure, 0x204=bank/program select, 0x205=text, 0x206=sysex, 0x207
---@param midiEditor userdata
---@param laneId integer
---@param newCC integer
---@return boolean rv
function reaper.BR_MIDI_CCLaneReplace(midiEditor, laneId, newCC) end

---[BR] Get position at mouse cursor. To check ruler along with arrange, pass checkRuler=true. Returns -1 if cursor is not over arrange/ruler.
---@param checkRuler boolean
---@return number num
function reaper.BR_PositionAtMouseCursor(checkRuler) end

---[BR] Deprecated, see GetSet_ArrangeView2 (REAPER v5.12pre4+) -- Set start and end time position of arrange view. To get arrange view instead, see BR_GetArrangeView.
---@param proj ReaProject|nil|0
---@param startTime number
---@param endTime number
function reaper.BR_SetArrangeView(proj, startTime, endTime) end

---[BR] Set item start and end edges' position - returns true in case of any changes
---@param item MediaItem
---@param startTime number
---@param endTime number
---@return boolean rv
function reaper.BR_SetItemEdges(item, startTime, endTime) end

---[BR] Set image resource and its flags for a given item. To clear current image resource, pass imageIn as "".
---imageFlags: &1=0: don't display image, &1: center / tile, &3: stretch, &5: full height (REAPER 5.974+).
---Can also be used to display existing text in empty items unstretched (pass imageIn = "", imageFlags = 0) or stretched (pass imageIn = "". imageFlags = 3).
---To get image resource, see BR_GetMediaItemImageResource.
---@param item MediaItem
---@param imageIn string
---@param imageFlags integer
function reaper.BR_SetMediaItemImageResource(item, imageIn, imageFlags) end

---[BR] Set take media source properties. Returns false if take can't have them (MIDI items etc.). Section parameters have to be valid only when passing section=true.
---To get source properties, see BR_GetMediaSourceProperties.
---@param take MediaItem_Take
---@param section boolean
---@param start number
---@param length number
---@param fade number
---@param reverse boolean
---@return boolean rv
function reaper.BR_SetMediaSourceProperties(take, section, start, length, fade, reverse) end

---[BR] Deprecated, see GetSetMediaTrackInfo (REAPER v5.02+). Set media track layouts for MCP and TCP. To set default layout, pass empty string ("") as layout name. In case layouts were successfully set, returns true (if layouts are already set to supplied layout names, it will return false since no changes were made).
---To get media track layouts, see BR_GetMediaTrackLayouts.
---@param track MediaTrack
---@param mcpLayoutNameIn string
---@param tcpLayoutNameIn string
---@return boolean rv
function reaper.BR_SetMediaTrackLayouts(track, mcpLayoutNameIn, tcpLayoutNameIn) end

---[BR] Set "ignore project tempo" information for MIDI take. Returns true in case the take was successfully updated.
---@param take MediaItem_Take
---@param ignoreProjTempo boolean
---@param bpm number
---@param num integer
---@param den integer
---@return boolean rv
function reaper.BR_SetMidiTakeTempoInfo(take, ignoreProjTempo, bpm, num, den) end

---[BR] Set new take source from file. To import MIDI file as in-project source data pass inProjectData=true. Returns false if failed.
---Any take source properties from the previous source will be lost - to preserve them, see BR_SetTakeSourceFromFile2.
---Note: To set source from existing take, see SNM_GetSetSourceState2.
---@param take MediaItem_Take
---@param filenameIn string
---@param inProjectData boolean
---@return boolean rv
function reaper.BR_SetTakeSourceFromFile(take, filenameIn, inProjectData) end

---[BR] Differs from BR_SetTakeSourceFromFile only that it can also preserve existing take media source properties.
---@param take MediaItem_Take
---@param filenameIn string
---@param inProjectData boolean
---@param keepSourceProperties boolean
---@return boolean rv
function reaper.BR_SetTakeSourceFromFile2(take, filenameIn, inProjectData, keepSourceProperties) end

---[BR] Get take under mouse cursor. Position is mouse cursor position in arrange.
---@return MediaItem_Take rv
---@return number position
function reaper.BR_TakeAtMouseCursor() end

---[BR] Get track under mouse cursor.
---Context signifies where the track was found: 0 = TCP, 1 = MCP, 2 = Arrange.
---Position will hold mouse cursor position in arrange if applicable.
---@return MediaTrack rv
---@return integer context
---@return number position
function reaper.BR_TrackAtMouseCursor() end

---[BR] Deprecated, see TrackFX_GetNamedConfigParm/'fx_ident' (v6.37+). Get the exact name (like effect.dll, effect.vst3, etc...) of an FX.
---@param track MediaTrack
---@param fx integer
---@return boolean rv
---@return string name
function reaper.BR_TrackFX_GetFXModuleName(track, fx) end

---[BR] Equivalent to win32 API ComboBox_FindString().
---@param comboBoxHwnd userdata
---@param startId integer
---@param string string
---@return integer rv
function reaper.BR_Win32_CB_FindString(comboBoxHwnd, startId, string) end

---[BR] Equivalent to win32 API ComboBox_FindStringExact().
---@param comboBoxHwnd userdata
---@param startId integer
---@param string string
---@return integer rv
function reaper.BR_Win32_CB_FindStringExact(comboBoxHwnd, startId, string) end

---[BR] Equivalent to win32 API ClientToScreen().
---@param hwnd userdata
---@param xIn integer
---@param yIn integer
---@return integer x
---@return integer y
function reaper.BR_Win32_ClientToScreen(hwnd, xIn, yIn) end

---[BR] Equivalent to win32 API FindWindowEx(). Since ReaScript doesn't allow passing NULL (None in Python, nil in Lua etc...) parameters, to search by supplied class or name set searchClass and searchName accordingly. HWND parameters should be passed as either "0" to signify NULL or as string obtained from BR_Win32_HwndToString.
---@param hwndParent string
---@param hwndChildAfter string
---@param className string
---@param windowName string
---@param searchClass boolean
---@param searchName boolean
---@return userdata rv
function reaper.BR_Win32_FindWindowEx(hwndParent, hwndChildAfter, className, windowName, searchClass, searchName) end

---[BR] Equivalent to win32 API GET_X_LPARAM().
---@param lParam integer
---@return integer rv
function reaper.BR_Win32_GET_X_LPARAM(lParam) end

---[BR] Equivalent to win32 API GET_Y_LPARAM().
---@param lParam integer
---@return integer rv
function reaper.BR_Win32_GET_Y_LPARAM(lParam) end

---[BR] Returns various constants needed for BR_Win32 functions.
---Supported constants are:
---CB_ERR, CB_GETCOUNT, CB_GETCURSEL, CB_SETCURSEL
---EM_SETSEL
---GW_CHILD, GW_HWNDFIRST, GW_HWNDLAST, GW_HWNDNEXT, GW_HWNDPREV, GW_OWNER
---GWL_STYLE
---SW_HIDE, SW_MAXIMIZE, SW_SHOW, SW_SHOWMINIMIZED, SW_SHOWNA, SW_SHOWNOACTIVATE, SW_SHOWNORMAL
---SWP_FRAMECHANGED, SWP_FRAMECHANGED, SWP_NOMOVE, SWP_NOOWNERZORDER, SWP_NOSIZE, SWP_NOZORDER
---VK_DOWN, VK_UP
---WM_CLOSE, WM_KEYDOWN
---WS_MAXIMIZE, WS_OVERLAPPEDWINDOW
---@param constantName string
---@return integer rv
function reaper.BR_Win32_GetConstant(constantName) end

---[BR] Equivalent to win32 API GetCursorPos().
---@return boolean rv
---@return integer x
---@return integer y
function reaper.BR_Win32_GetCursorPos() end

---[BR] Equivalent to win32 API GetFocus().
---@return userdata rv
function reaper.BR_Win32_GetFocus() end

---[BR] Equivalent to win32 API GetForegroundWindow().
---@return userdata rv
function reaper.BR_Win32_GetForegroundWindow() end

---[BR] Alternative to GetMainHwnd. REAPER seems to have problems with extensions using HWND type for exported functions so all BR_Win32 functions use void* instead of HWND type
---@return userdata rv
function reaper.BR_Win32_GetMainHwnd() end

---[BR] Get mixer window HWND. isDockedOut will be set to true if mixer is docked
---@return userdata rv
---@return boolean isDocked
function reaper.BR_Win32_GetMixerHwnd() end

---[BR] Get coordinates for screen which is nearest to supplied coordinates. Pass workingAreaOnly as true to get screen coordinates excluding taskbar (or menu bar on OSX).
---@param workingAreaOnly boolean
---@param leftIn integer
---@param topIn integer
---@param rightIn integer
---@param bottomIn integer
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.BR_Win32_GetMonitorRectFromRect(workingAreaOnly, leftIn, topIn, rightIn, bottomIn) end

---[BR] Equivalent to win32 API GetParent().
---@param hwnd userdata
---@return userdata rv
function reaper.BR_Win32_GetParent(hwnd) end

---[BR] Equivalent to win32 API GetPrivateProfileString(). For example, you can use this to get values from REAPER.ini.
---@param sectionName string
---@param keyName string
---@param defaultString string
---@param filePath string
---@return integer rv
---@return string string
function reaper.BR_Win32_GetPrivateProfileString(sectionName, keyName, defaultString, filePath) end

---[BR] Equivalent to win32 API GetWindow().
---@param hwnd userdata
---@param cmd integer
---@return userdata rv
function reaper.BR_Win32_GetWindow(hwnd, cmd) end

---[BR] Equivalent to win32 API GetWindowLong().
---@param hwnd userdata
---@param index integer
---@return integer rv
function reaper.BR_Win32_GetWindowLong(hwnd, index) end

---[BR] Equivalent to win32 API GetWindowRect().
---@param hwnd userdata
---@return boolean rv
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.BR_Win32_GetWindowRect(hwnd) end

---[BR] Equivalent to win32 API GetWindowText().
---@param hwnd userdata
---@return integer rv
---@return string text
function reaper.BR_Win32_GetWindowText(hwnd) end

---[BR] Equivalent to win32 API HIBYTE().
---@param value integer
---@return integer rv
function reaper.BR_Win32_HIBYTE(value) end

---[BR] Equivalent to win32 API HIWORD().
---@param value integer
---@return integer rv
function reaper.BR_Win32_HIWORD(value) end

---[BR] Convert HWND to string. To convert string back to HWND, see BR_Win32_StringToHwnd.
---@param hwnd userdata
---@return string string
function reaper.BR_Win32_HwndToString(hwnd) end

---[BR] Equivalent to win32 API IsWindow().
---@param hwnd userdata
---@return boolean rv
function reaper.BR_Win32_IsWindow(hwnd) end

---[BR] Equivalent to win32 API IsWindowVisible().
---@param hwnd userdata
---@return boolean rv
function reaper.BR_Win32_IsWindowVisible(hwnd) end

---[BR] Equivalent to win32 API LOBYTE().
---@param value integer
---@return integer rv
function reaper.BR_Win32_LOBYTE(value) end

---[BR] Equivalent to win32 API LOWORD().
---@param value integer
---@return integer rv
function reaper.BR_Win32_LOWORD(value) end

---[BR] Equivalent to win32 API MAKELONG().
---@param low integer
---@param high integer
---@return integer rv
function reaper.BR_Win32_MAKELONG(low, high) end

---[BR] Equivalent to win32 API MAKELPARAM().
---@param low integer
---@param high integer
---@return integer rv
function reaper.BR_Win32_MAKELPARAM(low, high) end

---[BR] Equivalent to win32 API MAKELRESULT().
---@param low integer
---@param high integer
---@return integer rv
function reaper.BR_Win32_MAKELRESULT(low, high) end

---[BR] Equivalent to win32 API MAKEWORD().
---@param low integer
---@param high integer
---@return integer rv
function reaper.BR_Win32_MAKEWORD(low, high) end

---[BR] Equivalent to win32 API MAKEWPARAM().
---@param low integer
---@param high integer
---@return integer rv
function reaper.BR_Win32_MAKEWPARAM(low, high) end

---[BR] Alternative to MIDIEditor_GetActive. REAPER seems to have problems with extensions using HWND type for exported functions so all BR_Win32 functions use void* instead of HWND type.
---@return userdata rv
function reaper.BR_Win32_MIDIEditor_GetActive() end

---[BR] Equivalent to win32 API ClientToScreen().
---@param hwnd userdata
---@param xIn integer
---@param yIn integer
---@return integer x
---@return integer y
function reaper.BR_Win32_ScreenToClient(hwnd, xIn, yIn) end

---[BR] Equivalent to win32 API SendMessage().
---@param hwnd userdata
---@param msg integer
---@param lParam integer
---@param wParam integer
---@return integer rv
function reaper.BR_Win32_SendMessage(hwnd, msg, lParam, wParam) end

---[BR] Equivalent to win32 API SetFocus().
---@param hwnd userdata
---@return userdata rv
function reaper.BR_Win32_SetFocus(hwnd) end

---[BR] Equivalent to win32 API SetForegroundWindow().
---@param hwnd userdata
---@return integer rv
function reaper.BR_Win32_SetForegroundWindow(hwnd) end

---[BR] Equivalent to win32 API SetWindowLong().
---@param hwnd userdata
---@param index integer
---@param newLong integer
---@return integer rv
function reaper.BR_Win32_SetWindowLong(hwnd, index, newLong) end

---[BR] Equivalent to win32 API SetWindowPos().
---hwndInsertAfter may be a string: "HWND_BOTTOM", "HWND_NOTOPMOST", "HWND_TOP", "HWND_TOPMOST" or a string obtained with BR_Win32_HwndToString.
---@param hwnd userdata
---@param hwndInsertAfter string
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param flags integer
---@return boolean rv
function reaper.BR_Win32_SetWindowPos(hwnd, hwndInsertAfter, x, y, width, height, flags) end

---[BR] Equivalent to win32 API ShellExecute() with HWND set to main window
---@param operation string
---@param file string
---@param parameters string
---@param directory string
---@param showFlags integer
---@return integer rv
function reaper.BR_Win32_ShellExecute(operation, file, parameters, directory, showFlags) end

---[BR] Equivalent to win32 API ShowWindow().
---@param hwnd userdata
---@param cmdShow integer
---@return boolean rv
function reaper.BR_Win32_ShowWindow(hwnd, cmdShow) end

---[BR] Convert string to HWND. To convert HWND back to string, see BR_Win32_HwndToString.
---@param string string
---@return userdata rv
function reaper.BR_Win32_StringToHwnd(string) end

---[BR] Equivalent to win32 API WindowFromPoint().
---@param x integer
---@param y integer
---@return userdata rv
function reaper.BR_Win32_WindowFromPoint(x, y) end

---[BR] Equivalent to win32 API WritePrivateProfileString(). For example, you can use this to write to REAPER.ini. You can pass an empty string as value to delete a key.
---@param sectionName string
---@param keyName string
---@param value string
---@param filePath string
---@return boolean rv
function reaper.BR_Win32_WritePrivateProfileString(sectionName, keyName, value, filePath) end

---Create a new preview object. Does not take ownership of the source (don't forget to destroy it unless it came from a take!). See CF_Preview_Play and the others CF_Preview_* functions.
---The preview object is automatically destroyed at the end of a defer cycle if at least one of these conditions are met:
---- playback finished
---- playback was not started using CF_Preview_Play
---- the output track no longer exists
---@param source PCM_source
---@return CF_Preview rv
function reaper.CF_CreatePreview(source) end

---Enumerate the source's media cues. Returns the next index or 0 when finished.
---@param src PCM_source
---@param index integer
---@return integer rv
---@return number time
---@return number endTime
---@return boolean isRegion
---@return string name
---@return boolean isChapter
function reaper.CF_EnumMediaSourceCues(src, index) end

---Return the index of the next selected effect in the given FX chain. Start index should be -1. Returns -1 if there are no more selected effects.
---@param hwnd FxChain
---@param index integer
---@return integer rv
function reaper.CF_EnumSelectedFX(hwnd, index) end

---Deprecated, see kbd_enumerateActions (v6.71+). Wrapper for the unexposed kbd_enumerateActions API function.
---Main=0, Main (alt recording)=100, MIDI Editor=32060, MIDI Event List Editor=32061, MIDI Inline Editor=32062, Media Explorer=32063
---@param section integer
---@param index integer
---@return integer rv
---@return string name
function reaper.CF_EnumerateActions(section, index) end

---Export the source to the given file (MIDI only).
---@param src PCM_source
---@param fn string
---@return boolean rv
function reaper.CF_ExportMediaSource(src, fn) end

---Read the contents of the system clipboard.
---@return string text
function reaper.CF_GetClipboard() end

---[DEPRECATED: Use CF_GetClipboard] Read the contents of the system clipboard. See SNM_CreateFastString and SNM_DeleteFastString.
---@param output WDL_FastString
---@return string str
function reaper.CF_GetClipboardBig(output) end

---Deprecated, see kbd_getTextFromCmd (v6.71+). Wrapper for the unexposed kbd_getTextFromCmd API function. See CF_EnumerateActions for common section IDs.
---@param section integer
---@param command integer
---@return string str
function reaper.CF_GetCommandText(section, command) end

---Get one of 16 SWS custom colors (0xBBGGRR on Windows, 0xRRGGBB everyhwere else). Index is zero-based.
---@param index integer
---@return integer rv
function reaper.CF_GetCustomColor(index) end

---Return a handle to the currently focused FX chain window.
---@return FxChain rv
function reaper.CF_GetFocusedFXChain() end

---Returns the bit depth if available (0 otherwise).
---@param src PCM_source
---@return integer rv
function reaper.CF_GetMediaSourceBitDepth(src) end

---Returns the bit rate for WAVE (wav, aif) and streaming/variable formats (mp3, ogg, opus). REAPER v6.19 or later is required for non-WAVE formats.
---@param src PCM_source
---@return number num
function reaper.CF_GetMediaSourceBitRate(src) end

---Get the value of the given metadata field (eg. DESC, ORIG, ORIGREF, DATE, TIME, UMI, CODINGHISTORY for BWF).
---@param src PCM_source
---@param name string
---@param out string
---@return boolean rv
---@return string out
function reaper.CF_GetMediaSourceMetadata(src, name, out) end

---Returns the online/offline status of the given source.
---@param src PCM_source
---@return boolean rv
function reaper.CF_GetMediaSourceOnline(src) end

---Get the project associated with this source (BWF, subproject...).
---@param src PCM_source
---@return boolean rv
---@return string fn
function reaper.CF_GetMediaSourceRPP(src) end

---Return the current SWS version number.
---@return string version
function reaper.CF_GetSWSVersion() end

---Return a handle to the given take FX chain window. HACK: This temporarily renames the take in order to disambiguate the take FX chain window from similarily named takes.
---@param take MediaItem_Take
---@return FxChain rv
function reaper.CF_GetTakeFXChain(take) end

---Return a handle to the given track FX chain window.
---@param track MediaTrack
---@return FxChain rv
function reaper.CF_GetTrackFXChain(track) end

---Return a handle to the given track FX chain window. Set wantInputChain to get the track's input/monitoring FX chain.
---@param project ReaProject|nil|0
---@param track MediaTrack
---@param wantInputChain boolean
---@return FxChain rv
function reaper.CF_GetTrackFXChainEx(project, track, wantInputChain) end

---Select the given file in explorer/finder.
---@param file string
---@return boolean rv
function reaper.CF_LocateInExplorer(file) end

---Apply Unicode normalization to the provided UTF-8 string.
---Mode values:
---- Bit 0 (composition mode):
---  * 0 = decomposition only
---  * 1 = decomposition + canonical composition
---- Bit 1 (decomposition mode):
---  * 0 = canonical decomposition
---  * 1 = compatibility decomposition
---Warning: this function is no-op on Windows XP (the input string is returned as-is).
---@param input string
---@param mode integer
---@return string normalized
function reaper.CF_NormalizeUTF8(input, mode) end

---Give a section source created using PCM_Source_CreateFromType("SECTION"). Offset and length are ignored if 0. Negative length to subtract from the total length of the source.
---@param section PCM_source
---@param source PCM_source
---@param offset number
---@param length number
---@param reverse boolean
---@param fadeIn number?
---@return boolean rv
function reaper.CF_PCM_Source_SetSectionInfo(section, source, offset, length, reverse, fadeIn) end

---@param preview CF_Preview
---@return MediaTrack rv
function reaper.CF_Preview_GetOutputTrack(preview) end

---Return the maximum sample value played since the last read. Refresh speed depends on buffer size.
---@param preview CF_Preview
---@param channel integer
---@return boolean rv
---@return number peakvol
function reaper.CF_Preview_GetPeak(preview, channel) end

---Supported attributes:
---B_LOOP         seek to the beginning when reaching the end of the source
---B_PPITCH       preserve pitch when changing playback rate
---D_FADEINLEN    length in seconds of playback fade in
---D_FADEOUTLEN   length in seconds of playback fade out
---D_LENGTH       (read only) length of the source * playback rate
---D_MEASUREALIGN >0 = wait until the next bar before starting playback (note: this causes playback to silently continue when project is paused and previewing through a track)
---D_PAN          playback pan
---D_PITCH        pitch adjustment in semitones
---D_PLAYRATE     playback rate (0.01..100)
---D_POSITION     current playback position
---D_VOLUME       playback volume
---I_OUTCHAN      first hardware output channel (&1024=mono, reads -1 when playing through a track, see CF_Preview_SetOutputTrack)
---I_PITCHMODE    highest 16 bits=pitch shift mode (see EnumPitchShiftModes), lower 16 bits=pitch shift submode (see EnumPitchShiftSubModes)
---@param preview CF_Preview
---@param name string
---@return boolean rv
---@return number value
function reaper.CF_Preview_GetValue(preview, name) end

---Start playback of the configured preview object.
---@param preview CF_Preview
---@return boolean rv
function reaper.CF_Preview_Play(preview) end

---@param preview CF_Preview
---@param project ReaProject|nil|0
---@param track MediaTrack
---@return boolean rv
function reaper.CF_Preview_SetOutputTrack(preview, project, track) end

---See CF_Preview_GetValue.
---@param preview CF_Preview
---@param name string
---@param newValue number
---@return boolean rv
function reaper.CF_Preview_SetValue(preview, name, newValue) end

---Stop and destroy a preview object.
---@param preview CF_Preview
---@return boolean rv
function reaper.CF_Preview_Stop(preview) end

---Stop and destroy all currently active preview objects.
function reaper.CF_Preview_StopAll() end

---Set which take effect is active in the take's FX chain. The FX chain window does not have to be open.
---@param take MediaItem_Take
---@param index integer
---@return boolean rv
function reaper.CF_SelectTakeFX(take, index) end

---Set which track effect is active in the track's FX chain. The FX chain window does not have to be open.
---@param track MediaTrack
---@param index integer
---@return boolean rv
function reaper.CF_SelectTrackFX(track, index) end

---Run in the specified window the action command ID associated with the shortcut key in the given section. See CF_EnumerateActions for common section IDs.
---	Keys are Windows virtual key codes. &0x8000 for an extended key (eg. Numpad Enter = VK_RETURN & 0x8000).
---	Modifier values: nil = read from keyboard, 0 = no modifier, &4 = Control (Cmd on macOS), &8 = Shift, &16 = Alt, &32 = Super
---@param hwnd userdata
---@param section integer
---@param key integer
---@param modifiersIn integer?
---@return boolean rv
function reaper.CF_SendActionShortcut(hwnd, section, key, modifiersIn) end

---Write the given string into the system clipboard.
---@param str string
function reaper.CF_SetClipboard(str) end

---Set one of 16 SWS custom colors (0xBBGGRR on Windows, 0xRRGGBB everyhwere else). Index is zero-based.
---@param index integer
---@param color integer
function reaper.CF_SetCustomColor(index, color) end

---Set the online/offline status of the given source (closes files when set=false).
---@param src PCM_source
---@param set boolean
function reaper.CF_SetMediaSourceOnline(src, set) end

---Open the given file or URL in the default application. See also CF_LocateInExplorer.
---@param file string
---@return boolean rv
function reaper.CF_ShellExecute(file) end

---[FNG] Add MIDI note to MIDI take
---@param midiTake RprMidiTake
---@return RprMidiNote rv
function reaper.FNG_AddMidiNote(midiTake) end

---[FNG] Allocate a RprMidiTake from a take pointer. Returns a NULL pointer if the take is not an in-project MIDI take
---@param take MediaItem_Take
---@return RprMidiTake rv
function reaper.FNG_AllocMidiTake(take) end

---[FNG] Count of how many MIDI notes are in the MIDI take
---@param midiTake RprMidiTake
---@return integer rv
function reaper.FNG_CountMidiNotes(midiTake) end

---[FNG] Commit changes to MIDI take and free allocated memory
---@param midiTake RprMidiTake
function reaper.FNG_FreeMidiTake(midiTake) end

---[FNG] Get a MIDI note from a MIDI take at specified index
---@param midiTake RprMidiTake
---@param index integer
---@return RprMidiNote rv
function reaper.FNG_GetMidiNote(midiTake, index) end

---[FNG] Get MIDI note property
---@param midiNote RprMidiNote
---@param property string
---@return integer rv
function reaper.FNG_GetMidiNoteIntProperty(midiNote, property) end

---[FNG] Set MIDI note property
---@param midiNote RprMidiNote
---@param property string
---@param value integer
function reaper.FNG_SetMidiNoteIntProperty(midiNote, property, value) end

---Returns the path to the directory containing imgui.lua, imgui.py and gfx2imgui.lua.
---@return string str
function reaper.ImGui_GetBuiltinPath() end

---@param project ReaProject|nil|0
---@return string str
function reaper.JB_GetSWSExtraProjectNotes(project) end

---@param project ReaProject|nil|0
---@param str string
function reaper.JB_SetSWSExtraProjectNotes(project, str) end

---Section:
---0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
---@param section integer
---@param cmdID integer
---@return integer rv
function reaper.JS_Actions_CountShortcuts(section, cmdID) end

---Section:
---0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
---@param section integer
---@param cmdID integer
---@param shortcutidx integer
---@return boolean rv
function reaper.JS_Actions_DeleteShortcut(section, cmdID, shortcutidx) end

---Section:
---0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
---If the shortcut index is higher than the current number of shortcuts, it will add a new shortcut.
---@param section integer
---@param cmdID integer
---@param shortcutidx integer
---@return boolean rv
function reaper.JS_Actions_DoShortcutDialog(section, cmdID, shortcutidx) end

---Section:
---0 = Main, 100 = Main (alt recording), 32060 = MIDI Editor, 32061 = MIDI Event List Editor, 32062 = MIDI Inline Editor, 32063 = Media Explorer.
---@param section integer
---@param cmdID integer
---@param shortcutidx integer
---@return boolean rv
---@return string desc
function reaper.JS_Actions_GetShortcutDesc(section, cmdID, shortcutidx) end

---Returns the unsigned byte at address[offset]. Offset is added as steps of 1 byte each.
---@param pointer userdata
---@param offset integer
---@return integer byte
function reaper.JS_Byte(pointer, offset) end

---Composites a LICE bitmap with a REAPER window.  Each time that the window is re-drawn, the bitmap will be blitted over the window's client area (with per-pixel alpha blending).
--- * If dstw or dsth is -1, the bitmap will be stretched to fill the width or height of the window, respectively.
--- * autoUpdate is an optional parameter that is false by default. If true, JS_Composite will automatically invalidate and re-draw the part of the window that covers the current position of the bitmap, and if the bitmap is being moved, also the previous position. (If only one or a handful of bitmaps are being moved across the screen, autoUpdate should result in smoother animation on WindowsOS; if numerous bitmaps are spread over the entire window, it may be faster to disable autoUpdate and instead call JS_Window_InvalidateRect explicitly once all bitmaps have been moved.)
--- * InvalidateRect should also be called whenever the contents of the bitmap contents have been changed, but not the position, to trigger a window update.
--- * On WindowsOS, the key to reducing flickering is to slow down the frequency at which the window is re-drawn. InvalidateRect should only be called when absolutely necessary, preferably not more than 20 times per second.  (Also refer to the JS_Composite_Delay function.)
--- * On WindowsOS, flickering can further be reduced by keeping the invalidated area as small as possible, covering only the bitmaps that have been edited or moved.  However, if numerous bitmaps are spread over the entire window, it may be faster to simply invalidate the entire client area. 
--- * This function should not be applied directly to top-level windows, but rather to child windows.
--- * Some classes of UI elements, particularly buttons, do not take kindly to being composited, and may crash REAPER.
--- * On WindowsOS, GDI blitting does not perform alpha multiplication of the source bitmap. For proper color rendering, a separate pre-multiplication step is therefore required, using either LICE_Blit or LICE_ProcessRect.
---Returns:
---1 if successful, otherwise -1 = windowHWND is not a window, -3 = Could not obtain the original window process, -4 = sysBitmap is not a LICE bitmap, -5 = sysBitmap is not a system bitmap, -6 = Could not obtain the window HDC, -7 = Error when subclassing to new window process.
---@param windowHWND userdata
---@param dstx integer
---@param dsty integer
---@param dstw integer
---@param dsth integer
---@param sysBitmap userdata
---@param srcx integer
---@param srcy integer
---@param srcw integer
---@param srch integer
---@param autoUpdate unsupported
---@return integer rv
function reaper.JS_Composite(windowHWND, dstx, dsty, dstw, dsth, sysBitmap, srcx, srcy, srcw, srch, autoUpdate) end

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
---@return integer rv
---@return number prevMinTime
---@return number prevMaxTime
---@return integer prevBitmaps
function reaper.JS_Composite_Delay(windowHWND, minTime, maxTime, numBitmapsWhenMax) end

---Returns all bitmaps composited to the given window.
---The list is formatted as a comma-separated string of hexadecimal values, each representing a LICE_IBitmap* pointer.
---retval is the number of linked bitmaps found, or negative if an error occured.
---@param windowHWND userdata
---@return integer rv
---@return string list
function reaper.JS_Composite_ListBitmaps(windowHWND) end

---Unlinks the window and bitmap.
--- * autoUpdate is an optional parameter. If unlinking a single bitmap and autoUpdate is true, the function will automatically re-draw the window to remove the blitted image.
---If no bitmap is specified, all bitmaps composited to the window will be unlinked -- even those by other scripts.
---@param windowHWND userdata
---@param bitmap userdata?
---@param autoUpdate unsupported
function reaper.JS_Composite_Unlink(windowHWND, bitmap, autoUpdate) end

---retval is 1 if a file was selected, 0 if the user cancelled the dialog, and -1 if an error occurred.
---@param caption string
---@param initialFolder string
---@return integer rv
---@return string folder
function reaper.JS_Dialog_BrowseForFolder(caption, initialFolder) end

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
---@return integer rv
---@return string fileNames
function reaper.JS_Dialog_BrowseForOpenFiles(windowTitle, initialFolder, initialFile, extensionList, allowMultiple) end

---retval is 1 if a file was selected, 0 if the user cancelled the dialog, or negative if an error occurred.
---extensionList is as described for JS_Dialog_BrowseForOpenFiles.
---@param windowTitle string
---@param initialFolder string
---@param initialFile string
---@param extensionList string
---@return integer rv
---@return string fileName
function reaper.JS_Dialog_BrowseForSaveFile(windowTitle, initialFolder, initialFile, extensionList) end

---Returns the 8-byte floating point value at address[offset]. Offset is added as steps of 8 bytes each.
---@param pointer userdata
---@param offset integer
---@return number double
function reaper.JS_Double(pointer, offset) end

---Returns information about a file.
---cTime is not implemented on all systems. If it does return a time, the value may differ depending on the OS: on WindowsOS, it may refer to the time that the file was either created or copied, whereas on Linux and macOS, it may refer to the time of last status change.
---retval is 0 if successful, negative if not.
---@param filePath string
---@return integer rv
---@return number size
---@return string accessedTime
---@return string modifiedTime
---@return string cTime
---@return integer deviceID
---@return integer deviceSpecialID
---@return integer inode
---@return integer mode
---@return integer numLinks
---@return integer ownerUserID
---@return integer ownerGroupID
function reaper.JS_File_Stat(filePath) end

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
---@param mode string?
function reaper.JS_GDI_Blit(destHDC, dstx, dsty, sourceHDC, srcx, srxy, width, height, mode) end

---@param color integer
---@return userdata rv
function reaper.JS_GDI_CreateFillBrush(color) end

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
---@return userdata rv
function reaper.JS_GDI_CreateFont(height, weight, angle, italic, underline, strike, fontName) end

---@param width integer
---@param color integer
---@return userdata rv
function reaper.JS_GDI_CreatePen(width, color) end

---@param GDIObject userdata
function reaper.JS_GDI_DeleteObject(GDIObject) end

---Parameters:
--- * align: Combination of: "TOP", "VCENTER", "LEFT", "HCENTER", "RIGHT", "BOTTOM", "WORDBREAK", "SINGLELINE", "NOCLIP", "CALCRECT", "NOPREFIX" or "ELLIPSIS"
---@param deviceHDC userdata
---@param text string
---@param len integer
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
---@param align string
---@return integer rv
function reaper.JS_GDI_DrawText(deviceHDC, text, len, left, top, right, bottom, align) end

---@param deviceHDC userdata
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function reaper.JS_GDI_FillEllipse(deviceHDC, left, top, right, bottom) end

---packedX and packedY are strings of points, each packed as "<i4".
---@param deviceHDC userdata
---@param packedX string
---@param packedY string
---@param numPoints integer
function reaper.JS_GDI_FillPolygon(deviceHDC, packedX, packedY, numPoints) end

---@param deviceHDC userdata
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
function reaper.JS_GDI_FillRect(deviceHDC, left, top, right, bottom) end

---@param deviceHDC userdata
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
---@param xrnd integer
---@param yrnd integer
function reaper.JS_GDI_FillRoundRect(deviceHDC, left, top, right, bottom, xrnd, yrnd) end

---Returns the device context for the client area of the specified window.
---@param windowHWND userdata
---@return userdata rv
function reaper.JS_GDI_GetClientDC(windowHWND) end

---Returns a device context for the entire screen.
---WARNING: Only available on Windows, not Linux or macOS.
---@return userdata rv
function reaper.JS_GDI_GetScreenDC() end

---@param GUIElement string
---@return integer rv
function reaper.JS_GDI_GetSysColor(GUIElement) end

---@param deviceHDC userdata
---@return integer rv
function reaper.JS_GDI_GetTextColor(deviceHDC) end

---Returns the device context for the entire window, including title bar and frame.
---@param windowHWND userdata
---@return userdata rv
function reaper.JS_GDI_GetWindowDC(windowHWND) end

---@param deviceHDC userdata
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
function reaper.JS_GDI_Line(deviceHDC, x1, y1, x2, y2) end

---packedX and packedY are strings of points, each packed as "<i4".
---@param deviceHDC userdata
---@param packedX string
---@param packedY string
---@param numPoints integer
function reaper.JS_GDI_Polyline(deviceHDC, packedX, packedY, numPoints) end

---To release a window HDC, both arguments must be supplied: the HWND as well as the HDC.  To release a screen DC, only the HDC needs to be supplied.  
---For compatibility with previous versions, the HWND and HDC can be supplied in any order.
---NOTE: Any GDI HDC should be released immediately after drawing, and deferred scripts should get and release new DCs in each cycle.
---@param deviceHDC userdata
---@param windowHWND userdata
---@return integer rv
function reaper.JS_GDI_ReleaseDC(deviceHDC, windowHWND) end

---Activates a font, pen, or fill brush for subsequent drawing in the specified device context.
---@param deviceHDC userdata
---@param GDIObject userdata
---@return userdata rv
function reaper.JS_GDI_SelectObject(deviceHDC, GDIObject) end

---@param deviceHDC userdata
---@param x integer
---@param y integer
---@param color integer
function reaper.JS_GDI_SetPixel(deviceHDC, x, y, color) end

---@param deviceHDC userdata
---@param color integer
function reaper.JS_GDI_SetTextBkColor(deviceHDC, color) end

---@param deviceHDC userdata
---@param mode integer
function reaper.JS_GDI_SetTextBkMode(deviceHDC, mode) end

---@param deviceHDC userdata
---@param color integer
function reaper.JS_GDI_SetTextColor(deviceHDC, color) end

---Blits between two device contexts, which may include LICE "system bitmaps".
---modeOptional: "SRCCOPY" by default, or specify "ALPHA" to enable per-pixel alpha blending.
---WARNING: On WindowsOS, GDI_Blit does not perform alpha multiplication of the source bitmap. For proper color rendering, a separate pre-multiplication step is therefore required, using either LICE_Blit or LICE_ProcessRect.
---@param destHDC userdata
---@param dstx integer
---@param dsty integer
---@param dstw integer
---@param dsth integer
---@param sourceHDC userdata
---@param srcx integer
---@param srxy integer
---@param srcw integer
---@param srch integer
---@param mode string?
function reaper.JS_GDI_StretchBlit(destHDC, dstx, dsty, dstw, dsth, sourceHDC, srcx, srxy, srcw, srch, mode) end

---@param headerHWND userdata
---@return integer rv
function reaper.JS_Header_GetItemCount(headerHWND) end

---Returns the 4-byte signed integer at address[offset]. Offset is added as steps of 4 bytes each.
---@param pointer userdata
---@param offset integer
---@return integer int
function reaper.JS_Int(pointer, offset) end

---Hue is rolled over, saturation and value are clamped, all 0..1. (Alpha remains unchanged.)
---@param bitmap userdata
---@param hue number
---@param saturation number
---@param value number
function reaper.JS_LICE_AlterBitmapHSV(bitmap, hue, saturation, value) end

---Hue is rolled over, saturation and value are clamped, all 0..1. (Alpha remains unchanged.)
---@param bitmap userdata
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param hue number
---@param saturation number
---@param value number
function reaper.JS_LICE_AlterRectHSV(bitmap, x, y, w, h, hue, saturation, value) end

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

---@param reaperarray userdata
---@return integer rv
function reaper.JS_LICE_ArrayAllBitmaps(reaperarray) end

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

---Standard LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-pixel alpha blending.
---In addition to the standard LICE modes, LICE_Blit also offers:
--- * "CHANCOPY_XTOY", with X and Y any of the four channels, A, R, G or B. (CHANCOPY_ATOA is similar to MASK mode.)
--- * "BLUR"
--- * "ALPHAMUL", which overwrites the destination with a per-pixel alpha-multiplied copy of the source. (Similar to first clearing the destination with 0x00000000 and then blitting with "COPY,ALPHA".)
---@param destBitmap userdata
---@param dstx integer
---@param dsty integer
---@param sourceBitmap userdata
---@param srcx integer
---@param srcy integer
---@param width integer
---@param height integer
---@param alpha number
---@param mode string
function reaper.JS_LICE_Blit(destBitmap, dstx, dsty, sourceBitmap, srcx, srcy, width, height, alpha, mode) end

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

---@param bitmap userdata
---@param color integer
function reaper.JS_LICE_Clear(bitmap, color) end

---@param isSysBitmap boolean
---@param width integer
---@param height integer
---@return userdata rv
function reaper.JS_LICE_CreateBitmap(isSysBitmap, width, height) end

---@return userdata rv
function reaper.JS_LICE_CreateFont() end

---Deletes the bitmap, and also unlinks bitmap from any composited window.
---@param bitmap userdata
function reaper.JS_LICE_DestroyBitmap(bitmap) end

---@param LICEFont userdata
function reaper.JS_LICE_DestroyFont(LICEFont) end

---@param bitmap userdata
---@param x integer
---@param y integer
---@param c integer
---@param color integer
---@param alpha number
---@param mode integer
function reaper.JS_LICE_DrawChar(bitmap, x, y, c, color, alpha, mode) end

---@param bitmap userdata
---@param LICEFont userdata
---@param text string
---@param textLen integer
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@return integer rv
function reaper.JS_LICE_DrawText(bitmap, LICEFont, text, textLen, x1, y1, x2, y2) end

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

---packedX and packedY are two strings of coordinates, each packed as "<i4".
---LICE modes : "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA" to enable per-pixel alpha blending.
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param packedX string
---@param packedY string
---@param numPoints integer
---@param color integer
---@param alpha number
---@param mode string
function reaper.JS_LICE_FillPolygon(bitmap, packedX, packedY, numPoints, color, alpha, mode) end

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

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param x3 integer
---@param y3 integer
---@param color integer
---@param alpha number
---@param mode string
function reaper.JS_LICE_FillTriangle(bitmap, x1, y1, x2, y2, x3, y3, color, alpha, mode) end

---@param bitmap userdata
---@return userdata rv
function reaper.JS_LICE_GetDC(bitmap) end

---@param bitmap userdata
---@return integer rv
function reaper.JS_LICE_GetHeight(bitmap) end

---Returns the color of the specified pixel.
---@param bitmap userdata
---@param x integer
---@param y integer
---@return number color
function reaper.JS_LICE_GetPixel(bitmap, x, y) end

---@param bitmap userdata
---@return integer rv
function reaper.JS_LICE_GetWidth(bitmap) end

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

---@param bitmap userdata
---@return boolean rv
function reaper.JS_LICE_IsFlipped(bitmap) end

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

---@return integer rv
---@return string list
function reaper.JS_LICE_ListAllBitmaps() end

---Returns a system LICE bitmap containing the JPEG.
---@param filename string
---@return userdata rv
function reaper.JS_LICE_LoadJPG(filename) end

---Returns a system LICE bitmap containing the JPEG.
---@param buffer string
---@param bufsize integer
---@return userdata rv
function reaper.JS_LICE_LoadJPGFromMemory(buffer, bufsize) end

---Returns a system LICE bitmap containing the PNG.
---@param filename string
---@return userdata rv
function reaper.JS_LICE_LoadPNG(filename) end

---Returns a system LICE bitmap containing the PNG.
---@param buffer string
---@param bufsize integer
---@return userdata rv
function reaper.JS_LICE_LoadPNGFromMemory(buffer, bufsize) end

---@param text string
---@return integer width
---@return integer Height
function reaper.JS_LICE_MeasureText(text) end

---Applies bitwise operations to each pixel in the target rectangle.
---operand: a color in 0xAARRGGBB format.
---modes:
--- * "XOR", "OR" or "AND".
--- * "SET_XYZ", with XYZ any combination of A, R, G, and B: copies the specified channels from operand to the bitmap. (Useful for setting the alpha values of a bitmap.)
--- * "ALPHAMUL": Performs alpha pre-multiplication on each pixel in the rect. operand is ignored in this mode. (On WindowsOS, GDI_Blit does not perform alpha multiplication on the fly, and a separate alpha pre-multiplication step is therefore required.)
---NOTE:
---LICE_Blit and LICE_ScaledBlit are also useful for processing bitmap colors. For example, to multiply all channel values by 1.5:
---reaper.JS_LICE_Blit(bitmap, x, y, bitmap, x, y, w, h, 0.5, "ADD").
---@param bitmap userdata
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param mode string
---@param operand number
---@return boolean rv
function reaper.JS_LICE_ProcessRect(bitmap, x, y, w, h, mode, operand) end

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param x integer
---@param y integer
---@param color number
---@param alpha number
---@param mode string
function reaper.JS_LICE_PutPixel(bitmap, x, y, color, alpha, mode) end

---@param bitmap userdata
---@param width integer
---@param height integer
function reaper.JS_LICE_Resize(bitmap, width, height) end

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

---LICE modes: "COPY" (default if empty string), "MASK", "ADD", "DODGE", "MUL", "OVERLAY" or "HSVADJ", any of which may be combined with "ALPHA".
---LICE color format: 0xAARRGGBB (AA is only used in ALPHA mode).
---@param bitmap userdata
---@param x number
---@param y number
---@param w number
---@param h number
---@param cornerradius integer
---@param color integer
---@param alpha number
---@param mode string
---@param antialias boolean
function reaper.JS_LICE_RoundRect(bitmap, x, y, w, h, cornerradius, color, alpha, mode, antialias) end

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

---Sets all pixels that match the given color's RGB values to fully transparent, and all other pixels to fully opaque.  (All pixels' RGB values remain unchanged.)
---@param bitmap userdata
---@param colorRGB integer
function reaper.JS_LICE_SetAlphaFromColorMask(bitmap, colorRGB) end

---Sets the color of the font background.
---@param LICEFont userdata
---@param color integer
function reaper.JS_LICE_SetFontBkColor(LICEFont, color) end

---@param LICEFont userdata
---@param color integer
function reaper.JS_LICE_SetFontColor(LICEFont, color) end

---Sets the color of font FX such as shadow.
---@param LICEFont userdata
---@param color integer
function reaper.JS_LICE_SetFontFXColor(LICEFont, color) end

---Converts a GDI font into a LICE font.
---The font can be modified by the following flags, in a comma-separated list:
---"VERTICAL", "BOTTOMUP", "NATIVE", "BLUR", "INVERT", "MONO", "SHADOW" or "OUTLINE".
---@param LICEFont userdata
---@param GDIFont userdata
---@param moreFormats string
function reaper.JS_LICE_SetFontFromGDI(LICEFont, GDIFont, moreFormats) end

---Parameters:
--- * quality is an integer in the range 1..100.
--- * forceBaseline is an optional boolean parameter that ensures compatibility with all JPEG viewers by preventing too low quality, "cubist" settings.
---@param filename string
---@param bitmap userdata
---@param quality integer
---@param forceBaseline unsupported
---@return boolean rv
function reaper.JS_LICE_WriteJPG(filename, bitmap, quality, forceBaseline) end

---@param filename string
---@param bitmap userdata
---@param wantAlpha boolean
---@return boolean rv
function reaper.JS_LICE_WritePNG(filename, bitmap, wantAlpha) end

---@param listviewHWND userdata
---@param index integer
---@param partialOK boolean
function reaper.JS_ListView_EnsureVisible(listviewHWND, index, partialOK) end

---Returns the index of the next selected list item with index greater that the specified number. Returns -1 if no selected items left.
---@param listviewHWND userdata
---@param index integer
---@return integer rv
function reaper.JS_ListView_EnumSelItems(listviewHWND, index) end

---Returns the index and text of the focused item, if any.
---@param listviewHWND userdata
---@return integer rv
---@return string text
function reaper.JS_ListView_GetFocusedItem(listviewHWND) end

---@param listviewHWND userdata
---@return userdata rv
function reaper.JS_ListView_GetHeader(listviewHWND) end

---Returns the text and state of specified item.
---@param listviewHWND userdata
---@param index integer
---@param subItem integer
---@return string text
---@return integer state
function reaper.JS_ListView_GetItem(listviewHWND, index, subItem) end

---@param listviewHWND userdata
---@return integer rv
function reaper.JS_ListView_GetItemCount(listviewHWND) end

---Returns client coordinates of the item.
---@param listviewHWND userdata
---@param index integer
---@return boolean rv
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.JS_ListView_GetItemRect(listviewHWND, index) end

---State is a bitmask:
---1 = focused, 2 = selected. On Windows only, cut-and-paste marked = 4, drag-and-drop highlighted = 8.
---Warning: this function uses the Win32 bitmask values, which differ from the values used by WDL/swell.
---@param listviewHWND userdata
---@param index integer
---@return integer rv
function reaper.JS_ListView_GetItemState(listviewHWND, index) end

---@param listviewHWND userdata
---@param index integer
---@param subItem integer
---@return string text
function reaper.JS_ListView_GetItemText(listviewHWND, index, subItem) end

---@param listviewHWND userdata
---@return integer rv
function reaper.JS_ListView_GetSelectedCount(listviewHWND) end

---@param listviewHWND userdata
---@return integer rv
function reaper.JS_ListView_GetTopIndex(listviewHWND) end

---@param listviewHWND userdata
---@param clientX integer
---@param clientY integer
---@return integer index
---@return integer subItem
---@return integer flags
function reaper.JS_ListView_HitTest(listviewHWND, clientX, clientY) end

---Returns the indices of all selected items as a comma-separated list.
--- * retval: Number of selected items found; negative or zero if an error occured.
---@param listviewHWND userdata
---@return integer rv
---@return string items
function reaper.JS_ListView_ListAllSelItems(listviewHWND) end

---The mask parameter specifies the state bits that must be set, and the state parameter specifies the new values for those bits.
---1 = focused, 2 = selected. On Windows only, cut-and-paste marked = 4, drag-and-drop highlighted = 8.
---Warning: this function uses the Win32 bitmask values, which differ from the values used by WDL/swell.
---@param listviewHWND userdata
---@param index integer
---@param state integer
---@param mask integer
function reaper.JS_ListView_SetItemState(listviewHWND, index, state, mask) end

---Currently, this fuction only accepts ASCII text.
---@param listviewHWND userdata
---@param index integer
---@param subItem integer
---@param text string
function reaper.JS_ListView_SetItemText(listviewHWND, index, subItem, text) end

---Returns the translation of the given US English text, according to the currently loaded Language Pack.
---Parameters:
--- * LangPackSection: Language Packs are divided into sections such as "common" or "DLG_102".
--- * In Lua, by default, text of up to 1024 chars can be returned. To increase (or reduce) the default buffer size, a string and size can be included as optional 3rd and 4th arguments.
---Example: reaper.JS_Localize("Actions", "common", "", 20)
---@param USEnglish string
---@param LangPackSection string
---@return string translation
function reaper.JS_Localize(USEnglish, LangPackSection) end

---Finds all open MIDI windows (whether docked or not).
--- * retval: The number of MIDI editor windows found; negative if an error occurred.
--- * The address of each MIDI editor window is stored in the provided reaper.array. Each address can be converted to a REAPER object (HWND) by the function JS_Window_HandleFromAddress.
---@param reaperarray userdata
---@return integer rv
function reaper.JS_MIDIEditor_ArrayAll(reaperarray) end

---Finds all open MIDI windows (whether docked or not).
--- * retval: The number of MIDI editor windows found; negative if an error occurred.
--- * list: Comma-separated string of hexadecimal values. Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
---@return integer rv
---@return string list
function reaper.JS_MIDIEditor_ListAll() end

---Allocates memory for general use by functions that require memory buffers.
---@param sizeBytes integer
---@return userdata rv
function reaper.JS_Mem_Alloc(sizeBytes) end

---Frees memory that was previously allocated by JS_Mem_Alloc.
---@param mallocPointer userdata
---@return boolean rv
function reaper.JS_Mem_Free(mallocPointer) end

---Copies a packed string into a memory buffer.
---@param mallocPointer userdata
---@param offset integer
---@param packedString string
---@param stringLength integer
---@return boolean rv
function reaper.JS_Mem_FromString(mallocPointer, offset, packedString, stringLength) end

---On Windows, retrieves a handle to the current mouse cursor.
---On Linux and macOS, retrieves a handle to the last cursor set by REAPER or its extensions via SWELL.
---@return userdata rv
function reaper.JS_Mouse_GetCursor() end

---Retrieves the states of mouse buttons and modifiers keys.
---Parameters:
--- * flags, state: The parameter and the return value both use the same format as gfx.mouse_cap. For example, to get the states of the left mouse button and the ctrl key, use flags = 0b00000101.
---@param flags integer
---@return integer rv
function reaper.JS_Mouse_GetState(flags) end

---Loads a cursor by number.
---cursorNumber: Same as used for gfx.setcursor, and includes some of Windows' predefined cursors (with numbers > 32000; refer to documentation for the Win32 C++ function LoadCursor), and REAPER's own cursors (with numbers < 2000).
---If successful, returns a handle to the cursor, which can be used in JS_Mouse_SetCursor.
---@param cursorNumber integer
---@return userdata rv
function reaper.JS_Mouse_LoadCursor(cursorNumber) end

---Loads a cursor from a .cur file.
---forceNewLoad is an optional boolean parameter:
--- * If omitted or false, and if the cursor file has already been loaded previously during the REAPER session by any script, the file will not be re-loaded, and the existing handle will be returned.
--- * If true, the file will be re-loaded and a new handle will be returned.
--- * WARNING: Each time that a cursor file is re-loaded, the number of GDI objects increases for the entire duration of the REAPER session.
---If successful, returns a handle to the cursor, which can be used in JS_Mouse_SetCursor.
---@param pathAndFileName string
---@param forceNewLoad unsupported
---@return userdata rv
function reaper.JS_Mouse_LoadCursorFromFile(pathAndFileName, forceNewLoad) end

---Sets the mouse cursor.  (Only lasts while script is running, and for a single "defer" cycle.)
---@param cursorHandle userdata
function reaper.JS_Mouse_SetCursor(cursorHandle) end

---Moves the mouse cursor to the specified screen coordinates.
---NOTES:
--- * On Windows and Linux, screen coordinates are relative to *upper* left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
---@param x integer
---@param y integer
---@return boolean rv
function reaper.JS_Mouse_SetPosition(x, y) end

---Returns the version of the js_ReaScriptAPI extension.
---@return number version
function reaper.JS_ReaScriptAPI_Version() end

---Returns the memory contents starting at address[offset] as a packed string. Offset is added as steps of 1 byte (char) each.
---@param pointer userdata
---@param offset integer
---@param lengthChars integer
---@return boolean rv
---@return string buf
function reaper.JS_String(pointer, offset, lengthChars) end

---Returns a 255-byte array that specifies which virtual keys, from 0x01 to 0xFF, have sent KEYDOWN messages since cutoffTime.
---Notes:
--- * Mouse buttons and modifier keys are not (currently) reliably detected, and JS_Mouse_GetState can be used instead.
--- * Auto-repeated KEYDOWN messages are ignored.
---@param cutoffTime number
---@return string state
function reaper.JS_VKeys_GetDown(cutoffTime) end

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

---Return a 255-byte array that specifies which virtual keys, from 0x01 to 0xFF, have sent KEYUP messages since cutoffTime.
---Note: Mouse buttons and modifier keys are not (currently) reliably detected, and JS_Mouse_GetState can be used instead.
---@param cutoffTime number
---@return string state
function reaper.JS_VKeys_GetUp(cutoffTime) end

---Intercepting (blocking) virtual keys work similar to the native function PreventUIRefresh:  Each key has a (non-negative) intercept state, and the key is passed through as usual if the state equals 0, or blocked if the state is greater than 0.
---keyCode: The virtual key code of the key, or -1 to change the state of all keys.
---intercept: A script can increase the intercept state by passing +1, or lower the state by passing -1.  Multiple scripts can block the same key, and the intercept state may reach up to 255. If zero is passed, the intercept state is not changed, but the current state is returned.
---Returns: If keyCode refers to a single key, the intercept state of that key is returned.  If keyCode = -1, the state of the key that is most strongly blocked (highest intercept state) is returned.
---@param keyCode integer
---@param intercept integer
---@return integer rv
function reaper.JS_VKeys_Intercept(keyCode, intercept) end

---Begins intercepting a window message type to specified window.
---Parameters:
--- * message: a single message type to be intercepted, either in WM_ or hexadecimal format. For example "WM_SETCURSOR" or "0x0020".
--- * passThrough: Whether message should be blocked (false) or passed through (true) to the window.
---    For more information on message codes, refer to the Win32 C++ API documentation.
---    All WM_ and CB_ message types listed in swell-types.h should be valid cross-platform, and the function can recognize all of these by name. Other messages can be specified by their hex code.
---Returns:
--- * 1: Success.
--- * 0: The message type is already being intercepted by another script.
--- * -2: message string could not be parsed.
--- * -3: Failure getting original window process / window not valid.
--- * -6: Could not obtain the window client HDC.
---Notes:
--- * Intercepted messages can be polled using JS_WindowMessage_Peek.
--- * Intercepted messages can be edited, if necessary, and then forwarded to their original destination using JS_WindowMessage_Post or JS_WindowMessage_Send.
--- * To check whether a message type is being blocked or passed through, Peek the message type, or retrieve the entire List of intercepts.
--- * Mouse events are typically received by the child window under the mouse, not the parent window.
---Keyboard events are usually *not* received by any individual window. To intercept keyboard events, use the VKey functions.
---@param windowHWND userdata
---@param message string
---@param passThrough boolean
---@return integer rv
function reaper.JS_WindowMessage_Intercept(windowHWND, message, passThrough) end

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
---@return integer rv
function reaper.JS_WindowMessage_InterceptList(windowHWND, messages) end

---Returns a string with a list of all message types currently being intercepted for the specified window.
---@param windowHWND userdata
---@return boolean rv
---@return string list
function reaper.JS_WindowMessage_ListIntercepts(windowHWND) end

---Changes the passthrough setting of a message type that is already being intercepted.
---Returns 1 if successful, 0 if the message type is not yet being intercepted, or -2 if the argument could not be parsed.
---@param windowHWND userdata
---@param message string
---@param passThrough boolean
---@return integer rv
function reaper.JS_WindowMessage_PassThrough(windowHWND, message, passThrough) end

---Polls the state of an intercepted message.
---Parameters:
--- * message: String containing a single message name, such as "WM_SETCURSOR", or in hexadecimal format, "0x0020".
--- (For a list of WM_ and CB_ message types that are valid cross-platform, refer to swell-types.h. Only these will be recognized by WM_ or CB_ name.)
---Returns:
--- * A retval of false indicates that the message type is not being intercepted in the specified window.
--- * All messages are timestamped. A time of 0 indicates that no message if this type has been intercepted yet.
--- * For more information about wParam and lParam for different message types, refer to Win32 C++ documentation.
--- * For example, in the case of mousewheel, returns mousewheel delta, modifier keys, x position and y position.
--- * wParamHigh, lParamLow and lParamHigh are signed, whereas wParamLow is unsigned.
---@param windowHWND userdata
---@param message string
---@return boolean rv
---@return boolean passedThrough
---@return number time
---@return integer wParamLow
---@return integer wParamHigh
---@return integer lParamLow
---@return integer lParamHigh
function reaper.JS_WindowMessage_Peek(windowHWND, message) end

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
---@return boolean rv
function reaper.JS_WindowMessage_Post(windowHWND, message, wParam, wParamHighWord, lParam, lParamHighWord) end

---Release intercepts of specified message types.
---Parameters:
--- * messages: "WM_SETCURSOR,WM_MOUSEHWHEEL" or "0x0020,0x020E", for example.
---@param windowHWND userdata
---@param messages string
---@return integer rv
function reaper.JS_WindowMessage_Release(windowHWND, messages) end

---Release script intercepts of window messages for all windows.
function reaper.JS_WindowMessage_ReleaseAll() end

---Release script intercepts of window messages for specified window.
---@param windowHWND userdata
function reaper.JS_WindowMessage_ReleaseWindow(windowHWND) end

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
---@return integer rv
function reaper.JS_WindowMessage_Send(windowHWND, message, wParam, wParamHighWord, lParam, lParamHighWord) end

---@param handle userdata
---@return number address
function reaper.JS_Window_AddressFromHandle(handle) end

---Finds all child windows of the specified parent.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * The addresses are stored in the provided reaper.array, and can be converted to REAPER objects (HWNDs) by the function JS_Window_HandleFromAddress.
---@param parentHWND userdata
---@param reaperarray userdata
---@return integer rv
function reaper.JS_Window_ArrayAllChild(parentHWND, reaperarray) end

---Finds all top-level windows.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * The addresses are stored in the provided reaper.array, and can be converted to REAPER objects (HWNDs) by the function JS_Window_HandleFromAddress.
---@param reaperarray userdata
---@return integer rv
function reaper.JS_Window_ArrayAllTop(reaperarray) end

---Finds all windows, whether top-level or child, whose titles match the specified string.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * The addresses are stored in the provided reaper.array, and can be converted to REAPER objects (HWNDs) by the function JS_Window_HandleFromAddress.
---Parameters:
--- * exact: Match entire title exactly, or match substring of title.
---@param title string
---@param exact boolean
---@param reaperarray userdata
---@return integer rv
function reaper.JS_Window_ArrayFind(title, exact, reaperarray) end

---@param windowHWND userdata
function reaper.JS_Window_AttachResizeGrip(windowHWND) end

---Attaches a "pin on top" button to the window frame. The button should remember its state when closing and re-opening the window.
---WARNING: This function does not yet work on Linux.
---@param windowHWND userdata
function reaper.JS_Window_AttachTopmostPin(windowHWND) end

---Converts the client-area coordinates of a specified point to screen coordinates.
---NOTES:
--- * On Windows and Linux, screen coordinates are relative to *upper* left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
--- * On all platforms, client coordinates are relative to the upper left corner of the client area.
---@param windowHWND userdata
---@param x integer
---@param y integer
---@return integer x
---@return integer y
function reaper.JS_Window_ClientToScreen(windowHWND, x, y) end

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
---@param style string?
---@param ownerHWND userdata?
---@return userdata rv
---@return string? style
function reaper.JS_Window_Create(title, className, x, y, w, h, style, ownerHWND) end

---Destroys the specified window.
---@param windowHWND userdata
function reaper.JS_Window_Destroy(windowHWND) end

---Enables or disables mouse and keyboard input to the specified window or control.
---@param windowHWND userdata
---@param enable boolean
function reaper.JS_Window_Enable(windowHWND, enable) end

---On macOS, returns the Metal graphics setting:
---2 = Metal enabled and support GetDC()/ReleaseDC() for drawing (more overhead).
---1 = Metal enabled.
---0 = N/A (Windows and Linux).
----1 = non-metal async layered mode.
----2 = non-metal non-async layered mode.
---WARNING: If using mode -1, any BitBlt()/StretchBlt() MUST have the source bitmap persist. If it is resized after Blit it could cause crashes.
---@param windowHWND userdata
---@return integer rv
function reaper.JS_Window_EnableMetal(windowHWND) end

---Returns a HWND to a window whose title matches the specified string.
--- * Unlike the Win32 function FindWindow, this function searches top-level as well as child windows, so that the target window can be found irrespective of docked state.
--- * In addition, the function can optionally match substrings of the title.
--- * Matching is not case sensitive.
---Parameters:
--- * exact: Match entire title, or match substring of title.
---@param title string
---@param exact boolean
---@return userdata rv
function reaper.JS_Window_Find(title, exact) end

---Returns a HWND to a child window whose title matches the specified string.
---Parameters:
--- * exact: Match entire title length, or match substring of title. In both cases, matching is not case sensitive.
---@param parentHWND userdata
---@param title string
---@param exact boolean
---@return userdata rv
function reaper.JS_Window_FindChild(parentHWND, title, exact) end

---Similar to the C++ WIN32 function GetDlgItem, this function finds child windows by ID.
---(The ID of a window may be retrieved by JS_Window_GetLongPtr.)
---@param parentHWND userdata
---@param ID integer
---@return userdata rv
function reaper.JS_Window_FindChildByID(parentHWND, ID) end

---Returns a handle to a child window whose class and title match the specified strings.
---Parameters: * childWindow: The function searches child windows, beginning with the window *after* the specified child window. If childHWND is equal to parentHWND, the search begins with the first child window of parentHWND.
--- * title: An empty string, "", will match all windows. (Search is not case sensitive.)
---@param parentHWND userdata
---@param childHWND userdata
---@param className string
---@param title string
---@return userdata rv
function reaper.JS_Window_FindEx(parentHWND, childHWND, className, title) end

---Returns a HWND to a top-level window whose title matches the specified string.
---Parameters:
--- * exact: Match entire title length, or match substring of title. In both cases, matching is not case sensitive.
---@param title string
---@param exact boolean
---@return userdata rv
function reaper.JS_Window_FindTop(title, exact) end

---Retrieves a HWND to the window that contains the specified point.
---NOTES:
--- * On Windows and Linux, screen coordinates are relative to *upper* left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
---@param x integer
---@param y integer
---@return userdata rv
function reaper.JS_Window_FromPoint(x, y) end

---WARNING: May not be fully implemented on macOS and Linux.
---@param windowHWND userdata
---@return string class
function reaper.JS_Window_GetClassName(windowHWND) end

---Retrieves the screen coordinates of the client area rectangle of the specified window.
---NOTES:
--- * Unlike the C++ function GetClientRect, this function returns the screen coordinates, not the width and height. To get the client size, use GetClientSize.
--- * The pixel at (right, bottom) lies immediately outside the rectangle.
--- * On Windows and Linux, screen coordinates are relative to *upper* left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
---@param windowHWND userdata
---@return boolean rv
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.JS_Window_GetClientRect(windowHWND) end

---@param windowHWND userdata
---@return boolean rv
---@return integer width
---@return integer height
function reaper.JS_Window_GetClientSize(windowHWND) end

---Retrieves a HWND to the window that has the keyboard focus, if the window is attached to the calling thread's message queue.
---@return userdata rv
function reaper.JS_Window_GetFocus() end

---Retrieves a HWND to the top-level foreground window (the window with which the user is currently working).
---@return userdata rv
function reaper.JS_Window_GetForeground() end

---Similar to JS_Window_GetLongPtr, but returns the information as a number instead of a pointer. 
---In the case of "DLGPROC" and "WNDPROC", the return values can be converted to pointers by JS_Window_HandleFromAddress.
---If the function fails, the return value is 0.
---@param windowHWND userdata
---@param info string
---@return number rv
function reaper.JS_Window_GetLong(windowHWND, info) end

---Returns information about the specified window.
---info: "USERDATA", "WNDPROC", "DLGPROC", "ID", "EXSTYLE" or "STYLE".
---For documentation about the types of information returned, refer to the Win32 function GetWindowLongPtr.
---The values returned by "DLGPROC" and "WNDPROC" are typically used as-is, as pointers, whereas the others should first be converted to integers.
---If the function fails, a null pointer is returned.
---@param windowHWND userdata
---@param info string
---@return userdata rv
function reaper.JS_Window_GetLongPtr(windowHWND, info) end

---Retrieves a HWND to the specified window's parent or owner.
---Returns NULL if the window is unowned or if the function otherwise fails.
---@param windowHWND userdata
---@return userdata rv
function reaper.JS_Window_GetParent(windowHWND) end

---Retrieves the screen coordinates of the bounding rectangle of the specified window.
---NOTES:
--- * On Windows and Linux, coordinates are relative to *upper* left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
--- * The pixel at (right, bottom) lies immediately outside the rectangle.
---@param windowHWND userdata
---@return boolean rv
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.JS_Window_GetRect(windowHWND) end

---Retrieves a handle to a window that has the specified relationship (Z-Order or owner) to the specified window.
---relation: "LAST", "NEXT", "PREV", "OWNER" or "CHILD".
---(Refer to documentation for Win32 C++ function GetWindow.)
---@param windowHWND userdata
---@param relation string
---@return userdata rv
function reaper.JS_Window_GetRelated(windowHWND, relation) end

---Retrieves the scroll information of a window.
---Parameters:
--- * windowHWND: The window that contains the scrollbar. This is usually a child window, not a top-level, framed window.
--- * scrollbar: "v" (or "SB_VERT", or "VERT") for vertical scroll, "h" (or "SB_HORZ" or "HORZ") for horizontal.
---Returns:
--- * Leftmost or topmost visible pixel position, as well as the visible page size, the range minimum and maximum, and scroll box tracking position.
---@param windowHWND userdata
---@param scrollbar string
---@return boolean rv
---@return integer position
---@return integer pageSize
---@return integer min
---@return integer max
---@return integer trackPos
function reaper.JS_Window_GetScrollInfo(windowHWND, scrollbar) end

---Returns the title (if any) of the specified window.
---@param windowHWND userdata
---@return string title
function reaper.JS_Window_GetTitle(windowHWND) end

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

---Converts an address to a handle (such as a HWND) that can be utilized by REAPER and other API functions.
---@param address number
---@return userdata rv
function reaper.JS_Window_HandleFromAddress(address) end

---Similar to the Win32 function InvalidateRect.
---@param windowHWND userdata
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
---@param eraseBackground boolean
---@return boolean rv
function reaper.JS_Window_InvalidateRect(windowHWND, left, top, right, bottom, eraseBackground) end

---Determines whether a window is a child window or descendant window of a specified parent window.
---@param parentHWND userdata
---@param childHWND userdata
---@return boolean rv
function reaper.JS_Window_IsChild(parentHWND, childHWND) end

---Determines the visibility state of the window.
---@param windowHWND userdata
---@return boolean rv
function reaper.JS_Window_IsVisible(windowHWND) end

---Determines whether the specified window handle identifies an existing window.
---On macOS and Linux, only windows that were created by WDL/swell will be identified (and only such windows should be acted on by scripts).
---NOTE: Since REAPER v5.974, windows can be checked using the native function ValidatePtr(windowHWND, "HWND").
---@param windowHWND userdata
---@return boolean rv
function reaper.JS_Window_IsWindow(windowHWND) end

---Finds all child windows of the specified parent.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * list: A comma-separated string of hexadecimal values.
---Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
---@param parentHWND userdata
---@return integer rv
---@return string list
function reaper.JS_Window_ListAllChild(parentHWND) end

---Finds all top-level windows.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * list: A comma-separated string of hexadecimal values. Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
---@return integer rv
---@return string list
function reaper.JS_Window_ListAllTop() end

---Finds all windows (whether top-level or child) whose titles match the specified string.
---Returns:
--- * retval: The number of windows found; negative if an error occurred.
--- * list: A comma-separated string of hexadecimal values. Each value is an address that can be converted to a HWND by the function Window_HandleFromAddress.
---Parameters:
--- * exact: Match entire title exactly, or match substring of title.
---@param title string
---@param exact boolean
---@return integer rv
---@return string list
function reaper.JS_Window_ListFind(title, exact) end

---Deprecated - use GetViewportFromRect instead.
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param wantWork boolean
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.JS_Window_MonitorFromRect(x1, y1, x2, y2, wantWork) end

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

---Sends a "WM_COMMAND" message to the specified window, which simulates a user selecting a command in the window menu.
---This function is similar to Main_OnCommand and MIDIEditor_OnCommand, but can send commands to any window that has a menu.
---In the case of windows that are listed among the Action list's contexts (such as the Media Explorer), the commandIDs of the actions in the Actions list may be used.
---@param windowHWND userdata
---@param commandID integer
---@return boolean rv
function reaper.JS_Window_OnCommand(windowHWND, commandID) end

---Changes the dimensions of the specified window, keeping the top left corner position constant.
--- * If resizing script GUIs, call gfx.update() after resizing.
---* Equivalent to calling JS_Window_SetPosition with NOMOVE, NOZORDER, NOACTIVATE and NOOWNERZORDER flags set.
---@param windowHWND userdata
---@param width integer
---@param height integer
function reaper.JS_Window_Resize(windowHWND, width, height) end

---Converts the screen coordinates of a specified point on the screen to client-area coordinates.
---NOTES:
--- * On Windows and Linux, screen coordinates are relative to *upper* left corner of the primary display, and the positive Y-axis points downward.
--- * On macOS, screen coordinates are relative to the *bottom* left corner of the primary display, and the positive Y-axis points upward.
--- * On all platforms, client coordinates are relative to the upper left corner of the client area.
---@param windowHWND userdata
---@param x integer
---@param y integer
---@return integer x
---@return integer y
function reaper.JS_Window_ScreenToClient(windowHWND, x, y) end

---Sets the keyboard focus to the specified window.
---@param windowHWND userdata
function reaper.JS_Window_SetFocus(windowHWND) end

---Brings the specified window into the foreground, activates the window, and directs keyboard input to it.
---@param windowHWND userdata
function reaper.JS_Window_SetForeground(windowHWND) end

---Similar to the Win32 function SetWindowLongPtr. 
---info: "USERDATA", "WNDPROC", "DLGPROC", "ID", "EXSTYLE" or "STYLE", and only on WindowOS, "INSTANCE" and "PARENT".
---@param windowHWND userdata
---@param info string
---@param value number
---@return number rv
function reaper.JS_Window_SetLong(windowHWND, info, value) end

---Sets the window opacity.
---Parameters:
---mode: either "ALPHA" or "COLOR". 
---value: If ALPHA, the specified value may range from zero to one, and will apply to the entire window, frame included. 
---If COLOR, value specifies a 0xRRGGBB color, and all pixels of this color will be made transparent. (All mouse clicks over transparent pixels will pass through, too).  WARNING:
---COLOR mode is only available in Windows, not Linux or macOS.
---Transparency can only be applied to top-level windows. If windowHWND refers to a child window, the entire top-level window that contains windowHWND will be made transparent.
---@param windowHWND userdata
---@param mode string
---@param value number
---@return boolean rv
function reaper.JS_Window_SetOpacity(windowHWND, mode, value) end

---If successful, returns a handle to the previous parent window.
---Only on WindowsOS: If parentHWND is not specified, the desktop window becomes the new parent window.
---@param childHWND userdata
---@param parentHWND userdata?
---@return userdata rv
function reaper.JS_Window_SetParent(childHWND, parentHWND) end

---Interface to the Win32/swell function SetWindowPos, with which window position, size, Z-order and visibility can be set, and new frame styles can be applied.
---ZOrder and flags are optional parameters. If no arguments are supplied, the window will simply be moved and resized, as if the NOACTIVATE, NOZORDER, NOOWNERZORDER flags were set.
--- * ZOrder: "BOTTOM", "TOPMOST", "NOTOPMOST", "TOP" or a window HWND converted to a string, for example by the Lua function tostring.
--- * flags: Any combination of the standard flags, of which "NOMOVE", "NOSIZE", "NOZORDER", "NOACTIVATE", "SHOWWINDOW", "FRAMECHANGED" and "NOCOPYBITS" should be valid cross-platform.
---@param windowHWND userdata
---@param left integer
---@param top integer
---@param width integer
---@param height integer
---@param ZOrder string?
---@param flags string?
---@return boolean rv
---@return string? ZOrder
---@return string? flags
function reaper.JS_Window_SetPosition(windowHWND, left, top, width, height, ZOrder, flags) end

---Parameters:
--- * scrollbar: "v" (or "SB_VERT", or "VERT") for vertical scroll, "h" (or "SB_HORZ" or "HORZ") for horizontal.
---NOTE: API functions can scroll REAPER's windows, but cannot zoom them.  Instead, use actions such as "View: Zoom to one loop iteration".
---@param windowHWND userdata
---@param scrollbar string
---@param position integer
---@return boolean rv
function reaper.JS_Window_SetScrollPos(windowHWND, scrollbar, position) end

---Sets and applies a window style.
---style may include any combination of standard window styles, such as "POPUP" for a frameless window, or "CAPTION,SIZEBOX,SYSMENU" for a standard framed window.
---On Linux and macOS, "MAXIMIZE" has not yet been implmented, and the remaining styles may appear slightly different from their WindowsOS counterparts.
---@param windowHWND userdata
---@param style string
---@return boolean rv
---@return string style
function reaper.JS_Window_SetStyle(windowHWND, style) end

---Changes the title of the specified window. Returns true if successful.
---@param windowHWND userdata
---@param title string
---@return boolean rv
function reaper.JS_Window_SetTitle(windowHWND, title) end

---Sets the window Z order.
--- * Equivalent to calling JS_Window_SetPos with flags NOMOVE | NOSIZE.
--- * Not all the Z orders have been implemented in Linux yet.
---Parameters:
--- * ZOrder: "BOTTOM", "TOPMOST", "NOTOPMOST", "TOP", or a window HWND converted to a string, for example by the Lua function tostring.
---* InsertAfterHWND: For compatibility with older versions, this parameter is still available, and is optional. If ZOrder is "INSERTAFTER", insertAfterHWND must be a handle to the window behind which windowHWND will be placed in the Z order, equivalent to setting ZOrder to this HWND; otherwise, insertAfterHWND is ignored and can be left out (or it can simply be set to the same value as windowHWND).
---@param windowHWND userdata
---@param ZOrder string
---@param insertAfterHWND userdata?
---@return boolean rv
function reaper.JS_Window_SetZOrder(windowHWND, ZOrder, insertAfterHWND) end

---Sets the specified window's show state.
---Parameters:
--- * state: One of the following options: "SHOW", "SHOWNA" (or "SHOWNOACTIVATE"), "SHOWMINIMIZED", "HIDE", "NORMAL", "SHOWNORMAL", "SHOWMAXIMIZED", "SHOWDEFAULT" or "RESTORE". On Linux and macOS, only the first four options are fully implemented.
---@param windowHWND userdata
---@param state string
function reaper.JS_Window_Show(windowHWND, state) end

---Similar to the Win32 function UpdateWindow.
---@param windowHWND userdata
function reaper.JS_Window_Update(windowHWND) end

---Closes the zip archive, using either the file name or the zip handle. Finalizes entries and releases resources.
---@param zipFile string
---@param zipHandle userdata?
---@return integer rv
function reaper.JS_Zip_Close(zipFile, zipHandle) end

---@param zipHandle userdata
---@return integer rv
function reaper.JS_Zip_CountEntries(zipHandle) end

---Deletes the specified entries from an existing Zip file.
---entryNames is zero-separated and double-zero-terminated.
---Returns the number of deleted entries on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param entryNames string
---@param entryNamesStrLen integer
---@return integer rv
function reaper.JS_Zip_DeleteEntries(zipHandle, entryNames, entryNamesStrLen) end

---Closes a zip entry, flushes buffer and releases resources. In WRITE mode, entries must be closed in order to apply and save changes.
---Returns 0 on success, negative number (< 0) on error.
---@param zipHandle userdata
---@return integer rv
function reaper.JS_Zip_Entry_Close(zipHandle) end

---Compresses the specified file into the zip archive's open entry.
---Returns 0 on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param inputFile string
---@return integer rv
function reaper.JS_Zip_Entry_CompressFile(zipHandle, inputFile) end

---Compresses the specified memory buffer into the zip archive's open entry.
---Returns 0 on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param buf string
---@param buf_size integer
---@return integer rv
function reaper.JS_Zip_Entry_CompressMemory(zipHandle, buf, buf_size) end

---Extracts the zip archive's open entry.
---Returns 0 on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param outputFile string
---@return integer rv
function reaper.JS_Zip_Entry_ExtractToFile(zipHandle, outputFile) end

---Extracts and returns the zip archive's open entry.
---Returns the number of bytes extracted on success, negative number (< 0) on error.
---@param zipHandle userdata
---@return integer rv
---@return string contents
function reaper.JS_Zip_Entry_ExtractToMemory(zipHandle) end

---Returns information about the zip archive's open entry.
---@param zipHandle userdata
---@return integer rv
---@return string name
---@return integer index
---@return integer isFolder
---@return number size
---@return number crc32
function reaper.JS_Zip_Entry_Info(zipHandle) end

---Opens a new entry by index in the zip archive.
---This function is only valid if zip archive was opened in 'r' (readonly) mode.
---Returns 0 on success, negative number on error.
---@param zipHandle userdata
---@param index integer
---@return integer rv
function reaper.JS_Zip_Entry_OpenByIndex(zipHandle, index) end

---Opens an entry by name in the zip archive.
---For zip archive opened in 'w' or 'a' mode the function will append a new entry. In readonly mode the function tries to locate an existing entry.
---Returns 0 on success, negative number (< 0) on error.
---@param zipHandle userdata
---@param entryName string
---@return integer rv
function reaper.JS_Zip_Entry_OpenByName(zipHandle, entryName) end

---Returns a descriptive string for the given error code.
---@param errorNum integer
---@return string errorStr
function reaper.JS_Zip_ErrorString(errorNum) end

---Extracts an existing Zip file to the specified folder.
---Returns the number of extracted files on success, negative number (< 0) on error.
---@param zipFile string
---@param outputFolder string
---@return integer rv
function reaper.JS_Zip_Extract(zipFile, outputFolder) end

---Returns the number of entries and a zero-separated and double-zero-terminated string of entry names.
---On error, returns a negative number (< 0).
---@param zipHandle userdata
---@return integer rv
---@return string list
function reaper.JS_Zip_ListAllEntries(zipHandle) end

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
---@return userdata rv
---@return integer rv
function reaper.JS_Zip_Open(zipFile, mode, compressionLevel) end

---This function combines all other NF_Peak/RMS functions in a single one and additionally returns peak RMS positions. Lua example code here. Note: It's recommended to use this function with ReaScript/Lua as it provides reaper.array objects. If using this function with other scripting languages, you must provide arrays in the reaper.array format.
---@param item MediaItem
---@param windowSize number
---@param reaper_array_peaks userdata
---@param reaper_array_peakpositions userdata
---@param reaper_array_RMSs userdata
---@param reaper_array_RMSpositions userdata
---@return boolean rv
function reaper.NF_AnalyzeMediaItemPeakAndRMS(item, windowSize, reaper_array_peaks, reaper_array_peakpositions, reaper_array_RMSs, reaper_array_RMSpositions) end

---Full loudness analysis. retval: returns true on successful analysis, false on MIDI take or when analysis failed for some reason. analyzeTruePeak=true: Also do true peak analysis. Returns true peak value in dBTP and true peak position (relative to item position). Considerably slower than without true peak analysis (since it uses oversampling). Note: Short term uses a time window of 3 sec. for calculation. So for items shorter than this shortTermMaxOut can't be calculated correctly. Momentary uses a time window of 0.4 sec.
---@param take MediaItem_Take
---@param analyzeTruePeak boolean
---@return boolean rv
---@return number lufsIntegrated
---@return number range
---@return number truePeak
---@return number truePeakPos
---@return number shortTermMax
---@return number momentaryMax
function reaper.NF_AnalyzeTakeLoudness(take, analyzeTruePeak) end

---Same as NF_AnalyzeTakeLoudness but additionally returns shortTermMaxPos and momentaryMaxPos (in absolute project time). Note: shortTermMaxPos and momentaryMaxPos indicate the beginning of time intervalls, (3 sec. and 0.4 sec. resp.).
---@param take MediaItem_Take
---@param analyzeTruePeak boolean
---@return boolean rv
---@return number lufsIntegrated
---@return number range
---@return number truePeak
---@return number truePeakPos
---@return number shortTermMax
---@return number momentaryMax
---@return number shortTermMaxPos
---@return number momentaryMaxPos
function reaper.NF_AnalyzeTakeLoudness2(take, analyzeTruePeak) end

---Does LUFS integrated analysis only. Faster than full loudness analysis (NF_AnalyzeTakeLoudness) . Use this if only LUFS integrated is required. Take vol. env. is taken into account. See: Signal flow
---@param take MediaItem_Take
---@return boolean rv
---@return number lufsIntegrated
function reaper.NF_AnalyzeTakeLoudness_IntegratedOnly(take) end

---Returns true on success.
---@param base64Str string
---@return boolean rv
---@return string decodedStr
function reaper.NF_Base64_Decode(base64Str) end

---Input string may contain null bytes in REAPER 6.44 or newer. Note: Doesn't allow padding in the middle (e.g. concatenated encoded strings), doesn't allow newlines.
---@param str string
---@param usePadding boolean
---@return string encodedStr
function reaper.NF_Base64_Encode(str, usePadding) end

---Returns true if global startup action was cleared successfully.
---@return boolean rv
function reaper.NF_ClearGlobalStartupAction() end

---Returns true if project startup action was cleared successfully.
---@return boolean rv
function reaper.NF_ClearProjectStartupAction() end

---Returns true if project track selection action was cleared successfully.
---@return boolean rv
function reaper.NF_ClearProjectTrackSelectionAction() end

---Deletes a take from an item. takeIdx is zero-based. Returns true on success.
---@param item MediaItem
---@param takeIdx integer
---@return boolean rv
function reaper.NF_DeleteTakeFromItem(item, takeIdx) end

---Gets action description and command ID number (for native actions) or named command IDs / identifier strings (for extension actions /ReaScripts) if global startup action is set, otherwise empty string. Returns false on failure.
---@return boolean rv
---@return string desc
---@return string cmdId
function reaper.NF_GetGlobalStartupAction() end

---Returns the average overall (non-windowed) dB RMS level of active channels of an audio item active take, post item gain, post take volume envelope, post-fade, pre fader, pre item FX. 
--- Returns -150.0 if MIDI take or empty item.
---@param item MediaItem
---@return number num
function reaper.NF_GetMediaItemAverageRMS(item) end

---Returns the greatest max. peak value in dBFS of all active channels of an audio item active take, post item gain, post take volume envelope, post-fade, pre fader, pre item FX. 
--- Returns -150.0 if MIDI take or empty item.
---@param item MediaItem
---@return number num
function reaper.NF_GetMediaItemMaxPeak(item) end

---See NF_GetMediaItemMaxPeak, additionally returns maxPeakPos (relative to item position).
---@param item MediaItem
---@return number num
---@return number maxPeakPos
function reaper.NF_GetMediaItemMaxPeakAndMaxPeakPos(item) end

---Returns the greatest overall (non-windowed) dB RMS peak level of all active channels of an audio item active take, post item gain, post take volume envelope, post-fade, pre fader, pre item FX. 
--- Returns -150.0 if MIDI take or empty item.
---@param item MediaItem
---@return number num
function reaper.NF_GetMediaItemPeakRMS_NonWindowed(item) end

---Returns the average dB RMS peak level of all active channels of an audio item active take, post item gain, post take volume envelope, post-fade, pre fader, pre item FX. 
--- Obeys 'Window size for peak RMS' setting in 'SWS: Set RMS analysis/normalize options' for calculation. Returns -150.0 if MIDI take or empty item.
---@param item MediaItem
---@return number num
function reaper.NF_GetMediaItemPeakRMS_Windowed(item) end

---Gets action description and command ID number (for native actions) or named command IDs / identifier strings (for extension actions /ReaScripts) if project startup action is set, otherwise empty string. Returns false on failure.
---@return boolean rv
---@return string desc
---@return string cmdId
function reaper.NF_GetProjectStartupAction() end

---Gets action description and command ID number (for native actions) or named command IDs / identifier strings (for extension actions /ReaScripts) if project track selection action is set, otherwise empty string. Returns false on failure.
---@return boolean rv
---@return string desc
---@return string cmdId
function reaper.NF_GetProjectTrackSelectionAction() end

---Returns SWS/S&M marker/region subtitle. markerRegionIdx: Refers to index that can be passed to EnumProjectMarkers (not displayed marker/region index). Returns empty string if marker/region with specified index not found or marker/region subtitle not set. Lua code example here.
---@param markerRegionIdx integer
---@return string str
function reaper.NF_GetSWSMarkerRegionSub(markerRegionIdx) end

---@param track MediaTrack
---@return string str
function reaper.NF_GetSWSTrackNotes(track) end

---Get SWS analysis/normalize options. See NF_SetSWS_RMSoptions.
---@return number target
---@return number windowSize
function reaper.NF_GetSWS_RMSoptions() end

---@return integer supercollapsed
---@return integer collapsed
---@return integer small
---@return integer recarm
function reaper.NF_GetThemeDefaultTCPHeights() end

---Returns the bitrate of an audio file in kb/s if available (0 otherwise). For supported filetypes see TagLib::AudioProperties::bitrate.
---@param fn string
---@return integer rv
function reaper.NF_ReadAudioFileBitrate(fn) end

---100 means scroll one page. Negative values scroll left.
---@param amount integer
function reaper.NF_ScrollHorizontallyByPercentage(amount) end

---Returns true if global startup action was set successfully (i.e. valid action ID). Note: For SWS / S&M actions and macros / scripts, you must use identifier strings (e.g. "_SWS_ABOUT", "_f506bc780a0ab34b8fdedb67ed5d3649"), not command IDs (e.g. "47145").
---Tip: to copy such identifiers, right-click the action in the Actions window > Copy selected action cmdID / identifier string.
---NOnly works for actions / scripts from Main action section.
---@param str string
---@return boolean rv
function reaper.NF_SetGlobalStartupAction(str) end

---Returns true if project startup action was set successfully (i.e. valid action ID). Note: For SWS / S&M actions and macros / scripts, you must use identifier strings (e.g. "_SWS_ABOUT", "_f506bc780a0ab34b8fdedb67ed5d3649"), not command IDs (e.g. "47145").
---Tip: to copy such identifiers, right-click the action in the Actions window > Copy selected action cmdID / identifier string.
---Only works for actions / scripts from Main action section. Project must be saved after setting project startup action to be persistent.
---@param str string
---@return boolean rv
function reaper.NF_SetProjectStartupAction(str) end

---Returns true if project track selection action was set successfully (i.e. valid action ID). Note: For SWS / S&M actions and macros / scripts, you must use identifier strings (e.g. "_SWS_ABOUT", "_f506bc780a0ab34b8fdedb67ed5d3649"), not command IDs (e.g. "47145").
---Tip: to copy such identifiers, right-click the action in the Actions window > Copy selected action cmdID / identifier string.
---Only works for actions / scripts from Main action section. Project must be saved after setting project track selection action to be persistent.
---@param str string
---@return boolean rv
function reaper.NF_SetProjectTrackSelectionAction(str) end

---Set SWS/S&M marker/region subtitle. markerRegionIdx: Refers to index that can be passed to EnumProjectMarkers (not displayed marker/region index). Returns true if subtitle is set successfully (i.e. marker/region with specified index is present in project). Lua code example here.
---@param markerRegionSub string
---@param markerRegionIdx integer
---@return boolean rv
function reaper.NF_SetSWSMarkerRegionSub(markerRegionSub, markerRegionIdx) end

---@param track MediaTrack
---@param str string
function reaper.NF_SetSWSTrackNotes(track, str) end

---Set SWS analysis/normalize options (same as running action 'SWS: Set RMS analysis/normalize options'). targetLevel: target RMS normalize level (dB), windowSize: window size for peak RMS (sec.)
---@param targetLevel number
---@param windowSize number
---@return boolean rv
function reaper.NF_SetSWS_RMSoptions(targetLevel, windowSize) end

---Deprecated, see TakeFX_GetNamedConfigParm/'fx_ident' (v6.37+). See BR_TrackFX_GetFXModuleName. fx: counted consecutively across all takes (zero-based).
---@param item MediaItem
---@param fx integer
---@return boolean rv
---@return string name
function reaper.NF_TakeFX_GetFXModuleName(item, fx) end

---Redraw the Notes window (call if you've changed a subtitle via NF_SetSWSMarkerRegionSub which is currently displayed in the Notes window and you want to appear the new subtitle immediately.)
function reaper.NF_UpdateSWSMarkerRegionSubWindow() end

---Equivalent to win32 API GetSystemMetrics(). Note: Only SM_C[XY]SCREEN, SM_C[XY][HV]SCROLL and SM_CYMENU are currently supported on macOS and Linux as of REAPER 6.68. Check the SWELL source code for up-to-date support information (swell-wnd.mm, swell-wnd-generic.cpp).
---@param nIndex integer
---@return integer rv
function reaper.NF_Win32_GetSystemMetrics(nIndex) end

---Show the about dialog of the given package entry.
---The repository index is downloaded asynchronously if the cached copy doesn't exist or is older than one week.
---@param entry PackageEntry
---@return boolean rv
function reaper.ReaPack_AboutInstalledPackage(entry) end

---Show the about dialog of the given repository. Returns true if the repository exists in the user configuration.
---The repository index is downloaded asynchronously if the cached copy doesn't exist or is older than one week.
---@param repoName string
---@return boolean rv
function reaper.ReaPack_AboutRepository(repoName) end

---Add or modify a repository. Set url to nullptr (or empty string in Lua) to keep the existing URL. Call ReaPack_ProcessQueue(true) when done to process the new list and update the GUI.
---autoInstall: usually set to 2 (obey user setting).
---@param name string
---@param url string
---@param enable boolean
---@param autoInstall integer
---@return boolean rv
---@return string error
function reaper.ReaPack_AddSetRepository(name, url, enable, autoInstall) end

---Opens the package browser with the given filter string.
---@param filter string
function reaper.ReaPack_BrowsePackages(filter) end

---Returns 0 if both versions are equal, a positive value if ver1 is higher than ver2 and a negative value otherwise.
---@param ver1 string
---@param ver2 string
---@return integer rv
---@return string error
function reaper.ReaPack_CompareVersions(ver1, ver2) end

---Enumerate the files owned by the given package. Returns false when there is no more data.
---sections: 0=not in action list, &1=main, &2=midi editor, &4=midi inline editor
---type: see ReaPack_GetEntryInfo.
---@param entry PackageEntry
---@param index integer
---@return boolean rv
---@return string path
---@return integer sections
---@return integer type
function reaper.ReaPack_EnumOwnedFiles(entry, index) end

---Free resources allocated for the given package entry.
---@param entry PackageEntry
---@return boolean rv
function reaper.ReaPack_FreeEntry(entry) end

---Get the repository name, category, package name, package description, package type, the currently installed version, author name, flags (&1=Pinned, &2=BleedingEdge) and how many files are owned by the given package entry.
---type: 1=script, 2=extension, 3=effect, 4=data, 5=theme, 6=langpack, 7=webinterface
---@param entry PackageEntry
---@return boolean rv
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

---Returns the package entry owning the given file.
---Delete the returned object from memory after use with ReaPack_FreeEntry.
---@param fn string
---@return PackageEntry rv
---@return string error
function reaper.ReaPack_GetOwner(fn) end

---Get the infos of the given repository.
---autoInstall: 0=manual, 1=when sychronizing, 2=obey user setting
---@param name string
---@return boolean rv
---@return string url
---@return boolean enabled
---@return integer autoInstall
function reaper.ReaPack_GetRepositoryInfo(name) end

---Run pending operations and save the configuration file. If refreshUI is true the browser and manager windows are guaranteed to be refreshed (otherwise it depends on which operations are in the queue).
---@param refreshUI boolean
function reaper.ReaPack_ProcessQueue(refreshUI) end

---[S&M] Deprecated, see CreateTrackSend (v5.15pre1+). Adds a receive. Returns false if nothing updated.
---type -1=Default type (user preferences), 0=Post-Fader (Post-Pan), 1=Pre-FX, 2=deprecated, 3=Pre-Fader (Post-FX).
---Note: obeys default sends preferences, supports frozen tracks, etc..
---@param src MediaTrack
---@param dest MediaTrack
---@param type integer
---@return boolean rv
function reaper.SNM_AddReceive(src, dest, type) end

---[S&M] Add an FX parameter knob in the TCP. Returns false if nothing updated (invalid parameters, knob already present, etc..)
---@param tr MediaTrack
---@param fxId integer
---@param prmId integer
---@return boolean rv
function reaper.SNM_AddTCPFXParm(tr, fxId, prmId) end

---[S&M] Instantiates a new "fast string". You must delete this string, see SNM_DeleteFastString.
---@param str string
---@return WDL_FastString rv
function reaper.SNM_CreateFastString(str) end

---[S&M] Deletes a "fast string" instance.
---@param str WDL_FastString
function reaper.SNM_DeleteFastString(str) end

---[S&M] Returns a floating-point preference (look in project prefs first, then in general prefs). Returns errvalue if failed (e.g. varname not found).
---@param varname string
---@param errvalue number
---@return number num
function reaper.SNM_GetDoubleConfigVar(varname, errvalue) end

---[S&M] See SNM_GetDoubleConfigVar.
---@param proj ReaProject|nil|0
---@param varname string
---@param errvalue number
---@return number num
function reaper.SNM_GetDoubleConfigVarEx(proj, varname, errvalue) end

---[S&M] Gets the "fast string" content.
---@param str WDL_FastString
---@return string str
function reaper.SNM_GetFastString(str) end

---[S&M] Gets the "fast string" length.
---@param str WDL_FastString
---@return integer rv
function reaper.SNM_GetFastStringLength(str) end

---[S&M] Returns an integer preference (look in project prefs first, then in general prefs). Returns errvalue if failed (e.g. varname not found).
---@param varname string
---@param errvalue integer
---@return integer rv
function reaper.SNM_GetIntConfigVar(varname, errvalue) end

---[S&M] See SNM_GetIntConfigVar.
---@param proj ReaProject|nil|0
---@param varname string
---@param errvalue integer
---@return integer rv
function reaper.SNM_GetIntConfigVarEx(proj, varname, errvalue) end

---[S&M] Reads a 64-bit integer preference split in two 32-bit integers (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found).
---@param varname string
---@return boolean rv
---@return integer high
---@return integer low
function reaper.SNM_GetLongConfigVar(varname) end

---[S&M] See SNM_GetLongConfigVar.
---@param proj ReaProject|nil|0
---@param varname string
---@return boolean rv
---@return integer high
---@return integer low
function reaper.SNM_GetLongConfigVarEx(proj, varname) end

---[S&M] Gets a take by GUID as string. The GUID must be enclosed in braces {}. To get take GUID as string, see BR_GetMediaItemTakeGUID
---@param project ReaProject|nil|0
---@param guid string
---@return MediaItem_Take rv
function reaper.SNM_GetMediaItemTakeByGUID(project, guid) end

---[S&M] Gets a marker/region name. Returns true if marker/region found.
---@param proj ReaProject|nil|0
---@param num integer
---@param isrgn boolean
---@param name WDL_FastString
---@return boolean rv
function reaper.SNM_GetProjectMarkerName(proj, num, isrgn, name) end

---[S&M] Gets or sets the state of a track, an item or an envelope. The state chunk size is unlimited. Returns false if failed.
---When getting a track state (and when you are not interested in FX data), you can use wantminimalstate=true to radically reduce the length of the state. Do not set such minimal states back though, this is for read-only applications!
---Note: unlike the native GetSetObjectState, calling to FreeHeapPtr() is not required.
---@param obj userdata
---@param state WDL_FastString
---@param setnewvalue boolean
---@param wantminimalstate boolean
---@return boolean rv
function reaper.SNM_GetSetObjectState(obj, state, setnewvalue, wantminimalstate) end

---[S&M] Gets or sets a take source state. Returns false if failed. Use takeidx=-1 to get/alter the active take.
---Note: this function does not use a MediaItem_Take* param in order to manage empty takes (i.e. takes with MediaItem_Take*==NULL), see SNM_GetSetSourceState2.
---@param item MediaItem
---@param takeidx integer
---@param state WDL_FastString
---@param setnewvalue boolean
---@return boolean rv
function reaper.SNM_GetSetSourceState(item, takeidx, state, setnewvalue) end

---[S&M] Gets or sets a take source state. Returns false if failed.
---Note: this function cannot deal with empty takes, see SNM_GetSetSourceState.
---@param take MediaItem_Take
---@param state WDL_FastString
---@param setnewvalue boolean
---@return boolean rv
function reaper.SNM_GetSetSourceState2(take, state, setnewvalue) end

---[S&M] Deprecated, see GetMediaSourceType. Gets the source type of a take. Returns false if failed (e.g. take with empty source, etc..)
---@param take MediaItem_Take
---@param type WDL_FastString
---@return boolean rv
function reaper.SNM_GetSourceType(take, type) end

---[S&M] Deprecated, see TrackFX_{CopyToTrack,Delete} (v5.95+). Move or removes a track FX. Returns true if tr has been updated.
---fxId: fx index in chain or -1 for the selected fx. what: 0 to remove, -1 to move fx up in chain, 1 to move fx down in chain.
---@param tr MediaTrack
---@param fxId integer
---@param what integer
---@return boolean rv
function reaper.SNM_MoveOrRemoveTrackFX(tr, fxId, what) end

---[S&M] Reads a media file tag. Supported tags: "artist", "album", "genre", "comment", "title", "track" (track number) or "year". Returns false if tag was not found. See SNM_TagMediaFile.
---@param fn string
---@param tag string
---@return boolean rv
---@return string tagval
function reaper.SNM_ReadMediaFileTag(fn, tag) end

---[S&M] Deprecated, see RemoveTrackSend (v5.15pre1+). Removes a receive. Returns false if nothing updated.
---@param tr MediaTrack
---@param rcvidx integer
---@return boolean rv
function reaper.SNM_RemoveReceive(tr, rcvidx) end

---[S&M] Removes all receives from srctr. Returns false if nothing updated.
---@param tr MediaTrack
---@param srctr MediaTrack
---@return boolean rv
function reaper.SNM_RemoveReceivesFrom(tr, srctr) end

---[S&M] Select a bookmark of the Resources window. Returns the related bookmark id (or -1 if failed).
---@param name string
---@return integer rv
function reaper.SNM_SelectResourceBookmark(name) end

---[S&M] Sets a floating-point preference (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found or newvalue out of range).
---@param varname string
---@param newvalue number
---@return boolean rv
function reaper.SNM_SetDoubleConfigVar(varname, newvalue) end

---[S&M] See SNM_SetDoubleConfigVar.
---@param proj ReaProject|nil|0
---@param varname string
---@param newvalue number
---@return boolean rv
function reaper.SNM_SetDoubleConfigVarEx(proj, varname, newvalue) end

---[S&M] Sets the "fast string" content. Returns str for facility.
---@param str WDL_FastString
---@param newstr string
---@return WDL_FastString rv
function reaper.SNM_SetFastString(str, newstr) end

---[S&M] Sets an integer preference (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found or newvalue out of range).
---@param varname string
---@param newvalue integer
---@return boolean rv
function reaper.SNM_SetIntConfigVar(varname, newvalue) end

---[S&M] See SNM_SetIntConfigVar.
---@param proj ReaProject|nil|0
---@param varname string
---@param newvalue integer
---@return boolean rv
function reaper.SNM_SetIntConfigVarEx(proj, varname, newvalue) end

---[S&M] Sets a 64-bit integer preference from two 32-bit integers (look in project prefs first, then in general prefs). Returns false if failed (e.g. varname not found).
---@param varname string
---@param newHighValue integer
---@param newLowValue integer
---@return boolean rv
function reaper.SNM_SetLongConfigVar(varname, newHighValue, newLowValue) end

---[S&M] SNM_SetLongConfigVar.
---@param proj ReaProject|nil|0
---@param varname string
---@param newHighValue integer
---@param newLowValue integer
---@return boolean rv
function reaper.SNM_SetLongConfigVarEx(proj, varname, newHighValue, newLowValue) end

---[S&M] Deprecated, see SetProjectMarker4 -- Same function as SetProjectMarker3() except it can set empty names "".
---@param proj ReaProject|nil|0
---@param num integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color integer
---@return boolean rv
function reaper.SNM_SetProjectMarker(proj, num, isrgn, pos, rgnend, name, color) end

---[S&M] Sets a string preference (general prefs only). Returns false if failed (e.g. varname not found or value too long). See get_config_var_string.
---@param varname string
---@param newvalue string
---@return boolean rv
function reaper.SNM_SetStringConfigVar(varname, newvalue) end

---[S&M] Tags a media file thanks to TagLib. Supported tags: "artist", "album", "genre", "comment", "title", "track" (track number) or "year". Use an empty tagval to clear a tag. When a file is opened in REAPER, turn it offline before using this function. Returns false if nothing updated. See SNM_ReadMediaFileTag.
---@param fn string
---@param tag string
---@param tagval string
---@return boolean rv
function reaper.SNM_TagMediaFile(fn, tag, tagval) end

---[S&M] Attach Resources slot actions to a given bookmark.
---@param bookmarkId integer
function reaper.SNM_TieResourceSlotActions(bookmarkId) end

---Focuses the active/open MIDI editor.
function reaper.SN_FocusMIDIEditor() end

---[ULT] Deprecated, see GetSetMediaItemInfo_String (v5.95+). Get item notes.
---@param item MediaItem
---@return string str
function reaper.ULT_GetMediaItemNote(item) end

---[ULT] Deprecated, see GetSetMediaItemInfo_String (v5.95+). Set item notes.
---@param item MediaItem
---@param note string
function reaper.ULT_SetMediaItemNote(item, note) end

---Creates writer for 32 bit floating point WAV
---@param filename string
---@param numchans integer
---@param samplerate integer
---@return AudioWriter rv
function reaper.Xen_AudioWriter_Create(filename, numchans, samplerate) end

---Destroys writer
---@param writer AudioWriter
function reaper.Xen_AudioWriter_Destroy(writer) end

---Write interleaved audio data to disk
---@param writer AudioWriter
---@param numframes integer
---@param data userdata
---@param offset integer
---@return integer rv
function reaper.Xen_AudioWriter_Write(writer, numframes, data, offset) end

---Get interleaved audio data from media source
---@param src PCM_source
---@param destbuf userdata
---@param destbufoffset integer
---@param numframes integer
---@param numchans integer
---@param samplerate number
---@param sourceposition number
---@return integer rv
function reaper.Xen_GetMediaSourceSamples(src, destbuf, destbufoffset, numframes, numchans, samplerate, sourceposition) end

---Start audio preview of a PCM_source. Returns id of a preview handle that can be provided to Xen_StopSourcePreview.
---If the given PCM_source does not belong to an existing MediaItem/Take, it will be deleted by the preview system when the preview is stopped.
---@param source PCM_source
---@param gain number
---@param loop boolean
---@param outputchanindexIn integer?
---@return integer rv
function reaper.Xen_StartSourcePreview(source, gain, loop, outputchanindexIn) end

---Stop audio preview. id -1 stops all.
---ReaScript/EEL2 Built-in Function List
---@param preview_id integer
---@return integer rv
function reaper.Xen_StopSourcePreview(preview_id) end

---is_new_value,filename,sectionID,cmdID,mode,resolution,val,contextstr = reaper.get_action_context()
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
---@param func function
---@return boolean retval
function reaper.defer(func) end

---Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to defer().
---Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
---@param func function
---@return boolean retval
function reaper.runloop(func) end

---Adds code to be executed when the script finishes or is ended by the user. Typically used to clean up after the user terminates defer() or runloop() code.
---@param func function
---@return boolean retval
function reaper.atexit(func) end

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
function gfx.triangle(x1, y1, x2, y2, x3, y3, x4, y4, ...) end

---Updates the graphics display, if opened
---@return number retval
function gfx.update() end

---Returns the path to the directory containing imgui.lua, imgui.py and gfx2imgui.lua.
---@return string path
function reaper.ImGui_GetBuiltinPath() end
