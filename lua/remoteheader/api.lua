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
    local evaluated_command = eval_command(url)
    local handle = io.popen('curl -s "' .. evaluated_command .. '"')
    local res = handle:read('*a')
    handle:close()

    return split(res, '\n')
end

function eval_command(command)
    local filename = vim.api.nvim_call_function("expand", { "%:t" })
    local replacement = {
        filename = filename,
        project = find_project_name(),
        description =  vim.api.nvim_call_function("input", { "Enter a description: " })
    }

    local new = string.gsub(command, "%$(%w+)", replacement)
    return string.gsub(new, " ", "%%20")
end

function find_project_name()
    local handle = io.popen('git rev-parse --show-toplevel')
    local res = handle:read('*a')
    handle:close()
    if res == nil
        then return 'Unknown project'
        else return res:match('^.+/(.+)$'):gsub("\n", "")
    end
end

function insert_top(lines)
    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end

return {
    insert_custom_header = insert_custom_header,
    insert_header = insert_header,
}
