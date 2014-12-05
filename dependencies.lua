local load = function(dir, named, file)
	local filename = string.gsub(file, '.lua', '')
	local path = dir .. '/' .. filename
	if named then
		_G[filename] = require(path)
	else
		require(path)
	end
end

local sets = {
	{
		dir = 'lib',
		named = true,
		callback = load,
	},
	{
		dir = 'modules',
		callback = load,
	},
	{
		dir = 'entities',
		callback = load,
	},
	{
		dir = 'helpers',
		callback = load,
	},
}

return function()
	for _,set in ipairs(sets) do
		love.filesystem.getDirectoryItems(set.dir, function(...) set.callback(set.dir, set.named, ...) end)
	end
	if aliases then
		aliases()
	end
end