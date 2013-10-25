package kylin.echo.edward.ui
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	public class ConstUtil
	{
		public static function constInClass(val:*,cls:Class):Boolean{
			var desc:XML = describeType(cls);
			var constList:XMLList = desc.elements("constant");
			var valType:String = getQualifiedClassName(val);
			for each(var x:* in constList){
				if(x.@type == valType && val == cls[x.@name]){
					return true;
				}
			}
			return false;
		}
	}
}