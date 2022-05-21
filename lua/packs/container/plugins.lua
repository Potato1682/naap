local container = {}

container["esensar/nvim-dev-container"] = {
  module = "devcontainer",

  cmd = {
    "DevcontainerBuild",
    "DevcontainerImageRun",
    "DevcontainerBuildAndRun",
    "DevcontainerBuildRunAndAttach",
    "DevcontainerComposeUp",
    "DevcontainerComposeDown",
    "DevcontainerComposeRm",
    "DevcontainerStartAuto",
    "DevcontainerStartAutoRefresh",
    "DevcontainerAttachAuto",
    "DevcontainerStopAuto",
    "DevcontainerStopAll",
    "DevcontainerRemoveAll",
    "DevcontainerLogs",
    "DevcontainerOpenNearestConfig",
    "DevcontainerEditNearestConfig"
  },

  setup = function()
    require("packs.container.config").devcontainer_setup()
  end,

  config = function()
    require("packs.container.config").devcontainer()
  end
}

return container
