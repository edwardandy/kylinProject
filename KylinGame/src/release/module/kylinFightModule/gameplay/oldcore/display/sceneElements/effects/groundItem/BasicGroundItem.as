package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundItem
{
	import flash.events.MouseEvent;
	
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.TreasureBoxOpen.OpenTreasureBoxEff;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.vo.treasureData.TreasureData;
	import release.module.kylinFightModule.gameplay.oldcore.vo.treasureData.TreasureDataList;

	/**
	 * 物资箱
	 */
	public class BasicGroundItem extends BasicBodySkinSceneElement
	{
		[Inject]
		public var timeTaskMgr:TimeTaskManager;
		[Inject]
		public var treasureList:TreasureDataList;
		
		private var _stayTick:int = 0;
		private var _stayDuration:int = 0;
		private var _addCount:int = 0;
		private var _itemId:uint;
		
		public function BasicGroundItem(typeId:int)
		{
			super();
			myElemeCategory = GameObjectCategoryType.GROUNDITEM;
			myObjectTypeId = typeId;
			myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_BOTTOM;
			
			mouseEnabled = true;
			useHandCursor = true;
			this.buttonMode = true;
		}
		
		public function initByParam(dur:int,cnt:int,itemId:uint = 0):void
		{
			_stayDuration = dur;
			_addCount = cnt;
			_itemId = itemId;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START);
			
			if(_stayDuration>0)
			{
				_stayTick = timeTaskMgr.createTimeTask(_stayDuration,null,null,1,destorySelf);	
				addEventListener(MouseEvent.CLICK,onClickItem);
			}
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			if(_stayTick>0)
				timeTaskMgr.destoryTimeTask(_stayTick);
			if(hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK,onClickItem);
			_stayTick = 0;
			_stayDuration = 0;
			_addCount = 0;
			_itemId = 0;
		}
		
		protected function onClickItem(e:MouseEvent):void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START
				,GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,onOpenBoxEnd);
			removeEventListener(MouseEvent.CLICK,onClickItem);
			//GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneGold(_addCount);
			//destorySelf();
		}
		
		private function onOpenBoxEnd():void
		{
			var data:TreasureData = treasureList.popTreasure();
			if(data)
			{
				const eff:OpenTreasureBoxEff = new OpenTreasureBoxEff(data.itemId,data.num,this.x,this.y,data.idx);
				injector.injectInto(eff);
			}
			destorySelf();
		}
	}
}