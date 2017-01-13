from selenium import webdriver

driver = webdriver.Firefox();
driver.get("http://www.oddsportal.com/hockey/usa/nhl-2013-2014/carolina-hurricanes-ottawa-senators-80YZhBGC");

driver.find_element_by_css_selector("ul.sub-menu > li:nth-child(2) > a:nth-child(1)").click();
driver.save_screenshot('page1.png');

driver.find_element_by_css_selector(".ul-nav > li:nth-child(3) > a:nth-child(1)").click();
driver.save_screenshot('page2.png');

driver.close();