package release.module.kylinFightModule.gameplay.oldcore.utils
{
	public final class WalkDataSerializeUtil
	{
		/**
		 * 将节点数据可通过属性字符串表达形式转换为数据列表
		 * @param numCols 列数
		 * @param numRows 行数
		 * @param walkDatas 可通过节点字符串表达形式
		 * @return 可通过数据列表
		 * 可通过数据列表为一维数组，逐个表示节点的可通过属性
		 */
		public static function walkDataDecode(numCols:uint, numRows:uint, walkDatas:String):Array/*Booelan 竖向*/
		{
			var walkDataArray:Array = new Array();
			var i:uint, j:uint, n:uint;
			if (walkDatas == "0" || walkDatas == "1")
			{
				n = numCols * numRows;
				for (i = 0; i < n; i++)
				{
					walkDataArray[i] = (walkDatas == "1");
				}
			}
			else
			{
				var walkArray:Array = walkDatas.split(",");
				n = walkArray.length;
				for (i = 0; i < n; i++)
				{
					for (j = 0; j < 32; j++)
					{
						walkDataArray.push(getBit(uint(walkArray[i]), 31 - j));
					}
				}
			}
			
			return walkDataArray;
		}
		
		/**
		 * 将节点数据可通过属性列表转换为字符串表达形式
		 * @param walkDataArray 可通过数据列表
		 * @return 可通过节点字符串表达形式
		 * 可通过节点字符串表达形式为若干32位无符号整数用","连接，每位表达一个单元格的可通过属性
		 */
		public static function walkDataEncode(walkDataArray:Array/*Booelan 竖向*/):String
		{
			var walkArray:Array = [];
			var walkUint:uint = 0;
			var n:uint = walkDataArray.length;
			for (var i:uint = 0; i < n; i++)
			{
				var j:uint = i % 32;
				if(walkDataArray[i])
				{
					walkUint |= Math.pow(2, 31 - j);
				}
				
				if (j == 31)
				{
					walkArray.push(walkUint);
					walkUint = 0;
				}
			}
			
			if (j != 31)
			{
				walkArray.push(walkUint);
			}
			
			return walkArray.join();
		}
		
		/**
		 * 查询无符号整数n的某位是否为1
		 * @param n 无符号整数
		 * @param bit 需查询的位数, 从低位到高位
		 * @return 若为1则返回true，否则返回false。
		 */
		private static function getBit(n:uint, bit:uint):Boolean
		{
			var b:uint = Math.pow(2, bit);
			return (n & b) != 0;
		}
	}
}