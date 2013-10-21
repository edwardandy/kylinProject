package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics
{
	import com.shinezone.towerDefense.fight.constants.Skill.BufferPosition;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes.BasicBufferResource;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.bufferState.BufferStateMgr;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 能够被buff影响的对象
	 */
	public class BasicBufferAttacher extends BasicSkillerElement
	{
		protected var _mySkillBufferEffecstLayer:Sprite = null;
		protected var _mySkillBufferBottomLayer:Sprite = null;
		protected var _buffStates:BufferStateMgr;
		
		
		
		public function BasicBufferAttacher()
		{
			super();
			_buffStates = new BufferStateMgr(this);
		}
		
		override protected function onInitialize():void
		{
			_mySkillBufferBottomLayer = new Sprite();
			_mySkillBufferBottomLayer.mouseEnabled = false;
			_mySkillBufferBottomLayer.mouseChildren = false;
			addChild(_mySkillBufferBottomLayer);
			
			super.onInitialize();
			
			_mySkillBufferEffecstLayer = new Sprite();
			_mySkillBufferEffecstLayer.mouseEnabled = false;
			_mySkillBufferEffecstLayer.mouseChildren = false;
			addChild(_mySkillBufferEffecstLayer);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
		}
		
		override protected function initStateWhenActive():void
		{
			super.initStateWhenActive();
			showBufferLayer(true);
		}
		
		override protected function onLifecycleFreeze():void
		{	
			super.onLifecycleFreeze();	
		}
		
		override protected function clearStateWhenFreeze(bDie:Boolean = false):void
		{
			clearBufferStates(bDie);
			super.clearStateWhenFreeze(bDie);
		}
		
		protected function clearBufferStates(bDie:Boolean = false):void
		{
			_buffStates.clear();
			if(_mySkillBufferEffecstLayer && _mySkillBufferEffecstLayer.numChildren>0)
				_mySkillBufferEffecstLayer.removeChildren();
			if(_mySkillBufferBottomLayer && _mySkillBufferBottomLayer.numChildren>0)
				_mySkillBufferBottomLayer.removeChildren();
		}
		
		override public function dispose():void
		{
			super.dispose();
			_buffStates.dispose();
			_buffStates = null;
			_mySkillBufferEffecstLayer = null;
			_mySkillBufferBottomLayer = null;	
		}
		
		override public function notifyAttachBuffer(buffId:uint,param:Object,owner:ISkillOwner):void
		{
			if((isFreezedState() || OrganismBehaviorState.RESURRECTION == currentBehaviorState || OrganismBehaviorState.SOLDIER_STAY_AT_HOME == currentBehaviorState
				|| isAlive) 
				&& _buffStates && _buffStates.attachBuff(buffId,param,owner))
				onBufferAttached(buffId);
		}
		
		protected function onBufferAttached(buffId:uint):void
		{
			
		}
		
		override public function notifyDettachBuffer(buffId:uint,bImmediate:Boolean = true):void
		{
			if(_buffStates)
				_buffStates.dettachBuff(buffId,bImmediate);
			onBufferDettached(buffId);
		}
		
		protected function onBufferDettached(buffId:uint):void
		{
			
		}
		
		override public function hasBuffer(buffId:uint):Boolean
		{
			return _buffStates.hasBuffer(buffId);
		}
		
		override public function notifyAddBuffRes(buffRes:BasicBufferResource,layer:int,offsetX:int,offsetY:int):void
		{
			buffRes.x = offsetX;
			buffRes.y = offsetY;
			if(BufferPosition.BOTTOM == layer)
			{
				_mySkillBufferBottomLayer.addChild(buffRes);
			}
			else
			{
				if(BufferPosition.TOP == layer)
				{
					buffRes.y = -myBodySkin.height;
				}
				else
				{
					buffRes.y = -myBodySkin.height*0.5;
				}
				_mySkillBufferEffecstLayer.addChild(buffRes);
			}
		}
		
		override public function notifyRemoveBuffRes(buffRes:BasicBufferResource):void
		{
			if(_mySkillBufferEffecstLayer && _mySkillBufferEffecstLayer.contains(buffRes))
				_mySkillBufferEffecstLayer.removeChild(buffRes);
			else if(_mySkillBufferBottomLayer && _mySkillBufferBottomLayer.contains(buffRes))
				_mySkillBufferBottomLayer.removeChild(buffRes);
		}
		
		override public function notifyTriggerSkillAndBuff(condition:int):void
		{
			super.notifyTriggerSkillAndBuff(condition);
			
			_buffStates.notifyTriggerBuff(condition);
		}
		
		protected function showBufferLayer(bShow:Boolean):void
		{
			if(_mySkillBufferEffecstLayer)
				_mySkillBufferEffecstLayer.visible = bShow;
			if(_mySkillBufferBottomLayer)
				_mySkillBufferBottomLayer.visible = bShow;
		}
		
		
	}
}