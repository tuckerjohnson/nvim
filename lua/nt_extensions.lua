--bindings
OPEN_FILE = '<leader>s' --as in 'see'
FILE_INFO = '<leader>a' --as in 'about'

--General File Associations
DOCUMENTS = '!setsid -f zathura'
AUDIO = 'below terminal mpv --no-vid'
OFFICE = '!setsid -f libreoffice'
IMAGE = '!setsid -f nsxiv'
VIDEO = '!mpv'

--file-type associations table
FILE_ASSOCIATIONS = {
    rpp = '!setsid -f reaper',
    pd = '!setsid -f pd',
    scd = '!scide',
    pdf = DOCUMENTS,
    epub = DOCUMENTS,
    wav = AUDIO,
    mp3 = AUDIO,
    caf = AUDIO,
    ogg = AUDIO,
    m4a = AUDIO,
    mov = VIDEO,
    mkv = VIDEO,
    mp4 = VIDEO,
    docx = OFFICE,
    ods = OFFICE,
    xlsx = OFFICE,
    png = IMAGE,
    jpg = IMAGE,
    jpeg = IMAGE
}

vim.keymap.set('n', OPEN_FILE, function()
    local line = vi_current_line()
    local trimmedPath = vi_top_line() .. string.match(line, "^%s*\7(.-)%s*$")
    if sh__file_exists(trimmedPath) then
        local fileExt = sh__extension(trimmedPath)
        if fileExt then
            local command = FILE_ASSOCIATIONS[fileExt]
            if command then
                vim.cmd(command .. " " .. sh__escape(trimmedPath))
            else
                print("ERROR: edit config: no file association: " .. fileExt)
            end
        end
    end
end, {desc = 'Open a file'})

vim.keymap.set('n', FILE_INFO, function()
    local line = vi_current_line()
    local trimmedPath = vi_top_line() .. line:match("^%s*\7(.-)%s*$")
    if sh__file_exists(trimmedPath) then
        vim.cmd('!stat ' .. sh__escape(trimmedPath))
    end
end, {desc = 'Retrieve file information'})

function sh__file_exists(path)
    openFile = io.open(path, "r")
    if openFile then
        io.close(openFile)
        return path
    else
        print("ERROR: no file found at: " .. path)
        return nil
    end
end

function sh__extension(path)
    local fileExt = string.match(path, "%.([^%.]+)$")
    if fileExt then
        return string.lower(fileExt)
    else
        print("ERROR: couldn't locate file extension: " .. path)
        return nil
    end
end

function sh__escape(str)
    return "'" .. string.gsub(str, "'", "'\\''") .. "'"
end


function vi_current_line()
    local buffer = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    return vim.api.nvim_buf_get_lines(buffer, cursor[1] - 1, cursor[1], false)[1]
end

function vi_top_line()
    local buffer = vim.api.nvim_get_current_buf()
    return vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1]
end
