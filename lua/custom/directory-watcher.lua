local M = {}

local watchers = {}
local watched_dirs = {}

local function is_ignored_dir(name)
	return name == ".git" or name == "node_modules" or name == ".direnv" or name == ".venv"
end

local function stop_watcher(watcher)
	if watcher and not watcher:is_closing() then
		watcher:stop()
		watcher:close()
	end
end

local function scan_dirs(root, on_dir)
	local stack = { root }
	while #stack > 0 do
		local dir = table.remove(stack)
		on_dir(dir)

		for name, kind in vim.fs.dir(dir) do
			if kind == "directory" and not is_ignored_dir(name) then
				table.insert(stack, dir .. "/" .. name)
			end
		end
	end
end

local function register(path, label, on_change)
	local uv = vim.uv or vim.loop
	watched_dirs[label] = watched_dirs[label] or {}
	local root = path
	local refresh_tree

	local function add_dir(dir)
		local label_dirs = watched_dirs[label]
		if not label_dirs or label_dirs[dir] then
			return
		end

		local watcher = uv.new_fs_event()
		if not watcher then
			return
		end

		local ok = watcher:start(dir, {}, vim.schedule_wrap(function(err, filename, events)
			if err then
				return
			end

			if not watched_dirs[label] then
				return
			end

			refresh_tree()
			local filepath = filename and (dir .. "/" .. filename) or dir
			on_change(filepath, events)
		end))

		if not ok then
			stop_watcher(watcher)
			return
		end

		watched_dirs[label][dir] = watcher
	end

	refresh_tree = function()
		if not watched_dirs[label] then
			return
		end

		scan_dirs(root, add_dir)
	end

	refresh_tree()
	watchers[label] = true
end

function M.registerOnChangeHandler(label, on_change)
	local cwd = vim.fn.getcwd()
	register(cwd, label, on_change)
end

function M.stop(label)
	for dir, watcher in pairs(watched_dirs[label] or {}) do
		if dir ~= "refresh" then
			stop_watcher(watcher)
		end
	end
	watched_dirs[label] = nil
	watchers[label] = nil
end

return M
