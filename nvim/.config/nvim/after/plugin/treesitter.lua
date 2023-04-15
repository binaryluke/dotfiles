require'nvim-treesitter.configs'.setup {
    ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "go" },
    sync_install = false,
    auto_install = true, -- automatically install missing parsers when entering buffer

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

