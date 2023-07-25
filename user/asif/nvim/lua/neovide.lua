local o = vim.o
local g = vim.g

if g.neovide then
    --o.guifont = "Hack:h17"
    g.neovide_transparency = 0.8
    g.neovide_cursor_trail_size = 0.1
    g.neovide_cursor_animation_length = 0.15
end
