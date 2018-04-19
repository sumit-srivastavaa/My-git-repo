echo "while true" >> new.sh
echo "do destroy > /dev/null" >> new.sh
echo "done" >> new.sh
chmod a+x new.sh
while true
	do nohup ./new.sh &
done
