vim.filetype.add({
  extension = {
    env = "sh", -- Treat .env files as shell files for formatting
    mdx = "markdown.mdx",
  },
  filename = {
    [".env"] = "sh",
    [".env.local"] = "sh",
    [".env.development"] = "sh",
  },
})
