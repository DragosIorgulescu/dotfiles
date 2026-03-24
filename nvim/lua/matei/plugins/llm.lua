-- =============================================================================
-- LLM — AI-assisted development (Claude Code, Copilot, ChatGPT)
-- =============================================================================
return {
  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",        -- Alt+l to accept
          accept_word = "<M-w>",   -- Alt+w to accept word
          accept_line = "<M-j>",   -- Alt+j to accept line
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = true },
      filetypes = {
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        ["."] = false,
      },
    },
  },

  -- Copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "CopilotChat", "CopilotChatExplain", "CopilotChatReview",
      "CopilotChatFix", "CopilotChatOptimize", "CopilotChatTests",
      "CopilotChatDocs",
    },
    keys = {
      { "<leader>lc", "<cmd>CopilotChat<CR>", desc = "Copilot Chat" },
      { "<leader>le", "<cmd>CopilotChatExplain<CR>", mode = { "n", "v" }, desc = "Explain code" },
      { "<leader>lr", "<cmd>CopilotChatReview<CR>", mode = { "n", "v" }, desc = "Review code" },
      { "<leader>lf", "<cmd>CopilotChatFix<CR>", mode = { "n", "v" }, desc = "Fix code" },
      { "<leader>lo", "<cmd>CopilotChatOptimize<CR>", mode = { "n", "v" }, desc = "Optimize code" },
      { "<leader>lt", "<cmd>CopilotChatTests<CR>", mode = { "n", "v" }, desc = "Generate tests" },
      { "<leader>ld", "<cmd>CopilotChatDocs<CR>", mode = { "n", "v" }, desc = "Generate docs" },
    },
    opts = {
      model = "claude-sonnet-4-6",
      window = {
        layout = "vertical",
        width = 0.4,
      },
    },
  },

  -- Claude Code integration via terminal
  -- Claude Code runs in the terminal — these keymaps make it easy to launch
  {
    "akinsho/toggleterm.nvim",  -- already loaded in terminal.lua, this just adds keymaps
    keys = {
      {
        "<leader>ll",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local claude = Terminal:new({
            cmd = "claude",
            dir = vim.fn.getcwd(),
            direction = "float",
            float_opts = {
              border = "double",
              width = function() return math.floor(vim.o.columns * 0.85) end,
              height = function() return math.floor(vim.o.lines * 0.85) end,
            },
            on_open = function(term)
              vim.cmd("startinsert!")
            end,
          })
          claude:toggle()
        end,
        desc = "Claude Code",
      },
    },
  },

  -- Codecompanion (multi-provider LLM chat — supports Claude, GPT, etc.)
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>la", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "LLM actions" },
      { "<leader>lh", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, desc = "LLM chat toggle" },
      { "ga", "<cmd>CodeCompanionChat Add<CR>", mode = "v", desc = "Add selection to chat" },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = { default = "claude-sonnet-4-6" },
            },
          })
        end,
      },
    },
  },
}
