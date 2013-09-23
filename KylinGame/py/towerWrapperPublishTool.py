#-*- encoding:utf-8 -*-
#written by:	Jiao Zhongxiao

import os
import sys
import shutil
import xml.etree.ElementTree as ET
import io
import binascii
from threading import Thread
from ftplib import FTP
#import subprocess
os.chdir( os.path.split( sys.argv[0] )[0] )
#config----------------------------------------------------------
publishDir = "D:\\"	#缓存目录
devDir = "E:\\workspace\\TowerFacebookDev\\branches\\TD_Branch_001\\release\\flash"
assets = ".json,.jpg,.png,.swf,.xml,.mp3"
projectDir = os.getcwd() + "/../"
newFile = 0

print( "欢迎使用Tower版本发布工具 For wrapper版" )
print( "使用前请确保已编辑了此文件做好了相关配置" )
#检查运行环境
#print( os.environ["PATH"] )
version = input( "请输入这次的版本号后 <Enter 回车> 继续：\n" )
#version = "13"

#1、更新SVN-------------------------------------------------------
print( "1、更新SVN" )
def checkToolPath( tool ):
	environ = os.environ["PATH"].split( ";" )
	for possiblePath in environ:
		possiblePath = os.path.join( possiblePath, tool )
		#print( possiblePath )
		if os.path.exists( possiblePath ):
			return True;
	return False;
hasSVN = checkToolPath( "svn.exe" )
def updateSVN():
	if hasSVN:
		os.system( "svn update " + projectDir )
		os.system( "svn update " + devDir )
	else:
		print( "没有SVN工具或没有添加到环境变量" )
		input( "请手动更新SVN，完成后 <Enter 回车> 继续" )

updateSVN();

topDir = os.path.join( publishDir, str(version) )
os.system( "rd /s /q " + topDir )
os.mkdir( topDir )

#2、编译新版本-----------------------------------------------------
print( "2、编译新版本" )
hasFlexSDK = checkToolPath( "mxmlc.exe" )
def publishRelease():
	if hasFlexSDK:
		os.system( "publish.bat" )
	else:
		print( "没有Flex工具或没有添加到环境变量" )
		input( "请手动导出发行版，完成后 <Enter 回车> 继续" )
publishRelease()

#Copy所有文件
def copyFiles():
	dirs = "bin-debug".split( "," )
	for dir in dirs:
		print( "Now working in:" + dir )
		fixDir = os.path.join( projectDir, dir )
		for rootDir, assetsDirs, files in os.walk( fixDir ):
			for file in files:
				ext = os.path.splitext( file )[1]
				#print( ext )
				if ext != "" and assets.find( ext ) != -1:
					if dir == "bin-debug" or dir == "bin-release":
						#
						shutil.copy( os.path.join( rootDir, file ), topDir )
					else:
						relPath = os.path.relpath( os.path.join( rootDir, file ), projectDir )
						print( "原始：" + relPath )
						relPath = os.path.join( topDir, relPath )
						print( "新的：" + relPath )
						fileDir = os.path.dirname( relPath )
						print( "FileDir:" + fileDir )
						if not os.path.exists( fileDir ):
							os.makedirs( fileDir )
						shutil.copyfile( os.path.join( rootDir, file ), relPath )
					print( "Copy " + os.path.join( rootDir, file ) + " 完成" )
copyFiles()

def addVersionFix():
	global newFile
	files = os.listdir( topDir )
	for file in files:
		oldFile = os.path.join( topDir, file )
		print( oldFile + "---" + str(os.path.isfile( oldFile )) )
		if os.path.isfile( oldFile ):
			ext = os.path.splitext( file )[1]
			newFile = oldFile.replace( ext, "_" + str(version) + ext )
			os.replace( oldFile, newFile )
			print( "重命名：" + oldFile + "<>"  + newFile )

addVersionFix()

#复制到DEV目录
def copyToDev():
	for rootDir, assetsDirs, files in os.walk( topDir ):
		for file in files:
			print( "Copying:" + file )
			if os.path.isfile( os.path.join( rootDir, file ) ):
				relPath = os.path.relpath( os.path.join( rootDir, file ), topDir )
				print( "原始：" + relPath )
				relPath = os.path.join( devDir, relPath )
				print( "新的：" + relPath )
				fileDir = os.path.dirname( relPath )
				print( "FileDir:" + fileDir )
				if not os.path.exists( fileDir ):
					os.makedirs( fileDir )
				shutil.copyfile( os.path.join( rootDir, file ), relPath )
				print( "Copy " + os.path.join( rootDir, file ) + " 完成" )
copyToDev()

#提交SVN
def commitSVN():
	print( "提交SVN----------------------------------------------" )
	if hasSVN:
		os.chdir( devDir )
		os.system( "svn add * --force" )
		msg = input( "请输入SVN日志：\n" )
		if ( len(msg) <= 1 ):
			msg = "版本更新，提交测试！"
		os.system( "svn commit -m " + msg )
	else:
		input( "请手动提交SVN后 <Enter 回车> 继续" )
commitSVN()

#上传FTP
print( "上传FTP----------------------------------------------" )
ftp = FTP( "172.17.0.78", "www", "uiEd53do64" )
#ftp = FTP( "127.0.0.1", "jiaox99" )
ftp.cwd( "dev-fb-td.shinezoneapp.com/web/dev_branch/flash" )

def sendFile( allFiles ):
	while len(allFiles) > 0:
		uploadfile = allFiles.pop( 0 )
		print( "Uploading:" + uploadfile )
		relPath = os.path.relpath( uploadfile, topDir ).replace( "\\", "/" )
		fileDir = os.path.dirname( relPath )
		if len(fileDir) > 0:
			try:
				ftp.mkd( fileDir )
			except:
				print( "Dir is ok!" )
		curUploadingFile = open( uploadfile, 'rb' )
		ftp.storbinary( "STOR " + relPath, curUploadingFile )

def collectFiles():
	allFiles = []
	for rootDir, assetsDirs, files in os.walk( topDir ):
		for file in files:
			filePath = os.path.join( topDir, os.path.join( rootDir, file ) )
			allFiles.append( filePath )
	return allFiles
		
sendFile( collectFiles() )

input( "Well done!wrapper 版本发布完成！ <Enter 回车> 退出" )