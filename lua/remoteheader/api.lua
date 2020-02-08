function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function get_file_ext()
    local filename = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    return filename:match('.([^..]*)$')
end

function insert_header(addr)
    if addr == nil then
        print 'You need to set the global variable g:remote_header_addr.'
        return nil
    end
    local file_ext = get_file_ext()
    local header_addr = addr[file_ext] or addr['default']
    local data = fetch_header(header_addr)
    insert_top(data)
    return data
end

function insert_custom_header(url)
    local file_ext = get_file_ext()
    local data = fetch_header(url)
    insert_top(data)
end

function fetch_header(url)
    local handle = io.popen('curl -s ' .. url)
    local res = handle:read('*a')
    handle:close()

    return split(res, '\n')
end

function insert_top(lines)
    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end

return {
    insert_custom_header = insert_custom_header,
    insert_header = insert_header,
}
