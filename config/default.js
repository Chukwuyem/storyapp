require('dotenv').config();     // is needed for the tests to access the environment and configuration variables
module.exports = {
    port: process.env.PORT,
    cookie: {
        secret: process.env.AUTH_SECRET,
    },
    db: {
        host: process.env.PG_HOST,
        user: process.env.PG_USER,
        password: process.env.PG_PASSWORD,
        name: process.env.PG_DB,
        port: process.env.PG_PORT,
    },
    log: 'debug'
};
