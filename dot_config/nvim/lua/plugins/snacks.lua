return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = false,
            ignored = true,

            actions = {
              toggle_resize_to_content = function(picker)
                local function set_width(win, width)
                  if not win or not vim.api.nvim_win_is_valid(win) then
                    return
                  end

                  width = math.max(30, width)
                  width = math.min(width, math.floor(vim.o.columns * 0.6))

                  local config = vim.api.nvim_win_get_config(win)

                  -- Floating window
                  if config.relative and config.relative ~= "" then
                    config.width = width
                    vim.api.nvim_win_set_config(win, config)
                    return
                  end

                  -- Normal/split/sidebar window
                  vim.api.nvim_win_set_width(win, width)
                end

                local win = vim.api.nvim_get_current_win()

                if not win or not vim.api.nvim_win_is_valid(win) then
                  return
                end

                picker.__explorer_width_toggle = picker.__explorer_width_toggle
                  or {
                    resized = false,
                    original_width = nil,
                  }

                local state = picker.__explorer_width_toggle

                -- Second press: restore original width
                if state.resized then
                  if state.original_width then
                    set_width(win, state.original_width)
                  end

                  state.resized = false
                  return
                end

                -- First press: save current width
                state.original_width = vim.api.nvim_win_get_width(win)

                local buf = vim.api.nvim_win_get_buf(win)

                if not buf or not vim.api.nvim_buf_is_valid(buf) then
                  return
                end

                local max_len = 30
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

                for _, line in ipairs(lines) do
                  local clean_line = line:gsub("%s+$", "")
                  local len = vim.fn.strdisplaywidth(clean_line)

                  if len > max_len then
                    max_len = len
                  end
                end

                local target_width = max_len + 5

                set_width(win, target_width)

                state.resized = true
              end,
            },

            win = {
              list = {
                keys = {
                  ["e"] = "toggle_resize_to_content",
                },
              },
            },
          },
        },
      },
    },
  },
}
