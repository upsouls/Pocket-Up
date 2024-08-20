
--[[
MIT License

Copyright (c) 2024 Max-Dil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]

local IS_WIN = system.getInfo 'platform' ~= 'android'
local IS_SIM = system.getInfo 'environment' == 'simulator'

local M = require("plugin.androidFilePicker")
local UTF8 = require 'plugin.utf8'

local OS_COPY = function(link, link2)
    if IS_SIM or IS_WIN then
        link = UTF8.gsub(link, '/', '\\')
        link2 = UTF8.gsub(link2, '/', '\\')
        os.execute('copy /y "' .. link .. '" "' .. link2 .. '"')
    else
        os.execute('cp -f "' .. link .. '" "' .. link2 .. '"')
    end
end

if IS_SIM or IS_WIN then
    FILEPICKER = require 'plugin.tinyfiledialogs'


    M = {}
    M.show = function(mime ,path, listener)
        local filter_patterns = mime == 'image/*' and {'*.png', '*.jpg', '*.jpeg', '*.gif'}
        or mime == 'audio/*' and {'*.wav', '*.mp3', '*.ogg'} or mime == 'ccode/*' and {'*.ccode', '*.zip'}
        or mime == 'text/x-lua' and {'*.lua', '*.txt'} or mime == 'video/*' and {'*.mov', '*.mp4', '*.m4v', '*.3gp'} or nil
        local pathToFile , path = path , FILEPICKER.openFileDialog({filter_patterns = filter_patterns})
        if path then OS_COPY(path, pathToFile) end listener({isError = path and false or true, done = path and 'ok' or 'error', origFileName = path})
    end
end

return M