-------------------------------- MODULE model --------------------------------
EXTENDS Integers, Naturals, Sequences, TLC

CONSTANT Input_type, Input_priority, Max_ready

Make_tasks(type, prior, status) == [type |-> type, prior |-> prior, status|-> status]

(*--algorithm model {
    \* advancedStates = <<"suspended", "ready", "running", "waiting">> 
    \* baseStates = <<"suspended", "ready", "running">>, 

    variable ready = 0, 
             runProcess = 0, 
             run = 0, 
             prioritys = [i \in 0..3 |-> <<>>],
             tasks = [i \in 1..Len(Input_priority) |-> Make_tasks(Input_type[i], Input_priority[i],"suspended")]
    
    process (planing_base_task \in 1..Len(Input_priority))
    {
         plan_loop_B:
             while (TRUE) {
                either {
                    \* activate
                    await /\ tasks[self].status = "suspended" 
                          /\ tasks[self].type = "B"
                          /\ ready < Max_ready;
                          
                    prioritys[tasks[self].prior] := Append(prioritys[tasks[self].prior], self);
                    tasks[self].status  := "ready";
                    ready := ready + 1;
                }
                or {          
                    \* start
                    await /\ tasks[self].status = "ready"
                          /\ run < 1
                          /\ tasks[self].type = "B"
                          /\ Head(prioritys[tasks[self].prior]) = self
                          /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0;
                    
                    tasks[self].status := "running";
                    
                    prioritys[tasks[self].prior] := Tail(prioritys[tasks[self].prior]);
                    ready := ready - 1;
                    run := run+1;
                    runProcess := self
                }
                or {              
                    \* terminate
                    await /\ tasks[self].status = "running"
                          /\ tasks[self].type = "B"
                          /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0;
                    
                    tasks[self].status := "suspended";
                    run :=  run-1;
                    runProcess := 0;
                }
                or {
                    \* preempt
                    await /\ tasks[self].status = "ready"
                          /\ Head(prioritys[tasks[self].prior]) = self
                          /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0
                          /\ tasks[self].type = "B"
                          /\ runProcess # 0
                          /\ run # 0 
                          /\ tasks[runProcess].prior < tasks[self].prior;
                    
                    prioritys[tasks[runProcess].prior] := Append(prioritys[tasks[runProcess].prior], runProcess) ||
                    prioritys[tasks[self].prior] := Tail(prioritys[tasks[self].prior]);
                    tasks[runProcess].status := "ready" ||
                    tasks[self].status := "running";
                    runProcess := self;
                }       
             \*print <<tasks[self]>>; 
             }
     }
}

process (planing_advanced_task \in 1..Len(Input_priority))
    {
         plan_loop_A:
             while (TRUE) {
                either {
                    \* activate
                    await /\ tasks[self].status = "suspended" 
                          /\ tasks[self].type = "A"
                          /\ ready < Max_ready;
                          
                    prioritys[tasks[self].prior] := Append(prioritys[tasks[self].prior], self);
                    tasks[self].status  := "ready";
                    ready := ready + 1;
                }
                or {          
                    \* start
                    await /\ tasks[self].status = "ready"
                          /\ tasks[self].type = "A"
                          /\ run < 1
                          /\ Head(prioritys[tasks[self].prior]) = self
                          /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0;
                    
                    tasks[self].status := "running";
                    
                    prioritys[tasks[self].prior] := Tail(prioritys[tasks[self].prior]);
                    ready := ready - 1;
                    run := run+1;
                    runProcess := self
                }
                or {              
                    \* terminate
                    await /\ tasks[self].status = "running"
                          /\ tasks[self].type = "A"
                          /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0;
                    
                    tasks[self].status := "suspended";
                    run :=  run-1;
                    runProcess := 0;
                }
                or {
                    \* preempt
                    await /\ tasks[self].status = "ready"
                          /\ Head(prioritys[tasks[self].prior]) = self
                          /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0
                          /\ tasks[self].type = "A"
                          /\ runProcess # 0
                          /\ run # 0 
                          /\ tasks[runProcess].prior < tasks[self].prior;
                    
                    prioritys[tasks[runProcess].prior] := Append(prioritys[tasks[runProcess].prior], runProcess) ||
                    prioritys[tasks[self].prior] := Tail(prioritys[tasks[self].prior]);
                    tasks[runProcess].status := "ready" ||
                    tasks[self].status := "running";
                    runProcess := self;
                }
                or {
                    \* wait
                    await /\ tasks[self].status= "running"
                          /\ tasks[self].type = "A"
                          /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0;
                    
                    tasks[self].status := "waiting";
                    run := run - 1;
                    runProcess := 0;
                }
                or {
                    \* release
                    await /\ tasks[self].status = "waiting"
                          /\ tasks[self].type = "A"
                          /\ ready < Max_ready;
                   prioritys[tasks[self].prior] := Append(prioritys[tasks[self].prior], self);
                   tasks[self].status := "ready";
                   ready := ready + 1;
                }           
             \*print <<tasks[self]>>; 
             }
     }
}

*)
\* BEGIN TRANSLATION (chksum(pcal) = "c7a06f8a" /\ chksum(tla) = "ececd7bc")
VARIABLES ready, runProcess, run, prioritys, tasks

vars == << ready, runProcess, run, prioritys, tasks >>

ProcSet == (1..Len(Input_priority))

Init == (* Global variables *)
        /\ ready = 0
        /\ runProcess = 0
        /\ run = 0
        /\ prioritys = [i \in 0..3 |-> <<>>]
        /\ tasks = [i \in 1..Len(Input_priority) |-> Make_tasks(Input_type[i], Input_priority[i],"suspended")]

planing_base_task(self) == \/ /\ /\ tasks[self].status = "suspended"
                                 /\ tasks[self].type = "B"
                                 /\ ready < Max_ready
                              /\ prioritys' = [prioritys EXCEPT ![tasks[self].prior] = Append(prioritys[tasks[self].prior], self)]
                              /\ tasks' = [tasks EXCEPT ![self].status = "ready"]
                              /\ ready' = ready + 1
                              /\ UNCHANGED <<runProcess, run>>
                           \/ /\ /\ tasks[self].status = "ready"
                                 /\ run < 1
                                 /\ tasks[self].type = "B"
                                 /\ Head(prioritys[tasks[self].prior]) = self
                                 /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0
                              /\ tasks' = [tasks EXCEPT ![self].status = "running"]
                              /\ prioritys' = [prioritys EXCEPT ![tasks'[self].prior] = Tail(prioritys[tasks'[self].prior])]
                              /\ ready' = ready - 1
                              /\ run' = run+1
                              /\ runProcess' = self
                           \/ /\ /\ tasks[self].status = "running"
                                 /\ tasks[self].type = "B"
                                 /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0
                              /\ tasks' = [tasks EXCEPT ![self].status = "suspended"]
                              /\ run' = run-1
                              /\ runProcess' = 0
                              /\ UNCHANGED <<ready, prioritys>>
                           \/ /\ /\ tasks[self].status = "ready"
                                 /\ Head(prioritys[tasks[self].prior]) = self
                                 /\ \A j \in (tasks[self].prior + 1)..3 : Len(prioritys[j]) = 0
                                 /\ tasks[self].type = "B"
                                 /\ runProcess # 0
                                 /\ run # 0
                                 /\ tasks[runProcess].prior < tasks[self].prior
                              /\ prioritys' = [prioritys EXCEPT ![tasks[runProcess].prior] = Append(prioritys[tasks[runProcess].prior], runProcess),
                                                                ![tasks[self].prior] = Tail(prioritys[tasks[self].prior])]
                              /\ tasks' = [tasks EXCEPT ![runProcess].status = "ready",
                                                        ![self].status = "running"]
                              /\ runProcess' = self
                              /\ UNCHANGED <<ready, run>>

Next == (\E self \in 1..Len(Input_priority): planing_base_task(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 01 04:06:19 MSK 2024 by adeli
\* Created Tue Mar 26 12:46:05 MSK 2024 by adeli
