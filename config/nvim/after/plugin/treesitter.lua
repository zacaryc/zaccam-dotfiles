local present, ts = pcall(require, "nvim-treesitter.configs")

if not present then
	return
end

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
local install_config = require("nvim-treesitter.install")

install_config.compilers = { "gcc", "clang" }

ts.setup({

	-- parser_install_dir = "/home/zaccam/vim/plugged/nvim-treesitter/parser",
	auto_install = true,
	highlight = {
		enable = false,
		use_languagetree = true,
        additional_vim_regex_highlighting = false,
	},
	matchup = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	ensure_installed = {
		"bash",
		"c",
		"git_config",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"go",
		"java",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"rust",
		"sql",
		"tmux",
		"vim",
		"vimdoc",
		"xml",
		"yaml"
	},
})

-- require("nvim-treesitter.configs").setup {
--     highlight = {
--         enable = true,
--         additional_vim_regex_highlighting = false
--     },
-- }
