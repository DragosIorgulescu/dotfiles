-- =============================================================================
-- Treesitter — Syntax highlighting, text objects, and more
-- =============================================================================
--
-- NOTE: nvim-treesitter main branch (2025) is a full rewrite.
--   • No more require("nvim-treesitter.configs").setup()
--   • Parsers installed via require("nvim-treesitter").install({...})
--   • Highlighting via vim.treesitter.start() autocmd
--   • Requires Neovim ≥ 0.11
-- =============================================================================

local parsers = {
  -- Core
  "lua", "vim", "vimdoc", "query", "regex", "markdown", "markdown_inline",
  -- Web
  "html", "css", "javascript", "typescript", "tsx", "json",
  -- Backend
  "go", "gomod", "gosum", "gowork",
  "ruby",
  "python",
  "rust",
  -- Infra
  "terraform", "hcl",
  "dockerfile", "yaml", "toml",
  "bash",
  -- Data
  "sql", "graphql",
  -- Config
  "gitcommit", "gitignore", "git_rebase", "diff",
  "make", "cmake",
  "proto",
}

return {
  -- ── nvim-treesitter (main branch) ──────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,  -- must not be lazy-loaded
    build = ":TSUpdate",
    config = function()
      -- Install missing parsers (deferred to avoid load-order issues with lazy.nvim)
      vim.schedule(function()
        local ok, ts = pcall(require, "nvim-treesitter")
        if not ok or not ts.install then return end
        local missing = vim.tbl_filter(function(lang)
          local has, _ = pcall(vim.treesitter.language.inspect, lang)
          return not has
        end, parsers)
        if #missing > 0 then
          ts.install(missing)
        end
      end)

      -- Enable treesitter highlighting for all filetypes with a parser
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(args)
          -- Only start if a parser exists for this filetype
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            -- Enable treesitter-based indentation
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Incremental selection keymaps (init/expand/shrink)
      vim.keymap.set("n", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").init()
      end, { desc = "Init treesitter selection" })
      vim.keymap.set("x", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").increment()
      end, { desc = "Expand treesitter selection" })
      vim.keymap.set("x", "<bs>", function()
        require("nvim-treesitter.incremental_selection").decrement()
      end, { desc = "Shrink treesitter selection" })
    end,
  },

  -- ── Textobjects ────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local tso = require("nvim-treesitter-textobjects")

      tso.setup({
        select = {
          lookahead = true,
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })

      local select_to = require("nvim-treesitter-textobjects.select").select_textobject
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- ── Select textobjects ──
      local select_maps = {
        ["af"] = { query = "@function.outer", desc = "Around function" },
        ["if"] = { query = "@function.inner", desc = "Inside function" },
        ["ac"] = { query = "@class.outer", desc = "Around class" },
        ["ic"] = { query = "@class.inner", desc = "Inside class" },
        ["aa"] = { query = "@parameter.outer", desc = "Around argument" },
        ["ia"] = { query = "@parameter.inner", desc = "Inside argument" },
        ["ai"] = { query = "@conditional.outer", desc = "Around conditional" },
        ["ii"] = { query = "@conditional.inner", desc = "Inside conditional" },
        ["al"] = { query = "@loop.outer", desc = "Around loop" },
        ["il"] = { query = "@loop.inner", desc = "Inside loop" },
        ["ab"] = { query = "@block.outer", desc = "Around block" },
        ["ib"] = { query = "@block.inner", desc = "Inside block" },
      }
      for key, mapping in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select_to(mapping.query, "textobjects")
        end, { desc = mapping.desc })
      end

      -- ── Move (go to next/prev start/end) ──
      local move_maps = {
        -- next start
        { keys = "]f", fn = move.goto_next_start, query = "@function.outer", desc = "Next function start" },
        { keys = "]c", fn = move.goto_next_start, query = "@class.outer", desc = "Next class start" },
        { keys = "]a", fn = move.goto_next_start, query = "@parameter.inner", desc = "Next argument" },
        -- next end
        { keys = "]F", fn = move.goto_next_end, query = "@function.outer", desc = "Next function end" },
        { keys = "]C", fn = move.goto_next_end, query = "@class.outer", desc = "Next class end" },
        -- prev start
        { keys = "[f", fn = move.goto_previous_start, query = "@function.outer", desc = "Prev function start" },
        { keys = "[c", fn = move.goto_previous_start, query = "@class.outer", desc = "Prev class start" },
        { keys = "[a", fn = move.goto_previous_start, query = "@parameter.inner", desc = "Prev argument" },
        -- prev end
        { keys = "[F", fn = move.goto_previous_end, query = "@function.outer", desc = "Prev function end" },
        { keys = "[C", fn = move.goto_previous_end, query = "@class.outer", desc = "Prev class end" },
      }
      for _, m in ipairs(move_maps) do
        vim.keymap.set({ "n", "x", "o" }, m.keys, function()
          m.fn(m.query, "textobjects")
        end, { desc = m.desc })
      end

      -- ── Swap ──
      vim.keymap.set("n", "<leader>sa", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap next argument" })
      vim.keymap.set("n", "<leader>sA", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap prev argument" })

      -- ── Repeatable moves (;/, to repeat like f/t) ──
      local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move_next, { desc = "Repeat last move next" })
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_previous, { desc = "Repeat last move prev" })
      -- Make builtin f/t/F/T repeatable with ;/,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat.builtin_f_expr, { expr = true, desc = "f (repeatable)" })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat.builtin_F_expr, { expr = true, desc = "F (repeatable)" })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat.builtin_t_expr, { expr = true, desc = "t (repeatable)" })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat.builtin_T_expr, { expr = true, desc = "T (repeatable)" })
    end,
  },

  -- ── Treesitter context (sticky scroll) ─────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      max_lines = 3,
      multiline_threshold = 1,
    },
  },

  -- ── Autotag (auto-close/rename HTML tags) ──────────────────────────
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
