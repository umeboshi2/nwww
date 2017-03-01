process.env.NODE_ENV = process.env.NODE_ENV || 'production';
try {
    require('coffee-script/register');
}
catch (e) {
    console.log("coffee-script not found, trying coffeescript.");
    require('coffeescript/register');
}
require('./src/main');

