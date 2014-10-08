while true
do
	inotifywait -r -e modify,create . && make html
done
