const db = require('../db/pg')
const table1 = 'stories'
const table1seq = 'stories_stid_seq'
const table2 = 'paragraphs'
const table2seq = 'para_prid_seq'
const numStories = 10

exports.createStory = ({storyTitle, storyDesc, writer, storyText}) =>{
    const query = `INSERT INTO ${table1} (stid, title, description) VALUES (generate_story_stid(), $1, $2) RETURNING stid;`
    const values = [storyTitle, storyDesc]
    let newSTID;
    let newPRID;

    return db.query(query, values) //creating the story record in the story table
        .then(data =>{
            newSTID = data.rows[0].stid
            console.log(newSTID)

            const paraQuery = `INSERT INTO ${table2} (prid, story, head, maintext, writer, parentpr, childpr) VALUES 
            (generate_para_prid(), $1, $2, $3, $4, $5, $6) RETURNING prid;`
            const paraValues = [newSTID, true, storyText, writer, null, null]

            return db.query(paraQuery, paraValues) //creating the first paragraph record in the paragraph table
                .then(data =>{
                    newPRID = data.rows[0].prid

                    const updtQuery = `UPDATE ${table1} SET headpara = $1 WHERE stid = $2`
                    const updtValues = [newPRID, newSTID]

                    return db.query(updtQuery, updtValues) //adding the paragraph id to the story record in the story table
                })
        })
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

exports.getStory = (stid) => {
    return db.query(`SELECT * FROM ${table1} WHERE stid = $1`, [stid])
}

exports.getPara = (prid) => {
    return db.query(`SELECT * FROM ${table2} WHERE prid = $1`, [prid])
}