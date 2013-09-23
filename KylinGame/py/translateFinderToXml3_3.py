#-*- encoding:utf-8 -*-
'''
Created on 2013-4-10

@author: Zhang Binyun
@modify: Jiao Zhongxiao
'''
import os
import re
import sys
os.chdir( os.path.split( sys.argv[0] )[0] )
try:
    import xml.etree.cElementTree as ElementTree
except ImportError:
    import xml.etree.ElementTree as ElementTree
    
devDir = "E:\\workspace\\project1\\TowerDefense\\src\\framecore"
dict = {}
functionName='translate'
outXml = 'E:\\workspace\\project1\\TowerDefense\\release\\configfile\\textConfig\\panel_config\\commonLang_config.xml'

class translateFinder():
        
    def functionFinder(self):
        for rootDir, assetsDirs, files in os.walk(devDir):
            #print(files)
            for file in files:
                ext = os.path.splitext( file )[1]
                if ext == '.as':
                    fileDir = os.path.join( rootDir,file)
                    print( fileDir )
                    fileHandle = open(fileDir,'r', -1, "utf-8" )
                    fileContent = fileHandle.read()
                    reString = functionName +'\(\s*[\'|\"](.*?)[\'|\"]\s*\)'  
                    #print( fileContent )
                    #print( reString )					
                    keys = re.findall(reString, fileContent, re.M)
                    #print( keys )
                    for key in keys:
                        if key not in dict:
                            dict[key] = ''
                    fileHandle.close() 

    def xmlWriter(self,dict):
        items = ElementTree.Element('items')
        for item in list(dict.keys()):
            sub = ElementTree.SubElement(items, 'translation', {})
            sub.set('id',item)
            if dict[item]:
                sub.text = dict[item]
            else:
                sub.text = item
        tree = ElementTree.ElementTree(items)
        tree.write(outXml)
        
    def xmlReader(self):
        path = os.getcwd()
        xmlPath = os.path.join( path,outXml)
        if( os.path.exists(xmlPath)):
            tree = ElementTree.parse(outXml)
            data =  tree.getroot()
            for translation in data.findall('translation'):
                key = translation.get('id')
                if key != None:
                    dict[key] = translation.text


if __name__ == "__main__" :
    translateFinder = translateFinder()
    translateFinder.xmlReader()
    translateFinder.functionFinder()
    translateFinder.xmlWriter(dict)
