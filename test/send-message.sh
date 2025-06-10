#!/bin/bash

# https://docs.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad

# Set the `errexit` option to make sure that
# if one command fails, all the script execution
# will also fail (see `man bash` for more 
# information on the options that you can set).
set -o errexit

main () {
    while getopts "h" option; 
    do
        case $option in
            h) # display Help
                Help
                exit;;
            \?) # Invalid option
                echo "Error: Invalid option"
                exit;;
        esac
    done
    SendSpan
}
SendSpan(){
    serverBridge="http://kube.local/kafka-bridge/topics/lv-test-topic"
    # send client trace
    echo "Send client message:"
    curl --insecure --write-out "%{http_code}\n" -X POST $serverBridge --data "@./message.json" -H "content-type: application/vnd.kafka.json.v2+json"
}
Help() {
   # Display Help
   echo "script to send span to zipkin."
   echo
   echo "Syntax: send-span [-h] "
   echo "options:"
   echo "h     Print this Help."
   echo
}
main "$@"