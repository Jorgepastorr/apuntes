# Qbit  
  
los siguientes scripts tienen la funcionalidad de rellenar las horas del qbit.

Si se inserta una linea en el cron indicando que se ejecute diariamente, solo se tendra que rellenar las valoraciones finales respectivas a cada mes.  
  
Ejemplo de ejecutar script: python qbit.py 4.0  
  
## Chrome

Dependencias necesarias para Chrome

```bash  
sudo dnf/apt install chromedriver
sudo dnf/apt install python-selenium
sudo pip install -U selenium
```   
  
*qbit.py*  
```bash
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# example: python qbit.py 4.0

# Imports
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from time import sleep
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import NoSuchElementException
import random
import sys

hours = str(sys.argv[1])
task = ['inp_8217','inp_8218','inp_8220','inp_8221','inp_8222','inp_8224','inp_8225','inp_8227','inp_8228','inp_8229','inp_8231','inp_8232']
username = "username"
password = "pasword"
###### version headles ###########
options = webdriver.ChromeOptions()
options.add_argument('headless')
driver = webdriver.Chrome(chrome_options=options)
######################
#driver = webdriver.Chrome()
driver.get("https://www.empresaiformacio.org/sBidAlumne")
driver.switch_to.frame(1)


username_input = driver.find_element_by_id("username")
password_input = driver.find_element_by_id("password")
username_input.send_keys(username)
password_input.send_keys(password)
password_input.send_keys(Keys.RETURN)


sleep(4)
driver.switch_to.frame(12)
driver.find_element_by_link_text(u"Activitat diària del dossier (2017195338)").click()
sleep(3)
#################
valueDefaultTask = "0"
for itemTask in task:
    Select(driver.find_element_by_id(itemTask)).select_by_value(valueDefaultTask)
##############
Select(driver.find_element_by_id(random.choice(task))).select_by_value(hours)
driver.find_element_by_xpath(u"//img[@title='Emmagatzemar activitat diària']").click()
driver.close()
```

## Firefox  

Dependencias necesarias para firefox
```bash  
sudo dnf/apt install chromedriver
sudo dnf/apt install python-selenium
sudo pip install -U selenium
# download geckodriver
wget https://github.com/mozilla/geckodriver/releases
sudo mv geckodriver /usr/local/bin
```   
  
*qbit.py*  
```bash
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# sudo dnf/apt install chromedriver
# sudo dnf/apt install python-selenium
# sudo pip install -U selenium
# download geckodriver
# https://github.com/mozilla/geckodriver/releases
# sudo mv geckodriver /usr/local/bin

# example: python qbit.py 4.0


# Imports
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from time import sleep
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import NoSuchElementException
import random
import sys

hours = str(sys.argv[1])
task = ['inp_8217','inp_8218','inp_8220','inp_8221','inp_8222','inp_8224','inp_8225','inp_8227','inp_8228','inp_8229','inp_8231','inp_8232']
username = "username"
password = "pasword"
###### version headles ###########
options = webdriver.FirefoxOptions()
options.add_argument('--headless')
driver = webdriver.Firefox(firefox_options=options)
######################
#driver = webdriver.Firefox()
driver.get("https://www.empresaiformacio.org/sBidAlumne")
driver.switch_to.frame(1)


username_input = driver.find_element_by_id("username")
password_input = driver.find_element_by_id("password")
username_input.send_keys(username)
password_input.send_keys(password)
password_input.send_keys(Keys.RETURN)


sleep(4)
driver.switch_to.frame(12)
driver.find_element_by_link_text(u"Activitat diària del dossier (2017195338)").click()
sleep(3)
#################
valueDefaultTask = "0"
for itemTask in task:
    Select(driver.find_element_by_id(itemTask)).select_by_value(valueDefaultTask)
##############
Select(driver.find_element_by_id(random.choice(task))).select_by_value(hours)
driver.find_element_by_xpath(u"//img[@title='Emmagatzemar activitat diària']").click()
driver.close()
```
