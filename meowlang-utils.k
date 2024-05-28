requires "meowlang-syntax.k"

module MEOWLANG-UTILS

    imports MEOWLANG-SYNTAX
    imports STRING-BUFFER
    imports INT
    
    syntax Int ::= getMeowListSize(MeowList) [function]
                 | getMeowElementSize(MeowElement) [function]

    syntax String ::= getCatEmojiString(Int) [function]


    rule getMeowElementSize(.MeowTokens ;) => 0
    rule getMeowElementSize(_:MeowToken MT:MeowTokens ;) => 1 +Int getMeowElementSize(MT ;)

    rule getMeowListSize(.MeowList) =>  0
    rule getMeowListSize(_:MeowElement ML:MeowList) =>  1 +Int getMeowListSize(ML)

    rule getCatEmojiString(0) => ""
    rule getCatEmojiString(I:Int) => StringBuffer2String(
        (.StringBuffer +String "🐈") +String getCatEmojiString(I -Int 1)) [owise]

endmodule