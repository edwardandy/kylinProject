package mainModule.model.gameData.dynamicData.hero
{	
	import mainModule.model.gameData.dynamicData.BaseDynamicItem;

	/**
	 * 每个英雄的动态数据项 
	 * @author Edward
	 * 
	 */	
	public class HeroDynamicItem extends BaseDynamicItem implements IHeroDynamicItem
	{
		private var _exp:uint;
		private var _level:uint;		
		/**
		 * 已激活的天赋列表: id1,id2,id3 
		 */		
		private var _talents:String;
		private var _arrTalents:Array;

		/**
		 * 等级
		 */
		public function get level():uint
		{
			return _level;
		}

		/**
		 * @private
		 */
		public function set level(value:uint):void
		{
			_level = value;
		}

		/**
		 * 当前经验
		 */
		public function get exp():uint
		{
			return _exp;
		}

		/**
		 * @private
		 */
		public function set exp(value:uint):void
		{
			_exp = value;
		}

		/**
		 * @inheritDoc 
		 */		
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