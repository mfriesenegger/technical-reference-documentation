#! /bin/sh
# Set up new SUSE TRD Getting Start Guide
# Collects input on new guide, then generates
# directory and file structure to allow authors
# to begin editing content.


##
# Display banner
##
echo
echo "= = = = = = = = = = = = = = = = = = = = = = = = = = ="
echo "=   TRD Getting Started Guide: Setup/Preparation    ="
echo "= = = = = = = = = = = = = = = = = = = = = = = = = = ="
echo
echo
echo "- - - - - - - - - - - - - - - - -"
echo "- Run from start directory with -"
echo "- ./bin/setup.sh                -"
echo "- - - - - - - - - - - - - - - - -"
echo 


##
# Initialize variables
##
category=""
doctype=""
suseprod=""
partnername=""
partnerprod=""
usecase=""
documentbase=""


##
# Gather inputs
##

  echo
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo " Gather some information"
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo

  # get solution category
  while read -p "Please enter the relevant category (i.e., 'k' for Kubernetes or 'l' for Linux) : " response
  do
    case ${response} in
      'k' | 'K' | 'Kubernetes' | 'kubernetes')
        category='kubernetes'
	break
      ;;
      'l' | 'L' | 'Linux' | 'linux')
        category='linux'
	break
      ;;
      'q' | 'quit')
        echo "Quitting ... nothing done."
	exit 1
      ;;
      *)
        echo "Invalid input.  Please try again or enter 'q' to quit."
      ;;
    esac
  done


  # get primary SUSE product
  while read -p "Please enter the primary SUSE product name (e.g., 'rancher', 'k3s', 'sles', 'suma', etc.) : " response
  do
    suseprod=$( echo ${response} | tr '[:upper:]' '[:lower:]' )
    # validate SUSE product
    case $suseprod in
      'sles' | 'slehpc' | 'slemicro' | 'suma')
        break
      ;;
      'rancher' | 'rke' | 'rke2' | 'k3s' | 'longhorn' | 'harvester')
        break
      ;;
      'q' | 'quit')
        echo "Quitting ... nothing done."
        exit 2
      ;;
      *)
        echo "Invalid input.  Please try again or enter 'q' to quit."
      ;;
    esac
  done

  # get Partner Name
  read -p "Please enter the name of the primary partner : " response
  partnername=$( echo ${response} | tr '[:upper:]' '[:lower:]' )


  # get Partner Product
  read -p "Please enter the primary partner product name : " response
  partnerprod=$( echo ${response} | tr '[:upper:]' '[:lower:]' )

  # get Use Case
  read -p "If you would like a use case or description (1-3 words), enter it now or just press ENTER : " response
  if [ -n "$response" ]; then
    usecase="_$( echo ${response} | tr '[:upper:]' '[:lower:]' | tr ' ' '-' )"
  else
    usecase=""
  fi



##
# build base filename and display
##

  documentbase="gs_${suseprod}_${partnername}-${partnerprod}${usecase}"

  echo
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "Base document name:"
  echo ${documentbase}
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo 


##
# confirm user is ready to proceed
##

  read -p "Press ENTER to create document structure or CTRL-C to cancel."


##
# setup structure, common elements
##

  echo
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo " Creating document structure "
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo

  # create primary directory if it does not already exist
  [ -d ${partnername} ] || mkdir ${partnername}
  cd ${partnername}

  # create DC- file
  cp ../.templates/_DC-file \
    ./_DC-${documentbase}
  # update adoc reference
  sed -i "s/MAIN=\"kubernetes_gs_suseprod_partner-partnerprod.adoc\"/MAIN=\"${documentbase}.adoc\"/g" ./DC-${documentbase}

  # create adoc directory if it does not already exist
  [ -d adoc ] || mkdir -p adoc
  cd adoc
 
  # create symlinks to common files
  [ -L common_gfdl1.2_i.adoc ] || \
    ln -s ../../../../common/adoc/common_gfdl1.2_i.adoc .
  [ -L common_sbp_legal_notice.adoc ] || \
    ln -s ../../../../common/adoc/common_sbp_legal_notice.adoc .
  [ -L common_trd_legal_notice.adoc ] || \
    ln -s ../../../../common/adoc/common_trd_legal_notice.adoc .
  [ -L common_docinfo_vars.adoc ] || \
    ln -s ../../../../common/adoc/common_docinfo_vars.adoc .

  # create .adoc file
  [ -f "${documentbase}.adoc" ] || \
    cp ../../.templates/_adoc-file \
      ./${documentbase}.adoc

  # create -docinfo.xml file
  [ -f "${documentbase}-docinfo.xml" ] || \
    cp ../../.templates/_docinfo-file \
      ./${documentbase}-docinfo.xml

  # create media directory structure
  cd ..
  [ -d media/src/png ] || mkdir -p media/src/png
  [ -d media/src/svg ] || mkdir -p media/src/svg
  cd media/src/svg
  # create symlink to logo
  [ -L suse-white-logo-green.svg ] || \
    ln -s ../../../../../../common/images/src/svg/suse-white-logo-green.svg .
  cd ../../..
  # create images symlink
  [ -L images ] || \
    ln -s media images
  # return to original directory
  cd ..

##
# display closing banner
##
  echo
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "Setup is complete"
  echo
  echo "See $PWD/${partnername}"
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo


# - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set up script for TRD Getting Started Guides
#
# Contributors:
# - Bryan Gartner <bryan.gartner@suse.com>
# - Terry Smith <terry.smith@suse.com>
# Revisions:
# - 20220127: Leverage template files
# - 20220203: Use renamed template files to avoid GitHub Actions validation

