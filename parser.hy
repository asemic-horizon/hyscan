(import re aiosql sqlite3
        [networkx :as nx])        


(setv 
     
  db (aiosql.from_path "prisoner_ops.sql" "sqlite3"))

(defn match-definitions [text]
 (re.findall r"\[([^\[\]]*)\]" text))

(defn match-references [text]
 (re.findall r"{([^\{}]*)}" text))

(defn run-text [fun]
  (fn [txt] (dfor [i par] (enumerate txt) 
              [i (flatten (fun (.lower par)))])))

(defn insert-docs [conn txt keying] 
 (for [[i t] (enumerate txt)]
      (db.insert-doc conn :doc-id (keying txt i) :content t)))
 
(defn insert-defs [conn txt keying]
 (setv defs ((run-text match-definitions) txt))
 (for [k defs]
  (for [v (get defs k)]  1
   (db.insert-term conn :term_name v :parent-doc (keying txt k)))))
 
(defn insert-refs [conn txt keying]
 (setv defs ((run-text match-references) txt))
 (for [k defs]
  (for [v (get defs k)] 
    (db.term-id conn v) 
   (db.insert-citation conn 
     :term_id (db.term-id conn v)
     :child-doc (keying txt k)))))
 
(defn commit-text [txt keying]
 (with [conn (sqlite3.connect "dbfile.sqlite")]
   (insert-docs conn  txt keying)
   (insert-defs conn  txt keying)
   (insert-refs conn  txt keying))) 

(defn get-graph [txt]
 (with [conn (sqlite3.connect "dbfile.sqlite")]
   (db.get-graph conn)))

(defmain []
 (setv txt 
   (lfor line (.readlines (open "test_text.txt" "r")) (.strip line)))
 (commit-text txt (fn [t k] k))
 (setv ys 
  (nx.topological-sort (nx.DiGraph (get-graph txt))))
 (for [y ys]
  (do (print (get txt y))
      (print))))      