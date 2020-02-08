
" Testing purpose
lua remoteheader = require("remoteheader")

" RH Api
lua remoteheader.api = require("remoteheader.api")

" Adding commands needed by the user.
command RemoteHeader lua remoteheader.api.insert_header()
command -nargs=1 RemoteHeaderCustom lua remoteheader.api.insert_custom_header(<f-args>)
