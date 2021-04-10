#! /bin/bash




3.    hosts=(“192.168.0.1” “173.194.222.113” “87.250.250.242”)
    port=80
    for h in ${hosts[@]}; do
    for ((i=1;i<=5;i++))
    do
    result=$(nmap $h -p$port | grep open)
    pattern=“open”;
    if [[ $result =~ $pattern ]]; then
    echo “$h on port $port is up"
    echo $result
    echo “$(date)” >> curl.log
    else
    echo “$h on port $port is down"
    echo $result
    echo “$(date)” “!!!ERROR!!!””$h on port $port is down” >> curl.log
    break
    fi
    done
    done

4.  hosts=(“192.168.1.1” “173.194.222.113” “87.250.250.242”)
    echo "port?"
    read port
    while ((0==0))
    do
    achtung=0
    for h in ${hosts[@]};
    do
    result=$(nmap $h -p$port | grep open)
    pattern=“open”;
    if [[ $result =~ $pattern ]]; then
    echo “$h on port $port is up"
    echo $result
    else
    echo “$h on port $port is down"
    echo $result
    echo “$(date)” “!!!ERROR!!!””$h on port $port is down” >> curl.log
    achtung=1
    break
    fi
    done
    if [[ $achtung>0 ]]; then break
    fi
    done

