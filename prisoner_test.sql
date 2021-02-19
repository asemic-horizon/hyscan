.header on
.mode column

insert into documents (doc_id, content) 
	values (1,"hey");
insert into documents (doc_id, content) 
	values (2,"hi");
insert into documents (doc_id, content) 
	values (3,"ha");
insert into terms (term_id, term_name, parent_doc) 
	values (1,"i", 2);
insert into terms (term_id, term_name, parent_doc) 
	values (2,"a", );
insert into citations (doc_id, term_id) 
	values (1,1);
insert into citations (doc_id, term_id) 
	values (3,2);
select * from document_graph;
