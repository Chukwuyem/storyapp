const express = require('express');
const router = express.Router();
const passport = require('passport')
const passportHelper = require('../helpers/passport')

const homeController = require('../controller/homeController')

router.get('/login', homeController.login)
router.post('/login', homeController.postLogin)
router.get('/logout', homeController.logout)
router.get('/', passportHelper.isAuthenticated, homeController.home)

router.get('/new', passportHelper.isAuthenticated, homeController.newStory)
//load new story form

router.post('/save', passportHelper.isAuthenticated, homeController.saveStory)
//saving a new story

router.get('/get/stories', passportHelper.isAuthenticated, homeController.getStories)
//load stories on homepage

router.get('/story/:stid', passportHelper.isAuthenticated, homeController.loadStory)
//get a specific story by stID (story ID)

router.get('/para/:prid', passportHelper.isAuthenticated, homeController.loadPara)
//get a specific paragraph by prID (paragraph ID)

router.post('/save/para', passportHelper.isAuthenticated, homeController.savePara)


// router.get('/', function(req, res, next) {
//   res.render('index', { title: 'Express' });
// });

module.exports = router;
