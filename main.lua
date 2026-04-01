local get_hovered = ya.sync(function()
	local hovered = cx.active.current.hovered
	if hovered then
		return tostring(hovered.url:parent()), hovered.name
	end
	return nil, nil
end)

return {
	entry = function()
		local parent, name = get_hovered()
		if not parent or not name then
			ya.notify({
				title = "Copy Relative Path",
				content = "No file hovered",
				timeout = 3,
				level = "warn",
			})
			return
		end

		-- Get path from git root to the file's parent directory
		local child, err = Command("git")
			:arg({ "rev-parse", "--show-prefix" })
			:cwd(parent)
			:output()

		if err or not child or child.status.code ~= 0 then
			ya.notify({
				title = "Copy Relative Path",
				content = "Not inside a git repository",
				timeout = 3,
				level = "error",
			})
			return
		end

		local prefix = child.stdout:gsub("%s+$", "")
		local rel = prefix .. name

		ya.clipboard(rel)
		ya.notify({
			title = "Copy Relative Path",
			content = rel,
			timeout = 3,
			level = "info",
		})
	end,
}
