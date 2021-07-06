describe("Relative path resolution", function()
	local resolve_relative_path = require "http.util".resolve_relative_path
	it("should resolve .. correctly", function()
		assert.same("/foo", resolve_relative_path("/", "foo"))
		assert.same("/foo", resolve_relative_path("/", "./foo"))
		assert.same("/foo", resolve_relative_path("/", "../foo"))
		assert.same("/foo", resolve_relative_path("/", "../foo/../foo"))
		assert.same("/foo", resolve_relative_path("/", "foo/bar/.."))
		assert.same("/foo/", resolve_relative_path("/", "foo/bar/../"))
		assert.same("/foo/", resolve_relative_path("/", "foo/bar/../"))
		assert.same("/", resolve_relative_path("/", "../.."))
		assert.same("/", resolve_relative_path("/", "../../"))
		assert.same("/bar", resolve_relative_path("/foo/", "../bar"))
		assert.same("bar", resolve_relative_path("foo/", "../bar"))
		assert.same("bar/", resolve_relative_path("foo/", "../bar/"))
	end)
	it("should ignore .", function()
		assert.same("/", resolve_relative_path("/", "."))
		assert.same("/", resolve_relative_path("/", "./././."))
		assert.same("/", resolve_relative_path("/", "././././"))
		assert.same("/foo/bar/", resolve_relative_path("/foo/", "bar/././././"))
	end)
	it("should keep leading and trailing /", function()
		assert.same("/foo/", resolve_relative_path("/foo/", "./"))
		assert.same("foo/", resolve_relative_path("foo/", "./"))
		assert.same("/foo", resolve_relative_path("/foo/", "."))
		assert.same("foo", resolve_relative_path("foo/", "."))
	end)
	it("an absolute path as 2nd arg should be resolved", function()
		assert.same("/foo", resolve_relative_path("ignored", "/foo"))
		assert.same("/foo", resolve_relative_path("ignored", "/foo/./."))
		assert.same("/foo", resolve_relative_path("ignored", "/foo/bar/.."))
		assert.same("/foo", resolve_relative_path("ignored", "/foo/bar/qux/./../././.."))
		assert.same("/foo/", resolve_relative_path("ignored", "/foo/././"))
	end)
	it("cannot go above root level", function()
		assert.same("/bar", resolve_relative_path("/", "../bar"))
		assert.same("/bar", resolve_relative_path("/foo", "../../../../bar"))
		assert.same("/bar", resolve_relative_path("/foo", "./../../../../bar"))
		assert.same("/", resolve_relative_path("/foo", "./../../../../"))
		assert.same("/", resolve_relative_path("/", ".."))
		assert.same("", resolve_relative_path("", ".."))
		assert.same("", resolve_relative_path("", "./.."))
		assert.same("bar", resolve_relative_path("", "../bar"))
	end)
end)
