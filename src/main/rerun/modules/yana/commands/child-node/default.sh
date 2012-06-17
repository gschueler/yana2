#!/bin/bash
#
# NAME
#
#   child-node
#
# DESCRIPTION
#
#   manage a child node relationship
#

# Read module function library
source $RERUN_MODULES/yana/lib/functions.sh || exit 1 ;

# Parse the command options
[ -r $RERUN_MODULES/yana/commands/child-node/options.sh ] && {
  source $RERUN_MODULES/yana/commands/child-node/options.sh || exit 2 ;
}


# ------------------------------

cookie=/tmp/yana-child-node-cookiejar.txt
response=/tmp/yana-child-node-response.txt
[ -f $response ] && rm $response

#
# Login and create a session
#
curl --silent --fail \
    --data "j_username=admin&j_password=admin" \
    ${URL}/springSecurityApp/j_spring_security_check \
    --cookie-jar ${cookie} || rerun_die "login failed for admin"

case $ACTION in
    create)
	curl --silent --fail --request POST \
	    --header "Content-Type: application/json" \
	    -d "{relationshipName:'${NAME}',parent:'${ID}',child:'${CHILD}'}" \
	    ${URL}/api/childNode/xml \
	    -o $response --cookie $cookie || rerun_die "server request failed"
	xmlstarlet val --well-formed \
	    --quiet ${response} 2>/dev/null || rerun_die "Yana response failed XML validation"
    	xmlstarlet sel -t -m /childNodes/childNode \
	    -v @relationshipName -o ":" -v @id -o ":" \
	    -v @parentName -o ":" -v @parentNodeId -o ":" \
	    -v @childName  -o ":" -v @childNodeId \
	    $response || rerun_die "failed parsing result"
	;;
    get)
	curl --silent --fail --request GET \
	    ${URL}/api/childNode/xml/${ID} \
	    -o $response --cookie $cookie
	[ $? == 0 -a ! -f $response ] && rerun_die "ChildNode not found. (id: ${ID})"
	xmlstarlet val --well-formed \
	    --quiet ${response} 2>/dev/null || rerun_die "Yana response failed XML validation"
	xmlstarlet sel -t -m /childNodes/childNode \
	    -v @relationshipName -o ":" -v @id -o ":" \
	    -v @parentName -o ":" -v @parentNodeId -o ":" \
	    -v @childName  -o ":" -v @childNodeId \
	    $response || rerun_die "failed parsing result"
	;;
    list)
	curl --silent --fail --request POST \
	    --header "Content-Type: application/json" \
	    ${URL}/api/childNode/list/xml \
	    -o $response --cookie $cookie 
	xmlstarlet val --well-formed \
	    --quiet ${response} 2>/dev/null || rerun_die "Yana response failed XML validation"
	xmlstarlet sel -t -m /childNodes/childNode \
	    -v @relationshipName -o ":" -v @id -o ":" \
	    -v @parentName -o ":" -v @parentNodeId -o ":" \
	    -v @childName  -o ":" -v @childNodeId \
	    -n  $response || rerun_die "failed parsing result"

	;;
   delete)
	curl --silent --fail --request DELETE \
	    ${URL}/api/childNode/none/${ID} \
	    -o ${response} --cookie ${cookie}
	;;
    *)
	echo actions: $RANGE
	exit 2
	;;
esac


# ------------------------------

exit $?

# Done
