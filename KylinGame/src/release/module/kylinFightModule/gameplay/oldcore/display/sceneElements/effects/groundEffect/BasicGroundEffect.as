package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect
{
	import mainModule.model.gameData.sheetData.groundEff.IGroundEffSheetDataModel;
	import mainModule.model.gameData.sheetData.groundEff.IGroundEffSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.FightUnitType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillAttackType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillResult;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.GameFightSkillResultMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	
	public class BasicGroundEffect extends BasicBodySkinSceneElement
	{
		[Inject]
		public var groundEffModel:IGroundEffSheetDataModel;
		[Inject]
		public var skillResultMgr:GameFightSkillResultMgr;
		[Inject]
		public var timeTaskMgr:TimeTaskManager;
		
		protected var m_effectArea:int = 40;
		protected var m_owner:ISkillOwner;
		protected var m_duration:int = 0;
		protected var m_timeTick:int = 0;
		protected var m_effParam:Object;
		/**
		 * 是否需要每0.1秒处理逻辑
		 */
		protected var m_bNeedInterval:Boolean = false;
		protected var m_bHasBuff:Boolean = false;
		protected var m_vecSkillResults:Vector.<BasicSkillResult>;
		protected var m_iCanAirFight:int = 0;
		
		public function BasicGroundEffect(typeId:int)
		{
			super();
			myElemeCategory = GameObjectCategoryType.GROUNDEFFECT;
			myObjectTypeId = typeId;
			myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_BOTTOM;
		}
		
		public function setEffectParam(duration:int,arrParam:Array,owner:ISkillOwner):void
		{	
			m_duration = duration;
			m_owner = owner;
			if(0 == m_duration || !arrParam || arrParam.length<=0)
			{
				m_bNeedInterval = false;
				return;
			}
			var temp:IGroundEffSheetItem = groundEffModel.getGroundEffSheetById(myObjectTypeId);
			if(!temp || temp.modeFields.length<=0)
			{
				m_bNeedInterval = false;
				return;
			}
			m_bNeedInterval = true;
			m_effectArea = temp.range;
			m_iCanAirFight = temp.canAirFight;
			
			m_effParam = {};
			for(var i:int = 0;i<temp.modeFields.length;++i)
			{
				if(BufferFields.BUFF == temp.modeFields[i])
					m_bHasBuff = true;
				//塔的技能伤害和塔的攻击成正比
				if(SkillResultTyps.DMG == temp.modeFields[i] && GameObjectCategoryType.TOWER == owner.elemeCategory)
					m_effParam[temp.modeFields[i]] = owner.maxAtk * arrParam[i]/100;
				else
					m_effParam[temp.modeFields[i]] = arrParam[i];
			}
			
			if(!m_bHasBuff)
			{
				if(m_effParam.hasOwnProperty(SkillResultTyps.DMG))
					m_effParam[SkillResultTyps.DMG] = int(m_effParam[SkillResultTyps.DMG]*0.1);
				
				m_vecSkillResults = new Vector.<BasicSkillResult>;
				var skillResult:ISkillResult;
				for (var field:* in m_effParam)
				{
					skillResult = skillResultMgr.getSkillResultById(field);
					if(skillResult)
						m_vecSkillResults.push(skillResult);
				}
			}
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();		
			
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,0 == m_duration?destorySelf:onAppearEnd);		
		}
		
		protected function onAppearEnd():void
		{
			initTimer();
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
		}
		
		private function initTimer():void
		{
			var repeat:int = 1;
			var interval:int = m_duration;
			if(m_bNeedInterval)
			{
				interval = m_bHasBuff?GameFightConstant.TIME_UINT*10:GameFightConstant.TIME_UINT;
				repeat = m_duration/interval;
			}			
			timeTaskMgr.createTimeTask(interval,onInterval,null,repeat,onEnd,null);
		}
		
		protected function onInterval():void
		{	
			if(!m_bNeedInterval)
				return;
			var vecTargets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(
				x,y,m_effectArea,m_owner.oppositeCampType,searchConditionFunc);
			if(!vecTargets || vecTargets.length <= 0 )
				return;
				
			for each(var target:BasicOrganismElement in vecTargets)
			{
				if(m_bHasBuff)
					target.notifyAttachBuffer(m_effParam[BufferFields.BUFF],m_effParam,null/*m_owner*/);
				else
				{
					for each(var result:BasicSkillResult in m_vecSkillResults)
					{
						result.effect(m_effParam,target,null/*m_owner*/);
					}
				}
			}
		}
		
		protected function searchConditionFunc(e:BasicOrganismElement):Boolean
		{
			if(SkillAttackType.LAND_AIR == m_iCanAirFight)
				return true;
			if(SkillAttackType.LAND == m_iCanAirFight && FightUnitType.LAND == e.fightUnitType)
				return true;
			if(SkillAttackType.AIR == m_iCanAirFight && FightUnitType.AIR == e.fightUnitType)
				return true;
			return false;
		}
		
		protected function onEnd():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.DISAPPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,destorySelf);
		}
				
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			m_duration = 0;	
			timeTaskMgr.destoryTimeTask(m_timeTick);
			m_timeTick = 0;
			m_bNeedInterval = false;
			m_effectArea = 40;
			m_effParam = null;
			m_bHasBuff = false;
			m_vecSkillResults = null;
			m_owner = null;
		}
		
		public function updateAngle(angle:Number):void
		{
			this.myBodySkin.rotation = angle;
		}
			
	}
}