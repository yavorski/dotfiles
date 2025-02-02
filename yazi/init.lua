-- ya pack -a yazi-rs/plugins:smart-enter
require("smart-enter"):setup({})

-- ya pack -a yazi-rs/plugins:full-border
if os.getenv("YAZI_NO_BORDER") == nil then
  require("full-border"):setup()
end
