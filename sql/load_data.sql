-- Insert data into publication. (From temppublication)
INSERT INTO publication(id, title, month, year, no_authors, decade) (
  SELECT DISTINCT
    tp.id, tp.title, tp.month, tp.year, tp.no_authors, tp.decade
  FROM temppublication as tp
);

-- Insert data into author.
INSERT INTO author(name, pubkey) (
  SELECT DISTINCT
    tf.value,
    tf.pubkey
  FROM tempfield as tf
  WHERE tf.fieldname = 'author'
);

-- Insert data into authored
INSERT INTO authored(authid, authname, pubkey) (
  SELECT DISTINCT
    a.authid,
    a.name,
    p.pubkey
  FROM author as a, publication as p, tempfield as tf
  WHERE tf.fieldname = 'author' AND tf.value = a.name AND tf.pubkey = p.pubkey
);

-- Insert data into conference
INSERT INTO conference(conf_code, publisher, title, year, month) (
  SELECT DISTINCT
    split_part(tp.pubkey, '/', 2),
    tf1.value,
    tf2.value,
    EXTRACT(YEAR FROM tp.mdate),
    EXTRACT(MONTH FROM tp.mdate)
  FROM temppublication as tp, tempfield as tf1, tempfield as tf2
  WHERE tp.pubkey = tf1.pubkey AND tf1.fieldname = 'publisher' AND 
        tp.pubkey = tf2.pubkey AND tf2.fieldname = 'title' AND
        tp.pubtype = 'proceedings'
);

-- Insert data into journal
INSERT INTO journal(journal_code, title, year, month) (
  SELECT DISTINCT
    split_part(p.pubkey, '/', 2),
    tf.value,
    p.year,
    EXTRACT(MONTH FROM p.mdate)
  FROM publication as p, tempfield as tf
  WHERE p.pubkey = tf.pubkey AND tf.fieldname = 'journal'
);


