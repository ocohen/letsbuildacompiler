require_relative 'cradle'


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

def factor 
    if $look == '('
        match('(')
        expression
        match(')')
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
    puts("pop edx")
    puts("idiv edx,ecx")
    puts("mov ecx,edx")
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
expression
puts "mov eax, ecx"
puts "ret"
