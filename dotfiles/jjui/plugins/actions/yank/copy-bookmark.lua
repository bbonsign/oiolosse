---@type ActionDef
return {
	name = "copy-bookmark",
	fn = function()
		local change_id = context.change_id()
		if not change_id then
			flash("No change selected")
			return
		end

		local output, err = jj(
			"log",
			"-r",
			change_id,
			"--no-graph",
			"-T",
			'local_bookmarks.map(|bookmark| bookmark.name()).join("\\n") ++ "\\n"',
			"--limit",
			"1"
		)
		if err then
			flash({ text = "Failed to read bookmarks: " .. err, error = true })
			return
		end

		local bookmarks = split_lines(output or "")
		if #bookmarks == 0 then
			flash("Selected change has no bookmark")
			return
		end

		local bookmark = bookmarks[1]
		if #bookmarks > 1 then
			bookmark = choose({
				title = "Choose bookmark to copy",
				options = bookmarks,
			})
			if not bookmark then
				return
			end
		end

		local ok, copy_err = copy_to_clipboard(bookmark)
		if ok == false then
			flash({ text = "Failed to copy bookmark: " .. (copy_err or "unknown error"), error = true })
			return
		end
		flash(string.format("Copied bookmark: %s", bookmark))
	end,
	opts = {
		seq = { "space", "c", "b" },
		scope = "revisions",
		desc = "copy bookmark name",
	},
}
