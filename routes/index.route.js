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
router.post('/save', passportHelper.isAuthenticated, homeController.saveStory)
router.get('/get/stories', passportHelper.isAuthenticated, homeController.getStories)

router.get('/story/:stid', passportHelper.isAuthenticated, homeController.loadStory)
router.get('/para/:prid', passportHelper.isAuthenticated, homeController.loadPara)


// router.get('/', function(req, res, next) {
//   res.render('index', { title: 'Express' });
// });

module.exports = router;
