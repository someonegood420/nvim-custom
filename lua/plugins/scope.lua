return {
	"tiagovla/scope.nvim",
	lazy = false, -- load immediately (scope needs to be active early for tab/buffer handling)
	config = function() require("scope").setup({}) end,
}
