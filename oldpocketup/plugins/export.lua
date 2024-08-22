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
local EXPORTFILE = require ('plugin.exportFile')

local IS_WIN = system.getInfo 'platform' ~= 'android'
local IS_SIM = system.getInfo 'environment' == 'simulator'

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
    EXPORTFILE.export = function(config)
        pcall(function ()
        local path, listener, name = config.path, config.listener, config.name
        local pathToFile = FILEPICKER.saveFileDialog({})
        if path then OS_COPY(path, pathToFile) end listener()          
        end)
    end
end

return EXPORTFILE