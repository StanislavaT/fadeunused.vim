function! fadeunused#FindVariablesJava()
    let text = getline(0, '$')
    let remainingText = []
    let declaredVariables = []
    for line in text
        let line = trim(line) " remove leading / trailing whitespace
        let line = substitute(line, "[ \t][ \t]*", " ", "") " squeeze spaces
        let line = substitute(line, "//.*", "", "") " remove single line comments
        let lineUsed = matchstr(line, '\(=\|(\|return\).*') " the part of the line in which variable values are being used
        let init = matchstr(line, "^[a-zA-Z_][^(]* [a-zA-Z_][^(]*=") " variable declared and initialized
        let init = matchstr(init, '\zs[a-zA-Z_][a-zA-Z_0-9]*\ze *=$')
        let decl = matchstr(line, '^[a-zA-Z_][^(=]* [a-zA-Z_][a-zA-Z_0-9]*;')
        if decl =~ '^\(import\|return\).*$'
            let decl = ""
        else
            let decl = matchstr(decl, '\zs[a-zA-Z_][a-zA-Z_0-9]*\ze;')
        endif
        if decl != ""
            call add(declaredVariables, decl)
        endif
        if init != ""
            call add(declaredVariables, init)
        endif
        let remainingText = add(remainingText, lineUsed)
    endfor
    let remainingText = join(remainingText, "\n")
    let unusedVariables = []
    call clearmatches()
    for variable in declaredVariables
        if remainingText !~ variable
            call add(unusedVariables, variable)
            call matchadd('FadeUnused', variable)
        endif
    endfor
    echo join(unusedVariables, " ")
endfunction

function! fadeunused#FindVariablesCpp()
    let text = getline(0, '$')
    let remainingText = []
    let declaredVariables = []
    for line in text
        let line = trim(line) " remove leading / trailing whitespace
        let line = substitute(line, "[ \t][ \t]*", " ", "") " squeeze spaces
        let line = substitute(line, "//.*", "", "") " remove single line comments
        let lineUsed = matchstr(line, '\(=\|(\|return\).*$') " the part of the line in which variable values are being used
        let init = matchstr(line, "^[a-zA-Z_][^(]* [a-zA-Z_][^(]*=") " variable declared and ini
        let init = matchstr(init, '\zs[a-zA-Z_][a-zA-Z_0-9]*\ze *=')
        let decl = matchstr(line, '^[a-zA-Z_][^(=]* [a-zA-Z_][a-zA-Z_0-9]*;')
        if decl =~ '^\(include\|import\|return\|using\).*$'
            let decl = ""
        else
            let decl = matchstr(decl, '\zs[a-zA-Z_][a-zA-Z_0-9]*\ze;')
        endif
        if decl != ""
            call add(declaredVariables, decl)
        endif
        if init != ""
            call add(declaredVariables, init)
        endif
        call add(remainingText, lineUsed)
    endfor
    let remainingText = join(remainingText, "\n")
    let unusedVariables = []
    call clearmatches()
    for variable in declaredVariables
        if remainingText !~ variable
            call add(unusedVariables, variable)
            call matchadd('FadeUnused', variable)
        endif
    endfor
    echo join(unusedVariables, " ")
endfunction

function! fadeunused#FindVariablesPython()
    let text = getline(0, '$')
    let remainingText = []
    let declaredVariables = []
    for line in text
        let line = trim(line) " remove leading / trailing whitespace
        let line = substitute(line, "[ \t][ \t]*", " ", "") " squeeze spaces
        let line = substitute(line, "#.*", "", "") " remove single line comments
        let lineUsed = matchstr(line, '\(=\|(\|return\|if|\for\|while\|assert\).*$') " the part of the line in which variable values are being used
        let init = matchstr(line, "^[a-zA-Z_][^(]*=") " variable declared and initialized
        let init = matchstr(init, '\zs[a-zA-Z_][a-zA-Z_0-9]*\ze *=')
        if init != ""
            call add(declaredVariables, init)
        endif
        let remainingText = add(remainingText, lineUsed)
    endfor
    let remainingText = join(remainingText, "\n")
    let unusedVariables = []
    call clearmatches()
    for variable in declaredVariables
        if remainingText !~ variable
            call add(unusedVariables, variable)
            call matchadd('FadeUnused', variable)
        endif
    endfor
    echo join(unusedVariables, " ")
endfunction

function! fadeunused#FindVariables()
    if b:current_syntax == 'java'
        call fadeunused#FindVariablesJava()
    elseif b:current_syntax == 'cpp'
        call fadeunused#FindVariablesCpp()
    elseif b:current_syntax == 'python'
        call fadeunused#FindVariablesPython()
    else
        echo 'Fade unused is not implemented for this language'
    endif
endfunction
