CREATE OR REPLACE FUNCTION add_article_inproceedings()
  RETURNS trigger AS
$$
BEGIN
    IF NEW.pubtype = 'article' THEN
    INSERT INTO article(akey, mdate, year, title, journal_code) 
    VALUES (NEW.pubkey, NEW.mdate, NEW.year, NEW.title, 
      split_part(NEW.pubkey, '/', 2));

    ELSIF NEW.pubtype = 'inproceedings' THEN
    INSERT INTO inproceedings(ikey, mdate, year, title, conf_code, decade)
    VALUES (NEW.pubkey, NEW.pubtype, NEW.mdate, NEW.year, NEW.title, 
      split_part(NEW.pubkey, '/', 2),
      EXTRACT(DECADE FROM NEW.mdate));
    END IF;

    RETURN NEW;
END;
$$ 
LANGUAGE 'plpgsql';

-- DROP TRIGGER IF EXISTS auto_add_article_inproceedings ON publication;

CREATE TRIGGER auto_add_article_inproceedings
  AFTER INSERT ON publication
  FOR EACH ROW
  EXECUTE PROCEDURE add_article_inproceedings();