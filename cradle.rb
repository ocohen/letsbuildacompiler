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
    skipWhite
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

def isAlNumeric(c)
    isDigit(c) || isAlpha(c)
end

def isWhitespace(c)
    [' ', '\t'].include?(c)
end

def skipWhite
    while isWhitespace($look)
        getChar
    end
end

# Get an Identifier 
def getName
    token = ""
    isAlpha($look) or expected("Name")
    while isAlpha($look)
        token << $look
        getChar
    end

    skipWhite
    return token
end

# Get a Number 
def getNum
    value = ""
    isDigit($look) or expected("Integer")
    while isDigit($look)
        value << $look
        getChar
    end

    skipWhite
    return value
end

# Initialize 
def init
    getChar
    skipWhite
end
