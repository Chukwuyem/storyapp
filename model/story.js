const db = require('../db/pg')
const table1 = 'stories'
const table1seq = 'stories_stid_seq'
const table2 = 'paragraphs'
const table2seq = 'para_prid_seq'
const numStories = 10

exports.createStory = ({storyTitle, storyDesc}) =>{
    const query = `INSERT INTO ${table1} (stid, title, description) VALUES (generate_story_stid(), $1, $2) RETURNING stid;`
    const values = [storyTitle, storyDesc]

    return db.query(query, values)
}

exports.getAllStories = function () {
    const query = `SELECT * FROM ${table1} ORDER BY created_at DESC LIMIT ${numStories} OFFSET 0;`

    return db.query(query, [])
}

exports.createParagraph = ({stid, head, maintext, writer, parentpr, childpr}) => {
    const query = `INSERT INTO ${table2} (prid, story, head, maintext, writer, parentpr, childpr) VALUES 
    (generate_para_prid(), $1, $2, $3, $4, $5, $6);`
    const values = [stid, head, maintext, writer, parentpr, childpr]

    return db.query(query, values)
}