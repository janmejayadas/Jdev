# Author : Janmejaya Das

source ./logger.sh
SCRIPTENTRY

#Distination Database Information
host_Pre_Var="dist_db_host";
port_Pre_Var="dist_db_port";
user_Pre_Var="dist_db_user";
pwd_Pre_Var="dist_db_pwd";
dbName_Pre_Var="dist_db_dbName";
bk_Location="backupLocation"

dist_db_host=
dist_db_port=
dist_db_user=
dist_db_pwd=
dist_db_dbName=
backupLocation=
#dist_db_host=localhost dist_db_port=3306 dist_db_user=root dist_db_pwd=jandas dist_db_dbName=ibackup backupLocation=C:\\Users\\jandas\\Desktop\\Work_C\\SellScript\\backup2.sql
#source_db_host=localhost source_db_port=3306 source_db_user=root source_db_pwd=jandas source_db_dbName=payment backupLocation=C:\\Users\\jandas\\Desktop\\Work_C\\DB_migration\\dev_backup\\backup2\\backup2.sql
#---------------------------#
#Try to input below line as just change host port,user,password,DirectoryPath
#Please add the list of predefine key as with value using single space only
#dist_db_host=remotemysql dist_db_port=3306 dist_db_user=BBB dist_db_pwd=password dist_db_dbName=ABC backupLocation=C:\\Users\\backup2.sql
#--------------------------#
echo "Please Enter Datasource Information followed by Stored Location>>>> eg. dist_db_host=localhost dist_db_port=3306 dist_db_user=ABC dist_db_pwd=ABC dist_db_dbName=ABC backupLocation=c:\\"
#gdryy9UmGV
#dist_db_host=remotemysql.com dist_db_port=3306 dist_db_user=gdryy9UmGV dist_db_pwd=a5phXivPvd dist_db_dbName=gdryy9UmGV backupLocation=C:\\Users\\jandas\\Desktop\\Work_C\\SellScript\\backup2.sql
#dist_db_host=remotemysql.com dist_db_port=3306 dist_db_user=gdryy9UmGV dist_db_pwd=a5phXivPvd dist_db_dbName=gdryy9UmGV backupLocation=C:\\Users\\jandas\\Desktop\\Work_C\\SellScript\\backup2.sql

 
	getDataSourceValidate(){
	ENTRY
	INFO "Validating datasourceInformation from userInput..."

	read -sp "Please Enter Datasource information for Restoring backup data: " dataSourceInfo
		echo
		echo

	if [ ! -z "$dataSourceInfo" -a "$dataSourceInfo" != " " ];
		then
			for i in $(echo $dataSourceInfo  |tr -d '\r')

				do
					var1=$(echo $i | cut -f1 -d=)
					var2=$(echo $i | cut -f2 -d=)
                     DEBUG "key: $var1, value: $var2"
						if [ -z "$var2" -a "$var2" == ""  ] || [  -z "$var1" -a "$var1" == ""  ] || [  -z "$var1" -a "$var1" == ""  ];
							then
								echo "Mandatory fields should not be Empty OR Null. "
								ERROR "Failed to validate datasource details. Message:Mandatory fields should not be Empty OR Null. , RC: $var1 and $var2 "
								EXIT
								exit 1;
						else

							if [ "$var1" == "$host_Pre_Var" ]

								then 
									dist_db_host=$var2;
										elif  [ "$var1" == "$port_Pre_Var" ]
								then
									dist_db_port=$var2;
								
							elif  [ "$var1" == "$user_Pre_Var" ]
								then
									dist_db_user=$var2;
							elif  [ "$var1" == "$pwd_Pre_Var" ]
								then
									dist_db_pwd=$var2;
							elif  [ "$var1" == "$dbName_Pre_Var" ]
								then
									dist_db_dbName=$var2;
							elif  [ "$var1" == "$bk_Location" ]
								then
									backupLocation=$var2;
							else 
								echo "Unexpected Inputs."
									ERROR "Failed to validate datasource details.. Message: Unexpected Inputs. , RC: $var1 and $var2 "	
									EXIT						  
								exit 1;
							fi
						fi
			done
	else 
		echo "Please provide complete datasource details."
			ERROR "Failed to validate datasource details. , Message:Please provide complete datasource details. , RC: $var1 and $var2 "
			EXIT
			exit 1;
			fi
		INFO " DataSource details validate Sucessfully.."
		EXIT
}
			#FullImport
	
		performDatabaseMigration(){
		INFO "Performing DatabaseBackup ."
				foundDb=false;
					index=0;
					NAME=()
				echo "You have enter databaseName as: $dist_db_dbName"
				DEBUG "You have enter databaseName as: $dist_db_dbName"
				dist_dbs=$(mysql -h "$dist_db_host" -u "$dist_db_user"  -p"$dist_db_pwd" --skip-column-names  -e "show databases" 2>/dev/null)

				for i in $(echo $dist_dbs  |tr -d '\r')
					do
						if [ "$i" == $dist_db_dbName ] 
							then
							NAME[$index]=${i}
								let index+=1
								echo 
								echo "[Find Specified Database..]"
								echo
								echo "[ Restoring Started.. ]"
								start_mgrt=$(date +%s%N)
								#startDateAnTime=`date '+%Y-%m-%d %H:%M:%S'`
								startDateAnTime=`date '+%s'`
								echo "StartTimeStamp: $startDateAnTime"
								TRACK_BACKUP_DATETIME "MIGRATE_START_TIME= $startDateAnTime"
								mysql -h"$dist_db_host" -u"$dist_db_user" -p"$dist_db_pwd" "$dist_db_dbName"  < "$backupLocation"
								end_mgrt=$(date +%s%N)
								echo "EndTimeStamp: $end_mgrt"
								total_mgrt=$(((end_mgrt - start_mgrt)/1000000))
								INFO "Total time taken  for backup:: $total_bakup ms"
								echo "Total time taken  for Migration:: $total_mgrt ms"
								echo
								echo "[ Restoring Complete..]"
								foundDb=true
								break;	

				fi
			done

			if [ "$foundDb" == false ] 
			then
			ERROR "Failed to perform databaseBackup.., Message: Specified Database Name is Not available., RC: ${NAME[*]} "
				echo "Specified Database Name is Not available."
				EXIT
				exit 1;
			fi

			INFO " DatabaseMigrate complete."
			EXIT
			
		}
		
#Main Function
getDataSourceValidate
performDatabaseMigration

		SCRIPTEXIT
		
		
