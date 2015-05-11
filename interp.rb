require_relative 'cradleInterp'

$vars = Hash.new(0)

def assignment
    name = getName
    match('=')
    $vars[name] = expression
end

def factor
    res = 0
    if $look == '('
        match '('
        res = expression
        match ')'
    elsif isAlpha $look
        res = $vars[getName]
    else
        res = getNum
    end

    return res
end

def term
    value = factor
    while ['*', '/'].include? $look
        case $look
        when '*'
            match '*'
            value *= factor
        when '/'
            match '/'
            value /= factor
        end
    end
    value
end

def expression
    value = 0
    if !isAddOp $look
        value = term 
    end

    while isAddOp $look
        case $look
        when '+'
            match '+'
            value += term
        when '-'
            match '-'
            value -= term
        end
    end

    value
end

loop do
    init
    if $look == '!'
        output
    else
        assignment
    end
    newLine
    $look != '.' or break
end
