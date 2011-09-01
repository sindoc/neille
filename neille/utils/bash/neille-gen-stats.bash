#!/bin/bash

function neille-sc-find
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



function neille-sc-print
{
  neille-sc-find | xargs cat
}



function neille-sc-rm-newline-chars
{
  neille-print-sc | tr '\n' ' '
}



function neille-sc-rm-leading-whtspc
{
  neille-sc-print | sed 's/^[ \t]*//'
}



function neille-sc-rm-whtspc-arnd-line
{
  neille-sc-rm-leading-whtspc | sed 's/[ \t]*$//'
}



function neille-sc-rm-empty-lines
{
  neille-sc-rm-peripheral-whtspc | '/^$/d'
}



echo "---------------------------------"
echo -n "Number of Source Files:"
neille-sc-find | wc -l
echo "================================="
echo
echo
echo "---------------------------------"
echo "Number of  Lines of Code        |"
echo "---------------------------------"
echo -n "Whitespace-included:"

neille-sc-print | wc -l
echo
echo -n "Whitespace-excluded:"

neille-sc-rm-whtspc-arnd-line | wc -l
echo
echo "================================="
echo
echo
echo "---------------------------------"
echo "Number of Characters in Code     |"
echo "---------------------------------"
echo -n "Whitespace-included:"

neille-sc-print | wc -c
echo
echo -n "Whitespace-excluded:"

neille-sc-rm-whtspc-arnd-line | wc -c
echo
echo "================================="








