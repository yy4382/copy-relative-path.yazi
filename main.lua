local get_hovered_url = ya.sync(function()
	local hovered = cx.active.current.hovered
	if hovered then
		return tostring(hovered.url)
	end
	return nil
end)

return {
	entry = function()
		local url = get_hovered_url()
		if not url then
			ya.notify({
				title = "Copy Relative Path",
				content = "No file hovered",
				timeout = 3,
				level = "warn",
			})
			return
		end

		-- Find git repo root
		local child, err = Command("git")
			:arg({ "rev-parse", "--show-toplevel" })
			:cwd(url:match("(.*/)" ) or "/")
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

		local git_root = child.stdout:gsub("%s+$", "")
		-- Compute relative path: strip git_root prefix from url
		local rel = url
		if url:sub(1, #git_root) == git_root then
			rel = url:sub(#git_root + 2) -- +2 to skip the trailing /
		end

		if rel == "" then
			rel = "."
		end

		ya.clipboard(rel)
		ya.notify({
			title = "Copy Relative Path",
			content = rel,
			timeout = 3,
			level = "info",
		})
	end,
}
