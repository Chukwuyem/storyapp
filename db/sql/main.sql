
create table users (
	id serial not null
		constraint users_pkey
			primary key,
	username text not null
		constraint users_username_key
			unique,
--	firstname text,
--	middlename text,
--	lastname text,
	email text,
	password_hash text not null,
	created_at timestamptz DEFAULT now()
);

--id ***
--username
--email
--password_hash
--created_at ***

ALTER TABLE users OWNER TO postgres;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- >>>>> Creating Stories table and id generator

CREATE OR REPLACE FUNCTION base36_encode(IN digits bigint, IN min_width int = 0)
        RETURNS varchar AS $$
              DECLARE
            chars char[];
            ret varchar;
            val bigint;
          BEGIN
          chars := ARRAY['0','1','2','3','4','5','6','7','8','9'
            ,'a','b','c','d','e','f','g','h','i','j','k','l','m'
            ,'n','o','p','q','r','s','t','u','v','w','x','y','z'];
          val := digits;
          ret := '';
          IF val < 0 THEN
            val := val * -1;
          END IF;
          WHILE val != 0 LOOP
            ret := chars[(val % 36)+1] || ret;
            val := val / 36;
          END LOOP;
          IF min_width > 0 AND char_length(ret) < min_width THEN
            ret := lpad(ret, min_width, '0');
          END IF;
          RETURN ret;
      END;
      $$ LANGUAGE 'plpgsql' IMMUTABLE;

create sequence stories_stid_sequence
    START WITH 1
    INCREMENT BY 1
    NO minvalue
    NO maxvalue
    CACHE 1;

CREATE OR REPLACE FUNCTION generate_story_stid() RETURNS varchar AS $$
      DECLARE
          our_epoch bigint := 1472533855842;
          seq_id bigint;
          now_millis bigint;
          result bigint;
          ret varchar;
      BEGIN
          SELECT nextval('stories_stid_sequence') % 1024 INTO seq_id;

          SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
          result := (now_millis - our_epoch) << 10;
          result := result | (seq_id);
          ret := base36_encode(result);
          RETURN ret;
      END;
      $$ LANGUAGE PLPGSQL;

create table stories (
    stid varchar not null primary key,
    title text not null,
    description text,
    created_at timestamptz DEFAULT now()
    -- headpara integer not null REFERENCES paragraphs(prid),
    -- headpara is the id of the head (first) paragraph
    -- can't do headpara because one has to come first, story or para since both reference each other
);

ALTER TABLE stories OWNER TO postgres;


--CREATE SEQUENCE stories_stid_seq
--    START WITH 13
--    INCREMENT BY 1
--    NO minvalue
--    NO maxvalue
--    CACHE 1;
--ALTER TABLE stories_stid_seq OWNER TO postgres;
--ALTER SEQUENCE stories_stid_seq OWNED BY stories.stid;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- >>>> Creating Paragraphs table and ID generator

CREATE SEQUENCE para_prid_sequence
    START WITH 1
    INCREMENT BY 1
    NO minvalue
    NO maxvalue
    CACHE 1;

CREATE OR REPLACE FUNCTION generate_para_prid(OUT result bigint) AS $$
DECLARE
    our_epoch bigint := 1314220021721;
    seq_id bigint;
    now_millis bigint;
    -- the id of this DB shard, must be set for each
    -- schema shard you have - you could pass this as a parameter too
    shard_id int := 1;
BEGIN
    SELECT nextval('para_prid_sequence') % 1024 INTO seq_id;

    SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
    result := (now_millis - our_epoch) << 23;
    result := result | (shard_id << 10);
    result := result | (seq_id);
END;
$$ LANGUAGE PLPGSQL;

create table paragraphs (
    prid bigint not null primary key,
    story varchar not null REFERENCES stories(stid),
    head boolean not null,
    maintext text,
    writer text not null REFERENCES users(username),
    parentpr integer,
    childpr integer,
    created_at timestamptz DEFAULT now()
);

ALTER TABLE paragraphs OWNER TO postgres;

--CREATE SEQUENCE para_prid_seq
--    START WITH 103
--    INCREMENT BY 1
--    NO minvalue
--    NO maxvalue
--    CACHE 1;
--ALTER TABLE para_prid_seq OWNER TO postgres;
--ALTER SEQUENCE para_prid_seq OWNED BY paragraphs.prid;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- ALTER TABLE stories ADD COLUMN headpara bigint;

INSERT INTO users (username, email, password_hash) VALUES ('testUser1', 'a@b.c',
'$2a$06$9h.3BD7pqZMPubkvoH5Ju.sZeum1aF4nhlqjkx.kmO0iF2bTzez2G');
-- PASSWORD: testpassword

INSERT INTO users (username, email, password_hash) VALUES ('testUser2', 'user@email.com',
'$2a$06$ri8U7FIT9qtKtT6TB.BO3.73FNDW7RDI5249g8pNyr8zrSeA.1OdO');
-- PASSWORD: testpassword2

-- command below will set primary key sequence of users table back to sync when mass import of users in done
-- this is for when id is serial integer 
SELECT setval('users_id_seq'::regclass, (SELECT MAX(id) FROM users)+1);