try {
    require('coffee-script/register');
}
catch (e) {
    console.log("coffee-script not found, trying coffeescript.");
    require('coffeescript/register');
}
require('./src/main');

