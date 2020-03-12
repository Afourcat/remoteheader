
" Testing purpose
lua remoteheader = require("remoteheader")

" RH Api
lua remoteheader.api = require("remoteheader.api")

" Adding commands needed by the user.
command! RemoteHeader lua remoteheader.api.insert_header(vim.api.nvim_get_var('remote_header_addr'))
command! -nargs=1 RemoteHeaderCustom lua remoteheader.api.insert_custom_header(<f-args>)
