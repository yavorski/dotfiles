--------------------------------------------------------------
-- [[ hyprland ]] --
--------------------------------------------------------------

--- @module "/usr/share/hypr/stubs"
--- https://wiki.hypr.land/Configuring/Start

------------------------------------------------------------------------------
-- Environment Variables --
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables
------------------------------------------------------------------------------

hl.env("GTK_THEME", "Adwaita:dark")

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Adwaita")

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct,qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

--------------------------------------------------------------
-- Auto Start --
-- https://wiki.hypr.land/Configuring/Basics/Autostart
--------------------------------------------------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("nwg-look -a")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
end)

--------------------------------------------------------------
-- Monitors --
-- https://wiki.hypr.land/Configuring/Basics/Monitors
--------------------------------------------------------------

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = 1
})

--------------------------------------------------------------
-- Programs --
--------------------------------------------------------------

-- Set programs that you use
local terminal = "alacritty"
local floating_terminal = 'ghostty --class="Ghostty.Terminal"'

local app_menu = "fuzzel"
local app_menu_run = "fuzzel --list-executables-in-path"

local file_manager = "cosmic-files"
local file_manager_terminal = 'env YAZI_NO_BORDER=1 ghostty --class="yazi.files" --title="File Manager" -e yazi'

local process_system_monitor = 'alacritty --class="BTM" --title="Process/System Monitor" --option "window.padding.x=10" --option "window.padding.y=4" -e btm --basic --tree'

--------------------------------------------------------------
-- Layer Rules --
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
--------------------------------------------------------------

-- Fuzzel
hl.layer_rule({
  name = "fuzzel",
  animation = "popin",
  match = { namespace = "launcher" }
})

-- nwg-bar
hl.layer_rule({
  name = "nwg-bar-power-menu",
  blur = true,
  match = { namespace = "gtk-layer-shell" }
})

--------------------------------------------------------------
-- Window Rules --
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
--------------------------------------------------------------

-- Floating Terminal
hl.window_rule({
  name = "floating-terminal",
  float = true,
  center = true,
  size = { "(monitor_w*0.85)", 1015 },
  match = { class = "^(Kitty|Ghostty.Terminal)$" }
})

-- Toggle border
hl.window_rule({
  name = "toggle-border",
  border_size = 2,
  match = { tag = "has-border" }
})

-- Ignore maximize requests from apps
hl.window_rule({
  name = "suppress-maximize-event",
  suppress_event = "maximize",
  match = { class = ".*" }
})

-- Fix dragging issues with XWayland
hl.window_rule({
  name = "xwayland-dragging-fix",
  no_focus = true,
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    pin = false,
    fullscreen = false
  }
})

--------------------------------------------------------------
-- Smart Rules
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules
--------------------------------------------------------------

-- hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "r[4-4]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "r[4-4] f[1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "r[4-4] w[tv1]", gaps_out = 0, gaps_in = 0 })

--------------------------------------------------------------
-- Floating Apps --
--------------------------------------------------------------

-- print
hl.window_rule({
  name = "print",
  float = true,
  match = { title = "^(Print)$" }
})

-- transmission
hl.window_rule({
  name = "transmission",
  float = true,
  center = true,
  size = { "(monitor_w*0.8)", "(monitor_h*0.8)" },
  match = { title = "^(Transmission)$" }
})

-- drawing
hl.window_rule({
  name = "gnome-drawing",
  float = true,
  center = true,
  size = { "(monitor_w*0.85)", "(monitor_h*0.85)" },
  match = { class = "^(com.github.maoschanz.drawing)$" }
})

-- image-viewer
hl.window_rule({
  name = "gnome-loupe",
  float = true,
  center = true,
  size = { "(monitor_w*0.85)", "(monitor_h*0.85)" },
  match = { class = "^(org.gnome.Loupe)$" }
})

-- calculator
hl.window_rule({
  name = "gnome-calculator",
  float = true,
  center = true,
  size = { "(monitor_w*0.25)", "(monitor_h*0.75)" },
  match = { class = "^(org.gnome.Calculator)$" }
})

-- portal
hl.window_rule({
  name = "xdg-desktop-portal-gtk",
  float = true,
  center = true,
  size = { "(monitor_w*0.75)", "(monitor_h*0.75)" },
  match = { class = "^(xdg-desktop-portal-gtk)$" }
})

-- cosmic-files
hl.window_rule({
  name = "cosmic-files",
  float = true,
  center = true,
  animation = "popin",
  size = { "(monitor_w*0.9)", "(monitor_h*0.84)" },
  match = { class = "^(com.system76.CosmicFiles)$" }
})

-- BTM
hl.window_rule({
  name = "bottom-process-system-monitor",
  float = true,
  center = true,
  border_size = 2,
  size = { "(monitor_w*0.94)", "(monitor_h*0.9)" },
  match = { class = "^(BTM)$" }
})

-- yazi
hl.window_rule({
  name = "yazi",
  float = true,
  center = true,
  border_size = 2,
  size = { "(monitor_w*0.94)", "(monitor_h*0.9)" },
  match = { class = "^(yazi.files)$" }
})

-- MPV
hl.window_rule({
  name = "mpv",
  float = true,
  center = true,
  min_size = { 960, 600 },
  size = { "(monitor_w*0.96)", "(monitor_h*0.92)" },
  match = { class = "^(mpv)$" }
})

-- neovide
hl.window_rule({
  name = "neovide",
  float = true,
  center = true,
  size = { 1804, 1078 },
  match = { class = "^(neovide)$" }
})

-- Zathura
hl.window_rule({
  name = "zathura-pdf",
  float = true,
  center = true,
  border_size = 2,
  size = { "(monitor_w*0.94)", "(monitor_h*0.9)" },
  match = { class = "^(org.pwmt.zathura)$" }
})

-- incognito
hl.window_rule({
  name = "brave-chrome",
  float = true,
  center = true,
  size = { "(monitor_w*0.94)", "(monitor_h*0.90)" },
  match = {
    class = "^(chromium|brave-browser)$",
    title = "((New (Private|Incognito) Tab)|(Untitled)) - (Brave|Chromium)"
  }
})

--------------------------------------------------------------
-- Look and Feel --
--------------------------------------------------------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 0,
    layout = "dwindle",
    allow_tearing = false,
    resize_on_border = false,
    col = {
      active_border = {
        angle = 45,
        colors = {
          "rgba(33ccffee)",
          "rgba(00ff99ee)"
        },
      },
      inactive_border = "rgba(595959aa)",
    }
  }
})

-- Decoration --
-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    rounding = 7,

    -- scratchpad workspace
    dim_special = 0.25,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#shadow
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(ee1a1a1a)",
    }
  }
})

------------------------------------------------------------------
-- Animations --
-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
------------------------------------------------------------------
hl.config({
  animations = {
    enabled = true
  }
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "default", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "fade" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "default", style = "slidefadevert -100%" })

------------------------------------------------------------------
-- Layout --
------------------------------------------------------------------

-- Dwindle
-- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
  dwindle = {
    force_split = 2,
    preserve_split = true,
  }
})

-- Master
-- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
hl.config({
  master = {
    new_status = "master"
  }
})

-- MISC --
-- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
hl.config({
  misc = {
    font_family = "Intel One Mono",
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})

------------------------------------------------------------------
-- Input --
------------------------------------------------------------------

-- Keyboard & TouchPad --
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    kb_model = "",
    kb_rules = "",
    kb_variant = "",
    kb_layout = "us,bg(phonetic)",
    kb_options = "ctrl:nocaps,grp:alt_shift_toggle",

    -- mouse
    sensitivity = 0,
    follow_mouse = 2,
    mouse_refocus = true,

    touchpad = {
      tap_to_click = true,
      tap_and_drag = true,
      natural_scroll = true,
      disable_while_typing = true,
    }
  }
})


-- Cursor --
-- https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
hl.config({
  cursor = {
    no_warps = true,
    inactive_timeout = 5,
    persistent_warps = true,
  },
})


------------------------------------------------------------------
-- Key Bindings --
-- https://wiki.hypr.land/Configuring/Basics/Binds
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers
------------------------------------------------------------------

-- Actions --

-- Close Active Window
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.window.close())

-- Quit Hyprland
-- hl.bind("SUPER + SHIFT + END", hl.dsp.exit())

-- Apps --
hl.bind("SUPER + D", hl.dsp.exec_cmd(app_menu))
hl.bind("SUPER + R", hl.dsp.exec_cmd(app_menu_run))

hl.bind("SUPER + E", hl.dsp.exec_cmd(file_manager))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(file_manager_terminal))

hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(floating_terminal))

hl.bind("SUPER + SHIFT + END", hl.dsp.exec_cmd("nwg-bar -i 128"))
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd(process_system_monitor))

-- Screenshot
-- hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind("SUPER + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))


-- Notifications
hl.bind("SUPER + SHIFT + DELETE", hl.dsp.exec_cmd("swaync-client --hide-latest"))

-- Lock
-- hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("hyprlock"))

-- Layout
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + SHIFT + U", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- maximize - fullscreen
hl.bind("SUPER + F11", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- NOTE: Fix Gaps?
-- maxmize - with visible bar
hl.bind("SUPER + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- set float, resize, center [ ]
local function toggle_window()
  local win = hl.get_active_window()

  if win == nil then
    return
  end

  local min_x, min_y = 1804, 1080
  local max_x, max_y = 1900, 1146
  local x, y = win.size.x, win.size.y

  hl.dispatch(hl.dsp.window.float({ action = "enable" }))

  if x == min_x and y == min_y then
    hl.dispatch(hl.dsp.window.resize({ x = max_x, y = max_y }))
  else
    hl.dispatch(hl.dsp.window.resize({ x = min_x, y = min_y }))
  end

  hl.dispatch(hl.dsp.window.center())
end

hl.bind("SUPER + SHIFT + BRACKETLEFT", toggle_window)
hl.bind("SUPER + SHIFT + BRACKETRIGHT", toggle_window)

-- cycle between workspaces
hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- cycle between floating apps in a workspace
hl.bind("ALT + TAB", function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

-- toggle smart gaps for active workspace
hl.bind("SUPER + T", hl.dsp.exec_cmd("/usr/local/bin/hypr-toggle-gaps.sh"))

-- toggle tag/border for active window
hl.bind("SUPER + B", hl.dsp.window.tag({ tag = "has-border" }))

-- Swap windows - vim keys
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

-- Move focus with SUPER - vim keys
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))

-- Move focus with SUPER - arrow keys
hl.bind("SUPER + UP", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "right" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspace - scratchpad
hl.bind("SUPER + GRAVE", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + MINUS", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + MINUS", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Special workspace - scratchboard
hl.bind("SUPER + EQUAL", hl.dsp.workspace.toggle_special("scratchboard"))
hl.bind("SUPER + SHIFT + EQUAL", hl.dsp.window.move({ workspace = "special:scratchboard", follow = false }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

------------------------------------------------------------------
-- Switches --
-- https://wiki.hypr.land/Configuring/Basics/Binds/#switches
------------------------------------------------------------------

-- Trigger when the switch is toggled
-- hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("hyprlock --immediate"), { locked = true })

-- Lock when lid close - switch is turned on
-- hl.bind("switch:on:[Lid Switch]", hl.dsp.exec_cmd("hyprlock --immediate"), { locked = true })

-- Lock when lid open - switch is turned off
-- hl.bind("switch:off:[Lid Switch]", hl.dsp.exec_cmd("hyprlock --immediate"), { locked = true })

------------------------------------------------------------------
-- Submap Move --
------------------------------------------------------------------

-- Move submap
hl.bind("SUPER + SHIFT + M", hl.dsp.submap("MOVE"))

hl.define_submap("MOVE", function()
  hl.bind("j", hl.dsp.window.move({ x = 0, y = 10, relative = true }), { repeating =  true })
  hl.bind("k", hl.dsp.window.move({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("l", hl.dsp.window.move({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind("h", hl.dsp.window.move({ x = -10, y = 0, relative = true }), { repeating = true })

  hl.bind("up", hl.dsp.window.move({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.move({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind("left", hl.dsp.window.move({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("right", hl.dsp.window.move({ x = 10, y = 0, relative = true }), { repeating = true })

  hl.bind("space", hl.dsp.window.center())
  hl.bind("escape", hl.dsp.submap("reset"))
end)

------------------------------------------------------------------
-- Submap Resize --
------------------------------------------------------------------
hl.bind("SUPER + SHIFT + R", hl.dsp.submap("RESIZE"))

hl.define_submap("RESIZE", function()
  hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })

  hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

  hl.bind("space", hl.dsp.window.center())
  hl.bind("escape", hl.dsp.submap("reset"))
end)

------------------------------------------------------------------
