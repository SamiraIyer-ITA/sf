#!/bin/bash
set +x

# Quiet down pushd, popd.
pushd() {
        command pushd "$@" > /dev/null
}

popd() {
        command popd "$@" > /dev/null
}

sandbox="dist/Salesforce"

# Compare branch with develop and make a change set for the comparison

echo "Comparing $GIT_BRANCH and origin/$base_branch for changes."
git_diff="git diff -w --name-only origin/$base_branch"

# Salesforce ant files
antfiles="src/package.xml"
propfile="build.properties_$JOB_BASE_NAME"
buildXML="$sandbox/build.xml"
# [ -f "../builds/build.properties" ] && rm ../builds/build.properties

# Component types that we deploy
types=" app \
	appMenu \
	approvalProcess  \
	asset \
        assignmentRules \
        authprovider \
        autoResponseRules \
        cls \
        cmp \
        component \
        connectedApps \
        crt \
        cspTrustedSite \
        css \
        customPermission \
	dashboard \
        email \
        evt \
	flexipage \
        flow \
        flowDefinition \
	geodata \
        globalValueSet \
        group \
        js \
        labels \
        layout \
        liveChatButton \
	notiftype \
        md \
        mdt \
        messageChannel \
        namedCredential \
	network \
        object \
	objectTranslation \
        page \
	pathAssistant \
	permissionset \
	permissionsetgroup \
	profilePasswordPolicy \
        queue \
        quickAction \
	remoteSite \
	report \
        reportType \
        resource \
        role \
        settings \
        sharingRules \
	site \
        standardValueSets \
        synonymDictionary \
        tab \
        trigger \
	wapp \
	wdash \
	wdf \
	wds \
	wlens \
        workflow \
	xmd"

typesubfolders="	email \
			dashboard \
			report"

# For creating the deployment change set
gitfiles=$sandbox/gitchanges
# profiles=$sandbox/profiles

# currently only used to make run tests
classfiles=$sandbox/classfiles

# blacklist are files that showup with changes but we don't want to deploy -- blacklist > whitelist

blacklist=build/blacklist
whitelist=build/whitelist
destructiveChanges=./build/`ls build | grep destructiveChanges`
# skipUnitTests=build/skipUnitTests
runUnitTests=build/runUnitTests

# Create the package
function makePackage() {
   for antfile in $antfiles; do
           echo "Copying $antfile"
           [ -f "$antfile" ] && cp "$antfile" $sandbox/src
   done

   [ -f "$destructiveChanges" ] && echo "Copying $destructiveChanges" && cp $destructiveChanges $sandbox/src

   while read srcfile; do
        type=`echo "$srcfile" | grep -o '\.[a-zA-Z]*$' | cut -f 2 -d .`
        dofile=`echo $types | grep $type` || true
	dosubfolders=`echo $typesubfolders | grep $type` || true
	folder=`echo "$srcfile" | cut -f 2 -d /`
	subfolder=`echo "$srcfile" | cut -f 3 -d /`
	subsubfolder=`echo "$srcfile" | cut -f 4 -d /`
        blacklisted=`cat "$blacklist" | grep "$srcfile"` || true
        if [ ! -z "$dofile" ] && [ -z "$blacklisted" ] ; then
                isSrc=`echo $srcfile | grep src` || true
                isAuraLWC=`echo $srcfile | grep 'aura\|lwc'` || true
                if [ -f "$srcfile" ] && [ ! -z "$isSrc" ] && [ ! -z "$isAuraLWC" ] ; then
			aol=`echo $isAuraLWC | cut -f 2 -d '/'`
                        auraPackage="src/$aol/`echo $srcfile | cut -f 3 -d '/'`"
			echo "Copying $auraPackage"
                        [ -d "$auraPackage" ] && cp -rp --parents $auraPackage/* $sandbox
                else
                        echo Copying "$srcfile"
		        [ -f "$srcfile" ] && [ ! -z "$isSrc" ] && cp -rp --parents "$srcfile" $sandbox
                        [ -f "${srcfile}-meta.xml" ] && cp -rp --parents "${srcfile}-meta.xml" $sandbox
			[ -f "src/$folder/${subfolder}-meta.xml" ] && cp -rp --parents "src/${folder}/${subfolder}-meta.xml" $sandbox
			[ -f "src/$folder/$subfolder/${subsubfolder}-meta.xml" ] && cp -rp --parents "src/$folder/$subfolder/${subsubfolder}-meta.xml" $sandbox
                fi
        fi
  done < $gitfiles
  profile_count=`ls -1 build/profiles | wc -l`
  if [ $profile_count > 0 ]; then
	  cp -rp build/profiles $sandbox/src
	  ls -1 $sandbox/src/profiles
  fi

  permset_count=`ls -1 build/permissionsets | wc -l`
  if [ $profile_count > 0 ]; then
          cp -rp build/permissionsets $sandbox/src
          ls -1 $sandbox/src/permissionsets
  fi

# Compress package

#  pushd $sandbox/src
#  zip -r ../$archive *
#  popd
}

function makeBuildXML() {

  runLocalTests="     <sf:deploy username=\"\${sf.username}\" password=\"\${sf.password}\" serverurl=\"\${sf.serverurl}\" maxPoll=\"\${sf.maxPoll}\" deployRoot=\"./src\" checkOnly=\"\${sf.checkonly}\" testLevel=\"RunLocalTests\" ignoreWarnings=\"true\">"
  runSpecifiedTests="     <sf:deploy username=\"\${sf.username}\" password=\"\${sf.password}\" serverurl=\"\${sf.serverurl}\" maxPoll=\"\${sf.maxPoll}\" deployRoot=\"./src\" checkOnly=\"\${sf.checkonly}\" testLevel=\"RunSpecifiedTests\" ignoreWarnings=\"true\">"
  none="     <sf:deploy username=\"\${sf.username}\" password=\"\${sf.password}\" serverurl=\"\${sf.serverurl}\" maxPoll=\"\${sf.maxPoll}\" deployRoot=\"./src\" checkOnly=\"\${sf.checkonly}\" runAllTests=\"false\" ignoreWarnings=\"true\">"

############## FIX FIX FIX ######################

 # SFDCClasses=`zipinfo -1 "$sandbox/$archive" | grep '.cls$'`
 SFDCClasses=`ls $sandbox/src/classes/*.cls | grep '.cls$'`

############## FIX FIX FIX ######################

  echo '<project name="Salesforce Ant tasks" default="tradeDeploy" basedir="." xmlns:sf="antlib:com.salesforce">' > "$buildXML"
  echo '     <property file="build.properties"/>' >> "$buildXML"
  echo '     <property environment="sandbox"/>' >> "$buildXML"
  echo '   <target name="tradeDeploy">' >> "$buildXML"
  if [ "$testLevel" == "none" ]; then
    echo "$none" >> "$buildXML"
  else
    echo "$runSpecifiedTests" >> "$buildXML"

    for SFDCClass in $SFDCClasses; do
       testCLS=`echo $SFDCClass | grep -i Test` || true
       metaFile=`echo $SFDCClass | grep meta` || true
#       skipTest=`cat $skipUnitTests | grep "$SFDCClass"`
#       echo $SFDCClass
#       if [ -z "$testCLS" ] && [ -z "$metaFile" ] && [  -z "$skipTest" ]; then
       if [ -z "$testCLS" ] && [ -z "$metaFile" ]; then
          cls=`echo $SFDCClass | cut -f 5 -d '/' | cut -f 1 -d '.'`
          echo $cls
          [ -f "src/classes/${cls}Test.cls" ] && echo "         <runTest>${cls}Test</runTest>" >> "$buildXML"
       fi
    done

    if [ -f "$runUnitTests" ]; then
	   unitTests=`cat $runUnitTests`
	   for unitTest in $unitTests; do
		 echo "         <runTest>$unitTest</runTest>" >> "$buildXML"
	   done
    fi
  fi

   echo '      </sf:deploy>' >> "$buildXML"

   echo '   </target>' >> "$buildXML"
   echo '</project>' >> "$buildXML"
}

# Begin execution

# Clean Sandbox

rm -rf $sandbox/*
[ ! -d "$sandbox/src" ] && mkdir -p "$sandbox/src"

$git_diff > $gitfiles

[ -f "$whitelist" ] && cat $whitelist >> $gitfiles

cat "$gitfiles" | grep src > $gitfiles-tmp
mv "$gitfiles-tmp" $gitfiles

# Creating string for archive name
# archive="Salesforce-`echo $GIT_BRANCH | cut -f 3 -d '/' | cut -f 2 -d '-'`.zip"

makePackage
makeBuildXML

[ -f "$propfile" ] && cp $propfile $sandbox/build.properties
exit 0


