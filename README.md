# hyscan
Natural language document compiler

The general goals of this project are as follows.

Let `S` be a SOURCE of natural language material that can be split into PARTS `p_1, p_2,...` (currently I'm using paragraphs as parts). Let `T` be a set of terms `t_1, t_2, ...`. 

Assume (realistic cases will have exceptions that will be dealt with gradually) every term `t_i` is DEFINED in a specific part `p_j`. Name the set of terms defined in `p_j` as `def(p_j)`.  

Assume further that this term is REFERENCED in multiple other parts, i.e. `ref(t_i)={p_k,p_{k+1},...}`. 

Then every part `p_i` has CHILDREN, namely `children(p_i) = {p_j s.t. p_j ∈ ref(t_i) for some t_i ∈def(p_j)}`. This defines a DIGRAPH: a set of textparts and a set of ordered parts of textparts. 

Some digraphs are acyclic, meaning no textpart is its own child. In these cases, it's possible to obtain a TOPOLOGICAL ORDERING of textparts, meaning a plain ordered list of textparts where every parent happens before its children (but not always immediately before). 

In this way we can obtain text whose understanding depends on several technical terms, in such a way that we're assured that no technical term will be referenced without having been defined before. Paragraphs are marked-up as follows:


```

[Zork]s are useful in zorchanic {chemistry}.

This is a paragraph defining what a {zork}. A {zork} is a flabbusted [mork].

A {mork} is a levitating fork.

```

where the brackets mean `{definition}`, `[reference]`. The text above is reordered to:


```
A {mork} is a levitating fork.

This is a paragraph defining what a {zork}. A {zork} is a flabbusted [mork].

[Zork]s are useful in zorchanic chemistry.

```

This technique is used widely in application installers.

Note that we have a problem if the paragraph on morks read instead


```
The study of {mork}s has always defied [chemistry].
```

Then there's a dependency chain chemistry -> zork -> mork -> chemistry which has no topological ordering -- a dependency ambiguity. In this case, we break ties by assuming text that came before in the original source must have precedence in case of cycles. Then in this example we would never define morks before zorks; `chemistry` would become a hanging definition.

--- 

Work to do:

So far this is classical topological sorting; I've succesfully used for some of my own writings. But the two following questions are outstanding:

[ ] Is original source priority always sufficient to break ties? (I haven't proven this, and it's actually easier to prove the opposite, just come with a counterexample)

[ ] Can the topological sort algorithm be modified to try to bring hanging definitions closer to their forthcoming definitions? (It probably can't; we'd need to redefine the problem in terms of a walk on a weighted graph).

