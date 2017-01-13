var url ='http://v6.bang.weibo.com/czv/caijing?period=month';
var casper = require('casper').create();
var fs = require('fs');
var save = 'MyPage.html';

casper.start(url, function() {
        fs.write(save, this.getPageContent(), 'w');
    });

casper.run();
