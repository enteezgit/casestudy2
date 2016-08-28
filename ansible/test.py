#!/usr/bin/env python

#######################################################################################
# 
#
# Script Name:      test.py
#
# Description:      This will test the nodejs crud application and insert the 36000000  
#                                                                             round of test data.
#                   
#
# %Version:         1.0
# %Creating Date:   Thu Dec 24 2015
# %Created by:      Jai
#######################################################################################


import unittest
import re
from selenium import webdriver
import os

from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait # available since 2.4.0
from selenium.webdriver.support import expected_conditions as EC # available since 2.26.0
from selenium.webdriver.common.by import By

class Test_Home_page(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://10.244.45.252:8080/webapp/views/homepage.html') 
	#print(self.browser.page_source)
        self.assertIn('Late Stay Management System', self.browser.title)

    def tearDown(self):
        self.browser.quit()

class Test_Login(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):        
	# Create a new instance of the Firefox driver
	driver = webdriver.Firefox()

	driver.get('http://10.244.45.252:8080/webapp/views/homepage.html') 
	#print driver.title

	# find the element that's name attribute is q (the google search box)
	driver.find_element_by_id('id').send_keys("1")
	driver.find_element_by_id('passwd').send_keys("admin")
	driver.find_element_by_xpath("//input[@value='Login']").click()

	src = driver.page_source
	text_found = re.search(r'View Late Stay List', src)
	self.assertNotEqual(text_found, None)
	driver.quit()

    def tearDown(self):
        self.browser.quit()

class Test_SignUpLink(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):        
	# Create a new instance of the Firefox driver
	driver = webdriver.Firefox()

	driver.get('http://10.244.45.252:8080/webapp/views/adminpage.html') 
	#print driver.title

	# find the element that's name attribute is q (the google search box)
	
	driver.find_element_by_id('reg_emp').click()
	driver.find_element_by_id('id').send_keys("0185411")
	driver.find_element_by_id('name').send_keys("sumedh88")
	driver.find_element_by_id('passwd').send_keys("pass1234")
	driver.find_element_by_id('register').click()
        
        wait = WebDriverWait(driver, 10)
        try:
          element = wait.until(EC.text_to_be_present_in_element((By.ID,'msg'), 'Employee')) 
        except TimeoutException:
          raise Exception('Unable to find text in span element after waiting 10 seconds')

        src = driver.page_source
        text_found = re.search(r"Employee Successfully Registered", src)
	self.assertNotEqual(text_found, None)
	driver.quit()

    def tearDown(self):
        self.browser.quit()

if __name__ == '__main__':
     log_file = '/root/test_result.log'
     f = open(log_file, "w")
     runner = unittest.TextTestRunner(f)
     unittest.main(testRunner=runner)
     f.close()
