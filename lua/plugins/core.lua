return {
  { 'NMAC427/guess-indent.nvim', opts = {} },
  { 'tpope/vim-fugitive'},
  { 
    'brenoprata10/nvim-highlight-colors', 
    config = function()
      require('nvim-highlight-colors').setup({})
    end
  },
  {
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
  }
}
