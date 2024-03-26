-------------------------------- MODULE model --------------------------------
EXTENDS Integers, Naturals, Sequences, TLC

CONSTANT Proc1, Proc2, Input_priority, Max_ready

(*--algorithm tlaLab_algorithm {
    \* advancedStates = <<"suspended", "ready", "running", "waiting">> 
    \* baseStates = <<"suspended", "ready", "running">>, 

    variable ready = 0, 
             run = 0, 
             states = [i \in 1..Len(Input_priority) |-> "suspended"],
             \*lastStep = "start", 
             prioritys = [i \in 0..3 |-> <<>>]
    
    process (baseTask \in 1..Proc2)
    {
        baseLoop:
            while (TRUE) {
               
            }
    }
    
    process (advancedTask \in (Proc2 + 1)..(Len(Input_priority)))
    {
        advancedLoop:
            while (TRUE) {
               
            }
    }
}
*)
=============================================================================
\* Modification History
\* Last modified Wed Mar 27 02:29:45 MSK 2024 by adeli
\* Created Tue Mar 26 12:46:05 MSK 2024 by adeli
