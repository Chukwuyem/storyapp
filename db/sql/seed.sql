
DELETE FROM paragraphs; -- delete this first because you can't delete stories if these still exist
DELETE FROM stories;

-- INSERT INTO stories (stid, title) VALUES (nextval('stories_stid_seq'), 'hanging stranger');

DO $$
-- DO block required due to story_stid01 variable. can't declare global variable in postgres
DECLARE
    story_stid01 varchar;
    para_prid01 bigint;
    para_prid02 bigint;
    para_prid03 bigint;
BEGIN
    INSERT INTO stories (stid, title) VALUES (generate_story_stid(), 'hanging stranger') RETURNING stid INTO story_stid01;


    INSERT INTO paragraphs (prid, story, head, maintext, writer) VALUES (generate_para_prid(), story_stid01,
    TRUE, 'At five o''clock Ed Loyce washed up, tossed on his hat and coat, got his car out and headed across town towardhis TV sales store.
    He was tired. His back and shoulders ached from digging dirt out of the basement and wheeling it into the back yard. But for a forty-year-old man he had done okay. Janet could get a new vase with the money he had saved; and he liked the idea of repairing the foundations himself.
    It was getting dark. The setting sun cast long rays over the scurrying commuters, tired and grim-faced, women loaded down with bundles and packages, students, swarming home from the university, mixing with clerks and businessmen and drab secretaries.
    He stopped his Packard for a red light and then started it up again. The store had been open without him; he''d arrive just in time to spell the help for dinner, go over the records of the day, maybe even close a couple of sales himself.
    He drove slowly past the small square of green in the center of the street, the town park. There were no parking places in front of LOYCE TV SALES AND SERVICE. He cursed under his breath and swung the car in a U-turn.
    Again he passed the little square of green with its lonely drinking fountain and bench and single lamppost.', 'testUser1') RETURNING prid INTO para_prid01;

    UPDATE stories SET headpara = para_prid01 WHERE stid = story_stid01;
    -- UPDATE stories SET fk_stories_headpara = (story_stid01, para_prid01) WHERE stid = story_stid01;

     INSERT INTO paragraphs (prid, story, head, maintext, parentpr, writer) VALUES (generate_para_prid(), story_stid01, FALSE,
    'From the lamppost something was hanging. A shapeless dark bundle, swinging a little with the wind. Like a dummy of some sort.
    Loyce rolled down his window and peered out. What the hell was it? A display of some kind? Sometimes the Chamber of Commerce put up displays in the square.
    Again he made a U-turn and brought his car around. He passed the park and concentrated on the dark bundle. It wasn''t a dummy.
    And if it was a display it was a strange kind. The hackles on his neck rose and he swallowed uneasily. Sweat slid out on his face and hands.
    It was a body. A human body. "Look at it!" Loyce snapped. "Come on out here!"
    Don Fergusson came slowly out of the store, buttoning his pin-stripe coat with dignity. "This is a big deal, Ed. I can''t just leave the guy standing there."
    "See it?" Ed pointed into the gathering gloom. The lamppost jutted up against the sky—the post and the bundle swinging from it.
    "There it is. How the hell long has it been there?" His voice rose excitedly. "What''s wrong with everybody? They just walk on past!"
    Don Fergusson lit a cigarette slowly. "Take it easy, old man. There must be a good reason, or it wouldn''t be there."
    "A reason! What kind of a reason?"
    Fergusson shrugged. "Like the time the Traffic Safety Council put that wrecked Buick there. Some sort of civic thing. How would I know?"
    Jack Potter from the shoe shop joined them. "What''s up, boys?"
    "There''s a body hanging from the lamppost," Loyce said. "I''m going to call the cops."
    "They must know about it," Potter said. "Or otherwise it wouldn''t be there."
    "I got to get back in." Fergusson headed back into the store. "Business before pleasure."
    Loyce began to get hysterical. "You see it? You see it hanging there? A man''s body! A dead man!" "Sure, Ed. I saw it this afternoon when I went out for coffee."
    "You mean it''s been there all afternoon?"
    "Sure. What''s the matter?" Potter glanced at his watch. "Have to run. See you later, Ed."', para_prid01, 'testUser2') RETURNING prid INTO para_prid02;

    UPDATE paragraphs SET childpr = para_prid02 WHERE prid = para_prid01;

    INSERT INTO paragraphs (prid, story, head, maintext, parentpr, writer) VALUES (generate_para_prid(), story_stid01, FALSE,
    'Potter hurried off, joining the flow of people moving along the sidewalk. Men and women, passing by the park. A few glanced up curiously at the dark bundle—and then went on. Nobody stopped. Nobody paid any attention.
    "I''m going nuts," Loyce whispered. He made his way to the curb and crossed out into traffic, among the cars. Horns honked angrily at him. He gained the curb and stepped up onto the little square of green.
    The man had been middle-aged. His clothing was ripped and torn, a gray suit, splashed and caked with dried mud. A stranger. Loyce had never seen him before. Not a local man. His face was partly turned away, and in the evening wind he spun a little, turning gently, silently. His skin was gouged and cut. Red gashes, deep scratches of congealed blood. A pair of steel-rimmed glasses hung from one ear, dangling foolishly. His eyes bulged. His mouth was open, tongue thick and ugly blue.
    "For Heaven''s sake," Loyce muttered, sickened. He pushed down his nausea and made his way back to the sidewalk. He was shaking all over, with revulsion—and fear.
    Why? Who was the man? Why was he hanging there? What did it mean?
    And—why didn''t anybody notice?
    He bumped into a small man hurrying along the sidewalk. "Watch it!" the man grated. "Oh, it''s you, Ed."
    Ed nodded dazedly. "Hello, Jenkins."
    "What''s the matter?" The stationery clerk caught Ed''s aim "You look sick."
    "The body. There in the park."
    "Sure, Ed." Jenkins led him into the alcove of LOYCE TV SALES AND SERVICE. "Take it easy."
    Margaret Henderson from the jewelry store joined them. "Something wrong?"
    "Ed''s not feeling well."
    Loyce yanked himself free. "How can you stand here? Don''t you see it? For God''s sake—" "What''s he talking about?" Margaret asked nervously.
    "The body!" Ed shouted. "The body hanging there!"
    More people collected. "Is he sick? It''s Ed Loyce. You okay, Ed?"', para_prid02, 'testUser1') RETURNING prid INTO para_prid03;

    UPDATE paragraphs SET childpr = para_prid03 WHERE prid = para_prid02;
END $$;

--INSERT INTO stories (stid, title) VALUES (nextval('stories_stid_seq'), 'the trials of jericho');
--
--INSERT INTO stories (stid, title) VALUES (nextval('stories_stid_seq'), 'the birth of God');
--
--INSERT INTO stories (stid, title) VALUES (nextval('stories_stid_seq'), 'standing in another man''s grave');

INSERT INTO stories (stid, title) VALUES (generate_story_stid(), 'the trials of jericho');

INSERT INTO stories (stid, title) VALUES (generate_story_stid(), 'the birth of God');

INSERT INTO stories (stid, title) VALUES (generate_story_stid(), 'standing in another man''s grave');
