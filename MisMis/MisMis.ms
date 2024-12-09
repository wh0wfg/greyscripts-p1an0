MisMis = {
    "TokenType": {
        "Unknown": "Unknown",
        "Keyword": "Keyword",
        "Number": "Number",
        "String": "String",
        "Identifier": "Identifier",
        "OpAssign": "OpAssign",
        "OpPlus": "OpPlus",
        "OpMinus": "OpMinus",
        "OpTimes": "OpTimes",
        "OpDivide": "OpDivide",
        "OpMod": "OpMod",
        "OpPower": "OpPower",
        "OpEqual": "OpEqual",
        "OpNotEqual": "OpNotEqual",
        "OpGreater": "OpGreater",
        "OpGreatEqual": "OpGreatEqual",
        "OpLesser": "OpLesser",
        "OpLessEqual": "OpLessEqual",
        "OpAssignPlus": "OpAssignPlus",
        "OpAssignMinus": "OpAssignMinus",
        "OpAssignTimes": "OpAssignTimes",
        "OpAssignDivide": "OpAssignDivide",
        "OpAssignMod": "OpAssignMod",
        "OpAssignPower": "OpAssignPower",
        "LParen": "LParen",
        "RParen": "RParen",
        "LSquare": "LSquare",
        "RSquare": "RSquare",
        "LCurly": "LCurly",
        "RCurly": "RCurly",
        "AddressOf": "AddressOf",
        "Comma": "Comma",
        "Dot": "Dot",
        "Colon": "Colon",
        "Comment": "Comment",
        "EOL": "EOL",
    },
    "Token": {
        "type": null,
        "text": "",
        "afterSpace": false,
    },
	"Keywords": {
		"all": [
			"break",
			"continue",
			"else",
			"end",
			"for",
			"function",
			"if",
			"in",
			"isa",
			"new",
			"null",
			"then",
			"repeat",
			"return",
			"while",
			"and",
			"or",
			"not",
			"true",
			"false",
		],
	},
	"Op": {
		"Noop": 0,
		"Imm": 1,
		"Assign": 2,
		"Func": 3,
		"New": 4,
		"ElemOf": 5,
		"Add": 6,
		"Sub": 7,
		"Mul": 8,
		"Div": 9,
		"Mod": 10,
		"Pow": 11,
		"Free": 12,
		"Eq": 13,
		"Neq": 14,
		"Geq": 15,
		"Leq": 16,
		"Gt": 17,
		"Lt": 18,
		"Not": 19,
		"Isa": 20,
		"Goto": 21,
		"GotoIf": 22,
		"GotoIfNot": 23,
		"Push": 24,
		"Pop": 25,
		"Call": 26,
		"CallI": 27,
		"Return": 28,
		"List": 29,
		"Pair": 30,
		"Map": 31,
		"And": 32,
		"Or": 33,
		"ElemOfIter": 34,
	},
	"SourceLoc": {
		"lineNum": 0,
		"context": "",
	},
	"UnitTest": {},
    "Lexer": {
        "lineNum": 1,
        "position": 0,
        "input": "",
        "inputLength": 0,
        "pending": null,
    },
	"Line": {
		"op": null,
		"value": null,
		"location": null,
	},
	"Address" :{
		"addr": null,
	},
	"Immediate": {
		"imm": null,
	},
	"Func": {
		"func": null,
	},
	"Machine": {
		"standardOutput": null,
		"lines": null,
		"contextStack": null,
		"startTime": null,
	},
	"Context": {
		"stack": null,
		"heap": null,
		"referenceCount": null,
		"symbolTable": null,
		"pc": 0,
	},
	"Exception": {
		"message": "",
		"inner": null,
	},
	"Intrinsics": {},
}
MisMis.Intrinsics["print"] = function(args, vm)
	args = {0: ""} + args
	args[0] = vm.contextStack[-1].Render(args[0], 3)
	print(args[0])
end function
MisMis.Intrinsics["time"] = function(args, vm)
	return time - vm.startTime
end function
MisMis.Intrinsics["len"] = function(args, vm)
	return len(args[0])
end function
MisMis.Intrinsics["range"] = function(args, vm)
	context = vm.contextStack[-1]
	args = {0: 0, 1: 0, 2: null} + args
	ret = []
	for elem in range(args[0], args[1], args[2])
		index = context.Malloc(elem)
		context.referenceCount[index] = 1
		ret.push(index)
	end for
	return ret
end function
MisMis.Intrinsics.Call = function(func, args)
	f = @MisMis.Intrinsics[func]
	return f(args)
end function

MisMis.SourceLoc.__init__ = function(context, lineNum)
	ret = new MisMis.SourceLoc
	ret.context = context
	ret.lineNum = lineNum
	return ret
end function
MisMis.SourceLoc.ToString = function
	if self.context == null or self.context.len == 0 then
		return "[line " + self.lineNum + "]"
	else
		return "[context" + self.context + "line " + self.lineNum + "]"
	end if
end function

MisMis.Address.__init__ = function(addr)
	ret = new MisMis.Address
	ret.addr = addr
	return ret
end function
MisMis.Address.ToString = function
	return "&"+self.addr
end function
MisMis.Address.SELF = MisMis.Address.__init__("self")
MisMis.Immediate.__init__ = function(imm)
	ret = new MisMis.Immediate
	ret.imm = imm
	return ret
end function
MisMis.Immediate.ToString = function
	if self.imm == null then return "null"
	return "$"+self.imm
end function
MisMis.Immediate.TRUE = MisMis.Immediate.__init__(true)
MisMis.Immediate.FALSE = MisMis.Immediate.__init__(false)
MisMis.Immediate.ONE = MisMis.Immediate.__init__(1)
MisMis.Immediate.ZERO = MisMis.Immediate.__init__(0)
MisMis.Immediate.NULL = MisMis.Immediate.__init__(null)
// only stored in the heap
MisMis.Func.__init__ = function(func)
	ret = new MisMis.Func
	ret.func = func
	return ret
end function

MisMis.Line.__init__ = function(op, value=null)
	ret = new MisMis.Line
	ret.op = op
	ret.value = value
	return ret
end function
MisMis.Line.ToString = function
	i = MisMis.Op.indexOf(self.op)
	if i != null then
		if self.value isa MisMis.Address then
			text = i + " &" + str(self.value.addr)
		else if self.value isa MisMis.Immediate then
			if self.value.imm isa number then
				text = i + " $" + str(self.value.imm)
			else if self.value.imm isa string then
				text = i + " $'" + str(self.value.imm)
			else
				text = i + " $null"
			end if
		else
			text = i
		end if
	else
        return MisMis.Raise(MisMis.RuntimeException.__init__({"message": "unknown opcode: " + str(self.op)}))
    end if
    if self.location then
        text = text + char(9) + "// " + self.location.ToString
    end if
    return text
end function

MisMis.Context.__init__ = function(pc)
	ret = new MisMis.Context
	ret.pc = pc
	ret.referenceCount = []
	ret.stack = []
	ret.heap = []
	ret.symbolTable = {}
	return ret
end function
// value: number | string | list | map | func
// return : index
MisMis.Context.Malloc = function(value)
	// try reuse free memory
	freeIndex = self.referenceCount.indexOf(0)
	if freeIndex != null then 
		// self.referenceCount[freeIndex] = 1
		self.heap[freeIndex] = value
		return freeIndex
	end if

	// allocate new memory space
	index = self.heap.len
	self.heap.push(value)
	self.referenceCount.push(0)
	return index
end function
// only for print
// return: truly miniscript object
MisMis.Context.Render = function(value, recurseLimit)
	if recurseLimit == 0 then return "..."
	if value isa list then
		eachs = []
		for eachIndex in value
			eachs.push(self.Render(self.heap[eachIndex], recurseLimit-1))
		end for
		return "[" + eachs.join(", ") + "]"
	else if value isa map then
		eachs = []
		for eachPair in value
			eachs.push(self.Render(self.heap[eachPair.key], recurseLimit-1) + ": " + self.Render(self.heap[eachPair.value], recurseLimit-1))
		end for
		return "{" + eachs.join(", ") + "}"
	else
		if value isa number then
			return value
		else if value isa string then
			return """" + value + """"
		else
			return "FUNCTION()"
		end if
	end if
end function
MisMis.Context.RecursiveFree = function(index)
	self.referenceCount[index] = self.referenceCount[index] - 1
	value = self.heap[index]
	if value isa list then
		for eachIndex in value
			self.RecursiveFree(eachIndex)
		end for
	else if value isa map then
		for eachPair in value
			self.RecursiveFree(eachPair.key)
			self.RecursiveFree(eachPair.value)
		end for
	end if
end function
MisMis.Context.Free = function(addr)
	if self.symbolTable.hasIndex(addr) == 0 then return

	oldIndex = self.symbolTable[addr]
	self.RecursiveFree(oldIndex)
end function
MisMis.Context.Push = function(index)
	self.referenceCount[index] = self.referenceCount[index] + 1
	self.stack.push(index)
end function
// return: index
MisMis.Context.Pop = function
	index = self.stack.pop
	self.referenceCount[index] = self.referenceCount[index] - 1
	return index
end function

MisMis.Machine.__init__ = function(lines, context, standardOutput=null)
	ret = new MisMis.Machine
	if @standardOutput == null then
		ret.standardOutput = @MisMis.WriteLine 
	else
		ret.standardOutput = @standardOutput
	end if
	ret.lines = lines
	ret.contextStack = [context]
	ret.startTime = null
	return ret
end function
// a = function(b)
//	print b
// end function
// a 1
MisMis.Machine.RunUnitTests = function
	IFELSE = [
		"Imm $1",
		"Assign &a",
		"Imm $0",
		"Call &a",
		"GotoIfNot $10",
		"Imm $'YES",
		"Imm $1",
		"CallI $'print",
		"Pop",
		"Goto $14",
		"Imm $'NO",
		"Imm $1",
		"CallI $'print",
		"Pop",
		"Noop",
	]
	FUNC = [
		"Func $3",
		"Assign &a",
		"Goto $11",
		"Assign &b",
		"Imm $1",
		"Call &b",
		"Imm $1",
		"CallI $'print",
		"Pop",
		"Imm $null",
		"Return",
		"Noop",
		"Imm $1",
		"Imm $1",
		"Call &a",
		"Pop",
	]
	LIST = [
		"Imm $1",
		"Imm $2",
		"Imm $3",
		"List $3",
		"Assign &a",
		"Push &a",
		"Imm $1",
		"CallI $'print",
		"Pop",
		"Imm $10",
		"Imm $1",
		"CallI $'range",
		"Assign &a",
		"Push &a",
		"Imm $1",
		"CallI $'print",
	]
	MAP = [
		"Imm $'a",
		"Imm $'A",
		"Pair",
		"Imm $'b",
		"Imm $'B",
		"Pair",
		"Map $2",
		"Assign &a",
		"Push &a",
		"Imm $1",
		"CallI $'print",
		"Pop",
		"Imm $4",
		"Assign &a",
	]
	// 13.7
	// 0.3
	bin = [
		"Imm $0",
		"CallI $'time",
		"Assign &s",
		"Imm $1000",
		"Imm $1",
		"CallI $'range",
		"Assign &*i_elem",
		"Push &*i_elem",
		"Imm $1",
		"CallI $'len",
		"Assign &*i_len",
		"Imm $0",
		"Assign &*i_idx",
		"Push &*i_idx",
		"Push &*i_len",
		"Geq",
		"GotoIf $32",
		"Push &*i_elem",
		"Push &*i_idx",
		"ElemOfIter",
		"Assign &i",
		"Push &i",
		"Imm $1",
		"Call &i",
		"Imm $1",
		"CallI $'print",
		"Pop",
		"Push &*i_idx",
		"Imm $1",
		"Add",
		"Assign &*i_idx",
		"Goto $13",
		"Noop",
		"Free &*i_idx",
		"Free &*i_elem",
		"Free &*i_len",
		"Imm $0",
		"CallI $'time",
		"Imm $0",
		"Call &s",
		"Sub",
		"Imm $1",
		"CallI $'print",
		"Pop",
	]
	BOOL = [
		"Imm $0",
		"Imm $1",
		"Or",
		"Imm $1",
		"CallI $'print",
		"Pop",
	]

	lines = []

	for line in bin
		l = line.split(" ")
		op = MisMis.Op[l[0]]
		if l.len > 1 then
			if l[1][0] == "$" then
				if l[1][1] == "'" then
					imm = l[1][2:]
				else
					if l[1][1:] == "null" then
						imm = null
					else
						imm = l[1][1:].val
					end if
				end if
				value = MisMis.Immediate.__init__(imm)
			else
				value = MisMis.Address.__init__(l[1][1:])
			end if
		else
			value = null
		end if
		lines.push(MisMis.Line.__init__(op, value))
	end for
	context = MisMis.Context.__init__(0)
	vm = MisMis.Machine.__init__(lines, context)
	vm.RunUntilDone
end function
// null | Exception
MisMis.Machine.Step = function
	if self.startTime == null then self.startTime = time

	context = self.contextStack[-1]
	if context.pc >= self.lines.len then return

	line = self.lines[context.pc]
	op = line.op
	value = line.value
	// print line.ToString
	if op == MisMis.Op.Noop then

	else if op == MisMis.Op.Imm then
		context.Push(context.Malloc(value.imm))
	else if op == MisMis.Op.List then
		_list = []
		for i in range(0, value.imm-1, 1)
			elemIndex = context.Pop
			_list.push(elemIndex)
			context.referenceCount[elemIndex] = context.referenceCount[elemIndex] + 1
		end for
		context.Push(context.Malloc(_list))
	else if op == MisMis.Op.Pair then
		valueIndex = context.Pop
		keyIndex = context.Pop

		context.referenceCount[keyIndex] = context.referenceCount[keyIndex] + 1
		context.referenceCount[valueIndex] = context.referenceCount[valueIndex] + 1
		context.Push(context.Malloc({"key": keyIndex, "value": valueIndex}))
	else if op == MisMis.Op.Map then
		_map = {}
		for i in range(0, value.imm-1, 1)
			pair = context.heap[context.Pop]
			_map[pair["key"]] = pair["value"]
		end for
		context.Push(context.Malloc(_map))
	else if op == MisMis.Op.Func then
		context.Push(context.Malloc(MisMis.Func.__init__(value.imm)))
	else if op == MisMis.Op.ElemOf then
		key = context.heap[context.Pop]
		elem = context.heap[context.Pop]
		context.Push(elem[key])
	else if op == MisMis.Op.ElemOfIter then
		key = context.heap[context.Pop]
		elem = context.heap[context.Pop]
		if elem isa map then
			elemKey = elem.indexes[key]
			context.Push(context.Malloc({"key": elemKey, "value": elem.values[elemKey]}))
		else
			context.Push(elem.values[key])
		end if
	else if op == MisMis.Op.Push then
		context.Push(context.symbolTable[value.addr])
	else if op == MisMis.Op.Pop then
		context.Pop
	else if op == MisMis.Op.Free then
		context.Free(value.addr)
	else if op == MisMis.Op.Assign then
		srcIndex = context.Pop

		context.Free(value.addr)
		context.symbolTable[value.addr] = srcIndex
		context.referenceCount[srcIndex] = context.referenceCount[srcIndex] + 1
	else if op == MisMis.Op.Call then
		funcIndex = context.symbolTable[value.addr]
		func = context.heap[funcIndex]
		numIndex = context.Pop

		if func isa MisMis.Func then
			funcContext = MisMis.Context.__init__(func.func-1)
			for i in range(0, context.heap[numIndex]-1, 1)
				funcContext.Push(funcContext.Malloc(context.heap[context.Pop]))
			end for
			self.contextStack.push(funcContext)
		else
			context.Push(funcIndex)
		end if
	else if op == MisMis.Op.CallI then
		func = @MisMis.Intrinsics[value.imm]
		numIndex = context.Pop
		args = {}
		for i in range(0, context.heap[numIndex]-1, 1)
			args[i]=context.heap[context.Pop]
		end for
		context.Push(context.Malloc(func(args, self)))
	else if op == MisMis.Op.Return then
		ret = context.heap[context.Pop]
		self.contextStack.pop
		self.contextStack[-1].Push(self.contextStack[-1].Malloc(ret))
	else if op == MisMis.Op.Add then
		opB = context.heap[context.Pop]
		opA = context.heap[context.Pop]
		context.Push(context.Malloc(opA + opB))
	else if op == MisMis.Op.Sub then
		opB = context.heap[context.Pop]
		opA = context.heap[context.Pop]
		context.Push(context.Malloc(opA - opB))
	else if op == MisMis.Op.And then
		opB = context.heap[context.Pop]
		opA = context.heap[context.Pop]
		context.Push(context.Malloc(opA and opB))
	else if op == MisMis.Op.Or then
		opB = context.heap[context.Pop]
		opA = context.heap[context.Pop]
		context.Push(context.Malloc(opA or opB))
	else if op == MisMis.Op.Gt then
		opB = context.heap[context.Pop]
		opA = context.heap[context.Pop]
		context.Push(context.Malloc(opA > opB))
	else if op == MisMis.Op.Lt then
		opB = context.heap[context.Pop]
		opA = context.heap[context.Pop]
		context.Push(context.Malloc(opA < opB))
	else if op == MisMis.Op.Geq then
		opB = context.heap[context.Pop]
		opA = context.heap[context.Pop]
		context.Push(context.Malloc(opA >= opB))
	else if op == MisMis.Op.Leq then
		opB = context.heap[context.Pop]
		opA = context.heap[context.Pop]
		context.Push(context.Malloc(opA <= opB))
	else if op == MisMis.Op.GotoIf then
		condition = context.heap[context.Pop]
		if condition then
			context.pc = value.imm - 1
		end if
	else if op == MisMis.Op.GotoIfNot then
		condition = context.heap[context.Pop]
		if not condition then
			context.pc = value.imm - 1
		end if
	else if op == MisMis.Op.Goto then
		context.pc = value.imm - 1
	else
		return MisMis.Raise(MisMis.RuntimeException.__init__({
			"message": "unknown opcode: " + str(op),
			"location": line.location,
			}))
	end if

	context = self.contextStack[-1]
	// print("heap: ")
	// print(context.heap)
	// print("referenceCount: ")
	// print(context.referenceCount)
	// print("stack: ")
	// print(context.stack)
	context.pc = context.pc + 1
	if context.pc == self.lines.len then
		self.contextStack.pop
	end if
end function
MisMis.Machine.done = function
	return self.contextStack.len == 0
end function
MisMis.Machine.RunUntilDone = function
	while not self.done 
		self.Step
	end while
end function

MisMis.WriteLine = function(value="", replaceText=0)
	print(value, replaceText)
end function
MisMis.Raise = function(e)
	MisMis.WriteLine(e.Description)
	return e
end function

MisMis.Exception.__init__ = function(message)
	ret = new MisMis.Exception
	ret.__initException__(message)
	return ret
end function
MisMis.Exception.__initException__ = function(message)
	self.message = message
end function
MisMis.Exception.Description = function
	desc = "Error: " + self.message
	return desc
end function
MisMis.MiniscriptException = new MisMis.Exception
MisMis.MiniscriptException.__init__ = function(kwargs)
	ret = new MisMis.MiniscriptException
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.MiniscriptException.__initMiniscriptException__ = function(kwargs)
	self.__initException__(kwargs.message)
	if kwargs.hasIndex("context") == 1 then
		self.location = MisMis.SourceLoc.__init__(kwargs.context, kwargs.lineNum)
	else if kwargs.hasIndex("inner") == 1 then
		self.inner = kwargs.inner
	else if kwargs.hasIndex("location") == 1 then
		self.location = kwargs.location
	end if
end function
MisMis.MiniscriptException.Description = function
	desc = "Error: "
	if self isa MisMis.LexerException then 
		desc = "Lexer Error: "
	else if self isa MisMis.CompilerException then 
		desc = "Compiler Error: "
	else if self isa MisMis.RuntimeException then 
		desc = "Runtime Error: "
	end if
	desc = desc + self.message
	if self.hasIndex("location") == 1 then desc = desc + " " + self.location.ToString
	return desc
end function
MisMis.LexerException = new MisMis.MiniscriptException
MisMis.LexerException.__init__ = function(kwargs)
	ret = new MisMis.LexerException
	if kwargs == null then kwargs = {}
	kwargs = {"message": "Lexer Error"} + kwargs
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.CompilerException = new MisMis.MiniscriptException
MisMis.CompilerException.__init__ = function(kwargs)
	ret = new MisMis.CompilerException
	if kwargs == null then kwargs = {}
	kwargs = {"message": "Syntax Error"} + kwargs
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.RuntimeException = new MisMis.MiniscriptException
MisMis.RuntimeException.__init__ = function(kwargs)
	ret = new MisMis.RuntimeException
	if kwargs == null then kwargs = {}
	kwargs = {"message": "Runtime Error"} + kwargs
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.IndexException = new MisMis.RuntimeException
MisMis.IndexException.__init__ = function(kwargs)
	ret = new MisMis.IndexException
	if kwargs == null then kwargs = {}
	kwargs = {"message": "Index Error (index out of range)"} + kwargs
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.KeyException = new MisMis.RuntimeException
MisMis.KeyException.__init__ = function(kwargs)
	ret = new MisMis.KeyException
	if kwargs.hasIndex("key") then kwargs.message = "Key Not Found: '" + kwargs.key + "' not found in map"
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.TypeException = new MisMis.RuntimeException
MisMis.TypeException.__init__ = function(kwargs)
	ret = new MisMis.TypeException
	if kwargs == null then kwargs = {}
	kwargs = {"message": "Type Error (wrong type for whatever you're doing)"} + kwargs
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.TooManyArgumentsException = new MisMis.RuntimeException
MisMis.TooManyArgumentsException.__init__ = function(kwargs)
	ret = new MisMis.TooManyArgumentsException
	if kwargs == null then kwargs = {}
	kwargs = {"message": "Too Many Arguments"} + kwargs
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.LimitExceededException = new MisMis.RuntimeException
MisMis.LimitExceededException.__init__ = function(kwargs)
	ret = new MisMis.LimitExceededException
	if kwargs == null then kwargs = {}
	kwargs = {"message": "Runtime Limit Exceeded"} + kwargs
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.UndefinedIdentifierException = new MisMis.RuntimeException
MisMis.UndefinedIdentifierException.__init__ = function(kwargs)
	ret = new MisMis.UndefinedIdentifierException
	if kwargs.hasIndex("ident") then kwargs.message = "Undefined Identifier: '" + ident + "' is unknown in this context"
	ret.__initMiniscriptException__(kwargs)
	return ret
end function
MisMis.UndefinedLocalException = new MisMis.RuntimeException
MisMis.UndefinedLocalException.__init__ = function(kwargs)
	ret = new MisMis.UndefinedLocalException
	if kwargs.hasIndex("ident") then kwargs.message = "Undefined Local Identifier: '" + ident + "' is unknown in this context"
	ret.__initMiniscriptException__(kwargs)
	return ret
end function

MisMis.UnitTest.Run = function
	// MisMis.Parser.RunUnitTests()
	MisMis.Lexer.RunUnitTests()
	MisMis.Machine.RunUnitTests()
end function
MisMis.UnitTest.ReportError = function(err)
	MisMis.WriteLine(err)
end function
MisMis.UnitTest.ErrorIf = function(condition, err)
	if condition then MisMis.UnitTest.ReportError(err)
end function
MisMis.UnitTest.ErrorIfNull = function(obj)
	if obj == null then MisMis.UnitTest.ReportError("Unexpected null")
end function

MisMis.Keywords.IsKeyword = function(text)
	return MisMis.Keywords.all.indexOf(text) != null
end function

MisMis.Token.__init__ = function(type=null, text=null)
    ret = new MisMis.Token
    if type == null then
        type = MisMis.TokenType.Unknown
    end if
    ret.type = type
    ret.text = text
    return ret
end function
MisMis.Token.ToString = function
    if self.text == null then return self.type
    return self.type+"("+self.text+")"
end function
MisMis.Token.EOL = MisMis.Token.__init__(MisMis.TokenType.EOL)
MisMis.Lexer.AtEnd = function
    return self.position >= self.inputLength and self.pending.len == 0
end function
MisMis.Lexer.__init__ = function(input)
    ret = new MisMis.Lexer
    ret.input = input
    ret.inputLength = input.len
    ret.position = 0
    ret.pending = []
    return ret
end function
// return: Token | Exception
MisMis.Lexer.Peek = function
    if self.pending.len == 0 then
        if self.AtEnd then return MisMis.Token.EOL
		e = self.Dequeue()
		if e isa MisMis.Exception then return e
        self.pending.push(e)
    end if
    return self.pending[0]
end function
// return: Token | Exception
MisMis.Lexer.Dequeue = function
    if self.pending.len > 0 then
        dequeue = self.pending[0]
        self.pending.remove(0)
        return dequeue
    end if

    oldPos = self.position
    self.SkipWhitespaceAndComment()

    if self.AtEnd then return MisMis.Token.EOL

    result = MisMis.Token.__init__()
    result.afterSpace = self.position > oldPos
    startPos = self.position
    c = self.input[self.position]
    self.position = self.position + 1
    if not self.AtEnd then
		c2 = self.input[self.position]
		if c2 == "=" then
			if c == "=" then
				result.type = MisMis.TokenType.OpEqual
			else if c == "+" then
				result.type = MisMis.TokenType.OpAssignPlus
			else if c == "-" then
				result.type = MisMis.TokenType.OpAssignMinus
			else if c == "*" then
				result.type = MisMis.TokenType.OpAssignTimes
			else if c == "/" then
				result.type = MisMis.TokenType.OpAssignDivide
			else if c == "%" then
				result.type = MisMis.TokenType.OpAssignMod
			else if c == "^" then
				result.type = MisMis.TokenType.OpAssignPower
			end if
		end if
		if c == "!" and c2 == "=" then
			result.type = MisMis.TokenType.OpNotEqual
		end if
		if c == ">" and c2 == "=" then
			result.type = MisMis.TokenType.OpGreatEqual
		end if
		if c == "<" and c2 == "=" then
			result.type = MisMis.TokenType.OpLessEqual
		end if
		if result.type != MisMis.TokenType.Unknown then
			self.position = self.position + 1
			return result
		end if
	end if

    if c == "+" then
		result.type = MisMis.TokenType.OpPlus
	else if c == "-" then
		result.type = MisMis.TokenType.OpMinus
	else if c == "*" then
		result.type = MisMis.TokenType.OpTimes
	else if c == "/" then
		result.type = MisMis.TokenType.OpDivide
	else if c == "%" then
		result.type = MisMis.TokenType.OpMod
	else if c == "^" then
		result.type = MisMis.TokenType.OpPower
	else if c == "(" then
		result.type = MisMis.TokenType.LParen
	else if c == ")" then
		result.type = MisMis.TokenType.RParen
	else if c == "[" then
		result.type = MisMis.TokenType.LSquare
	else if c == "]" then
		result.type = MisMis.TokenType.RSquare
	else if c == "{" then
		result.type = MisMis.TokenType.LCurly
	else if c == "}" then
		result.type = MisMis.TokenType.RCurly
	else if c == "," then
		result.type = MisMis.TokenType.Comma
	else if c == ":" then
		result.type = MisMis.TokenType.Colon
	else if c == "=" then
		result.type = MisMis.TokenType.OpAssign
	else if c == "<" then
		result.type = MisMis.TokenType.OpLesser
	else if c == ">" then
		result.type = MisMis.TokenType.OpGreater
	else if c == "@" then
		result.type = MisMis.TokenType.AddressOf
	else if c == ";" or c == char(10) then
		result.type = MisMis.TokenType.EOL
		if c == ";" then
			result.text = ";"
		else
			result.text = char(10)
		end if
		if c != ";" then self.lineNum = self.lineNum + 1
    end if
	if c == char(13) then
		result.type = MisMis.TokenType.EOL
		if self.position < self.inputLength and self.input[self.position] == char(10) then
			self.position = self.position + 1
			result.text = char(13) + char(10)
		else
			result.text = char(13)
		end if
		self.lineNum = self.lineNum + 1
	end if
    if result.type != MisMis.TokenType.Unknown then return result

	if c == "." then
		if self.position >= self.inputLength or not self.IsNumeric(self.input[self.position]) then
			result.type = MisMis.TokenType.Dot
			return result
		end if
	end if
	if c == "." or self.IsNumeric(c) then
		result.type = MisMis.TokenType.Number
		while self.position < self.inputLength
			lastc = c
			c = self.input[self.position]
			if self.IsNumeric(c) or c == "." or c == "E" or c == "e" or 
				((c == "-" or c == "+") and (lastc == "E" or lastc == "e")) then
				self.position = self.position + 1
			else
				break
			end if
		end while
	else if self.IsIdentifier(c) then
		while self.position < self.inputLength
			if self.IsIdentifier(self.input[self.position]) then
				self.position = self.position + 1
			else
				break
			end if
		end while
		result.text = self.input[startPos : self.position]
		if MisMis.Keywords.IsKeyword(result.text) then
			result.type = MisMis.TokenType.Keyword
		else
			result.type = MisMis.TokenType.Identifier
		end if
		if result.text == "end" then
			nextWord = self.Dequeue
			if nextWord isa MisMis.Exception then return nextWord
			if nextWord != null and nextWord.type == MisMis.TokenType.Keyword then
				result.text = ((result.text + " ") + nextWord.text)
			else
				return MisMis.Raise(MisMis.LexerException.__init__({"message": "'end' without following keyword ('if', 'function', etc.)"}))
			end if
		else if result.text == "else" then
			p = self.position
			while (p < self.inputLength and (self.input[p] == " " or self.input[p] == char(9)))
				p = p + 1
			end while
			if p + 1 < self.inputLength and self.input[p : (p + 2)] == "if" and ((p + 2) >= self.inputLength or not self.IsIdentifier(self.input[(p + 2)])) then
				result.text = "else if"
				self.position = p + 2
			end if
		end if
		return result
	else if c == """" then
		result.type = MisMis.TokenType.String
		haveDoubledQuotes = false
		startPos = self.position
		gotEndQuote = false
		while self.position < self.inputLength
			c = self.input[self.position]
			self.position = self.position + 1
			if c == """" then
				if self.position < self.inputLength and self.input[self.position] == """" then
					haveDoubledQuotes = true
					self.position = self.position + 1
				else
					gotEndQuote = true
					break
				end if
			else if c == char(10) or c == char(13) then
				break
			end if
		end while
		if not gotEndQuote then
			return MisMis.Raise(MisMis.LexerException.__init__({"message": "missing closing quote ("")"}))
		end if
		result.text = self.input[startPos : self.position-1]
		if haveDoubledQuotes then
			result.text = result.text.replace("""""", """")
		end if
		return result
	else
		result.type = MisMis.TokenType.Unknown
	end if
	result.text = self.input[startPos : self.position]
	return result
end function
MisMis.Lexer.SkipWhitespaceAndComment = function
	while (not self.AtEnd and self.IsWhitespace(self.input[self.position]))
		self.position = self.position + 1
	end while

	if self.position < (self.inputLength - 1) and self.input[self.position] == "/" and self.input[(self.position + 1)] == "/" then
		self.position = self.position + 2
		while (not self.AtEnd and 
			self.input[self.position] != char(10))
			self.position = self.position + 1
		end while
	end if
end function
MisMis.Lexer.IsNumeric = function(c)
	return "0" <= c <= "9"
end function
MisMis.Lexer.IsIdentifier = function(c)
	return (c == "_" or 
		"a" <= c <= "z" or 
		"A" <= c <= "Z" or 
		"0" <= c <= "9")
end function
MisMis.Lexer.IsWhitespace = function(c)
	return c == " " or c == char(9)
end function
MisMis.Lexer.IsAtWhitespace = function
	return self.AtEnd or self.IsWhitespace(self.input[self.position])
end function
MisMis.Lexer.IsInStringLiteral = function(charPos, source, startPos)
	inString = false
	for i in range(startPos, charPos-1)
		if source[i] == """" then
			inString = not inString
		end if
	end for
	return inString
end function
MisMis.Lexer.CommentStartPos = function(source, startPos)
	commentStart = startPos-2
	while true
		commentStart = source.indexOf("//", commentStart + 2)
		if commentStart == null then
			break
		end if
		if not MisMis.Lexer.IsInStringLiteral(commentStart, source, startPos) then
			break
		end if
	end while
	return commentStart
end function
MisMis.Lexer.LastIndexOf = function(s, value)
    for i in range(0, s.len - 1, 1)
		ret = s.indexOf(value, i)
		if ret != null then
			return ret
		end if
	end for
    return -1
end function
MisMis.Lexer.TrimComment = function(source)
	startPos = MisMis.Lexer.LastIndexOf(source, char(10)) + 1
	commentStart = MisMis.Lexer.CommentStartPos(source, startPos)
	if commentStart >= 0 then
		return source[startPos : commentStart]
	end if
	return source
end function
MisMis.Lexer.LastToken = function(source)
	startPos = MisMis.Lexer.LastIndexOf(source, char(10)) + 1
	commentStart = MisMis.Lexer.CommentStartPos(source, startPos)
	if commentStart >= 0 then
		endPos = commentStart - 1
	else
		endPos = source.len - 1
	end if
	while (endPos >= 0 and MisMis.Lexer.IsWhitespace(source[endPos]))
		endPos = endPos - 1
	end while
	if endPos < 0 then return MisMis.TokenType.EOL

	tokStart = endPos
	c = source[endPos]
	if MisMis.Lexer.IsIdentifier(c) then
		while tokStart > startPos and MisMis.Lexer.IsIdentifier(source[(tokStart - 1)])
			tokStart = tokStart - 1
		end while
	else if c == """" then
		inQuote = true
		while tokStart > startPos
			tokStart = tokStart - 1
			if source[tokStart] == """" then
				inQuote = not inQuote
				if not inQuote and tokStart > startPos and source[(tokStart - 1)] != """" then
					break
				end if
			end if
		end while
	else if c == "=" and tokStart > startPos then
		c2 = source[tokStart - 1]
		if c2 == ">" or c2 == "<" or c2 == "=" or c2 == "!" then tokStart = tokStart - 1
	end if
	lex = MisMis.Lexer.__init__(source)
	lex.position = tokStart
	return lex.Dequeue()
end function
MisMis.Lexer.Check = function(tok, type, text=null, line_num=null)
	if tok isa MisMis.Exception then return
	if line_num == null then line_num = 0
	MisMis.UnitTest.ErrorIfNull(tok)
	if tok == null then return
	MisMis.UnitTest.ErrorIf(tok.type != type, "Token type: expected " + type + ", but got " + tok.type)
	MisMis.UnitTest.ErrorIf(text != null and tok.text != text, "Token text: expected " + text + ", but got " + tok.text)
end function
MisMis.Lexer.CheckLineNum = function(actual, expected)
	MisMis.UnitTest.ErrorIf(actual != expected, "Lexer line number: expected " + expected + ", but got " + actual)
end function
MisMis.Lexer.RunUnitTests = function
	startTime = time
    lex = MisMis.Lexer.__init__("42 * 3.14158")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Number, "42")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 1)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.OpTimes)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Number, "3.14158")
	
    MisMis.UnitTest.ErrorIf(not lex.AtEnd, "AtEnd not set when it should be")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 1)

    lex = MisMis.Lexer.__init__("6*(.1-foo) end if // and a comment!")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Number, "6")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 1)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.OpTimes)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.LParen)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Number, ".1")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.OpMinus)
    MisMis.Lexer.Check(lex.Peek, MisMis.TokenType.Identifier, "foo")
	MisMis.Lexer.Check(lex.Peek, MisMis.TokenType.Identifier, "foo")
	MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Identifier, "foo")
	MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.RParen)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Keyword, "end if")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.EOL)
	MisMis.UnitTest.ErrorIf(not lex.AtEnd, "AtEnd not set when it should be")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 1)

    lex = MisMis.Lexer.__init__("""foo"" ""isn't """"real"""""" ""now """""""" double!""")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.String, "foo")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.String, "isn't ""real""")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.String, "now """" double!")
    MisMis.UnitTest.ErrorIf(not lex.AtEnd, "AtEnd not set when it should be")

    lex = MisMis.Lexer.__init__("foo" + char(10) + "bar" + char(13) + "baz" + char(13) + char(10) + "bamf")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Identifier, "foo")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 1)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.EOL)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Identifier, "bar")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 2)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.EOL)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Identifier, "baz")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 3)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.EOL)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Identifier, "bamf")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 4)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.EOL)
	MisMis.UnitTest.ErrorIf(not lex.AtEnd, "AtEnd not set when it should be")

    lex = MisMis.Lexer.__init__("x += 42")
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Identifier, "x")
    MisMis.Lexer.CheckLineNum(lex.lineNum, 1)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.OpAssignPlus)
    MisMis.Lexer.Check(lex.Dequeue, MisMis.TokenType.Number)
	MisMis.UnitTest.ErrorIf(not lex.AtEnd, "AtEnd not set when it should be")

    MisMis.Lexer.Check(MisMis.Lexer.LastToken("x=42 // foo"), MisMis.TokenType.Number, "42")
    MisMis.Lexer.Check(MisMis.Lexer.LastToken("x = [1, 2, // foo"), MisMis.TokenType.Comma)
    MisMis.Lexer.Check(MisMis.Lexer.LastToken("x = [1, 2 // foo"), MisMis.TokenType.Number, "2")
    MisMis.Lexer.Check(MisMis.Lexer.LastToken("x = [1, 2 // foo // and ""more"" foo"), MisMis.TokenType.Number, "2")
    MisMis.Lexer.Check(MisMis.Lexer.LastToken("x = [""foo"", ""//bar""]"), MisMis.TokenType.RSquare)
    MisMis.Lexer.Check(MisMis.Lexer.LastToken("print 1 // line 1" + char(10) + "print 2"), MisMis.TokenType.Number, "2")
    MisMis.Lexer.Check(MisMis.Lexer.LastToken("print ""Hi""""Quote"" // foo bar"), MisMis.TokenType.String, "Hi""Quote")
	MisMis.WriteLine("Lexer UnitTests finished in " + str(time - startTime) + " seconds.")
end function

MisMis.UnitTest.Run()