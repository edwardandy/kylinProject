@echo off
rem �������а�
echo ���ڵ���wrapper���а�
rem pause
mxmlc ../src/framecore/main/wrapper.as -debug=false -source-path ../src ../../TowerDefanseShell/src -o ../bin-debug/wrapper.swf -static-link-runtime-shared-libraries=true -external-library-path+=../uiComponent.swc 1>info.txt