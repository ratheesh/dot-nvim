-- Copyright (c) 2022 Ratheesh <ratheeshreddy@gmail.com>
-- License: MIT
-- null-ls Configuration

local M = {}

function M.setup()
	local ls = require("null-ls")
	local nls_utils = require "null-ls.utils"

	local with_diagnostics_code = function(builtin)
		return builtin.with {
			diagnostics_format = "#{m} [#{c}]",
		}
	end

	-- local with_root_file = function(builtin, file)
	-- 	return builtin.with {
	-- 		condition = function(utils)
	-- 			return utils.root_has_file(file)
	-- 		end,
	-- 	}
	-- end

	local sources = {
		-- formatting
		ls.builtins.formatting.shfmt,
		ls.builtins.formatting.black,
		ls.builtins.formatting.autopep8,
		ls.builtins.formatting.isort,
		ls.builtins.formatting.prettier.with({
			filetypes = { "html", "css", "yaml", "markdown", "json" },
		}),
		-- ls.builtins.formatting.stylua,

		-- diagnostics
		with_diagnostics_code(ls.builtins.diagnostics.shellcheck),
		ls.builtins.diagnostics.flake8,
		-- ls.builtins.diagnostics.mypy,
		ls.builtins.diagnostics.gitlint,
		-- ls.builtins.diagnostics.vale.with({ args = '--config="$XDG_CONFIG_HOME/vale/vale.ini"' }),

		-- completion
		ls.builtins.completion.spell,

		-- hover
		ls.builtins.hover.dictionary,

		-- code actions
		-- ls.builtins.code_actions.refactoring,
		ls.builtins.code_actions.gitsigns,
		ls.builtins.code_actions.gitrebase,
	}

	ls.setup({
		debug             = true,
		debounce          = 50,
		save_after_format = false,
		sources           = sources,
		root_dir          = nls_utils.root_pattern ".git",
		filetypes         = { 'python', 'lua' },

		on_init = function(new_client, _)
			new_client.offset_encoding = 'utf-32'
		end,

		on_attach = function(client)
			if client.server_capabilities.documentFormattingProvider then
				if vim.bo.filetype == 'python' then
					vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
				end
			end
		end
	})

end

	return M
