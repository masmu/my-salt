function error_handler(event)
    if event['error'] ~= nil then
        local command = ('notify-send -u critical -i "%s" -a mpv -- "%s" "%s"')
            :format(
                '/usr/share/icons/hicolor/64x64/apps/mpv.png',
                'Error',
                event['error'])
        os.execute(command)
    end
end

mp.register_event("end-file", error_handler)
