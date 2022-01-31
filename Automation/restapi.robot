*** Settings ***
Library    RequestsLibrary
Library     JSONLibrary
Library     Collections
Resource    resource.robot


*** Test Cases ***

Flow create update delete
    CHECK_DATA
    ADD_DATA
    CHECKUPDATE_DATA
    PATCH_DATA
    DELETE_DATA