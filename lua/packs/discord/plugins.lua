local discord = {}

discord["andweeb/presence.nvim"] = {
  opt = true,

  config = function()
    require("packs.discord.config").presence()
  end,
}

return discord
