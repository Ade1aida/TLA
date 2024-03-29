-------------------------------- MODULE model --------------------------------
EXTENDS Integers, Naturals, Sequences, TLC

CONSTANT Bace_proc, Advanced_proc, Input_priority, Max_ready

(*--algorithm tlaLab_algorithm {
    \* advancedStates = <<"suspended", "ready", "running", "waiting">> 
    \* baseStates = <<"suspended", "ready", "running">>, 

    variable ready = 0, 
             run = 0, 
             states = [i \in 1..Len(Input_priority) |-> "suspended"], 
             prioritys = [i \in 0..3 |-> <<>>]
    
    process (base_task \in 1..Len(Bace_proc))
    {
        base_loop:
            while (TRUE) {
                either {
            
                }
                \*print <<Input_priority[Bace_proc[self]]>>;   
            }
    }
    
    process (advanced_task \in 1..Len(Advanced_proc))
    {
        advanced_loop:
            while (TRUE) {
                either {
            
                }            
               \*print <<Input_priority[Advanced_proc1[self]]>>;
            }
    }
}
*)
=============================================================================
\* Modification History
\* Last modified Fri Mar 29 15:20:16 MSK 2024 by adeli
\* Created Tue Mar 26 12:46:05 MSK 2024 by adeli
