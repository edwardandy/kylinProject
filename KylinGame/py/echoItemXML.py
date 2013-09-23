#-*- encoding:utf-8 -*-
#written by:    jiao zhongxiao
import os
import xml.etree.ElementTree as ET
import xml.dom.minidom
import sys
os.chdir( os.path.split( sys.argv[0] )[0] )
print( "注意：直接生成的XML没有格式化，但不影响程序使用" )
print( "      为了便于阅读请自行手动格式化" )
print( "     （Notepad++有XML插件，或用IE打开再复制保存）" )
input( '欢迎使用Tower资源导出工具!' )

#if os.path.exists( "../ver_config/config.xml" ):
#       tree = ET.parse( "../ver_config/config.xml" )
#       root = tree.getroot()
#else:
root = ET.Element( "root" )
tree = ET.ElementTree( root )
topDir = os.getcwd() + "/../release"
baseDir = os.path.basename( topDir )
topDirs = os.listdir( topDir )

def checkText( items, text ):
        for element in items:
                if element.text == text:
                        return True
        return False

for subDir in topDirs:
        if os.path.isdir( os.path.join( topDir, subDir ) ):
                if subDir.find( 'svn' ) == -1:
                        #目录元素
                        folderelement = root.find( subDir )
                        if folderelement is None:
                                folderelement = ET.Element( subDir )
                                curDir = baseDir + "/" + subDir + "/"
                                folderelement.set( 'folder', curDir )
                                root.append( folderelement )
                                curDir = os.path.join( topDir, subDir)
                        
                        for rootDir, dirs, assets in os.walk( os.path.join( topDir, subDir ) ):
                                if len(assets) > 0:
                                        filePath = rootDir
                                        for item in assets:
                                                if item.find( 'svn' ) == -1 and item.find( '.fla' ) == -1 and item.find( 'entries' ) == -1 and item.find( ".db" ) == -1 and item.find( ".ttf" ) == -1 and item.find( ".otf" ) == -1 and item.find( ".csv" ) == -1 and item.find( ".xlsx" ) == -1:
                                                        info = item.split( '.' )
                                                        relPath = os.path.relpath( rootDir, curDir )
                                                        relPath = os.path.join( relPath, item )
                                                        relPath = '/'.join( relPath.split( os.sep ) ).replace( './', '' )       #去掉可能的"./"
                                                        
                                                        if relPath.find( 'svn' ) == -1 and not checkText( folderelement.findall( "item" ), relPath ):
                                                                element = ET.Element( 'item' )
                                                                element.set( "id", info[0] )
                                                                element.set( "size", str(os.path.getsize(os.path.join( curDir, relPath ))))
                                                                #os.path.getsize(os.path.join( curDir, relPath ))
                                                                element.text = relPath
                                                                folderelement.append( element )

#特殊处理mapxml文件
#srcElement = root.find( 'map')
#folderelement = root.find( "mapxml" )
#if folderelement is None:
#       folderelement = ET.Element( 'mapxml' )
#       root.append( folderelement )
#       folderelement.set( 'folder', srcElement.get( 'folder' ) )
#items = srcElement.findall( 'item' )
#for item in items:
#       if item.text.find( '.xml' ) != -1:
#               srcElement.remove( item )
#               folderelement.append( item )

#               if folderelement.find( "item[@id='" + item.get( "id" ) + "']" ) is None:
#                       folderelement.append( item )
#特殊处理字体文件
doc = xml.dom.minidom.parseString( ET.tostring( root ) )
#input( doc.toprettyxml() )
fhandle = open( "../ver_config/config.xml", "w" )
fhandle.write( doc.toprettyxml() )
fhandle.close()
#tree.write( "../ver_config/config.xml", method="html" )
input( "导出配置成功！\n<回车>退出" )
