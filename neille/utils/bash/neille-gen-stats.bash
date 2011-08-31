#!/bin/bash

function find-source-files
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


function print-content-of-source-files
{
  find-source-files | xargs cat
}


function print-newline-char-free-content-of-source-files 
{
  find-source-files | tr '\n' ' '
}


function count-chars-in-source-files
{
  print-newline-char-free-content-of-source-files | wc -c
}


function count-source-files
{
  find-source-files | wc -l
}


echo "Number of Source Files: "

count-source-files


echo "Number of Characters in Source Files: "

count-chars-in-source-files


