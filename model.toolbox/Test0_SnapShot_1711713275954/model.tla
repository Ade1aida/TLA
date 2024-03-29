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
    
    process (baseTask \in Proc2[0]..Proc2[Len(Proc2)])
    {
        baseLoop:
            while (TRUE) {
            
                print(Input_priority[self]);
               
            }
    }
    
    process (advancedTask \in Proc1[0]..Proc1[Len(Proc1)])
    {
        advancedLoop:
            while (TRUE) {
               print(Input_priority[self]);
            }
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "1ed406d5" /\ chksum(tla) = "6e606906")
VARIABLES ready, run, states, prioritys

vars == << ready, run, states, prioritys >>

ProcSet == (Proc2[0]..Proc2[Len(Proc2)]) \cup (Proc1[0]..Proc1[Len(Proc1)])

Init == (* Global variables *)
        /\ ready = 0
        /\ run = 0
        /\ states = [i \in 1..Len(Input_priority) |-> "suspended"]
        /\ prioritys = [i \in 0..3 |-> <<>>]

baseTask(self) == /\ PrintT((Input_priority[self]))
                  /\ UNCHANGED << ready, run, states, prioritys >>

advancedTask(self) == /\ PrintT((Input_priority[self]))
                      /\ UNCHANGED << ready, run, states, prioritys >>

Next == (\E self \in Proc2[0]..Proc2[Len(Proc2)]: baseTask(self))
           \/ (\E self \in Proc1[0]..Proc1[Len(Proc1)]: advancedTask(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 
=============================================================================
\* Modification History
\* Last modified Fri Mar 29 14:53:10 MSK 2024 by adeli
\* Created Tue Mar 26 12:46:05 MSK 2024 by adeli
