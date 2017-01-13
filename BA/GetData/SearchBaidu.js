var MyTerm = 'SJTU';
var casper = require('casper').create();
var xPath = require('casper').selectXPath;
var fs = require('fs');
var FilePath = 'MyPage.html';

casper.start('https://www.baidu.com/', function(){ console.log ('Page opened');});
 
casper.thenEvaluate(  function(term) {
    console.log('Now search...');
    document.querySelector('input[name="wd"]').setAttribute('value', term);
    document.querySelector('form[name="f"]').submit();
}, MyTerm);
 
casper.then(function() {
    //if (this.exists('h3.t a.favurl')) {
    //    this.echo('The URL to be clicked exists'); }
    //this.evaluate ( function () { this.click('h3.t a.favurl');} );

    var NewPageURL = this.getElementAttribute('h3.t a.favurl', 'href');
    console.log(NewPageURL);
    this.thenOpen(NewPageURL);
}); 

//casper.thenEvaluate(function () {
// $('h3.t a.favurl').click();
//}); 

casper.then(function() {
    console.log('Clicked ok, new location is ' + this.getCurrentUrl());
    this.capture('Click.png');
    fs.write(FilePath, this.getPageContent(), 'w');
});
 
casper.run();