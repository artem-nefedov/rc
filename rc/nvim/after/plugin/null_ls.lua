local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.tfsec,
    -- null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.markdownlint,
  },
})

null_ls.register(require('none-ls-shellcheck.code_actions'))
