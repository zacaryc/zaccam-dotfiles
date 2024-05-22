-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/zaccam/.cache/nvim/packer_hererocks/2.1.1692716794/share/lua/5.1/?.lua;/home/zaccam/.cache/nvim/packer_hererocks/2.1.1692716794/share/lua/5.1/?/init.lua;/home/zaccam/.cache/nvim/packer_hererocks/2.1.1692716794/lib/luarocks/rocks-5.1/?.lua;/home/zaccam/.cache/nvim/packer_hererocks/2.1.1692716794/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/zaccam/.cache/nvim/packer_hererocks/2.1.1692716794/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  FastFold = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/FastFold",
    url = "https://github.com/Konfekt/FastFold"
  },
  ale = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/ale",
    url = "https://github.com/w0rp/ale"
  },
  catppuccin = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  delimitMate = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/delimitMate",
    url = "https://github.com/Raimondi/delimitMate"
  },
  fzf = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  ["kanagawa.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/kanagawa.nvim",
    url = "https://github.com/rebelot/kanagawa.nvim"
  },
  ["limelight.vim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/limelight.vim",
    url = "https://github.com/junegunn/limelight.vim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["material.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/material.nvim",
    url = "https://github.com/marko-cerovac/material.nvim"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/nightfox.nvim",
    url = "https://github.com/edeneast/nightfox.nvim"
  },
  ["nvim-hybrid"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/nvim-hybrid",
    url = "https://github.com/PHSix/nvim-hybrid"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["onedark.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/onedark.nvim",
    url = "https://github.com/navarasu/onedark.nvim"
  },
  ["onedarkpro.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/onedarkpro.nvim",
    url = "https://github.com/olimorris/onedarkpro.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rainbow_parentheses.vim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/rainbow_parentheses.vim",
    url = "https://github.com/kien/rainbow_parentheses.vim"
  },
  tagbar = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/tagbar",
    url = "https://github.com/majutsushi/tagbar"
  },
  ["todo-comments.nvim"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["vim-airline"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-airline",
    url = "https://github.com/vim-airline/vim-airline"
  },
  ["vim-airline-themes"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-airline-themes",
    url = "https://github.com/vim-airline/vim-airline-themes"
  },
  ["vim-colors-solarized"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-colors-solarized",
    url = "https://github.com/altercation/vim-colors-solarized"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-git"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-git",
    url = "https://github.com/tpope/vim-git"
  },
  ["vim-gitgutter"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-gitgutter",
    url = "https://github.com/airblade/vim-gitgutter"
  },
  ["vim-go"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-go",
    url = "https://github.com/fatih/vim-go"
  },
  ["vim-hybrid"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-hybrid",
    url = "https://github.com/w0ng/vim-hybrid"
  },
  ["vim-indent-guides"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-indent-guides",
    url = "https://github.com/nathanaelkane/vim-indent-guides"
  },
  ["vim-javascript"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-javascript",
    url = "https://github.com/pangloss/vim-javascript"
  },
  ["vim-json"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-json",
    url = "https://github.com/elzr/vim-json"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-markdown",
    url = "https://github.com/tpope/vim-markdown"
  },
  ["vim-puppet"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-puppet",
    url = "https://github.com/rodjek/vim-puppet"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-sensible",
    url = "https://github.com/tpope/vim-sensible"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-vinegar"] = {
    loaded = true,
    path = "/home/zaccam/.local/share/nvim/site/pack/packer/start/vim-vinegar",
    url = "https://github.com/tpope/vim-vinegar"
  }
}

time([[Defining packer_plugins]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
