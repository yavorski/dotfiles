import { Plugin } from "@opencode/plugin/tui"

export default Plugin.define({
  id: "close",
  setup(context) {
    context.keymap.layer(() => ({
      mode: "global",
      commands: [
        {
          id: "close.smart",
          title: "Close tab, else exit",
          group: "Tabs",
          bind: "ctrl+q",
          palette: true,
          slash: { name: "close" },
          run: () => {
            const tabs = context.ui.tabs.enabled() ? context.ui.tabs.list() : []
            if (tabs.length > 0) {
              context.keymap.dispatch("session.tab.close")
            }
            else {
              context.keymap.dispatch("app.exit")
            }
          }
        }
      ],
      bindings: ["close.smart"]
    }))
  }
})
