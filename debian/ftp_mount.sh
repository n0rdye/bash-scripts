#!/bin/bash
install_pass=$1;
user="n0rdye";
folder="Disks";
func(){

	if [ -d "/home/$user/$folder" ]; then
		ip_1="192.168.0.7";
		srv_1=("ftp" "html" "n0rdye");

		ip_2="192.168.0.6";
		srv_2=("n0rdye" "mc");

		con(){
			pass=$1
			host=$2
			ip=$3
			srv_names=$4
			echo "connecting to $ip $pass $host $srv_names";
			if [[ "$host" != "$user" ]]; then
				echo "yes" | echo "$pass" | sshfs $host@$ip:/home/$host /home/$user/$folder/$host-$srv_names -o password_stdin
			elif [[ "$host" == "$user" ]]; then
				echo "yes" | echo "$pass" | sshfs $host@$ip:/ /home/$user/$folder/$host-$srv_names -o password_stdin
			fi
		}

		srv_con(){
			local -n srv=$1
			ip=$2
			srv_name=$3
			ssh-keyscan $ip >>~/.ssh/known_hosts
			for str in "${srv[@]}"; do
				c_name="$str-$srv_name";
				if mountpoint -q /home/$user/$folder/$c_name;  then
					echo "$c_name mounted."
				else
					echo "$c_name not mounted."
					if [ -d "/home/$user/$folder/$c_name" ]; then
						echo "folder for $c_name exist";
						con "484" $str $ip $srv_name
					else
						# echo "none";
						echo "creating /home/$user/$folder/$c_name";
						mkdir "/home/$user/$folder/$c_name";
						if [ -d "/home/$user/$folder/$c_name" ]; then
							echo "folder created"
							con "484" $str $ip $srv_name
						fi
					fi
				fi
			done
		}
		srv_con srv_2 $ip_2 "s2"
		srv_con srv_1 $ip_1 "s1"
	else
		echo "no /home/$user/$folder"
		mkdir "/home/$user/$folder";
		func
	fi
}
install(){
    if apt list | grep "sshfs" ;then 
        func
    else
        if apt list | grep "expect" ;then 
            expect -c "
            spawn sudo apt-get -y install sshfs
            expect -nocase \":\" {send \"$install_pass\r\"; interact}"
            install
        else
            echo "please install 'expect'"
        fi
    fi
}
install
# function copyFiles {
#    local -n arr=$1

#    for i in "${arr[@]}"
#    do
#       echo "$i"
#    done
# }

# array=("one" "two" "three")

# copyFiles array

# # srv_2
# srv_2="";
# srv_2="${srv_2} mc";
# srv_2="${srv_2} n0rdye";

# for host in ${srv}; do
#     echo ${host};
# done


# if [ -d "/home/$user/$folder" ]; then
#   # Take action if $DIR exists. #
#   echo "Installing config files in ${DIR}..."
# else
# 	echo "none";
# fi

# SRV_1

# echo 'yes' | echo '484' | sshfs html@192.168.0.7:/home/html /home/n0rdye/FTP/html -o password_stdin 
# echo 'yes' | echo '484' | sshfs n0rdye@192.168.0.7:/home/n0rdye /home/n0rdye/FTP/srv_1 -o password_stdin

# # SRV_2
# echo 'yes' | echo '484' | sshfs mc@192.168.0.6:/home/mc /home/n0rdye/FTP/mc -o password_stdin 
# echo 'yes' | echo '484' | sshfs n0rdye@192.168.0.6:/home/n0rdye /home/n0rdye/FTP/srv_2 -o password_stdin




