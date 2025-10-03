#  Custom Neovim config 
<img width="2560" height="1080" alt="image" src="https://github.com/user-attachments/assets/9c388c03-f37b-4988-b38c-47b9a46f5fe7" />

Held together with duct tape.

## Features 
### General todo list 
- [x] Lsp setup
- [x] Treesitter highlights
- [x] Completions with blink.cmp
- [x] finding in-Buffer + grep with Telescope
- [x] Searching,QOL and pickers with Snacks
- [x] Code formatting with Conform
- [x] Lsp management with Mason
- [x] Diagnostics and quickfix with trouble
- [x] file management with oil
- [x] file tree with both nvim-tree and snacks.explorer(i need help)
- [x] Quick Buffer navigation with custom buffer picker
- [x] Quick Tab navigation with custom tab picker
- [x] Quick mark and file navigation with Harpoon
- [x] Symbol navigation with aerial
- [x] Statusbar at the bottom with `cwd` ,git info,Diagnostics and time with heirline
- [x] Buffers and tabs on the top with Bufferline
- [x] Transparency
- [x] Reference highlighting with vim-illuminate
- [x] scrolloff 
- [x] Animated Indent scopes with Snacks indent
- [x] Color picker with minty
- [x] Mouse actions with menu(half done,only works in nvim-tree and files)
- [x] Split/join code structures with treesj
- [x] Git integration via gitsigns
- [x] Git integration via Snacks's Lazygit
- [x] Status Column with Snacks(Left -> git,marks,diagnostics(if enabled) Right -> folds)
- [ ] Dropbar menu 
- [ ] smooth scroll with neoscroll
- [x] In-Buffer Navigation with flash.nvim
- [ ] Debloated
- [x] BetterMacros with NeoComposer.nvim
- [x] Buffer timeline,snapshots and undotree with Traceback
#### Telescope 
- [x] fuzzy finding in buffer
- [x] live grep
#### Snacks
- [x] Snacks.explorer
- [x] Snacks pickers for file search(Find)
- [x] Snacks pickers for utilities(search)
- [x] Snacks pickers for git
- [ ] Snacks pickers for themes
- [ ] Snacks toggles for plugins
- [x] Snacks Dashboard Ascii art
- [ ] Improvements to Snacks Dashboard Layout
#### theme
- [x] Main Dark theme with astrotheme
- [ ] Matching Light theme
- [ ] Matching themes
#### 
### Plugins
#### Lsp
- [blink.cmp](https://github.com/saghen/blink.cmp)
- [conform.nvim](https://github.com/stevearc/conform.nvim)
- [nvim-lsp-config](https://github.com/neovim/nvim-lspconfig)
- [Luasnip](https://github.com/L3MON4D3/LuaSnip)
- [lazydev.nvim](https://github.com/folke/lazydev.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
#### Utils
- [aerial.nvim](https://github.com/stevearc/aerial.nvim)
- [flash.nvim](https://github.com/folke/flash.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
- [harpoon](https://github.com/ThePrimeagen/harpoon)
- [oil.nvim](https://github.com/stevearc/oil.nvim)
- [nvim-surround](https://github.com/kylechui/nvim-surround)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
- [scrollEOF.nvim](https://github.com/Aasim-A/scrollEOF.nvim)
- [trouble.nvim](https://github.com/folke/trouble.nvim)
- [treesj](https://github.com/Wansmer/treesj)
- [Traceback](https://github.com/theawakener0/TraceBack)
- [NeoComposer.nvim](https://github.com/ecthelionvi/NeoComposer.nvim)

#### UI
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [noice.nvim](https://github.com/folke/noice.nvim)
- [heirline.nvim](https://github.com/rebelot/heirline.nvim)
- [vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [menu](https://github.com/nvzone/menu)
- [whichkey.nvim](https://github.com/folke/which-key.nvim)
- [minty](https://github.com/nvzone/minty)
#### Theme and Icons
- [astrotheme](https://github.com/AstroNvim/astrotheme)
- [mini.icons](https://github.com/echasnovski/mini.icons)
- [transparent.nvim](https://github.com/xiyaowong/transparent.nvim)
#### Miscellaneous
- [store.nvim](https://github.com/alex-popov-tech/store.nvim)
- [typr](https://github.com/nvzone/typr)
### Custom scripts
#### Indicators
- Animated Cursor position via [Beacon](https://github.com/someonegood420/nvim-custom/blob/main/lua/utils/Beaacon.lua)
- Macro Recording via [Recorder](https://github.com/someonegood420/nvim-custom/blob/main/lua/utils/recorder.lua)
#### Pickers
- Session Management via [Session picker](https://github.com/someonegood420/nvim-custom/blob/main/lua/utils/session_picker.lua) and [Session Manager](https://github.com/someonegood420/nvim-custom/blob/main/lua/utils/session_manager.lua)
- Buffer Navigation via [Buffer picker](https://github.com/someonegood420/nvim-custom/blob/main/lua/utils/buffer_picker.lua)
- Tab navigation via [tab picker](https://github.com/someonegood420/nvim-custom/blob/main/lua/utils/tab_picker.lua) and detailed snacks Tab picker through Snacks via [S_tab picker](https://github.com/someonegood420/nvim-custom/blob/main/lua/utils/s_tab_picker.lua)

## Startup time 
320ms
## Screenshots
#### Dashboard
<img width="2560" height="1080" alt="Screenshot 2025-09-16 030414" src="https://github.com/user-attachments/assets/891c920f-5f4d-45eb-9a8b-aceaae1c4f3e" />

#### buffer picker
<img width="2560" height="1080" alt="image" src="https://github.com/user-attachments/assets/b5670f64-6e3b-42fe-9cb2-c432e6defdad" />

#### tab picker 
<img width="2560" height="1080" alt="image" src="https://github.com/user-attachments/assets/f143209c-7a36-41fc-ac26-909fc644978e" />

#### whichkey
<img width="2560" height="1080" alt="image" src="https://github.com/user-attachments/assets/928c8ac3-f50f-456a-b04e-893187ab3ef0" />
