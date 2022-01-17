*** Settings ***
Library    RequestsLibrary
Library     JSONLibrary
Library     Collections


*** Variables ***
${base_url}    http://thetestingworldapi.com/


*** Test Cases ***

CHECK_DATA
    create session      GetData      ${base_url}
    ${response}=    Get On Session     GetData     /api/studentsDetails/
    log to console  ${response.status_code}
    ${actual_code}=    convert to string  ${response.status_code}
    should be equal     ${actual_code}     200
    log to console  ${response.content}


ADD_DATA
    create session      AddData      ${base_url}
    ${body}=    create dictionary    first_name=Test_004   middle_name=TC_004  last_name=TCL_004   date_of_birth=12/12/1990
    ${response}=    POST On Session     AddData     /api/studentsDetails/    data=${body}
    ${actual_code}=    convert to string  ${response.status_code}
    should be equal     ${actual_code}     201
    log to console  ${actual_code}

    ${json_object}=     set variable     ${response.json()}
    ${id}=      get value from json     ${json_object}     id
    ${id_student}       Convert json to string  ${id[0]}
    Set Global Variable     ${id_student}
    log to console      ${id_student}

CHECKUPDATE_DATA
    create session      GetData      ${base_url}
    ${response}=    Get On Session     GetData      http://thetestingworldapi.com/api/studentsDetails/${id_student}
    ${actual_code}=    convert to string  ${response.status_code}
    should be equal     ${actual_code}     200

    ${json_object}=     set variable     ${response.json()}
    ${id}=      get value from json     ${json_object}     data.id
    log to console      ${id}

PATCH_DATA
    create session      PatchData      ${base_url}
    ${body}=    create dictionary  id=${id_student}     first_name=Test_101   middle_name=TC_004  last_name=TCL_004   date_of_birth=12/12/1990
    ${response}=    PUT On Session     PatchData     /api/studentsDetails/${id_student}    data=${body}
    log to console  ${response.content}

    ${actual_code}=    convert to string  ${response.status_code}
    should be equal     ${actual_code}     200
    log to console  ${actual_code}

    ${response}=    Get On Session    PatchData       /api/studentsDetails/${id_student}
    log to console  ${response.content}

DELETE_DATA
    create session      DeleteData      ${base_url}
    ${response}=    Delete On Session     DeleteData     /api/studentsDetails/${id_student}
    ${actual_code}=    convert json to string      ${response.status_code}
    should be equal        ${actual_code}      200
    log to console  ${actual_code}

    ${jsonresponse}=        set variable        ${response.json()}
    ${status_list}=     get value from json     ${jsonresponse}     status
    ${status}=      get from list    ${status_list}      0
    should be equal        ${status}      true
    log to console  ${status}