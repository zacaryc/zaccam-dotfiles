require('telescope').setup({ extensions = { fzf = {} } })
pcall(require('telescope').load_extension, 'fzf')
