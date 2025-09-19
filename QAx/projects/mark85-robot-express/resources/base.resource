*** Settings ***
Library          libs/database.py
Library          Browser
Documentation    Base de recursos para testes do Mark85.
Resource         libs/env.resource
Resource         pages/components/Notice.resource
Resource         pages/components/Header.resource
Resource         pages/components/Alert.resource
Resource         pages/SignupPage.resource
Resource         pages/LoginPage.resource
*** Keywords ***
Start Session
    New Browser    browser=chromium    headless=False
    New Page       ${BASE_URL}