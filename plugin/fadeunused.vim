" Title:        Fade Unused
" Description:  A plugin to highlight (fade) unused variables.
" Last Change:  22 May 2023
" Maintainer:   Stanislava Todorova <https://github.com/StanislavaT>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_fadeunused")
    finish
endif
let g:loaded_fadeunused = 1

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=0 FindVariables call fadeunused#FindVariables()

highlight FadeUnused ctermbg=DarkGrey

nnoremap <F6> :FindVariables<CR>
nnoremap <F7> :call clearmatches()<CR>
