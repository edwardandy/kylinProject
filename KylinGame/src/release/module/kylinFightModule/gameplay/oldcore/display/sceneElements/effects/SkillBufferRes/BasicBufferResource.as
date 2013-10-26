package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes
{
	import mainModule.model.gameData.sheetData.buff.IBuffSheetDataModel;
	import mainModule.model.gameData.sheetData.buff.IBuffSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IBufferResource;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	public class BasicBufferResource extends BasicBodySkinSceneElement implements IBufferResource
	{
		[Inject]
		public var buffModel:IBuffSheetDataModel;
		
		private var _target:ISkillTarget;
		private var _buffInfo:IBuffSheetItem;
		/**
		 *  显示位置的相对点
		 * 	0表示在目标的头上显示
		 *	1表示在目标的脚下显示
		 *	2表示在身体中间
		 */
		private var _positionType:int = 0;
		/**
		 * 偏移位置
		 */
		private var _ptOffset:PointVO = new PointVO;
		
		public function BasicBufferResource(typeId:int)
		{	
			super();
			myElemeCategory = GameObjectCategoryType.ORGANISM_SKILL_BUFFER;
			myObjectTypeId = typeId;
			
		}
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			_buffInfo = buffModel.getBuffSheetById(myObjectTypeId);
		}
		
		override protected function get bodySkinResourceURL():String
		{
			if(_buffInfo && _buffInfo.resId>0)
				return myElemeCategory + "_" + _buffInfo.resId;
			else 
				return super.bodySkinResourceURL;
		}
		
		public function initializeByParameters(target:ISkillTarget):void
		{
			_target = target;
			setAttach2DettachFromParentDisplayListFunction(attach2DettachFromParent);
		}
		
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			//有些buffer是没有皮肤的
			if(myBodySkin != null)
			{
				if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
				{
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
						GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,onBuffAnimAppearEnd);
				}	
				else
				{
					onBuffAnimAppearEnd();
				}
			}
		}
		
		protected function onBuffAnimAppearEnd():void
		{
			if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
			{
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);	
			}
			else if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.IDLE))
			{
				myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE);
			}
		}
		
		public function disappear():void
		{
			changeToTargetBehaviorState(OrganismBehaviorState.DISAPPEAR);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			switch(currentBehaviorState)
			{
				case OrganismBehaviorState.DISAPPEAR:
					if(myBodySkin && myBodySkin.hasFrameName(GameMovieClipFrameNameType.DISAPPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
					{
						myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
							GameMovieClipFrameNameType.DISAPPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,destorySelf);
					}
					else
						destorySelf();
					break;
					
			}
		}
		
		public function attach2DettachFromParent(e:BasicBufferResource,isAttch:Boolean):void
		{
			/*if(!myBodySkin)
				return;*/
			if(isAttch)
				_target.notifyAddBuffRes(this,_buffInfo.positionType,_buffInfo.ptOffset.x,_buffInfo.ptOffset.y);
			else
				_target.notifyRemoveBuffRes(this);
		}

	}
}