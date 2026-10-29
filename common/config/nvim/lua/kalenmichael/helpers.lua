local function run_typecheck()
  -- Use the tsc compiler settings for parsing
  vim.cmd("compiler tsc")

  -- Set the command
  vim.opt_local.makeprg = "pnpm type-check"

  -- Run it asynchronously so Neovim doesn't freeze
  -- '!' makes it quiet so it doesn't jump to the first error automatically
  vim.cmd("silent make!")

  -- Wait a moment for the check to finish or use an autocmd
  -- For a simpler setup, just trigger the Trouble toggle
  vim.cmd("redraw!")

  -- 6. Final notification
  -- We check if the quickfix list is empty to give a success message
  local qflist = vim.fn.getqflist()
  if #qflist == 0 then
    vim.notify("Type-check passed! ✨", vim.log.levels.INFO, { title = "TypeScript" })
  else
    vim.notify("Type-check found " .. #qflist .. " errors.", vim.log.levels.WARN, { title = "TypeScript" })
    vim.cmd("Trouble qflist open")
  end
end

vim.keymap.set("n", "<leader>tc", run_typecheck, { desc = "Run Project Type-check" })

vim.api.nvim_create_user_command("SpellToQf", function()
  local items = {}
  local filename = vim.api.nvim_buf_get_name(0)

  for lnum = 1, vim.fn.line("$") do
    local line = vim.fn.getline(lnum)
    local col = 1
    while true do
      vim.fn.cursor(lnum, col)
      local bw = vim.fn.spellbadword()
      if bw[1] == "" then
        break
      end
      local idx = string.find(line, bw[1], col)
      if not idx then
        break
      end
      table.insert(items, {
        filename = filename,
        lnum = lnum,
        col = idx,
        text = "Spelling error: " .. bw[1],
      })
      col = idx + string.len(bw[1])
      if col > string.len(line) then
        break
      end
    end
  end
  vim.fn.setqflist(items)
  vim.cmd("copen")
  print("Found " .. #items .. " spelling errors.")
end, {})

-- Optional keymap (e.g., <leader>cs for Check Spelling)
vim.keymap.set("n", "<leader>cs", ":SpellToQf<CR>", { desc = "Send spelling errors to quickfix" })
