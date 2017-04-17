utils = require 'mp.utils'

function do_screenshot()
    local time_pos = mp.get_property('time-pos')
    local filepath = mp.get_property('path')
    local filename = mp.get_property('filename')
    local screenshot = get_screenshot_filename()
    
    mp.osd_message('writing screenshot ...')
    mp.commandv('screenshot_to_file', screenshot)
    mp.commandv('run', '{{ home }}/.bin/set-image-meta',
        screenshot,
       'Software:mpv',
       'VideoTitle:' .. filename,
       'VideoURL:' .. filepath,
       'VideoPosition:' .. math.floor(time_pos * 1000))
    mp.osd_message(screenshot)
end

function file_exists(name)
   local f=io.open(name, 'r')
   if f~=nil then io.close(f) return true else return false end
end

function get_screenshot_filename()
    local screenshot_dir  = mp.get_property('options/screenshot-directory')
    local screenshot_tmpl = mp.get_property('options/screenshot-template')
    local screenshot_ext  = mp.get_property('options/screenshot-format')
    screenshot_tmpl = screenshot_tmpl:gsub('%%f', mp.get_property('filename'))
    local count = 1
    local filename = nil
    while true do
        filename = utils.join_path(
            screenshot_dir, screenshot_tmpl:gsub('%%01n', count) .. '.' .. screenshot_ext)
        if file_exists(filename) == false then
            return filename
        end
        count = count + 1
    end
end

mp.add_forced_key_binding('Ctrl+Alt+s', 'do_screenshot', function() do_screenshot() end)
