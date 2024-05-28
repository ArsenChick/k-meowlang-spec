module MEOWLANG-SYNTAX
    syntax MeowToken ::= "Meow" [token]
                       | "Miaou" [token]
                       | "喵" [token]
                       | "Miao" [token]

    syntax MeowTokens ::= List{MeowToken, ""}
    syntax MeowElement ::= MeowTokens ";"
    syntax MeowList ::= List{MeowElement, ""}
endmodule