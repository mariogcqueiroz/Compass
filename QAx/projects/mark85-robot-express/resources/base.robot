*** Settings ***
Library          libs/database.py
Library          Browser
Documentation    Base de recursos para testes do Mark85.
*** Keywords ***
Start Session
    New Browser    browser=chromium    headless=False
    New Page       http://localhost:3000