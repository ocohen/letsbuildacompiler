require_relative 'cradle'

$variables = {}

def add
    match('+')
    term
    puts "pop edx"
    puts "add ecx,edx"
    puts "push ecx"
end

def subtract
    match('-')
    term
    puts "pop edx"
    puts "sub edx,ecx" #this isedx =edx -ecx
    puts "push edx"
end

def expression
    if isAddOp($look)
        puts "mov ecx, 0"
    else
        term
    end

    puts "push ecx"
    while ["+", "-"].include?($look) do
        case $look
        when '+'
            add
        when '-'
            subtract
        else
            expected('AddOp')
        end
    end
    puts "pop ecx"
end

def assignment
    name = getName
    match('=')
    expression
    puts "lea edx, [#{name}]"
    puts "mov [edx], ecx"
    $variables[name] = true
end

def ident
        name = getName
        if $look == '('
            match('(')
            match(')')
            puts "call #{name}"
        else
            puts "mov ecx, [#{name}]"
            $variables[name] = true
        end
end

def factor 
    if $look == '('
        match('(')
        expression
        match(')')
    elsif isAlpha($look)
        ident
    else
        puts "mov ecx, #{getNum}"
    end
end

def multiply
    match('*')
    factor
    puts("pop edx")
    puts("imul ecx,edx")
end

def divide
    match('/')
    factor
    puts("pop eax")
    puts("mov edx, 0")
    puts("idiv ecx")
    puts("mov ecx,eax")
end

def term 
    factor
    while ["*", "/"].include?($look) do
        puts "push ecx"
        case $look
        when '*'
            multiply
        when '/'
            divide
        else
            expected('MulOp')
        end
    end
end

puts "section .text"
puts "global run"
puts "run:"
init
assignment
if $look != "\n"
    expected("Newline")
end
puts "mov eax, ecx"
puts "ret"
if $variables
    puts "section .bss"
    $variables.each do |name, value|
       puts "#{name} resd 1"
   end
end
