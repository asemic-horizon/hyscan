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

create view undefined_terms as
  select
    term_id
  from
    terms
  where
    parent_doc = -1;

-- create view sterile_terms as
--   select
--     term_id
--   from
--     terms
--   left join 
--     citations on citations.term_id = terms.term_id
--   where
--     citations.term_id is NULL

create view orphaned_documents as
  select
    doc_id
  from
    citations
  left join
    terms on terms.term_id = citations.term_id
  where
    terms.parent_doc = -1;


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
--   Informally: a document d is a "child doc" of a term t 
--if there is a reference with doc_id = d, term_id = t.

-- Equivalently t is the "parent term" of d if 
-- it's in the result set of
--  `select doc_id from references where term_id = t"

-- And a document d is a parent doc of a term t if 
--it's in the result set of `select parent_doc from terms if terms = t`. 

-- Finally: a document d is the parent of a document d' if
-- there are terms t,t',... that are parents of d'. 

