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

-- Code from gist https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99
local char_to_hex = function(c)
  return string.format("%%%02X", string.byte(c))
end

local function urlencode(url)
  if url == nil then
    return
  end
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w ])", char_to_hex)
  url = url:gsub(" ", "+")
  return url
end

local hex_to_char = function(x)
  return string.char(tonumber(x, 16))
end

local urldecode = function(url)
  if url == nil then
    return
  end
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", hex_to_char)
  return url
end
-- End

function eval_command(command)
    local filename = vim.api.nvim_call_function("expand", { "%:t" })
    local replacement = {
        filename = urlencode(filename),
        project = urlencode(find_project_name()),
        description =  urlencode(vim.api.nvim_call_function("input", { "Enter a description: " }))
    }

    return string.gsub(command, "%$(%w+)", replacement)
end

function find_project_name()
    local handle = io.popen('git rev-parse --show-toplevel')
    local res = handle:read('*a')
    local r = { handle:close() }
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
