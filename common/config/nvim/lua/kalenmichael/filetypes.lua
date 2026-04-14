vim.filetype.add({
  extension = {
    env = "sh", -- Treat .env files as shell files for formatting
  },
  filename = {
    [".env"] = "sh",
    [".env.local"] = "sh",
    [".env.development"] = "sh",
  },
})
