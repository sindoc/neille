#!/bin/bash

function find_source_files
{
  find .                \
       -name '*.bash'   \
    -o -name '*.mk'     \
    -o -name '*.xsl'    \
    -o -name '*.rkt'    \
    -o -name '*.xml'    \
    -o -name '*.rnc'    \
    -o -name 'Makefile'
}


function print_content_of_source_files
{
  find_source_files | xargs cat
}


function remove_newline_chars_from_source_files
{
  find_source_files | tr '\n' ' '
}


function count_chars_in_source_files
{
  remove_newline_chars_from_source_files | wc -c
}


function count_source_files
{
  find_source_files | wc -l
}


echo "Number of Source Files: "

count_source_files


echo "Number of Characters in Source Files: "

count_chars_in_source_files


