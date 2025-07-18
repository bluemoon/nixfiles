{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Set catppuccin as the colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          telescope.enabled = true;
          indent_blankline.enabled = true;
          native_lsp = {
            enabled = true;
          };
        };
      };
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      updatetime = 50;
      completeopt = "menuone,noselect";
      clipboard = "unnamedplus";
      cursorline = true;
      mouse = "a";
      splitbelow = true;
      splitright = true;
      splitkeep = "screen";
      timeoutlen = 300;
      showmode = false;
      cmdheight = 0;
    };

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    # Essential plugins
    plugins = {
      # LSP
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; # Nix
          lua_ls.enable = true;
          ts_ls.enable = true;
          pyright.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
        };
        keymaps = {
          silent = true;
          lspBuf = {
            gd = {
              action = "definition";
              desc = "Goto Definition";
            };
            gr = {
              action = "references";
              desc = "Goto References";
            };
            gD = {
              action = "declaration";
              desc = "Goto Declaration";
            };
            gI = {
              action = "implementation";
              desc = "Goto Implementation";
            };
            gT = {
              action = "type_definition";
              desc = "Type Definition";
            };
            K = {
              action = "hover";
              desc = "Hover";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "Code Action";
            };
            "<leader>cr" = {
              action = "rename";
              desc = "Rename";
            };
          };
          diagnostic = {
            "<leader>cd" = {
              action = "open_float";
              desc = "Line Diagnostics";
            };
            "[d" = {
              action = "goto_prev";
              desc = "Previous Diagnostic";
            };
            "]d" = {
              action = "goto_next";
              desc = "Next Diagnostic";
            };
          };
        };
      };

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
          formatters_by_ft = {
            nix = [ "nixfmt-rfc-style" ];
            python = [ "black" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            css = [ "prettier" ];
            html = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "prettier" ];
            markdown = [ "prettier" ];
            lua = [ "stylua" ];
            "_" = [ "trim_whitespace" ];
          };
        };
      };

      # Treesitter
      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        folding = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };

      # File tree
      neo-tree = {
        enable = true;
        filesystem = {
          bindToCwd = false;
          followCurrentFile = {
            enabled = true;
          };
        };
        window = {
          position = "left";
          width = 30;
        };
      };

      # Status line
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
            globalstatus = true;
          };
        };
      };

      # Buffer line
      bufferline = {
        enable = true;
        settings = {
          options = {
            diagnostics = "nvim_lsp";
            mode = "buffers";
            offsets = [
              {
                filetype = "neo-tree";
                text = "Neo-tree";
                highlight = "Directory";
                text_align = "left";
              }
            ];
          };
        };
      };

      # Fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
        settings = {
          defaults = {
            layout_config = {
              horizontal = {
                prompt_position = "top";
              };
            };
            sorting_strategy = "ascending";
          };
        };
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options.desc = "Find files";
          };
          "<leader>fg" = {
            action = "live_grep";
            options.desc = "Live grep";
          };
          "<leader>fb" = {
            action = "buffers";
            options.desc = "Buffers";
          };
          "<leader>fh" = {
            action = "help_tags";
            options.desc = "Help tags";
          };
          "<leader>fr" = {
            action = "oldfiles";
            options.desc = "Recent files";
          };
        };
      };

      # Git integration
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = { text = "│"; };
            change = { text = "│"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
            untracked = { text = "┆"; };
          };
        };
      };
      
      # Completion
      cmp = {
        enable = true;
        settings = {
          snippet = {
            expand = "luasnip";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
          window = {
            completion = {
              border = "rounded";
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
            };
            documentation = {
              border = "rounded";
            };
          };
        };
      };
      
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
          store_selection_keys = "<Tab>";
        };
      };

      # UI enhancements
      web-devicons.enable = true;
      indent-blankline.enable = true;
      todo-comments.enable = true;
      illuminate = {
        enable = true;
        underCursor = false;
      };
      fidget = {
        enable = true;
        settings = {
          notification = {
            override_vim_notify = true;
          };
        };
      };

      # Comments
      comment.enable = true;

      # Auto pairs
      nvim-autopairs = {
        enable = true;
        settings = {
          disable_filetype = [
            "TelescopePrompt"
            "vim"
          ];
        };
      };

      # Terminal
      toggleterm = {
        enable = true;
        settings = {
          size = 20;
          open_mapping = "[[<c-\\>]]";
          direction = "float";
          float_opts = {
            border = "curved";
          };
        };
      };

      # Utilities
      which-key.enable = true;
      mini = {
        enable = true;
        modules = {
          surround = { };
          pairs = { };
          comment = { };
        };
      };
    };

    # Key mappings
    keymaps = [
      # General
      { key = "<leader>w"; action = "<cmd>w<cr>"; options.desc = "Save file"; }
      { key = "<leader>q"; action = "<cmd>q<cr>"; options.desc = "Quit"; }
      { key = "<leader>qq"; action = "<cmd>qa<cr>"; options.desc = "Quit All"; }
      
      # Navigation
      { key = "<C-h>"; action = "<C-w>h"; options.desc = "Navigate left"; }
      { key = "<C-j>"; action = "<C-w>j"; options.desc = "Navigate down"; }
      { key = "<C-k>"; action = "<C-w>k"; options.desc = "Navigate up"; }
      { key = "<C-l>"; action = "<C-w>l"; options.desc = "Navigate right"; }
      
      # Window management
      { key = "<leader>w-"; action = "<C-W>s"; options = { desc = "Split Window Below"; remap = true; }; }
      { key = "<leader>w|"; action = "<C-W>v"; options = { desc = "Split Window Right"; remap = true; }; }
      { key = "<leader>wd"; action = "<C-W>c"; options = { desc = "Delete Window"; remap = true; }; }
      
      # Buffer navigation
      { key = "<S-h>"; action = "<cmd>BufferLineCyclePrev<cr>"; options.desc = "Prev Buffer"; }
      { key = "<S-l>"; action = "<cmd>BufferLineCycleNext<cr>"; options.desc = "Next Buffer"; }
      { key = "[b"; action = "<cmd>BufferLineCyclePrev<cr>"; options.desc = "Prev Buffer"; }
      { key = "]b"; action = "<cmd>BufferLineCycleNext<cr>"; options.desc = "Next Buffer"; }
      { key = "<leader>bd"; action = "<cmd>bdelete<cr>"; options.desc = "Delete Buffer"; }
      
      # Neo-tree
      { key = "<leader>e"; action = "<cmd>Neotree toggle<cr>"; options.desc = "Toggle file tree"; }
      
      # Terminal
      { key = "<leader>tt"; action = "<cmd>ToggleTerm<cr>"; options.desc = "Toggle terminal"; }
      
      # Clear search with <esc>
      {
        mode = ["i" "n"];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options.desc = "Escape and Clear hlsearch";
      }
      
      # Save file
      {
        mode = ["i" "x" "n" "s"];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options.desc = "Save File";
      }
    ];

    extraPackages = with pkgs; [
      ripgrep
      fd
      fzf
      nixfmt-rfc-style
      black
      prettierd
      stylua
    ];

    # Highlight on yank
    autoGroups = {
      highlight_yank = { };
    };

    autoCmd = [
      {
        group = "highlight_yank";
        event = [ "TextYankPost" ];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        };
      }
    ];

    extraConfigLua = ''
      -- Rounded borders for LSP windows
      local _border = "rounded"

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = _border
        }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = _border
        }
      )

      vim.diagnostic.config{
        float={border=_border}
      };
    '';
  };
}