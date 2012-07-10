#!/bin/bash
#
# NAME
#
#   children
#
# DESCRIPTION
#
#   list child nodes
#

# Read module function library
source $RERUN_MODULES/yana/lib/functions.sh || exit 1 ;

# Parse the command options
[ -r $RERUN_MODULES/yana/commands/children/options.sh ] && {
  source $RERUN_MODULES/yana/commands/children/options.sh || exit 2 ;
}


# ------------------------------
flags="" #-v --silent --fail --show-error"

cookie=/tmp/yana-children-cookiejar.txt
response=/tmp/yana-children-response.txt
[ -f $response ] && rm $response

#
# Initialize the context
#
yana_initialize $CFG || rerun_die "Yana initialization failed"

#
# Login and create a session
#
yana_authenticate $YANA_URL $YANA_USER $YANA_PASSWORD ${cookie} || rerun_die "Yana authentication failed"

#
# Retrieve the data from Yana
#
curl --fail --silent ${YANA_URL}/node/show/${ID}?format=xml \
    --cookie ${cookie} -o ${response} || rerun_die "failed obtaining Yana data"


#
# Validate the response is well formed XML
#
xmlstarlet val --well-formed --quiet ${response} 2>/dev/null || rerun_die "Yana response failed XML validation"

#
# Function to format the output
# 
format() {
    oIFS=$IFS
    while read line
    do
	IFS=:
	arr=( $line )
	[ ${#arr[*]} -eq 3 ] || continue
	IFS=$oIFS
	yana_expand "$FORMAT" TYPE=${arr[0]} NAME=${arr[1]} ID=${arr[2]}

    done 
}

#
# Output the data
#
if [ -n "$DEPTH" -a "$DEPTH" -gt 0 ]
then
#
# For each child, print its info, then recurse
#
    for child in $(xmlstarlet sel -t -m /nodes/node/children/node \
  -v @type -o ":" -v @name -o ":" -v @id -n $response)
    do
  #
  # Print this child's info to stdout 
  #
  echo $child | format
  #
  # Parse the child info to lookup its ID (3rd element) 
  #      ex: environment:myfoobar:3
  #
  arr=( ${child//:/ } ) # Split on ':' 
  regex="[0-9]+"
  [[ ( ${#arr[*]} -eq 3 ) && ( ${arr[2]} =~ $regex ) ]] || continue ;# bad record
  #
  # ... and recurse another level 
  #
  $RERUN yana:children --depth $(( $DEPTH - 1 )) --id ${arr[2]} --format $FORMAT \
      || rerun_die "Failed recursing through children"
    done
else
    xmlstarlet sel -t -m /nodes/node/children/node \
	-v @type -o ":" -v @name -o ":" -v @id  $response|sort | format
fi



# ------------------------------

exit $?

# Done
