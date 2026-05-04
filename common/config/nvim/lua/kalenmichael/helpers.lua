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
