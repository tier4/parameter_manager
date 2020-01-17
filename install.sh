#!/bin/bash

# please set environmental variable "AW_PARAM_PATH" in ~/.bashrc
source ~/.bashrc

if [ -z $AW_PARAM_PATH ];then
  echo "please set environment variable AW_PARAM_PATH"
elif [ ! -d $AW_PARAM_PATH ];then
  echo "cannot find $AW_PARAM_PATH"
else
  roscd parameter_manager || {
    echo "failed to change directory"
    return
  }
  rm -rf link launch
  ln -s $AW_PARAM_PATH link
  mkdir -p launch
  output_file=./launch/param.launch
  target_files=`find ./link/* -name *.yaml`

  echo "<!-- this file is automatically installed. -->" >> $output_file
  echo "<launch>" >> $output_file
  for file in $target_files
  do
    yaml_path=`echo $file|sed "s/\.\/link/\$\(find parameter_manager\)\/link/g"`
    echo "  <rosparam"              >> $output_file
    echo "    command=\"load\""     >> $output_file
    echo "    file=\"$yaml_path\""  >> $output_file
    echo "    subst_value=\"True\"" >> $output_file
    echo "  />"                     >> $output_file
  done
  echo "</launch>" >> $output_file

  echo "$AW_PARAM_PATH"
  echo "success to install params!!!"
fi
