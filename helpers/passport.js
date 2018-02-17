const passport = require('passport')
const LocalStrategy = require('passport-local').Strategy
const JwtStrategy = require('passport-jwt').Strategy
const Users = require('../model/user')
const winston = require('winston')


passport.use('local-login', new LocalStrategy(
    function (username, password, done) {
        Users.findByUsername(username)
            .then((data) => {
                const user = data.rows[0]
                if (data.rowCount === 1 && Users.comparePassword(password, user.password_hash)) {
                    return done(null, user)
                } else {
                    return done(null, false, 'Invalid email or password.')
                }
            })
            .catch((err) => {
                done(err, null)
            })
    }
))


passport.serializeUser(function (user, done) {
    return done(null, user.id)
})


passport.deserializeUser(function (id, done) {
    Users.findById(id)
        .then((user) => {
            done(null, user)
        })
        .catch((err) => {
            console.error(err.message)
            done(err, null)
        })
})


exports.isAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        return next()
    }
    //req.flash('info', 'You need to login to access that page')
    res.redirect(`/login?redirectTo=${req.originalUrl}`)
}