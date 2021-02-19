
--name: insert-doc!
insert into documents (doc_id, content) values(:doc_id, :content);

--name: insert-term!
insert into terms (term_name, parent_doc) 
	values (:term_name, :parent_doc);

--name: insert-citation!
insert into citations (doc_id, term_id) 
	values (:child_doc, :term_id);

--name: term-exists$
select count(*) 
from terms 
where term_name is :term_name;

--name: term-parent^
select doc_parent from terms where term_name is :term_name

--name: term-id$
select term_id from terms where term_name is :term_name limit 1

--name: get-graph
select parent_doc, child_doc from document_graph;