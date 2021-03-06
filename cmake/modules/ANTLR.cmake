# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

if(USE_ANTLR)
  file(GLOB_RECURSE ANTLR4
        /usr/local/lib/antlr-*-complete.jar
        /usr/local/Cellar/*antlr-*-complete.jar)

  if(DEFINED ANTLR4)
    # Get the first element of the list of antlr jars.
    # Sort and reverse the list so the item selected is the highest
    #   version in lib or else in Cellar if no lib installation exists.
    list(SORT ANTLR4)
    list(REVERSE ANTLR4)
    list(GET ANTLR4 0 ANTLR4)
    set(RELAY_PARSER_DIR
      ${CMAKE_CURRENT_SOURCE_DIR}/python/tvm/relay/grammar)

    set(RELAY_PARSER
      ${RELAY_PARSER_DIR}/py2/RelayVisitor.py
      ${RELAY_PARSER_DIR}/py2/RelayParser.py
      ${RELAY_PARSER_DIR}/py2/RelayLexer.py

      ${RELAY_PARSER_DIR}/py3/RelayVisitor.py
      ${RELAY_PARSER_DIR}/py3/RelayParser.py
      ${RELAY_PARSER_DIR}/py3/RelayLexer.py)

    set(JAVA_HOME $ENV{JAVA_HOME})
    if (NOT DEFINED JAVA_HOME)
      # Hack to get system to search for Java itself.
      set(JAVA_HOME "/usr")
    endif()

    # Generate ANTLR grammar for parsing.
    add_custom_command(OUTPUT ${RELAY_PARSER}
      COMMAND ${JAVA_HOME}/bin/java -jar ${ANTLR4} -visitor -no-listener -Dlanguage=Python2 ${RELAY_PARSER_DIR}/Relay.g4 -o ${RELAY_PARSER_DIR}/py2
      COMMAND ${JAVA_HOME}/bin/java -jar ${ANTLR4} -visitor -no-listener -Dlanguage=Python3 ${RELAY_PARSER_DIR}/Relay.g4 -o ${RELAY_PARSER_DIR}/py3
      DEPENDS ${RELAY_PARSER_DIR}/Relay.g4
      WORKING_DIRECTORY ${RELAY_PARSER_DIR})

    add_custom_target(relay_parser ALL DEPENDS ${RELAY_PARSER})
  else()
    message(FATAL_ERROR "Can't find ANTLR4: ANTLR4=" ${ANTLR4})
  endif()
endif(USE_ANTLR)
