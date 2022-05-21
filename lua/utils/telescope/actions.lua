local M = {}

local action_state = require("telescope.actions.state")

function M.set_prompt_to_entry_value(prompt_bufnr)
  local entry = action_state.get_selected_entry()

  if not entry or not type(entry) == "table" then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

return M
