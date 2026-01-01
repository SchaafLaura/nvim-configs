-- This file is in this location:
--     "~/.config/nvim/"

------------------------------------------
--                IDK                   --
------------------------------------------
vim.g.mapleader = " "

------------------------------------------
--               Packages               --
------------------------------------------
vim.iter {
    {
        source = "nvim-treesitter/nvim-treesitter",
        checkout = "main",
        hooks = {
            post_checkout = function() vim.cmd "TSUpdate" end
        },
    },
    "neovim/nvim-lspconfig",
    "Mofiqul/dracula.nvim",
    "seblyng/roslyn.nvim",
    -- "OmniSharp/omnisharp-vim",
}:each(require("mini.deps").add)


-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd([[echo "Installing mini.nvim" | redraw]])
    local clone_cmd = {
        "git", "clone", "--filter=blob:none",
        "https://github.com/nvim-mini/mini.nvim", mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd([[echo "Installed mini.nvim" | redraw]])
    end
    require("mini.deps").setup {
        path = {
            package = path_package
        }
    }

------------------------------------------
--             Package-Setup            --
------------------------------------------
-- Treesitter
local trans = setmetatable({
    cs = "c_sharp"
}, { __index = function (tbl, key) return key end})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(e)
    local ts = require "nvim-treesitter"
    local has = function (what)
    return function (it)
    return it == what
    end
    end
    local parser = trans[e.match]
    if vim.iter(ts.get_installed()):any(has(parser)) then
        vim.treesitter.start()
        if #vim.treesitter.query.get_files(parser, "indents") > 0 then
            vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
            return
            end
            if vim.iter(ts.get_available()):any(has(parser)) then
                vim.cmd.TSInstall(parser)
                end
                end,
})

-- Setups
require("mini.completion").setup()
require("mini.snippets").setup()
require("mini.icons").setup()
MiniIcons.tweak_lsp_kind()

------------------------------------------
--                  LSP                 --
------------------------------------------

 vim.lsp.enable({
    -- "csharp_ls"
    -- "omnisharp"
    "roslyn"
 })

vim.lsp.config("roslyn", {
    on_attach = function()
    print("This will run when the server attaches!")
    end,
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
})

------------------------------------------
--              Visuals                 --
------------------------------------------

-- cursors
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- theme
vim.cmd.colorscheme("dracula")

-- bar on the left
-- TODO: absolute number instead of "0" in the center
vim.wo.relativenumber = true

-- indents
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- display whitepsace
vim.opt.listchars = [[space:·,trail:·,nbsp:+,tab:-  ,precedes:←,extends:→,leadmultispace:·,nbsp:␣]]
vim.opt.list = true

------------------------------------------
--                Keys                  --
------------------------------------------

-- jump around errors
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count = 1, float = true}) end)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count = -1, float = true}) end)

-- display all errors in new thingy
vim.keymap.set("n", "<leader>q",
               function()
                    vim.diagnostic.setqflist()
                    vim.cmd("copen")
                end)







