-- =============================================================================
-- LSP — Language Server Protocol (Mason + lspconfig + fidget)
-- =============================================================================
--
-- NOTE: mason-lspconfig v2 (2025) removed setup_handlers() and
-- automatic_installation. Servers are now configured via vim.lsp.config()
-- and enabled via vim.lsp.enable() (automatic_enable in mason-lspconfig).
-- Requires Neovim ≥ 0.11, mason.nvim ≥ 2.0, nvim-lspconfig ≥ 2.0.
-- =============================================================================

return {
  -- Mason: manages LSP servers, DAP, linters, formatters
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
    },
  },

  -- nvim-lspconfig (must load before mason-lspconfig)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      -- ── Diagnostic config ──────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
        },
      })

      -- ── Hover / signature borders ──────────────────────────────────
      vim.o.winborder = "rounded"

      -- ── Capabilities (from cmp) ────────────────────────────────────
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      -- ── On-attach keymaps (TJ pattern: define once, apply everywhere) ──
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach-keymaps", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "Go to definition")
          map("gr", require("telescope.builtin").lsp_references, "References")
          map("gI", require("telescope.builtin").lsp_implementations, "Implementations")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gy", require("telescope.builtin").lsp_type_definitions, "Type definition")

          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("<leader>cs", vim.lsp.buf.signature_help, "Signature help")

          -- Inlay hints (Neovim 0.10+)
          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, "Toggle inlay hints")
          end

          -- Code lens
          if client and client:supports_method("textDocument/codeLens") then
            map("<leader>cl", vim.lsp.codelens.run, "Code lens")
          end
        end,
      })

      -- ── Server configurations via vim.lsp.config ───────────────────
      local lspconfig = vim.lsp.config

      -- Go
      lspconfig.gopls = {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = true,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
              shadow = true,
            },
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-node_modules" },
            semanticTokens = true,
          },
        },
      }

      -- Ruby
      lspconfig.ruby_lsp = { capabilities = capabilities }
      lspconfig.solargraph = { capabilities = capabilities }

      -- TypeScript / JavaScript
      lspconfig.ts_ls = {
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
            },
          },
        },
      }

      -- Lua
      lspconfig.lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
            diagnostics = { disable = { "missing-fields" } },
            hint = { enable = true },
          },
        },
      }

      -- Python
      lspconfig.pyright = { capabilities = capabilities }

      -- Rust
      lspconfig.rust_analyzer = {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
            inlayHints = {
              bindingModeHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              lifetimeElisionHints = { enable = "always" },
            },
          },
        },
      }

      -- Terraform
      lspconfig.terraformls = { capabilities = capabilities }
      lspconfig.tflint = { capabilities = capabilities }

      -- Web
      lspconfig.html = { capabilities = capabilities }
      lspconfig.cssls = { capabilities = capabilities }
      lspconfig.tailwindcss = { capabilities = capabilities }
      lspconfig.eslint = { capabilities = capabilities }
      lspconfig.jsonls = { capabilities = capabilities }
      lspconfig.yamlls = {
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] = "/.github/action.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                "/docker-compose*.{yml,yaml}",
            },
          },
        },
      }

      -- DevOps
      lspconfig.dockerls = { capabilities = capabilities }
      lspconfig.docker_compose_language_service = { capabilities = capabilities }
      lspconfig.bashls = { capabilities = capabilities }
    end,
  },

  -- Bridge mason ↔ lspconfig (auto-install + auto-enable)
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "gopls",
        "ruby_lsp", "solargraph",
        "ts_ls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "terraformls", "tflint",
        "html", "cssls", "tailwindcss", "eslint", "jsonls", "yamlls",
        "dockerls", "docker_compose_language_service", "bashls",
      },
      automatic_enable = true,
    },
  },
}
