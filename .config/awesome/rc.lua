-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
require("eminent")
-- Notification library
require("naughty")
require("revelation")
local vicious = require("vicious")



-- COLOURS
coldef  = "</span>"
colblk  = "<span color='#1a1a1a'>"
colred  = "<span color='#b23535'>"
colgre  = "<span color='#60801f'>"
colyel  = "<span color='#be6e00'>"
colblu  = "<span color='#1f6080'>"
colmag  = "<span color='#8f46b2'>"
colcya  = "<span color='#73afb4'>"
colwhi  = "<span color='#b2b2b2'>"
colbblk = "<span color='#333333'>"
colbred = "<span color='#ff4b4b'>"
colbgre = "<span color='#9bcd32'>"
colbyel = "<span color='#d79b1e'>"
colbblu = "<span color='#329bcd'>"
colbmag = "<span color='#cd64ff'>"
colbcya = "<span color='#9bcdff'>"
colbwhi = "<span color='#ffffff'>"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/rbown/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,     --1
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    names = {"☯", "☥", "♎", "♨"}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    --tags[s] = awful.tag({ 1, 2, 3 }, s, layouts[4])
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5 }, s, awful.layout.suit.tile)
    tags[s] = awful.tag(tags.names, s, awful.layout.suit.tile)
end
-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

--Memory widget
memwidget = widget({ type = "textbox" })
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, '($2MB/$3MB)(<span color="#00EE00">$1%</span>)', 10)

membar = awful.widget.progressbar()

membar:set_width(8)
membar:set_height(10)
membar:set_vertical(true)
membar:set_background_color("#1793D1")
membar:set_border_color(nil)
membar:set_color("#1793D1")
membar:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })

vicious.register(membar, vicious.widgets.mem, "$1", 1)



-- CPU temp widget
tempwidget = widget({ type = "textbox" })
    vicious.register(tempwidget, vicious.widgets.thermal,
    function (widget, args)
        if  args[1] >= 65 and args[1] < 75 then
            return "" .. colyel .. "" .. coldef .. colbyel .. args[1] .. "°C" .. coldef .. ""
        elseif args[1] >= 75 and args[1] < 80 then
            return "" .. colred .. "" .. coldef .. colbred .. args[1] .. "°C" .. coldef .. ""
        elseif args[1] > 80 then
            naughty.notify({ title = "Temperature Warning", text = "Running hot! " .. args[1] .. "°C!\nTake it easy.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
            return "" .. colred .. "" .. coldef .. colbred .. args[1] .. "°C" .. coldef .. "" 
        else
            return "" .. colwhi .. "" .. coldef .. colbwhi .. args[1] .. "°C" .. coldef .. ""
        end
    end, 10, "thermal_zone0" )

--baticon.image = image(beautiful.widget_bat)
batwidget = widget({ type = "textbox" })
    vicious.register(batwidget, vicious.widgets.bat,
    function (widget, args)
        if args[2] >= 25 and args[2] < 50 then
            return "" .. colyel .. "" .. coldef .. colbyel .. args[1] ..args[2] .. "%" .. "(" .. args[3] .. ")" .. coldef .. ""
        elseif args[2] >= 10 and args[2] < 25 then
            return "" .. colred .. "" .. coldef .. colbred .. args[1] ..args[2] .. "%" .. "(" .. args[3] .. ")" .. coldef .. ""
        elseif args[2] < 10 and args[1] == "-" then
            naughty.notify({ title = "Battery Warning", text = "Battery low! "..args[2].."% left!\nBetter get some power.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
            return "" .. colred .. "" .. coldef .. colbred .. args[1] .. args[2] .. "%" .. "(" .. args[3] .. ")" .. coldef .. ""
        elseif args[2] < 10 then 
            return "" .. colred .. "" .. coldef .. colbred .. args[1] .. args[2] .. "%" .. "(" .. args[3] .. ")" .. coldef .. ""
        else
            return "" .. colwhi .. "" .. coldef .. colbwhi .. args[1] .. args[2] .. "%" .. "(" .. args[3] .. ")" .. coldef .. ""
        end
    end, 20, "BAT0"    )

  
  
cpuwidget = awful.widget.graph()
cpuwidget:set_width(40)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#FF5656")
cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
vicious.register(cpuwidget, vicious.widgets.cpu, "$1")

uptimewidget = widget({ type = "textbox" })
uptimewidget.width, uptimewidget.align = 40, "right"
vicious.register(uptimewidget, vicious.widgets.uptime, "$3:$2:$1", 60)


-- Volume widget
volwidget = widget({ type = "textbox" })
    vicious.register(volwidget, vicious.widgets.volume,
        function (widget, args)
            if args[1] == 0 or args[2] == "♩" then
                return "" .. colwhi .. "" .. coldef .. colbred .. "mute" .. coldef .. "" 
            else
                return "" .. colwhi .. "" .. coldef .. colbwhi .. args[1] .. "%" .. coldef .. ""
            end
        end, 1, "Master" )
    volwidget:buttons(
        awful.util.table.join(
            awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle")   end),
            awful.button({ }, 3, function () awful.util.spawn( terminal .. " -e alsamixer")   end),
            awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 3%+") end),
            awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 3%-") end)
        )
    )


-- widget separator
separator = widget({ type = "textbox" })
separator.text  = "|"

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        separator,
        memwidget,
	    separator,
        cpuwidget.widget,
	    separator,
--	uptimewidget,
--	separator,
        batwidget,
	    separator,
        volwidget,
	    separator,
	    tempwidget,
	    separator,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "e", revelation),
    awful.key({ modkey,           }, "a", function () mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible end),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    
    
    -- Programs
    -- launchers
    awful.key({ "Mod1", "Control"   }, "Delete",                function () awful.util.spawn("xscreensaver-command --lock") end),
    awful.key({                     }, "XF86Calculator",        function () awful.util.spawn("gcalctool") end),
    -- volume + mpd
    awful.key({                   }, "XF86AudioLowerVolume",  function () awful.util.spawn("amixer -q sset Master 3%-") end),
    awful.key({                   }, "XF86AudioRaiseVolume",  function () awful.util.spawn("amixer -q sset Master 3%+") end),
    awful.key({                   }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 3") end),
    awful.key({                   }, "XF86MonBrightnessUp",   function () awful.util.spawn("xbacklight -inc 3") end),
    awful.key({                   }, "XF86AudioStop",         function () awful.util.spawn("mpc stop") end),
    awful.key({                   }, "XF86AudioPlay",         function () awful.util.spawn("mpc toggle") end),
    awful.key({                   }, "XF86AudioNext",         function () awful.util.spawn("mpc next") end),
    awful.key({                   }, "XF86AudioPrev",         function () awful.util.spawn("mpc prev") end),
    awful.key({                   }, "XF86AudioMute",         function () awful.util.spawn("amixer -q set Master toggle") end),
    awful.key({ modkey,           }, "g",                     function () awful.util.spawn(terminal .. " -e ranger") end), 
    awful.key({ modkey,           }, "b",                     function () awful.util.spawn("chromium") end), 
    awful.key({ "Shift",          }, "Print",                 function () awful.util.spawn("import  sora screenshot.jpg") end),
    --awful.key({ modkey,           }, "m",                     function () awful.util.spawn(terminal .. " -e ncmpcpp") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/Pictures/screenshots/ 2>dev/null'") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
