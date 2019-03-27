# Author : Janmejaya Das

source ./logger.sh
SCRIPTENTRY

#Full DB backup with migration and Validation script 
#Source Database Information
host_Pre_Var="source_db_host";
port_Pre_Var="source_db_port";
user_Pre_Var="source_db_user";
pwd_Pre_Var="source_db_pwd";
dbName_Pre_Var="source_db_dbName";
bk_Location="backupLocation"

source_db_host=
source_db_port=
source_db_user=
source_db_pwd=
source_db_dbName=
backupLocation=
#--------------------------#


#--------------------------#
#Source Database Information
#Try to input below line as just change host port,user,password,DirectoryPath.
#Please add the value of predefine key as with value using single space only
#source_db_host=localhost source_db_port=3306 source_db_user=root source_db_pwd=jandas source_db_dbName=ibackup backupLocation=C:\\Users\\jandas\\Desktop\\Work_C\\SellScript\\backup3.sql
#-----------------------#

	 INFO "Validate datasourceInformation from userInput..."

	getDataSourceValidate(){
		ENTRY
			echo "Please Enter Datasource Information followed by Stored Location>>>> source_db_host=localhost source_db_port=3306 source_db_user=root source_db_pwd=UN source_db_dbName=AAAA backupLocation=C:\\Users\\backup2.sql"
			echo 
			read -p "Please Enter Datasource information for Backuped data: " dataSourceInfo
			
			
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
										echo "Mandatory fields should not be Empty OR Null.. "
										ERROR "Failed to validate datasource details. Message:Mandatory fields should not be Empty OR Null.. ,RC: $var1 and $var2 "
										EXIT
										exit 1;
							else

								if [ "$var1" == "$host_Pre_Var" ]

									then 
										source_db_host=$var2;
								elif  [ "$var1" == "$port_Pre_Var" ]
									then
										source_db_port=$var2;
								elif  [ "$var1" == "$user_Pre_Var" ]
									then
										source_db_user=$var2;
								elif  [ "$var1" == "$pwd_Pre_Var" ]
									then
										source_db_pwd=$var2;
								elif  [ "$var1" == "$dbName_Pre_Var" ]
									then
										source_db_dbName=$var2;
								elif  [ "$var1" == "$bk_Location" ]
									then
										backupLocation=$var2;
								else 
									echo "Unexpected Inputs.. "
									ERROR "Failed to validate datasource details.. Message: Unexpected Inputs.. , RC: $var1 and $var2 "	
									EXIT						  
									exit 1;
								fi
							fi
					done
			else 
					echo "Please provide complete datasource details.."
					ERROR "Failed to validate datasource details.., Message:Please provide complete datasource details.. , RC: $var1 and $var2 "
					EXIT
					exit 1;
			fi
			INFO " DataSource details validate Sucessfully.."
			EXIT
	
	}
	
		INFO "Performing DatabaseBackup ..."

		performdatabaseBackup(){
					#attributes
					index=0;
					foundDb=false
					NAME=()
					ENTRY
					echo "You have enter databaseName as: $source_db_dbName"
					DEBUG "You have enter databaseName as: $source_db_dbName"
					source_dbs=$(mysql -h "$source_db_host" -u "$source_db_user"  -p"$source_db_pwd" --skip-column-names  -e "show databases" 2>/dev/null)
							
						for i in $(echo $source_dbs  |tr -d '\r')
							do
								NAME[$index]=${i}
								let index+=1
								if [ "$i" == $source_db_dbName ] 
									then
										INFO " Find Specified Database.."
										echo 
										echo "[Find Specified Database..]"
										echo
										echo
										#FullBackup
										echo "[backup started.]"
										echo 
										start_bakup=$(date +%s%N)
										#startDateAnTime=`date '+%Y-%m-%d %H:%M:%S'`
										startDateAnTime=`date '+%s'`
										echo "$startDateAnTime"
										TRACK_BACKUP_DATETIME "BACKUP_START_TIME= $startDateAnTime"
										#makeItDump=$(mysqldump -h "$source_db_host" -u "$source_db_user"  -p"$source_db_pwd" payment  --single-transaction --quick --skip-add-locks  --skip-disable-keys 2>/dev/null > \backup2.sql)
										makeItDump=$(mysqldump -h "$source_db_host" -u "$source_db_user"  -p"$source_db_pwd" payment  --single-transaction --quick --skip-add-locks  --skip-disable-keys  > $backupLocation)
										end_bakup=$(date +%s%N)
										#endDateAnTime=`date '+%Y-%m-%d %H:%M:%S'`
										endDateAnTime=`date '+%s'`
										echo 
										TRACK_BACKUP_DATETIME "BACKUP_END_TIME= $endDateAnTime"
										echo "$endDateAnTime"
										total_bakup=$(((end_bakup - start_bakup)/1000000))
										INFO "Total time taken  for backup:: $total_bakup ms"
										echo
										echo "Total time taken  for backup:: $total_bakup ms"
										echo
										foundDb=true
										break;	

								fi
						done

					if [ "$foundDb" == false ] 
						then
							echo "Specified Database Name is Not available."
							ERROR "Failed to perform databaseBackup.., Message: Specified Database Name is Not available.., RC: ${NAME[*]} "
							EXIT
							exit 1;
					fi
						INFO " databaseBackup complete."
						EXIT
		}	

# Main body of script starts here

	 getDataSourceValidate
	 performdatabaseBackup
	 

SCRIPTEXIT

	
