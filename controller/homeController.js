const winston = require('winston')
const passport = require('passport')
const story = require('../model/story')
const table1 = 'stories'
const numStories = 10

exports.login = (req, res) => {
    const redirectTo = req.query.redirectTo || '/'
    res.render('login', {title: 'Story App - Login', redirectTo})
}

exports.logout = (req, res) => {
    req.logout()
    req.flash('success', 'You are successfully logged out')
    res.redirect('/login')
}
exports.postLogin = (req, res, next) => {
    // TODO: remove all console.log
    //console.log("in post /login")
    console.log(req.body)

    const redirectTo = req.query.redirectTo || '/';
    //console.log(redirectTo)
    passport.authenticate('local-login', function(err, user, info) {

        //console.log("passport.authenticate")
        if (err) {
            console.log("auth: error")
            winston.error(err)
            return next(err)
        }
        if (!user) {
            console.log("auth: not user")
            req.flash("error", "Login details not recognized")
            return res.redirect('/login')
        }

        //console.log("auth: not error, not !user")
        req.logIn(user, function(err) {
            console.log("logIn: req.logIn")
            //console.log(user)
            if (err) {
                console.log("logIn: error")
                winston.error(err)
                return next(err);
            }

            //console.log("logIn: no error")
            return res.redirect(redirectTo);
        });
    })(req, res, next);
}

exports.home = (req, res, next) => {
    //TODO: remove log
    console.log("loading home...")

    res.render('index', {title: "STORY APP - Home"})

    // story.getAllStories()
    //     .then(data => {
    //         console.log(data.rows)
    //         res.render('index', {title: "STORY APP - Home", story: data.rows})
    //     })
    //     .catch(err => {
    //         winston.error(err)
    //         req.flash('error', 'Error: Unable to load stories')
    //     })
}

exports.getStories = (req, res, next) => {
    console.log("loading stories...")

    story.getAllStories()
        .then(data => {
            res.json(data.rows)
        })
        .catch(err => {
            winston.error(err)
            res.send('Error: Unable to load stories')
        })
}

exports.newStory = (req, res, next) => {
    console.log("loading new story page...")

    res.render('newStory', {title: "STORY APP - New Story"})
}

exports.saveStory = (req, res, next) => {
    //saving a New story
    console.log("saving story...")

    console.log(req.body)
    console.log('this is req')

    let object = {
        storyTitle: req.body.storyTitle,
        storyDesc: req.body.storyDesc,
        writer: req.user.rows[0].username,
        storyText: req.body.storyText
    }

    story.createStory(object)
        .then(data => {
            console.log('saved story and first paragraph')
            req.flash('success', 'New Story successfully created')
            res.redirect('/new')

        })
        .catch(err => {
            winston.error(err)
            req.flash('error', 'Error: Unable to save new story')
            res.redirect('/new')
        })

}

exports.loadStory = (req, res, next) => {
    const stID = req.params.stid

    let title, storyTitle, description, firstpara, nextpara;

    story.getStory(stID)
        .then(data =>{
            //console.log(data.rows)

            storyTitle = data.rows[0].title
            description = data.rows[0].description

            story.getPara(data.rows[0].headpara)
                .then(data =>{
                    //console.log(data.rows)

                    firstpara = data.rows[0].maintext
                    nextpara= data.rows[0].childpr

                    if (nextpara == null)
                        nextpara = "NULL"

                    res.render('storyPage', {title: 'Story App', storyTitle: storyTitle, description: description,
                        firstpara: firstpara, nextpara: nextpara, paraprid: data.rows[0].prid})
                })
                .catch(err => {
                    winston.error(err)
                    req.flash('error', 'Error: Unable to load requested story [paragraph query err]')
                    res.redirect('/')
                })
        })
        .catch(err => {
            winston.error(err)
            req.flash('error', 'Error: Unable to load requested story [story query err]')
            res.redirect('/')
        })
}

exports.loadPara = (req, res, next) => {
    const prID = req.params.prid

    story.getPara(prID)
        .then(data =>{
            //console.log(data.rows)
            res.send(data.rows[0])
        })
        .catch(err => {
            winston.error(err)
            //req.flash('error', 'Error: Unable to load requested paragraph')
        })
}

exports.savePara = (req, res, next) => {

}
