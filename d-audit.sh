#!/bin/bash
# Small tool to either audit Discourse docs with woke, or download the docs to a ./docs directory

# Linefeed character for grep output / field separator
NEWLINE=$'\n'

download=false
url=false

function get-params () {

    # Generate raw address for given URL
    dindex=$(echo $url | grep --color=never -o '/t/[[:alnum:]|-]*/[[:digit:]]*' | grep -o '[[:digit:]]*$')

    # Extract site address for forum
    durl=$(echo $url | sed 's/\/t.*//')

    # Create raw URL for index document
    dindex="$durl/raw/$dindex"

    # Download raw contents of index document into string
    dindex=$(curl -s "$dindex")

    # Populate doclist with just the post numbers
    doclist=$(echo $dindex| grep --color=never -o '/t/[[:alnum:]|-]*/[[:digit:]]*' | grep -o '[[:digit:]]*$' )

}

while getopts "d:u:" opt; do
    case "${opt}" in
        d) download=${OPTARG};;
	u) url=${OPTARG};;
    esac
done

if [ $download != false ] && [ $url != false ]; then

    get-params
   
    mkdir -p $download
    echo -ne "Downloading docs"

    while NEWLINE= read -r urltext; do
         curl -s "$durl/raw/$urltext/" -o "docs/$urltext.md"
         echo -ne "."
    done <<< "$doclist"

    echo " Finished"

elif [ $url != false ]; then

    get-params

    echo "Auditing docs"
    
    while NEWLINE= read -r urltext; do
     wokeout=$(curl -s "$durl/raw/$urltext/" | woke --stdin )

      if [ "$wokeout" != "No findings found." ]; then
              echo "$durl/t/$urltext: $wokeout"
      fi
    done <<< "$doclist"
else
    echo "Usage: d-audit.sh [OPTION] ..."
    echo "Will scan given Discourse docs index URL for non-inclusive language using the required woke tool."
    echo ""
    echo "  -u <url>     URL for Discourse index page (mandatory)"
    echo "  -d <dir>     Flag to optionally download documentation pages to given directory"
fi
