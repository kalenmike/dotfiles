local M = {}

-- Obsidian-to-Lua Format Mapper
local function get_lua_date(fmt, time_offset)
  time_offset = time_offset or 0
  local conversion_map = {
    ["YYYY"] = "%Y",
    ["YY"] = "%y",
    ["MMMM"] = "%B",
    ["MMM"] = "%b",
    ["MM"] = "%m",
    ["DD"] = "%d",
    ["dddd"] = "%A",
    ["ddd"] = "%a",
    ["HH"] = "%H",
    ["mm"] = "%M",
    ["ss"] = "%S",
  }

  -- Default formats if none provided
  if fmt == "" or fmt == nil then
    fmt = "YYYY-MM-DD"
  end

  local lua_fmt = fmt:gsub("[%w]+", function(match)
    return conversion_map[match] or match
  end)

  return os.date(lua_fmt, os.time() + time_offset)
end

-- Function to dynamically find the git root
local function get_git_root()
  local dot_git = vim.fn.finddir(".git", ".;")
  if dot_git ~= "" then
    -- Return the parent directory of .git
    return vim.fn.fnamemodify(dot_git, ":h")
  else
    -- Fallback to current directory if not in a git repo
    return vim.fn.getcwd()
  end
end

M.insert_template = function()
  local root = get_git_root()
  local template_path = root .. "/.system/templates"

  -- Verify the directory exists before proceeding
  if vim.fn.isdirectory(template_path) == 0 then
    vim.notify("Template directory not found at: " .. template_path, vim.log.levels.ERROR)
    return
  end

  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  builtin.find_files({
    prompt_title = "Insert Template",
    cwd = template_path,
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local path = selection.cwd .. "/" .. selection.value

        -- Read the template file
        local file = io.open(path, "r")
        if not file then
          return
        end
        local content = file:read("*all")
        file:close()

        -- Handles {{date:FORMAT}} and {{time:FORMAT}}
        content = content:gsub("{{(date):?([^}]*)}}", function(_, fmt)
          return get_lua_date(fmt)
        end)
        content = content:gsub("{{(time):?([^}]*)}}", function(_, fmt)
          return get_lua_date(fmt or "HH:mm")
        end)

        -- Prepare replacements
        local substitutions = {
          ["{{Title}}"] = vim.fn.expand("%:t:r"),
          ["{{author}}"] = "Kalen Michael",
          ["{{yesterday}}"] = get_lua_date("YYYY-MM-DD", -86400),
          ["{{tomorrow}}"] = get_lua_date("YYYY-MM-DD", 86400),
        }

        -- Replace placeholders
        for placeholder, value in pairs(substitutions) do
          content = content:gsub(placeholder, value)
        end

        -- Insert content at cursor
        local lines = vim.split(content, "\n")
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
      end)
      return true
    end,
  })
end

-- Helper to extract 'type' from YAML frontmatter
local function get_buffer_metadata_type()
  local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false) -- Check top 10 lines
  for _, line in ipairs(lines) do
    local type_val = line:match("^type:%s+(%S+)")
    if type_val then
      return type_val
    end
  end
  return nil
end

M.insert_tag = function()
  local module_type = get_buffer_metadata_type()

  vim.print(module_type)

  if not module_type then
    vim.notify("No 'type' found in buffer frontmatter", vim.log.levels.WARN)
    return
  end

  local root = get_git_root()
  local tag_file = root .. "/.system/tags/" .. module_type .. ".yaml"

  -- Read and parse simple YAML (assuming a flat 'tags:' list)
  local file = io.open(tag_file, "r")
  if not file then
    vim.notify("Tag file not found: " .. tag_file, vim.log.levels.ERROR)
    return
  end

  local tags = {}
  local in_tags_section = false
  for line in file:lines() do
    if line:match("^tags:") then
      in_tags_section = true
    elseif in_tags_section then
      local tag = line:match("^%s+-%s+(%S+)")
      if tag then
        table.insert(tags, tag)
      end
      -- Stop if we hit a new top-level key
      if line:match("^%S") and not line:match("^%s") then
        in_tags_section = false
      end
    end
  end
  file:close()

  -- Telescope Picker
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Insert Tag for " .. module_type,
      finder = finders.new_table({ results = tags }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          -- Insert at cursor (adding '#' prefix)
          vim.api.nvim_put({ " #" .. selection[1] }, "", false, true)
        end)
        return true
      end,
    })
    :find()
end

M.show_backlinks = function()
  local filename = vim.fn.expand("%:t:r") -- Get note name without .md
  local current_file = vim.fn.expand("%:t") -- e.g., "Meeting-Notes.md"
  local root = get_git_root()

  -- Regex explanation:
  -- \\[ \\[      -> Literal "[["
  -- %s           -> Your filename
  -- ( \\] \\]    -> Followed by "]]"
  -- | \\| )      -> OR followed by "|" (for aliases like [[Note|Alias]])
  local pattern = string.format("\\[\\[%s(\\]\\]|\\|)", filename)

  require("telescope.builtin").grep_string({
    search = pattern,
    use_regex = true,
    cwd = root,
    prompt_title = "Backlinks to: " .. filename,
    -- Force searching only in markdown files to reduce noise
    additional_args = function()
      return {
        "--type",
        "md", -- Exclusion: do not search in the current file
        "--glob",
        "!" .. current_file,
      }
    end,
  })
end

M.show_outgoing_links = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local links = {}
  local existing_paths = {}
  local seen = {}
  local root = get_git_root() -- Using your existing git root helper

  for _, line in ipairs(content) do
    for link in line:gmatch("%[%[([^%]|]+)") do
      if not seen[link] then
        local target = link .. ".md"

        -- Use vim.fs.find to search RECURSIVELY from the root
        local found = vim.fs.find(target, {
          path = root,
          type = "file",
          limit = 1, -- We only need to know if at least one exists
        })

        if #found > 0 then
          -- We only need the filename for the Telescope filter
          table.insert(existing_paths, target)
        end
        seen[link] = true
      end
    end
  end

  if #existing_paths == 0 then
    vim.notify("No existing outgoing links found.", vim.log.levels.INFO)
    return
  end

  -- Open Telescope find_files with our list of links
  require("telescope.builtin").find_files({
    prompt_title = "Outgoing Links",
    search_file = table.concat(
      vim.tbl_map(function(path)
        return vim.fn.fnamemodify(path, ":t")
      end, existing_paths),
      " "
    ),
    cwd = root,
  })
end

M.ai_search = function()
  local prompt = vim.fn.input("AI Concept Search: ")
  if prompt == "" then
    return
  end

  -- Call our python script and get the list of files
  local project_root = "/home/jet/Projects/neuronet-indexer"
  local cmd = string.format(
    "uv run --project %s neuronet search %s",
    vim.fn.shellescape(project_root),
    vim.fn.shellescape(prompt)
  )
  local git_root = get_git_root()
  local results = vim.fn.systemlist(cmd)

  if #results == 0 then
    vim.notify("No related concepts found.", vim.log.levels.INFO)
    return
  end

  -- Open Telescope with these specific files
  -- require("telescope.builtin").find_files({
  --   prompt_title = "AI Insights for: " .. prompt,
  --   search_file = table.concat(quoted_results, " "),
  --   cwd = git_root,
  -- })
  -- This is the compact "Internal" way to show a list in Telescope
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Neuronet: " .. prompt,
      finder = finders.new_table({ results = results }),
      sorter = conf.generic_sorter({}),
      previewer = conf.file_previewer({}),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          -- 3. Combine vault_path + relative_path to open the file
          local full_path = git_root .. "/" .. selection[1]
          vim.cmd("edit " .. vim.fn.fnameescape(full_path))
        end)
        return true
      end,
    })
    :find()
end

M.find_all_links_to_this_file = function()
  local filename = vim.fn.expand("%:t:r") -- e.g., "Meeting-Notes"

  require("telescope.builtin").grep_string({
    -- Search for the filename wrapped in brackets or as a markdown link
    search = filename,
    only_sort_tags = true,
    prompt_title = "Global Mentions of " .. filename,
    -- You can refine this regex to be more specific to [[ ]] if you want
  })
end

-- Create the command and keybinding
vim.api.nvim_create_user_command("InsertTemplate", M.insert_template, {})
vim.keymap.set("n", "<leader>ot", ":InsertTemplate<CR>", { desc = "Insert Template" })

-- Search Backlinks using Telescope
vim.keymap.set("n", "<leader>ob", function()
  require("kalenmichael.template").show_backlinks()
end, { desc = "Buffer Backlinks" })

-- Search Backlinks using Telescope
vim.keymap.set("n", "<leader>oit", function()
  require("kalenmichael.template").insert_tag()
end, { desc = "Insert Tag" })

-- <leader>oo for "Outgoing"
vim.keymap.set("n", "<leader>oo", function()
  require("kalenmichael.template").show_outgoing_links()
end, { desc = "Outgoing Links" })

-- <leader>os for "Search"
vim.keymap.set("n", "<leader>os", function()
  require("kalenmichael.template").ai_search()
end, { desc = "AI Search" })

-- vim.keymap.set("n", "<leader>ob", function()
--   require("telescope.builtin").lsp_references({
--     include_declaration = false, -- Don't show the title of the current file in the list
--     show_line = true, -- Show the text surrounding the link
--   })
-- end, { desc = "View Backlinks" })

return M
