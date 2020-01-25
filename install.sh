#!/bin/bash
#
# input env vars:
# - AW_INSTALL_PATH
# - AW_PARAM_PATH
# - AW_OPERATIONAL_TYPE
#
# please export the above vars in .profile and .bashrc
#

source ${AW_INSTALL_PATH}/setup.sh
current_dir=`pwd`

autoware_parameter_dir=${AW_PARAM_PATH}/params.${AW_OPERATIONAL_TYPE}
if [ -z "${autoware_parameter_dir}" ];then
  echo "please set environment variable AW_PARAM_PATH & AW_OPERATIONAL_TYPE"
elif [ ! -d ${autoware_parameter_dir} ];then
  echo "cannot find ${autoware_parameter_dir}"
else
  install_dir=`rospack find parameter_manager`
  if [ -e ${install_dir} ]; then
    cd ${install_dir}
    rm -rf link launch
    ln -s ${autoware_parameter_dir} link
    mkdir -p launch
    output_file=./launch/param.launch
    target_files=`find ./link/* -name *.yaml`

    echo "<!-- this file is automatically installed. -->" >> ${output_file}
    echo "<launch>" >> ${output_file}
    for file in ${target_files}
    do
      yaml_path=`echo ${file}|sed "s/\.\/link/\$\(find parameter_manager\)\/link/g"`
      echo "  <rosparam"                >> ${output_file}
      echo "    command=\"load\""       >> ${output_file}
      echo "    file=\"${yaml_path}\""  >> ${output_file}
      echo "    subst_value=\"True\""   >> ${output_file}
      echo "  />"                       >> ${output_file}
      unset yaml_path
    done
    echo "</launch>" >> ${output_file}

    echo "${autoware_parameter_dir}"
    echo "success to install params!!!"
    unset output_file
    unset target_files
  fi
  unset install_dir
fi
cd ${current_dir}
unset current_dir
unset autoware_parameter_dir

