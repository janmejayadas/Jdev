# Author : Janmejaya
#Database Incremental Backup script 

source ./logger.sh
SCRIPTENTRY
#Distination Database Information
d_host_Pre_Var="dist_db_host";
d_port_Pre_Var="dist_db_port";
d_user_Pre_Var="dist_db_user";
d_pwd_Pre_Var="dist_db_pwd";
d_dbName_Pre_Var="dist_db_dbName";


dist_db_host=
dist_db_port=
dist_db_user=
dist_db_pwd=
dist_db_dbName=

#---------------------------#       
#Try to input below line as just change host port,user,password,DirectoryPath
#Please add the list of predefine key as with value using single space only
#dist_db_host=remotemysql dist_db_port=3306 dist_db_user=BBB dist_db_pwd=password dist_db_dbName=ABC 
#dist_db_host=remotemysql.com dist_db_port=3306 dist_db_user=BBB dist_db_pwd=jandas dist_db_dbName=payment
#--------------------------#

#Source Database Information
s_host_Pre_Var="source_db_host";
s_port_Pre_Var="source_db_port";
s_user_Pre_Var="source_db_user";
s_pwd_Pre_Var="source_db_pwd";
s_dbName_Pre_Var="source_db_dbName";
s_binlog_Lct_Pre_Var="source_binlog_location"
s_binlog_File_Pre_Var="source_binlog_fileName"
s_last_FBkpDt_Pre_Var="source_last_FBkpDt"

source_db_host=
source_db_port=
source_db_user=
source_db_pwd=
source_db_dbName=
source_binlog_location=
source_binlog_fileName=
source_last_FBkpDt=


#globalVariable
varlat=
#mysqlbinlog --start-datetime="2019-03-12 17:03:30" -hlocalhost -uroot -pjandas C:\\Users\\jandas\\Desktop\\Work_C\\DB_migration\\bin_logs\\mysql-bin.000002 | mysql -h"localhost" -u"root" -p"jandas" "ibackup"



#---------------------------#
#Try to input below line as just change host port,user,password,DirectoryPath
#Please add the list of predefine key as with value using single space only
#source_db_host=localhost source_db_port=3306 source_db_user=root source_db_pwd=jandas source_db_dbName=payment source_binlog_location=C:\\Users\\jandas\\Desktop\\Work_C\\DB_migration\\bin_logs  source_binlog_fileName=\\mysql-bin.000001 
#--------------------------#

getDataSourceValidate(){
echo "Please Enter Datasource Information  followed by Source and Distination !!!"

#read -sp "Please Enter Source Datasource information : " s_validate 
echo
echo
s_validate="source_binlog_location=C:\\Users\\jandas\\Desktop\\Work_C\\DB_migration\\bin_logs\\mysql-bin.000001 source_db_host=localhost source_db_port=3306 source_db_user=root source_db_pwd=jandas source_db_dbName=gdryy9UmGV"
#for taking Incremental Backup
#read -sp "Please Enter Distination Datasource information : " d_validate
echo
echo

d_validate="dist_db_host=localhost dist_db_port=3306 dist_db_user=root dist_db_pwd=jandas dist_db_dbName=gdryy9UmGV"

if [ ! -z "$s_validate" -a "$s_validate" != ""  ] || [ ! -z "$d_validate" -a "$d_validate" != ""  ];
											then

												echo " You have enter source distination databaseName as: source: $s_validate , distination: $d_validate"

												for srs in $(echo $s_validate  |tr -d '\r')
													do
													            s_var1=$(echo $srs | cut -f1 -d=)
																s_var2=$(echo $srs | cut -f2 -d=)
																
													if   [ "$s_var1" == "source_binlog_location" ]
																	then 																
																		 source_binlog_location=$s_var2
																		 
																		fi 
														for dst in $(echo $d_validate |tr -d '\r')
															do
																d_var1=$(echo $dst | cut -f1 -d=)
																d_var2=$(echo $dst | cut -f2 -d=)
															
																if [ -z "$s_var2" -a "$d_var2" == ""  ] || [  -z "$s_var1" -a "$d_var1" == ""  ];
																	then
																	  echo "Mandatory fields should not be Empty OR Null. "
																	  echo "Failed to validate datasource details. Message:Mandatory fields should not be Empty OR Null.. ,RC:Source_key: $s_var1, Source_value: $s_var2 && Distn_key:  $d_var1, Distn_value: $d_var2 "
																	 	
																	  exit 1;
																fi

																if [ "$s_var1" == "$s_host_Pre_Var" ] && [ "$d_var1" == "$d_host_Pre_Var" ]

																	then #echo "database identify." 
																		dist_db_host=$d_var2;
																		source_db_host=$s_var2;
																		break;

																elif  [ "$s_var1" == "$s_port_Pre_Var" ] && [ "$d_var1" == "$d_port_Pre_Var" ]
																	then
																		dist_db_port=$d_var2;
																		source_db_port=$s_var2;
																		break;
																elif  [ "$s_var1" == "$s_user_Pre_Var" ] && [ "$d_var1" == "$d_user_Pre_Var" ]
																	then
																		dist_db_user=$d_var2;
																		source_db_user=$s_var2;
																		break;
																elif  [ "$s_var1" == "$s_pwd_Pre_Var" ] && [ "$d_var1" == "$d_pwd_Pre_Var" ]
																	then
																		dist_db_pwd=$d_var2;
																		source_db_pwd=$s_var2
																		break;
																elif  [ "$s_var1" == "$s_dbName_Pre_Var" ] && [ "$d_var1" == "$d_dbName_Pre_Var" ]
																	then
																		dist_db_dbName=$d_var2;
																		source_db_dbName=$s_var2;
																		break;
																		
																
																elif  [ "$s_var1" == "" ] && [ "$d_var1" == "" ]
																	then
																		echo "Unexpected Inputs.. "
																		echo "Failed to validate datasource details.. Message: Unexpected Inputs.. , RC:Source_key: $s_var1, Source_value: $s_var2 && Distn_key:  $d_var1, Distn_value: $d_var2 "	
																		
																		exit 1;

																fi
														done	
												done

										else
											echo "Please provide source and distination datasource details."
											echo "Failed to validate datasource details., Message:Please provide complete datasource details.. , RC:Source_key: $s_var1, Source_value: $s_var2 && Distn_key:  $d_var1, Distn_value: $d_var2  "
											
											exit 1;
										fi
											echo " DataSource details validate Sucessfully.."
											
									
										echo "sourceDBName: $source_db_dbName"
										echo "DistDBName: $dist_db_dbName"
echo " You have enter Binlog Location as: BinLogLocation: $source_binlog_location , FileName: $source_binlog_fileName ,  Date&Time: $varlat" 
}


dateAndTimeParser(){
dt=

START_DATE=$(grep "BACKUP_START_TIME" ./SystemOut.log | cut -d'=' -f2-)
END_DATE=$(grep "BACKUP_END_TIME" ./SystemOut.log | cut -d'=' -f2-)
for i in $(echo $START_DATE  |tr -d '\r')
do
	echo 
#START[$index]=${i}	
#let index+=1				
#END[$index]=${}	
dt="$i"			
					done

#	echo ${START[*]}
 #   timestamp=${START[1]}

 echo `date -d @"$varlat" +'%Y-%m-%d %H:%M:%S'`		

 varlat=`date -d @"$dt" +'%Y-%m-%d %H:%M:%S'`
 source_last_FBkpDt="$varlat"
}


performIncrBackup(){
echo "[Incremential Backup Started..]"
foundDb=false;
echo
#start_valid=$(date +%s%N)






#source_dbs=$(mysql -h "$source_db_host" -u "$source_db_user"  -p"$source_db_pwd" --skip-column-names  -e "show databases" 2>/dev/null)
#dist_dbs=$(mysql -h "$dist_db_host" -u "$dist_db_user"  -p"$dist_db_pwd" --skip-column-names  -e "show databases" 2>/dev/null)
source_dbs=$(mysql -h "$source_db_host" -u "$source_db_user"  -p"$source_db_pwd" --skip-column-names  -e "show databases")
dist_dbs=$(mysql -h "$dist_db_host" -u "$dist_db_user"  -p"$dist_db_pwd" --skip-column-names  -e "show databases")

echo " SourceDB : $source_dbs"
echo " DistDB : $dist_dbs"
echo "com"
 for source_db in $(echo $source_dbs  |tr -d '\r')
		do
			for dist_db in $(echo $dist_dbs  |tr -d '\r')
				do
				#	if [ "$source_db" == "$source_db_dbName" ] && [ "$dist_db" ==  "$dist_db_dbName" ] ;
				if [ "${source_db,,}" = "${source_db_dbName,,}" ] && [ "${dist_db,,}" = "${dist_db,,}" ]; 
						then		
echo "true"	
	startDateAndTime=`date '+%s'`
echo

echo "Last backup dateTime= $source_last_FBkpDt"

		echo "$startDateAndTime"
		TRACK_BACKUP_DATETIME "BACKUP_START_TIME= $startDateAndTime"
 binlogBackup=$(mysqlbinlog --start-datetime="$source_last_FBkpDt" -h"$source_db_host" -u"$source_db_user" -p"$source_db_pwd"  $source_binlog_location | mysql -h"$dist_db_host" -u"$dist_db_user" -p"$dist_db_pwd" "$dist_db_dbName")
#mysqlbinlog --start-datetime="2019-03-17 22:49:54" -hlocalhost -uroot -pjandas C:\\Users\\jandas\\Desktop\\Work_C\\DB_migration\\bin_logs\\mysql-bin.000002 | mysql -h"localhost" -u"root" -p"jandas" "gdryy9UmGV"						
		endDateAndTime=`date '+%s'`
		echo 
echo "$endDateAndTime" 
TRACK_BACKUP_DATETIME "BACKUP_END_TIME= $endDateAndTime"
echo
		foundDb=true;
							break ;
					fi	
			done
		if [ "$foundDb" == true ] 
			then
				break;
			fi
	done

	if [ "$foundDb" == false ] 
then
echo "Specified Database Name is Not available."
exit 1;
fi

echo

echo "[Incremential Backup Sucess..]"

}

#----------------------------#
#Main function
dateAndTimeParser
getDataSourceValidate
performIncrBackup

#---------------------------#
