requires "meowlang-syntax.k"
requires "meowlang-utils.k"
requires "domains.md"

module MEOWLANG-1-SYNTAX
    imports MEOWLANG-SYNTAX
endmodule

module MEOWLANG-1
    imports MEOWLANG-1-SYNTAX
    imports MEOWLANG-UTILS
    
    imports STRING-BUFFER
    imports K-EQUAL
    imports BOOL
    imports LIST
    imports INT

    configuration
        <T>
            <k> $PGM:MeowList </k>
            <state>
                <ip> 0 </ip>
                <meowlist> .List </meowlist>
                <output> "" </output>
            </state>
        </T>

    //-------------------------------------------------------------------------

    rule <k> ME:MeowElement ML:MeowList => ME ~> ML ...</k>
    rule <k> ME:MeowElement => .K ...</k>
         <meowlist>... .List => ListItem(getMeowElementSize(ME)) </meowlist>
    
    //-------------------------------------------------------------------------

    rule <k> .MeowList => .K ...</k>
         <ip> I:Int </ip>
         <meowlist> ML:List </meowlist>

        requires I >=Int size(ML) [priority(51)]

    //-------------------------------------------------------------------------

    // RET: Print an empty line to the output console.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 1 </ip>
         <meowlist> ML:List </meowlist>
         <output> S:String => S +String "\x0a" </output>
        
        requires {ML[I]}:>Int ==Int 0 [priority(52)]

    // MEOW: Print T cat emoji characters to the output console.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 1 </ip>
         <meowlist> ML:List </meowlist>
         <output> S:String => S +String
            getCatEmojiString({ML[-1]}:>Int) </output>
        
        requires {ML[I]}:>Int ==Int 1 [priority(52)]
    
    // PUSH: Push N to the tail of the Meow List.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 2 </ip>
         <meowlist> ML:List => ML ListItem(ML[I +Int 1]) </meowlist>
        
        requires {ML[I]}:>Int ==Int 2 [priority(52)]

    // POP: Pop the tail element from the Meow List.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 1 </ip>
         <meowlist> ML:List => range(ML, 0, 1) </meowlist>
        
        requires {ML[I]}:>Int ==Int 3 [priority(52)]

    // LOAD: Push the value of E(N) to the tail of the Meow List.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 2 </ip>
         <meowlist> ML:List =>
            ML ListItem(ML[{ML[I +Int 1]}:>Int]) </meowlist>
        
        requires {ML[I]}:>Int ==Int 4 [priority(52)]

    // SAVE: Copy the value of the tail element to E(N)

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 2 </ip>
         <meowlist> ML:List =>
            ML[{ML[I +Int 1]}:>Int <- ML[-1]] </meowlist>
        
        requires {ML[I]}:>Int ==Int 5 [priority(52)]
    
    // ADD: Add the values of the last two tail elements,
    // pop them from the tail, then push the result to the tail.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 1 </ip>
         <meowlist> ML:List => range(ML, 0, 2) 
            ListItem({ML[-1]}:>Int +Int {ML[-2]}:>Int)</meowlist>
        
        requires {ML[I]}:>Int ==Int 6 [priority(52)]

    // SUB: Subtract the value of the last element from the value of the
    // second to the last element, pop the last two elements from the tail,
    // then push the result to the tail. If the result is negative,
    // a zero is pushed.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 1 </ip>
         <meowlist> ML:List =>
            #if ({ML[-2]}:>Int -Int {ML[-1]}:>Int) >=Int 0
                #then range(ML, 0, 2) 
                    ListItem({ML[-2]}:>Int -Int {ML[-1]}:>Int)
                #else range(ML, 0, 2) ListItem(0)
            #fi </meowlist>
        
        requires {ML[I]}:>Int ==Int 7 [priority(52)]

    // JMP: Set IP to N.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => {ML[I +Int 1]}:>Int </ip>
         <meowlist> ML:List </meowlist>
        
        requires {ML[I]}:>Int ==Int 8 [priority(52)]

    // JE: If the value of the tail element is zero, set IP to N. Otherwise,
    // continue to execute the next after the next instruction.

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int =>
            #if ({ML[-1]}:>Int ==Int 0)
                #then {ML[I +Int 1]}:>Int
                #else I +Int 2
            #fi </ip>
         <meowlist> ML:List </meowlist>
        
        requires {ML[I]}:>Int ==Int 9 [priority(52)]

    // NOP: No operation

    rule <k> .MeowList ~> .K </k>
         <ip> I:Int => I +Int 1</ip>
         <meowlist> ML:List </meowlist>
        
        requires {ML[I]}:>Int >=Int 10 [priority(52)]

endmodule