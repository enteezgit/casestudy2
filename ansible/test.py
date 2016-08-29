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
#from sys import *
import sys

from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait # available since 2.4.0
from selenium.webdriver.support import expected_conditions as EC # available since 2.26.0
from selenium.webdriver.common.by import By

class Test_Home_page(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        self.assertIn('Late Stay Management System', self.browser.title)
    def tearDown(self):
        self.browser.quit()
        
class Test_Home_page2(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        src = self.browser.page_source
        print(src)
        text_found = re.search(r"ONE", src)
        self.assertNotEqual(text_found, None)
        
    def tearDown(self):
        self.browser.quit()
        
class Test_Home_page3(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        src = self.browser.page_source
        print(src)
        text_found = re.search(r"TWO", src)
        self.assertNotEqual(text_found, None)
        
    def tearDown(self):
        self.browser.quit()

class Test_Home_page4(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        self.assertIn('Late Stay Management System', self.browser.title)
    def tearDown(self):
        self.browser.quit()
        
class Test_Home_page5(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        self.assertIn('Late Stay Management System', self.browser.title)
    def tearDown(self):
        self.browser.quit()
        
class Test_Home_page6(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        self.assertIn('Late Stay Management System', self.browser.title)
    def tearDown(self):
        self.browser.quit()

        
class Test_Home_page7(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        self.assertIn('Late Stay Management System', self.browser.title)
    def tearDown(self):
        self.browser.quit()
        
class Test_Home_page8(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):
        self.browser.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        self.assertIn('Late Stay Management System', self.browser.title)
    def tearDown(self):
        self.browser.quit()
        
class Test_Login(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):        
        driver = webdriver.Firefox()

        driver.get('http://'+IP+':'+PORT+'/webapp/views/homepage.html') 
        #print driver.title

        # find the element that's name attribute is q (the google search box)
        driver.find_element_by_id('id').send_keys("1")
        driver.find_element_by_id('passwd').send_keys("admin")
        driver.find_element_by_xpath("//input[@value='Login']").click()

        src = driver.page_source
        text_found = re.search(r'View Late Stay List', src)
        self.assertNotEqual(text_found,None)
        driver.quit()

    def tearDown(self):
        self.browser.quit()

class Test_SignUpLink(unittest.TestCase):

    def setUp(self):
        self.browser = webdriver.Firefox()

    def testTitle(self):        
        # Create a new instance of the Firefox driver
        driver = webdriver.Firefox()

        driver.get('http://'+IP+':'+PORT+'/webapp/views/adminpage.html') 
        #print driver.title
        # find the element that's name attribute is q (the google search box)
        
        driver.find_element_by_id('reg_emp').click()
        driver.find_element_by_id('id').send_keys("018543")
        driver.find_element_by_id('name').send_keys("akshayv")
        driver.find_element_by_id('passwd').send_keys("pasv")
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
     if len(sys.argv) > 1:
        BUILDNO = sys.argv.pop()
        PORT = sys.argv.pop()
        IP = sys.argv.pop()
        
     log_file = '/root/test_result.log'
     f = open(log_file, "w")
     runner = unittest.TextTestRunner(f)
     unittest.main(testRunner=runner)
     f.close()