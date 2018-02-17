
DELETE FROM paragraphs; -- delete this first because you can't delete stories if these still exist
DELETE FROM stories;

-- INSERT INTO stories (stid, title) VALUES (nextval('stories_stid_seq'), 'hanging stranger');

DO $$
-- DO block required due to story_stid01 variable. can't declare global variable in postgres
DECLARE
    story_stid01 varchar;
BEGIN
    INSERT INTO stories (stid, title) VALUES (generate_story_stid(), 'hanging stranger') RETURNING stid INTO story_stid01;


    INSERT INTO paragraphs (prid, story, head, maintext, writer) VALUES (generate_para_prid(), story_stid01,
    TRUE, 'At five o''clock Ed Loyce washed up, tossed on his hat and coat, got his car out and headed across town toward
     his TV sales store. He was tired. His back and shoulders ached from digging dirt out of the basement and wheeling it into
     the back yard. But for a forty-year-old man he had done okay. Janet could get a new vase with the money he had saved;
     and he liked the idea of repairing the foundations himself.\nIt was getting dark. The setting sun cast long rays over
     the scurrying commuters, tired and grim-faced, women loaded down
    with bundles and packages, students, swarming home from the university, mixing with clerks and businessmen and drab secretaries.
    He stopped his Packard for a red light and then started it up again. The store had been open without him; he''d arrive just in time
    to spell the help for dinner, go over the records of the day, maybe even close a couple of sales himself. He drove slowly
    past the small square of green in the center of the street, the town park. There were no parking places in front of LOYCE
    TV SALES AND SERVICE. He cursed under his breath and swung the car in a U-turn. Again he passed the little square of green
    with its lonely drinking fountain and bench and single lamppost.', 'testUser1');
END $$;

--INSERT INTO stories (stid, title) VALUES (nextval('stories_stid_seq'), 'the trials of jericho');
--
--INSERT INTO stories (stid, title) VALUES (nextval('stories_stid_seq'), 'the birth of God');
--
--INSERT INTO stories (stid, title) VALUES (nextval('stories_stid_seq'), 'standing in another man''s grave');

INSERT INTO stories (stid, title) VALUES (generate_story_stid(), 'the trials of jericho');

INSERT INTO stories (stid, title) VALUES (generate_story_stid(), 'the birth of God');

INSERT INTO stories (stid, title) VALUES (generate_story_stid(), 'standing in another man''s grave');
