require_relative 'cradle'


def add
    match('+')
    term
    puts "popq %rdx"
    puts "add %rcx,%rdx"
    puts "pushq %rcx"
end

def subtract
    match('-')
    term
    puts "popq %rdx"
    puts "sub %rdx,%rcx" #this is%rdx =%rdx -%rcx
    puts "pushq %rdx"
end

def expression
    if isAddOp($look)
        puts "movq %rcx, 0"
    else
        term
    end

    puts "pushq %rcx"
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
    puts "popq %rcx"
end

def factor 
    if $look == '('
        match('(')
        expression
        match(')')
    else
        puts "movq %rcx, #{getNum}"
    end
end

def multiply
    match('*')
    factor
    puts("popq %rdx")
    puts("imul %rcx,%rdx")
end

def divide
    match('/')
    factor
    puts("popq %rdx")
    puts("idivq %rdx,%rcx")
    puts("movq %rcx,%rdx")
end

def term 
    factor
    while ["*", "/"].include?($look) do
        puts "pushq %rcx"
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

puts ".text"
puts ".globl run"
puts ".align 4,0x90"
puts "run:"
init
expression
puts "ret"
puts ".cfi_endproc"
