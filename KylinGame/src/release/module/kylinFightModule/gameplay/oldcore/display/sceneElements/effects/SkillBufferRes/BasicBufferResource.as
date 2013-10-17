package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IBufferResource;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.display.DisplayObject;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.buff.BuffTemplateInfo;
	
	public class BasicBufferResource extends BasicBodySkinSceneElement implements IBufferResource
	{
		private var _target:ISkillTarget;
		private var _buffInfo:BuffTemplateInfo;
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
			_buffInfo = TemplateDataFactory.getInstance().getBuffTemplateById(myObjectTypeId);
		}
		
		override protected function get bodySkinResourceURL():String
		{
			if(_buffInfo && _buffInfo.resourceId>0)
				return myElemeCategory + "_" + _buffInfo.resourceId;
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
				_target.notifyAddBuffRes(this,_buffInfo.positionType,_buffInfo.offsetX,_buffInfo.offsetY);
			else
				_target.notifyRemoveBuffRes(this);
		}

	}
}