package utili.structure
{
	/**
	 * 填充对象内容功能类
	 * @author Edward
	 * 
	 */	
	public final class FillObjectUtil
	{
		public function FillObjectUtil()
		{
		}
		/**
		 *  copy对象内容，可以覆写目标对象dest中的setter进行深层copy
		 * @param dest 目标对象，属性将要被改变
		 * @param src 源对象，提供用于copy的值
		 * @return 如果源对象或目标对象为空，则失败
		 * 
		 */		
		public static function fillObj(dest:Object,src:Object):Boolean
		{
			if(!dest || !src)
				return false;
			
			for(var idx:* in src)
			{
				if(!dest.hasOwnProperty(idx) || null == src[idx])
					continue;
				dest[idx] = src[idx];
			}
			return true;
		}
	}
}