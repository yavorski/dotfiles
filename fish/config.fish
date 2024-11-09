# Nothing to do if not inside an interactive shell
if not status is-interactive
  return 0
end

# Environment
set --local os (uname)
set --universal fish_greeting

set --export EDITOR nvim
set --export SUDO_EDITOR nvim
set --export BAT_THEME "Dracula"

# set --export MANPAGER "nvim +Man!"
set --export MANPAGER "sh -c 'col -bx | bat -l man -p'"
set --export MANROFFOPT "-c"
set --export GROFF_NO_SGR 1

# Prompt
starship init fish | source

# Fnm
fnm env --shell fish | source

# Zoxide
zoxide init --cmd cd fish | source

# Path
fish_add_path "$HOME/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.fly/bin"
fish_add_path "$HOME/.npm/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.dotnet/tools"
fish_add_path "$HOME/.local/share/fnm"

# Pretty path
function pretty_path
  printf "%s\n" $PATH
end

# Navigation
abbr --add ... "cd ../.."
abbr --add .... "cd ../../.."
abbr --add ..... "cd ../../../.."

abbr --add d "cd ~/dev"
abbr --add dl "cd ~/Downloads"

# Git
abbr -a g git
abbr -a gi git
abbr -a gd git diff
abbr -a gs git status

# Neovim
abbr --add nv nvim
abbr --add nvo --set-cursor "cd % && nvim"

# man ls | nvm
abbr --add nvm "nvim +Man!"
# abbr --add nvm --set-cursor "nvim \"+hide Man %\""

# ls
alias l="eza"
alias ls="eza"

# Always enable colored `grep` output
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# bat --help | bathelp
alias bathelp="bat --plain --language=help"
alias batman="bat --plain --language=Manpage"

# neofetch
alias neofetch="fastfetch --config neofetch"

# IP address
alias rip="curl ifconfig.me"

# sudo edit diff mode
alias sudodiff="SUDO_EDITOR='nvim -d' sudoedit"

# Turn OFF keyboard mic led - ThinkPad T14
alias turn-off-mic-led="light -s sysfs/leds/platform::micmute -S 0"
alias turn-off-mic-led="brightnessctl --device 'platform::micmute' set 0"

# Power profile
alias power-profile="cat /sys/firmware/acpi/platform_profile"

# Battery power draw
alias bat-watt="awk '{print \$1 / 1000000 \" W\"}' /sys/class/power_supply/BAT0/power_now"

# Battery status & capacity
alias battery="cat /sys/class/power_supply/BAT0/status /sys/class/power_supply/BAT0/capacity | paste -sd ' '"

# Screenshot
alias screenshot='grim -t png -g (slurp) ~/Screenshots/screenshot-(date +%d-%m-%Y-%H-%M-%S).png'

# fisher
# fisher install yavorski/autopair.fish
