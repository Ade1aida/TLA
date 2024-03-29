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
    
    process (baseTask \in 0..Proc2)
    {
        baseLoop:
            while (TRUE) {
            
                print <<Input_priority[self]>>;
               
            }
    }
    
    process (advancedTask \in 0..Proc1)
    {
        advancedLoop:
            while (TRUE) {
               print <<Input_priority[self]>>;
            }
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "94526e5d" /\ chksum(tla) = "3fafc49b")
VARIABLES ready, run, states, prioritys

vars == << ready, run, states, prioritys >>

ProcSet == (0..Proc2) \cup (0..Proc1)

Init == (* Global variables *)
        /\ ready = 0
        /\ run = 0
        /\ states = [i \in 1..Len(Input_priority) |-> "suspended"]
        /\ prioritys = [i \in 0..3 |-> <<>>]

baseTask(self) == /\ PrintT(<<Input_priority[self]>>)
                  /\ UNCHANGED << ready, run, states, prioritys >>

advancedTask(self) == /\ PrintT(<<Input_priority[self]>>)
                      /\ UNCHANGED << ready, run, states, prioritys >>

Next == (\E self \in 0..Proc2: baseTask(self))
           \/ (\E self \in 0..Proc1: advancedTask(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 
=============================================================================
\* Modification History
\* Last modified Fri Mar 29 15:10:07 MSK 2024 by adeli
\* Created Tue Mar 26 12:46:05 MSK 2024 by adeli
