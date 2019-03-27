# Author : Janmejaya
#Database Validation script 
source ./logger.sh
SCRIPTENTRY
#destination Database Information
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
#dist_db_host=remotemysql dist_db_port=3306 dist_db_user=BBB dist_db_pwd=password dist_db_dbName=ABC backupLocation=C:\\Users\\backup2.sql
#dist_db_host=remotemysql.com dist_db_port=3306 dist_db_user=gdryy9UmGV dist_db_pwd=a5phXivPvd dist_db_dbName=gdryy9UmGV
#--------------------------#

#Source Database Information
s_host_Pre_Var="source_db_host";
s_port_Pre_Var="source_db_port";
s_user_Pre_Var="source_db_user";
s_pwd_Pre_Var="source_db_pwd";
s_dbName_Pre_Var="source_db_dbName";

source_db_host=
source_db_port=
source_db_user=
source_db_pwd=
source_db_dbName=


#---------------------------#
#Try to input below line as just change host port,user,password,DirectoryPath
#Please add the list of predefine key as with value using single space only
#source_db_host=localhost source_db_port=3306 source_db_user=root source_db_pwd=jandas source_db_dbName=payment
#--------------------------#

tableFlag=false;

			getDataSourceValidate(){
										ENTRY
										INFO "Validating datasourceInformation from userInput..."
										echo "Please Enter Datasource Information  followed by Source and destination !!!"
										echo
										read -sp "Please Enter Source Datasource information : " s_validate 
										echo
										echo
										read -sp "Please Enter destination Datasource information : " d_validate
										echo
										echo
										start_valid=$(date +%s%N)
										if [ ! -z "$s_validate" -a "$s_validate" != ""  ] || [ ! -z "$d_validate" -a "$d_validate" != ""  ];
											then

												echo " You have enter source destination databaseName as: source: $s_validate , destination: $d_validate"

												for dst in $(echo $d_validate  |tr -d '\r')
													do
														for srs in $(echo $s_validate |tr -d '\r')
															do
																s_var1=$(echo $srs | cut -f1 -d=)
																s_var2=$(echo $srs | cut -f2 -d=)
																d_var1=$(echo $dst | cut -f1 -d=)
																d_var2=$(echo $dst | cut -f2 -d=)
																DEBUG "Source_key: $s_var1, Source_value: $s_var2"
																DEBUG "Distn_key:  $d_var1, Distn_value: $d_var2"
																

																if [ -z "$s_var2" -a "$d_var2" == ""  ] || [  -z "$s_var1" -a "$d_var1" == ""  ];
																	then
																	  echo "Mandatory fields should not be Empty OR Null. "
																	  ERROR "Failed to validate datasource details. Message:Mandatory fields should not be Empty OR Null.. ,RC:Source_key: $s_var1, Source_value: $s_var2 && Distn_key:  $d_var1, Distn_value: $d_var2 "
																	  EXIT	
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
																		ERROR "Failed to validate datasource details.. Message: Unexpected Inputs.. , RC:Source_key: $s_var1, Source_value: $s_var2 && Distn_key:  $d_var1, Distn_value: $d_var2 "	
																		EXIT
																		exit 1;

																fi
														done	
												done

										else
											echo "Please provide source and destination datasource details."
											ERROR "Failed to validate datasource details., Message:Please provide complete datasource details.. , RC:Source_key: $s_var1, Source_value: $s_var2 && Distn_key:  $d_var1, Distn_value: $d_var2  "
											EXIT
											exit 1;
										fi
											INFO " DataSource details validate Sucessfully.."
											EXIT
									
										echo "sourceDBName: $source_db_dbName"
										echo "DistDBName: $dist_db_dbName"

								}

#validate

			dataBaseValidate(){
								ENTRY
								INFO " Database  Validate Started."
								foundDb=false;
								s_index=0;
								d_index=0;
								S_NAME=()
								D_NAME=()
								echo
								start_valid=$(date +%s%N)
								source_dbs=$(mysql -h "$source_db_host" -u "$source_db_user"  -p"$source_db_pwd" --skip-column-names  -e "show databases" 2>/dev/null)
								dist_dbs=$(mysql -h "$dist_db_host" -u "$dist_db_user"  -p"$dist_db_pwd" --skip-column-names  -e "show databases" 2>/dev/null)
								
								for source_db in $(echo $source_dbs  |tr -d '\r')
									do
									S_NAME[$s_index]=${source_db}
									let s_index+=1;
										for dist_db in $(echo $dist_dbs  |tr -d '\r')
											do
											D_NAME[$d_index]=${dist_db}
											let d_index+=1;
											
												if [ "$source_db" == "$source_db_dbName" ] && [ "$dist_db" ==  "$dist_db_dbName" ] ;
													then			
														foundDb=true;
														break ;
												fi	
										done
										if [ "$foundDb" == true ] 
											then
												break;
										fi
								done
								echo
								if [ "$foundDb" == false ] 
											then
												echo "Specified Database Name is Not available."
												ERROR "Failed to perform database Validate.., Message: Specified Database Name is Not available.., RC: SourceDb: $S_NAME ,DistDb: $D_NAME "
												EXIT
												exit 1;
										fi
										
								INFO " Database validate Complete."
								EXIT
		
							}
			
			tablesValidate(){
	
							INFO " Tables Validate Started."
							# Table validate
							ENTRY
							SOURCE_TBLS=()
							DIST_TBLS=()
							S_index=0;
							D_index=0;
							echo
							for source_tbl in $(echo $1  |tr -d '\r')
								do
									SOURCE_TBLS[$S_index]=${source_tbl}
									let S_index+=1	 
							done
									for dist_tabl in $(echo $2  |tr -d '\r')
										do				
											DIST_TBLS[$D_index]=${dist_tabl}
											let D_index+=1						
									done
										S_length=${#SOURCE_TBLS[*]}
										D_length=${#DIST_TBLS[*]}
									DEBUG " Source Datbase Table Length: $S_length"
									DEBUG " destination Datbase Table Length: $D_length"
										if [ $S_length != $D_length ]	
												then  
												tableFlag=true;
										fi
										
										if [ "$tableFlag" == true ] 
											then 
												read -sp "Do u want me to show tableName that doesn't Found eg.[y|n] ?  : " show 
												echo
												echo
												if [ ! -z "$show" -a "$show" != ""  ] && [ "$show" == "y" ];
													then
													echo " Table's doesn't found at destination."
													DEBUG " Table's doesn't found at destination."
													echo
														for((i=0;i<$S_length;i++))
															do 
																j=0;
																for((j=0;j<$D_length;j++))
																	do
																		if [ "${SOURCE_TBLS[$i]}" == "${DIST_TBLS[$j]}" ]
																			then 
																				break;
																		fi
																done
																if [ "$j" == "$D_length" ]
																	then 
																		echo " ${SOURCE_TBLS[i]} "
																		DEBUG " ${SOURCE_TBLS[i]} "
																fi
														done
												fi
										fi	
										
					
							if [ "$tableFlag" == true ]
								then 
								echo 
									echo "[ Warning ] The Program  found table missing [source OR destination]. those tables are not eligable for validation !!! "
									DEBUG "[ Warning ] The Program  found table missing [source OR destination]. those tables are not eligable for validation !!! "
							fi					
							INFO " Tables Validation complete."
							EXIT
						}
		
	#Check Sum
			checkSumValidation(){
							#CheckSum Valdation
							isCheckSum=false;
							ENTRY
							INFO "Performing CheckSum Validation."
							echo "[CheckSum Valdition started..]"
							start_date=$(date +%s%N)
								for s_verify in $(echo $1  |tr -d '\r')
									do
										for d_verify in $(echo $2 |tr -d '\r')
											do
												if [ "$s_verify" == "$d_verify" ]
													then													
														S_checkSum=$(mysql -h"$source_db_host" -u"$source_db_user" -p"$source_db_pwd" --skip-column-names  -e"checksum table $source_db_dbName.$s_verify" 2>/dev/null)
														D_checkSum=$(mysql -h"$dist_db_host" -u"$dist_db_user" -p"$dist_db_pwd" --skip-column-names -e"checksum table $dist_db_dbName.$d_verify" 2>/dev/null)
														for s_cs_verify in $(echo $S_checkSum  |tr -d '\r')
															do
																for d_cs_verify in $(echo $D_checkSum |tr -d '\r')
																	do																	
																		if [[ ! -n ${s_cs_verify//[0-9]/} ]] && [[ ! -n ${d_cs_verify//[0-9]/} ]]
																			then
																				if [ "$s_cs_verify" != "$d_cs_verify" ] 
																					then 
																						isCheckSum=true;
																						DEBUG "CheckSum Mismatch Found:: Source_Tbls: $s_verify & CheckSum: $s_cs_verify ====> destination_Tbls: d_verify & CheckSum: $d_cs_verify "
																						
																						echo
																						echo "S_CheckSum:$s_verify"
																						echo "D_CheckSum:$d_verify"
																						echo
																						echo "CheckSum NotMatch !!!!!!"
																						echo "$s_cs_verify == $d_cs_verify"
																				fi
																			fi
																done
														done
												fi
										done
								done
								if [ "$isCheckSum" == false ]
								then
									echo "All CheckSum Matched..."
									DEBUG "All CheckSum Matched..."
							fi
								end_date=$(date +%s%N)
								echo
								echo "[CheckSum Validation Complete..]"
								echo
								total_date=$(((end_date - start_date)/1000000));
								echo "Total time taken  for CheckSum validation:: $total_date ms"
								INFO "Total time taken  for CheckSum validation:: $total_date ms"
								echo
							echo
						echo
						INFO " CheckSum Valdition Complete."
						EXIT
					}	

			rowCountValidition(){
								isRowCount=false;
								ENTRY
								INFO "Performing RowCount Validation."
								echo "[RowCount Validation started..]"
								start_date=$(date +%s%N)
								for r_s_verify in $(echo $1  |tr -d '\r')
										do
											for r_d_verify in $(echo $2 |tr -d '\r')
												do
													if [ "$r_s_verify" == "$r_d_verify" ]
														then													
															r_S_rowCount=$(mysql -h"$source_db_host" -u"$source_db_user" -p"$source_db_pwd" --skip-column-names  -e"select count(*) from $source_db_dbName.$r_s_verify" 2>/dev/null)
															r_D_rowCount=$(mysql -h"$dist_db_host" -u"$dist_db_user" -p"$dist_db_pwd" --skip-column-names -e"select count(*) from $dist_db_dbName.$r_d_verify" 2>/dev/null)

															for r_s_cs_verify in $(echo $r_S_rowCount  |tr -d '\r')
																do
																	for r_d_cs_verify in $(echo $r_D_rowCount |tr -d '\r')
																		do
																			if [[ ! -n ${r_s_cs_verify//[0-9]/} ]] && [[ ! -n ${r_d_cs_verify//[0-9]/} ]]
																				then
																					if [ "$r_s_cs_verify" != "$r_d_cs_verify" ]
																						then 
																							isRowCount=true;
																							echo
																							DEBUG "RowCount Mismatch Found:: Source_Tbls: $r_s_verify & RowCount: $r_s_cs_verify ====> destination_Tbls: r_d_verify & RowCount: $r_d_cs_verify "
																							echo "S_RowCount:$r_s_verify"
																							echo "D_RowCount:$r_d_verify"
																							echo
																							echo "RowCount NotMatch !!!!!!"
																							echo "$r_s_cs_verify == $r_d_cs_verify"
																					fi
																			fi
																	done
															done
													fi
											done
									done
							if [ "$isRowCount" == false ]
									then
									echo
									echo "All RowCount Matched..."
									DEBUG "All RowCount Matched..."
									echo		
								fi
									end_date=$(date +%s%N)
									echo
									echo "[RowCount Validation Complete..]"
									echo
									total_date=$(((end_date - start_date)/1000000));
									echo "Total time taken  for rowCount validation:: $total_date ms"
									INFO "Total time taken  for RowCount validation:: $total_date ms"
									echo			
									INFO " RowCount Validation Complete."
									EXIT		
							}

			
			
				
#Main Function Calll
   
	getDataSourceValidate
	dataBaseValidate
	 S_listOfTables=$(mysql -h"$source_db_host" -u"$source_db_user" -p"$source_db_pwd" --skip-column-names --database="$source_db_dbName" -e"show tables" 2>/dev/null)
	D_listOfTables=$(mysql -h"$dist_db_host" -u"$dist_db_user" -p"$dist_db_pwd" --skip-column-names --database="$dist_db_dbName" -e"show tables" 2>/dev/null)
	tablesValidate "$S_listOfTables"  "$D_listOfTables"
		read -sp "Please Enter Validation Level[ RowCount OR CheckSum OR Both ] information : " valid_level
		echo
		echo
			if [ "$valid_level" == "CheckSum" ] || [ "$valid_level" == "Both" ];
				then  checkSumValidation  "$S_listOfTables"  "$D_listOfTables"
			fi
 
			if  [ "$valid_level" == "RowCount" ] || [ "$valid_level" == "Both" ];
				then rowCountValidition "$S_listOfTables"  "$D_listOfTables"
				
			fi 		
		
SCRIPTEXIT		
		
