-- Insert data into publication. (From temppublication)
INSERT INTO publication(id, title, month, year, no_authors, decade) (
  SELECT DISTINCT
    tp.id, tp.title, tp.month, tp.year, tp.no_authors, tp.decade  
  FROM temppublication as tp
);

-- Insert data into author. (tempfield)
INSERT INTO author(id, family_name, given_name) (
  SELECT DISTINCT
    --replace(tf.value, '/', ' '),
    tf.value,
    split_part(tf.value, '/', 2),
    split_part(tf.value, '/', 1)
  FROM tempfield as tf
  WHERE tf.fieldname = 'author'
);

-- Insert data into authored
INSERT INTO link_publ_auth(auth_id, publ_id) (
  SELECT DISTINCT
    a.id,
    p.id
  FROM author as a, publication as p, tempfield as tf
  WHERE tf.fieldname = 'author' AND tf.value = a.id AND tf.pubkey = p.id
);

-- Insert data into journal
INSERT INTO journal(code, title, year, month) (
  SELECT DISTINCT
    split_part(tp.id, '/', 2),
    tf.value,
    tp.year,
    tp.month
  FROM temppublication as tp, tempfield as tf
  WHERE tp.id = tf.pubkey AND tp.pubtype = 'article' AND tf.fieldname = 'journal'
);

-- Insert data into conference
INSERT INTO conference(code, title, year, month) (
  SELECT DISTINCT
    split_part(tp.id, '/', 2),
    tf.value,
    tp.year,
    tp.month
  FROM temppublication as tp, tempfield as tf
  WHERE tp.id = tf.pubkey AND tp.pubtype = 'inproceedings' AND tf.fieldname = 'crossref'
);

-- Insert data into article   // PROBLEM HERE
INSERT INTO article(id, journal_id) (
  SELECT DISTINCT
    tp.id,
    j.id
  FROM temppublication as tp, journal as j
  WHERE j.code = tp.code AND j.month = tp.month AND j.year = tp.year
);

-- Insert data into inproceedings
INSERT INTO inproceedings(id, conf_id) (
  SELECT DISTINCT
    p.id,
    c.id
  FROM publication as p, conference as c
  WHERE c.code = split_part(p.id, '/', 2) AND c.month = p.month AND c.year = p.year
);


