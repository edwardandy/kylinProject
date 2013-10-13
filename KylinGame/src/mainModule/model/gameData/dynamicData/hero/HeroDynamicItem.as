package mainModule.model.gameData.dynamicData.hero
{	
	import mainModule.model.gameData.dynamicData.BaseDynamicItem;

	/**
	 * 每个英雄的动态数据项 
	 * @author Edward
	 * 
	 */	
	public class HeroDynamicItem extends BaseDynamicItem
	{
		/**
		 * 当前经验
		 */
		public var exp:uint;
		/**
		 * 等级
		 */
		public var level:uint;		
		/**
		 * 已激活的天赋列表: id1,id2,id3 
		 */		
		private var _talents:String;
		private var _arrTalents:Array;
		
		public function get arrTalents():Array
		{
			return _arrTalents;
		}
		
		public function set talents(s:String):void
		{
			_arrTalents = [];
			if(s)
			{
				var arr:Array = s.split(":");
				for each(var id:uint in arr)
				{
					if ( id )
					{
						_arrTalents.push(id);
					}
				}
			}
		}		
		/**
		 * 英雄技能列表
		 */
		/*private var _vecSkillInfos:Vector.<HeroSkillDynamicItem> = new Vector.<HeroSkillDynamicItem>;
		public function set skills(value:Object):void
		{
			if(!value)
				return;
			for(var id:* in value)
			{
				
			}
		}*/
		
		
		public function HeroDynamicItem()
		{
			super();
		}
	}
}