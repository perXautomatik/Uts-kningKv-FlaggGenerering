select recTillsynsobjektID,
       cast(eq2 as int)+cast(eq3 as int) as fel,
       strVatten,
       _Vatten_,
       intByggnadsaar,
       flikAvloppsanläggnByggnadsår
from MittVsEdpAvlopsAnl