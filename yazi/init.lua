-- ya pack -a yazi-rs/plugins:smart-enter
require("smart-enter"):setup({})

-- ya pack -a yazi-rs/plugins:full-border
if os.getenv("YAZI_NO_BORDER") == nil then
  require("full-border"):setup()
end

-- ya pkg add yazi-rs/plugins:mount
-- Mount manager, providing disk mount, unmount, and eject functionality.

-- date created
function Linemode:creation_date()
	local time = math.floor(self._file.cha.btime or 0)
	if time == 0 then
		return ""
	end
	return os.date("%d-%m-%Y", time)
end
