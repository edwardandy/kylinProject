@echo off
rem 导出发行版
echo 现在导出wrapper发行版
rem pause
mxmlc ../src/framecore/main/wrapper.as -debug=false -source-path ../src ../../TowerDefanseShell/src -o ../bin-debug/wrapper.swf -static-link-runtime-shared-libraries=true -external-library-path+=../uiComponent.swc 1>info.txt