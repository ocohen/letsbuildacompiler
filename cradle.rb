# Variable Declarations 

look = '' # lookahead Character 

# Read New Character From Input Stream 
def getChar
    $look = ARGF.readchar
end


# Report What Was Expected 
def expected(s)
    abort("#{s} Expected")
end

# Match a Specific Input Character 
def match(x)
    $look == x or expected("#{x}")
    getChar
end

def isAddOp(c)
    ['+', '-'].include?(c)
end

# Recognize an Alpha Character 
def isAlpha(c)
    ('A' .. 'Z').include?(c.capitalize)
end

# Recognize a Decimal Digit 
def isDigit(c)
    ('0' .. '9').include?(c)
end

# Get an Identifier 
def getName
    isAlpha($look) or expected("Name")
    upper = uppercase($look)
    getChar
    return upper
end

# Get a Number 
def getNum
    isDigit($look) or expected("Integer")
    digit = $look
    getChar
    return digit
end

# Initialize 
def init
    getChar
end
