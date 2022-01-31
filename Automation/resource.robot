*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary
Library     Collections


*** Variables ***
${base_url}    http://thetestingworldapi.com/


*** Keyword ***
CHECK_DATA
    create session      GetData      ${base_url}
    ${response}=    Get On Session     GetData     /api/studentsDetails/    expected_status=200
    ${actual_code}=    convert to string  ${response.status_code}
    should be equal     ${actual_code}     200
    log to console  ${actual_code}
    log to console  ${response.content}

ADD_DATA
    create session      AddData      ${base_url}
    ${body}=    create dictionary     first_name=Test_004   middle_name=TC_004  last_name=TCL_004   date_of_birth=12/12/1990
    ${response}=    POST On Session     AddData     /api/studentsDetails/    data=${body}       expected_status=201
    ${actual_code}=    convert to string  ${response.status_code}

    Should Be Equal As Strings     ${body["first_name"]}        ${response.json()}[first_name]
    Should Be Equal As Strings     ${body["middle_name"]}       ${response.json()}[middle_name]
    Should Be Equal As Strings     ${body["last_name"]}         ${response.json()}[last_name]
    Should Be Equal As Strings     ${body["date_of_birth"]}     ${response.json()}[date_of_birth]

    should be equal     ${actual_code}     201
    log to console  ${actual_code}

    ${json_object}=     set variable     ${response.json()}
    ${id}=      get value from json     ${json_object}     id
    ${id_student}       Convert json to string  ${id[0]}
    Set Global Variable     ${id_student}

    log to console  ${response.content}

CHECKUPDATE_DATA
    create session      GetData      ${base_url}
    ${response}=    Get On Session     GetData      http://thetestingworldapi.com/api/studentsDetails/${id_student}     expected_status=200
    ${actual_code}=    convert to string  ${response.status_code}
    should be equal     ${actual_code}     200
    log to console  ${actual_code}

    ${json_object}=     set variable     ${response.json()}
    ${id}=      get value from json     ${json_object}     data.id
    log to console  ${response.content}

PATCH_DATA
    create session      PatchData      ${base_url}
    ${body}=    create dictionary  id=${id_student}     first_name=Test_101   middle_name=TC_004  last_name=TCL_004   date_of_birth=12/12/1990
    ${response}=    PUT On Session     PatchData     /api/studentsDetails/${id_student}    data=${body}     expected_status=200
    ${actual_code}=    convert to string  ${response.status_code}
    should be equal     ${actual_code}     200
    log to console  ${actual_code}

    log to console  ${response.content}

    ${response}=    Get On Session    PatchData       /api/studentsDetails/${id_student}        expected_status=200
    Should Be Equal As Strings     ${body["first_name"]}      ${response.json()}[data][first_name]
    log to console   ${response.content}

DELETE_DATA
    create session      DeleteData      ${base_url}
    ${response}=    Delete On Session     DeleteData     /api/studentsDetails/${id_student}     expected_status=200
    ${actual_code}=    convert json to string      ${response.status_code}
    should be equal        ${actual_code}      200
    log to console  ${actual_code}
    log to console  ${response.content}

    ${jsonresponse}=        set variable        ${response.json()}
    ${status_list}=     get value from json     ${jsonresponse}     status
    ${status}=      get from list    ${status_list}      0
    should be equal        ${status}      true
    log to console  ${status}