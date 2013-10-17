package release.module.kylinFightModule.gameplay.oldcore.vo.treasureData
{
	public class TreasureDataList
	{
		private var _vecData:Vector.<TreasureData>;
		
		public function TreasureDataList()
		{
			_vecData = new Vector.<TreasureData>;
		}
		
		public function initList(arrData:Array):void
		{
			_vecData.length = 0;
			if(!arrData || 0 == arrData.length)
				return;
			var treasure:TreasureData;
			var idx:int = 0;
			for each(var data:Object in arrData)
			{
				treasure = new TreasureData;
				treasure.itemId = data.id;
				treasure.num = data.num;
				treasure.idx = idx++;
				_vecData.push(treasure);
			}
		}
		/**
		 * 是否有宝藏猎人 
		 * @return 
		 * 
		 */		
		public function hasTreasure():Boolean
		{
			return _vecData.length > 0;
		}
		
		public function popTreasure():TreasureData
		{
			return _vecData.shift();
		}
	}
}