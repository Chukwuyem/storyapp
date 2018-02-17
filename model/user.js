const bcrypt = require('bcryptjs')
const db = require('../db/pg')
const table = 'users'

//TODO change this function
// exports.createUser = ({username, firstname, middlename, lastname, email, password, phone, gender}) =>{
//
//     const salt = bcrypt.genSaltSync()
//     const hash = bcrypt.hashSync(password, salt)
//
//     const query = `INSERT INTO users(username, firstname, middlename, lastname, email, user_type, status, password_hash, phone, gender) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING id`;
//     const values = [username, firstname, middlename, lastname, email, "user", "active", hash, phone, gender]
//
//     return db.query(query, values)
// }

exports.changePassword = (id, password) =>{
    const salt = bcrypt.genSaltSync()
    const hash = bcrypt.hashSync(password, salt)

    const query = `UPDATE users SET password_hash = $1 WHERE id = $2`
    const values = [hash, id]

    return db.query(query, values)
}

exports.isUsernameUnique = (username) =>{
    return db.query("SELECT username FROM users WHERE username = $1", [username])
}


exports.findById = (id) => {
    return db.query(`SELECT * from ${table} WHERE id = $1`, [id])
}

exports.findByUsername = (username) => {
    return db.query(`SELECT * from ${table} WHERE username = $1`, [username])
}

// exports.findAdminByUsername = (username) => {
//     return db.query(`SELECT * from ${table} WHERE user_type ='admin' AND username = $1`, [username])
// }

exports.comparePassword = (clearPassword, hash) => {
    return bcrypt.compareSync(clearPassword, hash)
}