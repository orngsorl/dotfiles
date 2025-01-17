local present, mason = pcall(require, 'mason')

if not present then
	return
end

local present1, mason_lsp = pcall(require, 'mason-lspconfig')
if not present1 then
	return
end

local precent_nvim_lsp, nvim_lsp = pcall(require, 'lspconfig')
if not precent_nvim_lsp then
	return
end

local precent_null_ls, null_ls = pcall(require, 'null-ls')
if not precent_null_ls then
	return
end

local precent_mason_null_ls, mason_null_ls = pcall(require, 'mason-null-ls')
if not precent_mason_null_ls then
	return
end

-- -- Add additional capabilities supported by nvim-cmp
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.preselectSupport = true
-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
-- capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   },
-- }
--
-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--
--   -- Highlighting references
--   if client.server_capabilities.document_highlight then
--     vim.api.nvim_exec(
--       [[
--       augroup lsp_document_highlight
--         autocmd! * <buffer>
--         autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--         autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--       augroup END
--     ]], false)
--   end
--
--   -- Enable completion triggered by <c-x><c-o>
--   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--   -- Mappings.
--   local opts = { noremap=true, silent=true }
--
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--   buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--   buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--   buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--   buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--   -- buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
--   buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
--   buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
--   buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
--   buf_set_keymap('n', '<leader>fm', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
--
-- end

-- vim.api.nvim_create_augroup("_mason", { clear = true })

local options = {
	PATH = 'skip',
	ui = {
		icons = {
			package_pending = ' ',
			package_installed = ' ',
			package_uninstalled = ' ﮊ',
		},
		keymaps = {
			toggle_server_expand = '<CR>',
			install_server = 'i',
			update_server = 'u',
			check_server_version = 'c',
			update_all_servers = 'U',
			check_outdated_servers = 'C',
			uninstall_server = 'X',
			cancel_installation = '<C-c>',
		},
	},
	max_concurrent_installers = 10,
}

-- vim.api.nvim_create_user_command("MasonInstallAll", function()
--   vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
-- end, {})

mason.setup(options)
mason_lsp.setup({
	ensure_installed = { 'gopls' },
})

mason_lsp.setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		-- nvim_lsp[server_name].setup {
		--   on_attach = on_attach,
		--   capabilities = capabilities,
		--   flags = {
		--     debounce_text_changes = 150,
		--   }
		-- }
		nvim_lsp[server_name].setup({})
	end,
	-- Next, you can provide a dedicated handler for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	-- ["rust_analyzer"] = function ()
	--     require("rust-tools").setup {}
	-- end
})

mason_null_ls.setup({
	ensure_installed = { 'stylua' },
	automatic_setup = true,
	handlers = {
		-- function(source_name, methods)
		-- all sources with no handler get passed here
		-- Keep original functionality of `automatic_setup = true`
		-- require('mason-null-ls.automatic_setup')(source_name, methods)
		-- end,
		stylua = function(source_name, methods)
			null_ls.register(null_ls.builtins.formatting.stylua)
		end,
	},
})

-- will setup any installed and configured sources above
null_ls.setup()
