#!/bin/bash

echo
echo
echo
echo

function neille-find-compiled-dirs 
{
  find . -name 'compiled' -type d
}

function neille-find-aux-files 
{
  find . -name '*~' -o -name '.DS_Store' -o -name '#*#' -type f
}

neille-find-compiled-dir | xargs rm -r

neille-find-aux-files | xargs rm

