create table documents (
  doc_id integer primary key,
  content text
);


create table terms (
  term_id integer primary key,
  term_name text,
  parent_doc integer,
  foreign key (parent_doc) references documents (doc_id)
  );
  
create table citations (
  ref_id integer primary key,
  doc_id integer,
  term_id integer,
  foreign key (doc_id) references documents (doc_id),
  foreign key (term_id) references terms (term_id)
  );

create view document_graph as 
  select 
    parent.doc_id as parent_doc,
    child.doc_id as child_doc
  from 
    documents as child
  left join 
    citations on citations.doc_id = child.doc_id
  left join
    terms on terms.term_id = citations.term_id
  left join
    documents as parent on parent.doc_id = terms.parent_doc
  where parent.doc_id!= -1;


