# Stack & Heap Based Virtual Machine

reference count table

$1: number

$'s: string 's'

&a: adress

Imm: opcode

---

**value instructions:**

Noop

Imm $b: allocate memory space for $b and push it into stack

Free &b: mark address &b is usable

Func &b: (bind b to the line as a function)

Assign &a &b

AssignImp &a

New &b

ElemOf &m &k

**arithmetic instructions**:

Plus &x &y

Minus &x &y

Times &x &y

Div &x &y

Mod &x &y

Pow &x &y

Len &b

**Boolean instructions**:

Eq &b

Neq &b

Geq &b

Leq &b

Gt &b

Lt &b

Not &b

Isa &b

**control instructions**:

Goto $a

GotoIf $a

GotoIfNot $a

**call instructions**:

Push &a

Pop

Call $n $a (call function with n args from stack)

CallI (call intrinsic function)

Return (Back to previous goto)

&a List $n (make list with n addresses from stack and save to &a)

Pair &k &v (push {k: v} pair in stack)

&a map $n (make list with n pairs from stack and save to &a)


# register based vm (legacy)

a = 1
b = 1 + a

mov &a $1
addi &a $1

%0: return value

$1: number

$'s: string

&a: adress

%0: register

Assign &a $1

---

Modified from Miniscript Instructions

Immediate value: $a

Address(holds truly miniscript type in runtime): &a

Opcode: @op
