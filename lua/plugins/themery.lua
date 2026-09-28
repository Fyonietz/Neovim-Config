return {
{
    "zaldih/themery.nvim",
 lazy = false,
    config = function()
      require("themery").setup({
            themes = {
            {
                name = "Sonokai",
                colorscheme = "sonokai",
            },
            {
                name = "Unokai",
                colorscheme = "unokai",
            },
            {
                name = "Onedark",
                colorscheme = "onedark",
            },
            {
                name = "Catcappcin",
                colorscheme = "catppuccin",
            },
        }
    })
    end
}
}
