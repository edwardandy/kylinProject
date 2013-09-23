package kylin.echo.edward.utilities.string
{
	/**
	 * 字符串功能类 
	 * @author Edward
	 * 
	 */	
	public class KylinStringUtil
	{
		private static const csvReg:RegExp = /([^",]*,)|(("[^"]*"[^",]*)*,)/g;
		/**
		 * 将CSV(逗号分隔格式文件)表结构解析为2维数组，支持在csv中使用逗号和双引号
		 * @param csv
		 * @return 结果二维数组,0索引的子数组是表的标题，如果以*开头，则该列数据不使用
		 * 
		 */		
		public static function parseCsv(csv:String):Array
		{
			if(!csv)
				return null;
			
			var arrResult:Array = [];
			var arrLines:Array = csv.split("\r\n");
			var arrSub:Array;
			for each(var strLine:String in arrLines)
			{
				strLine += ",";
				arrSub = strLine.match(csvReg);
				if(!arrSub)
					throw new Error("parseCsv Line Error");
				if(arrSub.length>0)
				{
					for(var i:* in arrSub)
					{
						var str:String = arrSub[i] as String;
						if("," == str.charAt(str.length-1))
							str = arrSub[i] = str.slice(0,str.length-1);
						if("\"" == str.charAt(0) && "\"" == str.charAt(str.length-1))
							str = arrSub[i] = str.slice(1,str.length-1);
						arrSub[i] = (arrSub[i] as String).replace("\"\"","\"");
					}
					arrResult.push(arrSub);
				}
			}
			return arrResult;
		}
		
		/**
		 *将格式为  "dmg:10-100,summon:10000"的字符串转换为
		 * {dmg:"10-100",summon:"10000"}格式的对象
		 */
		public static function parseCommaString(s:String,split:String = ",",subSplit:String = ":"):Object
		{
			if(!s)
				return null;
			var result:Object = {};
			
			var keyAndValues:Array = null;
			
			var sArr:Array = s.split(split);
			var n:uint = sArr.length;
			for(var i:uint = 0; i < n; i++)
			{
				keyAndValues = String(sArr[i]).split(subSplit);
				result[keyAndValues[0]] = keyAndValues[1];
			}
			
			return result;
		}
		
		/**
		 * 
		 * 解析分隔的多个字符串对象 "buff:20000,dmg:10-100,summon:10000|buff:20001,dmg:20-200,summon:20000" 解析为
		 * 元素为对象的数组:[{buff:"20000",dmg:"10-100",summon:"10000"},{buff:"20001",dmg:"20-200",summon:"20000"}]
		 */		
		public static function parseSplitString(s:String,split:String = "|",subSplit:String = ",",innerSplit:String = ":"):Array
		{
			if(!s)
				return null;
			var arrString:Array = s.split(split);
			var arrRes:Array = [];
			for each(var str:String in arrString)
			{
				arrRes.push(parseCommaString(str,subSplit,innerSplit));
			}
			return arrRes;
		}
	}
}