package utili.behavior.declare 
{
	import flash.utils.Dictionary;
	
	import utili.behavior.appear.AppearAlpha;
	import utili.behavior.appear.AppearAlphaScale;
	import utili.behavior.appear.AppearAlphaScale2;
	import utili.behavior.appear.AppearDirectly;
	import utili.behavior.appear.AppearScale;
	import utili.behavior.appear.AppearScaleForNewMonsterPop;
	import utili.behavior.disappear.DisappearAlpha;
	import utili.behavior.disappear.DisappearAlphaScale2;
	import utili.behavior.disappear.DisappearDirectly;
	import utili.behavior.disappear.DisappearScale;

	/**
	 * 映射面板出现方式
	 * @author Edward
	 */
	public class DeclareBehavior 
	{	
		private var _dicDeclare:Dictionary;
		
		public function DeclareBehavior() 
		{
			_dicDeclare = new Dictionary;
			declare();
		}
		
		private function declare():void
		{
			_dicDeclare["AppearAlpha"] = AppearAlpha;
			_dicDeclare["AppearScale"] = AppearScale;
			_dicDeclare["AppearDirectly"] = AppearDirectly;
			_dicDeclare["AppearScaleForNewMonsterPop"] = AppearScaleForNewMonsterPop;
			_dicDeclare["AppearAlphaScale2"] = AppearAlphaScale2;
			_dicDeclare["AppearAlphaScale"] = AppearAlphaScale;
			
			_dicDeclare["DisappearAlphaScale2"] = DisappearAlphaScale2;
			_dicDeclare["DisappearAlpha"] = DisappearAlpha;
			_dicDeclare["DisappearScale"] = DisappearScale;
			_dicDeclare["DisappearDirectly"] = DisappearDirectly;
		}
		
		public function getBehaviorClass(id:String):Class
		{
			return _dicDeclare[id];
		}
	}
}