from selenium import webdriver
from selenium.webdriver.common.keys import Keys

driver = webdriver.Firefox();
driver.get("https://jenner.com/people");

driver.find_element_by_xpath("//form[@id='new_search']/div[4]/div/h1").click()
driver.find_element_by_id("search_offices_new_york").click()
driver.find_element_by_css_selector("div.filter.roles > div.header > h1").click()
driver.find_element_by_xpath("//form[@id='new_search']/div[6]/div/h1").click()
driver.find_element_by_id("search_roles_partner").click()
driver.find_element_by_css_selector("input.button:nth-child(2)").click()

driver.save_screenshot('page.png');
driver.close();