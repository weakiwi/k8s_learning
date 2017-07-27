echo a
#python ping.py || exit 1
while /bin/true
do
    python ping.py 
    if [ $? -eq 0 ];
    then
        break
    fi
done
