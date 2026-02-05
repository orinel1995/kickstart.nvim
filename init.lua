vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.termguicolors = true

do
  local bash = vim.fn.exepath 'bash'
  if bash == '' and vim.fn.filereadable 'C:\\Git\\bin\\bash.exe' == 1 then
    bash = 'C:\\Git\\bin\\bash.exe'
  elseif bash == '' and vim.fn.filereadable 'C:\\Git\\usr\\bin\\bash.exe' == 1 then
    bash = 'C:\\Git\\usr\\bin\\bash.exe'
  end

  if bash ~= '' then
    vim.o.shell = bash
    vim.env.SHELL = bash
  end

  if vim.o.shell ~= '' then
    vim.o.shellcmdflag = '-lc'
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
  end
end

vim.o.showmode = false
vim.o.modeline = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.cmdheight = 1
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '  ', trail = '.', nbsp = '+' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.scroll = 25
vim.o.confirm = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('i', 'jk', '<Esc>', { silent = true, desc = 'Exit insert mode' })
vim.keymap.set('i', 'jj', '<Esc>', { silent = true, desc = 'Exit insert mode' })
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })


vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  { 'NMAC427/guess-indent.nvim', opts = {} },
  { -- Auto insert matching brackets/quotes
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require 'nvim-autopairs'
      local Rule = require 'nvim-autopairs.rule'

      npairs.setup {}

      npairs.add_rules {
        Rule("'''", "'''", 'python'),
        Rule('"""', '"""', 'python'),

        Rule('%', '%', { 'htmldjango', 'django' }),
      }
    end,
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },


  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },


  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',


    enabled = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()

      require('telescope').setup {
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

          vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

          vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

          vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

          vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

          vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} },

      'saghen/blink.cmp',
    },
    config = function()

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        pyright = {},
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'lua-language-server', -- Lua Language server (mason package name)
        'pyright', -- Python LSP
        'stylua', -- Used to format Lua code
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })
      vim.lsp.enable 'lua_ls'
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = 'n',
        desc = '[C]ode [F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters = {
        sqlformat = {
          command = 'sqlformat',
          args = { '-r', '-k', 'upper', '-' },
          stdin = true,
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        sql = { 'sqlformat' },
        python = { 'isort', 'autopep8' },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
        },
        opts = {},
      },
    },
    opts = {
      keymap = {
        preset = 'default',
        ['<C-space>'] = {'show'},
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = {
          auto_show = false,
          draw = function() end, -- never render docs unless explicitly opened elsewhere
          window = { max_height = 0, max_width = 0 },
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'lua' },

      signature = { enabled = true, window = { show_documentation = false } },
    },
  },

  { -- You can easily change to a different colorscheme.
    'rebelot/kanagawa.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('kanagawa').setup {
        commentstyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { italic = false },
        typeStyle = { italic = false },
        functionStyle = { italic = false },
        colors = {
          theme = { comment = '#ff9e3b' },
        },
        overrides = function(colors)
          return {
            ['@comment'] = { fg = '#ff9e3b', italic = false },
            ['@comment.documentation'] = { fg = '#ff9e3b', italic = false },
            Comment = { fg = '#ff9e3b', italic = false },
            Normal = { bg = 'none' },
            NormalNC = { bg = 'none' },
            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
            SignColumn = { bg = 'none' },
            EndOfBuffer = { bg = 'none' },
            LineNr = { bg = 'none' },
            CursorLineNr = { fg = colors.palette.sumiInk0, bg = colors.palette.springGreen, nocombine = true },
            LineNrAbove = { bg = 'none' },
            LineNrBelow = { bg = 'none' },
            NoiceCmdlinePopupBorder = { bg = 'none' },
          }
        end,
      }
      vim.cmd.colorscheme 'kanagawa'

      local palette = require('kanagawa.colors').setup().palette
      local mode_bg = {
        n = palette.springBlue, -- normal (more saturated)
        v = palette.oniViolet, -- visual
        V = palette.oniViolet,
        ['\x16'] = palette.oniViolet, -- visual block
        i = palette.springGreen, -- insert
        R = palette.waveRed, -- replace
        c = palette.autumnYellow, -- command-line
      }
      local function set_cursor_colors(mode)
        local bg = mode_bg[mode] or palette.dragonBlue
        vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = palette.sumiInk0, bg = bg, nocombine = true })
      end
      set_cursor_colors(vim.api.nvim_get_mode().mode)
      vim.api.nvim_create_autocmd('ModeChanged', {
        callback = function() set_cursor_colors(vim.api.nvim_get_mode().mode) end,
      })

      vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'LineNrAbove', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'LineNrBelow', { bg = 'none' })

      local function disable_bold()
        local groups = {
          'Keyword',
          'Statement',
          'Function',
          'Type',
          '@keyword',
          '@keyword.function',
          '@keyword.operator',
          '@function',
          '@function.builtin',
          '@function.method',
          '@type',
          '@type.builtin',
          '@type.definition',
          '@type.qualifier',
          '@constructor',
          '@lsp.type.class',
          '@lsp.type.function',
          '@lsp.type.method',
          '@lsp.type.namespace',
          '@lsp.type.type',
          '@lsp.type.typeParameter',
          '@lsp.type.keyword',
        }
        for _, group in ipairs(groups) do
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
          if ok then
            hl.bold = false
            vim.api.nvim_set_hl(0, group, hl)
          else
            vim.api.nvim_set_hl(0, group, { bold = false })
          end
        end
      end

      disable_bold()
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = disable_bold,
      })
    end,
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      local ai = require 'mini.ai'
      ai.setup {
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
          o = ai.gen_spec.pair('\n\n', '\n\n'),
          a = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },
          t = ai.gen_spec.treesitter { a = '@tag.outer', i = '@tag.inner' },
          s = ai.gen_spec.treesitter { a = '@string.outer', i = '@string.inner' },
          ['('] = ai.gen_spec.pair('(', ')'),
          ['['] = ai.gen_spec.pair('[', ']'),
          ['{'] = ai.gen_spec.pair('{', '}'),
        },
      }

      pcall(vim.treesitter.query.set, 'python', 'textobjects', [[
        (function_definition) @function.outer
        (function_definition
          body: (block) @function.inner)

        (class_definition) @class.outer
        (class_definition
          body: (block) @class.inner)

        (parameters (identifier) @parameter.inner) @parameter.outer
        (parameters (typed_parameter (identifier) @parameter.inner)) @parameter.outer
        (parameters (default_parameter (identifier) @parameter.inner)) @parameter.outer

        (string) @string.outer
        (string (string_content) @string.inner)
      ]])

      require('mini.surround').setup()
      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true, desc = 'Surround visual selection' })

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      statusline.section_location = function() return '%2l:%-2v' end

    end,
  },

  { -- Subtle indent guides (VSCode-like)
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = { char = '│', highlight = 'IblIndent' },
      scope = { enabled = false },
    },
  },

  { -- Floating cmdline and search UI
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
      },
      lsp = {
        signature = { enabled = false },
        hover = { enabled = false },
      },
      messages = { enabled = true },
      popupmenu = { enabled = true },
      views = {
        cmdline_popup = {
          border = { style = 'none' },
          position = { row = '100%', col = '50%' },
          size = { width = 60, height = 'auto' },
        },
      },
    },
  },

  { -- Floating terminal
    'numToStr/FTerm.nvim',
    event = 'VimEnter',
    opts = {
      cmd = { 'C:\\Git\\bin\\bash.exe', '--login', '-i' },
      border = 'rounded',
      dimensions = { height = 0.9, width = 0.9 },
    },
    keys = {
      {
        '<leader>tt',
        function() require('FTerm').toggle() end,
        desc = '[T]oggle [T]erminal',
      },
      {
        '<Esc>',
        function() require('FTerm').toggle() end,
        mode = 't',
        desc = 'Close floating terminal',
      },
    },
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'sql',
        'vim',
        'vimdoc',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['if'] = '@function.inner',
            ['af'] = '@function.outer',
            ['ic'] = '@class.inner',
            ['ac'] = '@class.outer',
            ['ia'] = '@parameter.inner',
            ['aa'] = '@parameter.outer',
            ['is'] = '@string.inner',
            ['as'] = '@string.outer',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'python', 'sql', 'html', 'lua', 'vim', 'query', 'markdown', 'markdown_inline', 'bash', 'c', 'diff' },
        callback = function() pcall(vim.treesitter.start, 0) end,
      })
    end,
  },



}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

