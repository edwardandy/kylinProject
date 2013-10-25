package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.OrganismBodySizeType;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.constant.identify.BulletID;
	import release.module.kylinFightModule.gameplay.constant.identify.ExplosionID;
	import release.module.kylinFightModule.gameplay.constant.identify.GroundEffectID;
	import release.module.kylinFightModule.gameplay.constant.identify.MagicID;
	import release.module.kylinFightModule.gameplay.constant.identify.MonsterID;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.ToftElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.arrowTowers.ArrowTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.barrackTowers.BarrackTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.cannonTowers.CannonTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.cannonTowers.LongXiTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers.MagicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers.MysteryMagicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers.WitchTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers.WizardTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.ExplosionEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SceneTipEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.WitchRayEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes.BasicBufferResource;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes.SpecialBufferRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.BasicSkillEffectRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.BlackWindSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.ColdStormSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.FlameRainSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.NuclareWeaponEff;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SafeLaunchSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SummonDemonDoorSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.AeroliteBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.ArcaneBombBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.ArrowBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BlazeBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.DeadlyShurikenBullet;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.LetBulletFlyBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.ShellBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.ZiMuBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.skillBullets.TrackMissile;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.dieEffect.BasicDieEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.explosion.MireEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.IceMagicWandGroundEff;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundItem.BasicGroundItem;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.BaoFengXueMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.BasicMagicSkillEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.DaDiZhenchanMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.FreshAppleMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.FullScreenFreezeEnemy;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.FullScreenKillMonster;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.GoblinBombMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.GoblinThunderMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.HuoYanZuZhouMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.MarmotWhistleMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.QingQiuZhiYuanMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.ShengGuangPuZhaoMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.WenYiManYanMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.WorkerRopeMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.YiCiYuanZhiMenMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.ZiRanZhiRuMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros.Bomber;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros.MagicMan;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros.PowerOfNatural;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros.ShadowWarrior;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros.SilverHero;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.Behemoth;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.DemonSnowman;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.IcePhoenix;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.OrcOnWolfMonster;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.Skeletons;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss.DisasterLord;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss.HeartOfIce;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss.IceElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss.ImmortalDragon;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss.KingOfSwamp;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss.WolfPioneer;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.BarrackSoldierElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.CondottiereSoldier;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.SummonByOrganisms;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.SummonByTower;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.SupportSoldier;
	import release.module.kylinFightModule.gameplay.oldcore.logic.hurt.AttackerInfo;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.BasicGameManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.MovieClipRasterizationUtil;
	
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;

	//该类实际主要负责BasicSceneElement对象创建、缓存、销毁
	public class ObjectPoolManager extends BasicGameManager
	{
		public static const TOFT_CACHE_MAX_COUNT:int = 10;
		public static const MONSTER_CACHE_MAX_COUNT:int = 10;
		public static const HERO_CACHE_MAX_COUNT:int = 5;
		public static const SOLIDER_CACHE_MAX_COUNT:int = 15;
		public static const TOWER_CACHE_MAX_COUNT:int = 10;

		public static const BULLET_CACHE_MAX_COUNT:int = 30;
		public static const EXPLOSION_CACHE_MAX_COUNT:int = 20;
		public static const SCENE_TIP_CACHE_MAX_COUNT:int = 20;
		public static const SKILL_BUFFER_CACHE_MAX_COUNT:int = 20;
		public static const MAGIC_SKILL_CACHE_MAX_COUNT:int = 3;
		
		public static const SKILLRES_CACHE_MAX_COUNT:int = 10;
		public static const GROUNDEFFECT_CACHE_MAX_COUNT:int = 10;
		public static const GROUNDITEM_CACHE_MAX_COUNT:int = 5;	
		public static const DIEEFFECT_CACHE_MAX_COUNT:int = 5;
		
		private static const CREATENEW:String = "createNew";
		
		[Inject]
		public var logger:ILogger;
		[Inject]
		public var rasterUtil:MovieClipRasterizationUtil;
		[Inject]
		public var assetsService:ILoadAssetsServices;
		[Inject]
		public var injector:IInjector;

		private var _bitmapFrameInfosPool:Array;//resourceURL-> [scaleRatioType->BitmapFrameInfos, ...]
		private var _sceneElementsPool:Array;//category-> [objectTypeId->[object,...], ...
		
		private var _vecEmptyAttackerInfos:Vector.<AttackerInfo>;
		
		private var ptSize:Point = new Point;
		private var _dicUrlToMc:Dictionary;
		
		public function ObjectPoolManager()
		{
			super();
		}
		
		override public function onFightStart():void
		{
			super.onFightStart();
			_bitmapFrameInfosPool = [];
			_sceneElementsPool = [];
			_vecEmptyAttackerInfos = new Vector.<AttackerInfo>;
			_dicUrlToMc = new Dictionary(true);
		}
		
		override public function onFightEnd():void
		{
			super.onFightEnd();
			disposeSceneElementsPool();
			_sceneElementsPool = null;	
			disposeBitmapFramePool();
			_bitmapFrameInfosPool = null;	
			_dicUrlToMc = null;
			_vecEmptyAttackerInfos = null;
		}
		
		private function disposeSceneElementsPool():void
		{
			var object:Object = null;
			var groupObjects:Array = null;
			
			for each(groupObjects in _sceneElementsPool)
			{
				for each(var arrObjects:Array in groupObjects)
				{
					for each(object in arrObjects)
						disposeObject(object);
				}
			}
		}
		
		private function disposeBitmapFramePool():void
		{
			var object:Object = null;
			var groupObjects:Array = null;
			for each(groupObjects in _bitmapFrameInfosPool)
			{
				for each(object in groupObjects)
				{
					disposeObject(object);
				}
			}
		}
		/**
		 * 获得一个可用的空的攻击者信息用于填充
		 * @return 
		 * 
		 */		
		public function getEmptyAttackerInfo():AttackerInfo
		{
			_vecEmptyAttackerInfos ||= new Vector.<AttackerInfo>();
			var info:AttackerInfo;
			for each(info in _vecEmptyAttackerInfos)
			{
				if(!info.bUsed)
				{
					info.bUsed = true;
					return info;
				}
			}
			info = new AttackerInfo;
			info.bUsed = true;
			_vecEmptyAttackerInfos.push(info);
			return info;
		}
		
		public function getNewBitmapFrameInfos(resourceURL:String, scaleRatioType:int = OrganismBodySizeType.SIZE_NORMAL
											,startFrameName:Object=null,endFrameName:Object=null):Vector.<BitmapFrameInfo>
		{
			var subCategorys:Array = _bitmapFrameInfosPool[resourceURL];
			if(!_bitmapFrameInfosPool[resourceURL])
			{
				subCategorys = [];
				_bitmapFrameInfosPool[resourceURL] = subCategorys;
			}
			scaleRatioType ||= OrganismBodySizeType.SIZE_NORMAL;
				
			var bitmapFrameInfos:Vector.<BitmapFrameInfo> = subCategorys[scaleRatioType] as Vector.<BitmapFrameInfo>;
			if(1 == startFrameName && bitmapFrameInfos && bitmapFrameInfos.length>0 && bitmapFrameInfos[0])
				return bitmapFrameInfos;
			
			var mc:MovieClip = getMCByUrl(resourceURL);
			
			if(mc == null)
			{
				logger.warn("ObjectPoolManager::getBitmapFrameInfos resourceURL: " + 
					resourceURL + " scaleRatioType: " + 
					scaleRatioType);
				return null;
			}		
			var scale:Number = 1;
			if(scaleRatioType != OrganismBodySizeType.SIZE_NORMAL)
			{
				scale = (scaleRatioType == OrganismBodySizeType.SIZE_MIDDLE ? 
					GameFightConstant.MIDDLE_SIZE_BITMAP_SCLE_RATIO : 
					GameFightConstant.BIG_SIZE_BITMAP_SCLE_RATIO);
			}

			var tick:int = getTimer();
			subCategorys[scaleRatioType] = rasterUtil.rasterizeNew(ptSize,mc,scale,subCategorys[scaleRatioType],startFrameName,endFrameName);
			tick = getTimer() - tick;
			if(tick>200)
				logger.warn("[getNewBitmapFrameInfos] "+ resourceURL +" frameStart:"+startFrameName+" frameEnd:"+endFrameName +" tick: "+tick+" size: "+int(ptSize.x));			

			return subCategorys[scaleRatioType];
		}
		
		public function getMCByUrl(url:String):MovieClip
		{		
			_dicUrlToMc[url] ||= assetsService.domainMgr.getMovieClipByDomain(url,"FightRes");
			return _dicUrlToMc[url] as MovieClip;
		}
		
		public function rasterizeCurFrameInfo(resourceURL:String,scaleRatioType:int = OrganismBodySizeType.SIZE_NORMAL,curFrame:int=1):void
		{
			var subCategorys:Array = _bitmapFrameInfosPool[resourceURL];
			scaleRatioType ||= OrganismBodySizeType.SIZE_NORMAL;
			var bitmapFrameInfos:Vector.<BitmapFrameInfo> = subCategorys[scaleRatioType] as Vector.<BitmapFrameInfo>;
			var mc:MovieClip = getMCByUrl(resourceURL);
			var scale:Number = 1;
			if(scaleRatioType != OrganismBodySizeType.SIZE_NORMAL)
			{
				scale = (scaleRatioType == OrganismBodySizeType.SIZE_MIDDLE ? 
					GameFightConstant.MIDDLE_SIZE_BITMAP_SCLE_RATIO : 
					GameFightConstant.BIG_SIZE_BITMAP_SCLE_RATIO);
			}
			
			mc.gotoAndStop(curFrame);
			rasterUtil.rasterizeCurrentFrameToBitmap(mc,subCategorys[scaleRatioType][curFrame-1],scale);
		}

		//isAutoLifecycleActive 是否立即激活, 不然要调用object.notifyLifecycleActive();手动激活
		public function createSceneElementObject(category:String, 
												 elementTypeId:int = -1, 
												 isAutoLifecycleActive:Boolean = true):BasicSceneElement
		{
			elementTypeId = adjustSceneElementObjectTypeIdByCategory(category, elementTypeId);
			
			var object:BasicSceneElement = null;
			
			var categoryTypedObjects:Array = getCategoryTypedSceneElementObjectsPool(category, elementTypeId);
			if(categoryTypedObjects.length > 0)
			{
				object = categoryTypedObjects.pop();
			}
			else
			{
				var functionName:String = CREATENEW + category;
				if(this.hasOwnProperty(functionName))
				{
					object = this[functionName](elementTypeId) as BasicSceneElement;
				}
			}
			
			if(isAutoLifecycleActive)
			{
				//再次使用激活对象
				object.notifyLifecycleActive();
			}
			
			//否则，必须手动调用,一般在加激活对象前需要设置一些参数的时候需要这样做
			return object;
		}

		public function recycleSceneElementObject(sceneElement:BasicSceneElement):void
		{
			var elemeCategory:String = sceneElement.elemeCategory;
			var elementTypeId:int = sceneElement.objectTypeId;
			elementTypeId = adjustSceneElementObjectTypeIdByCategory(sceneElement.elemeCategory, sceneElement.objectTypeId);
			
			var categoryTypedObjects:Array = getCategoryTypedSceneElementObjectsPool(elemeCategory, elementTypeId);

			sceneElement.notifyLifecycleFreeze();
			
			if(isAllowRecycleObject(elemeCategory, elementTypeId, categoryTypedObjects.length))
			{
				if(categoryTypedObjects.indexOf(sceneElement) == -1)
					categoryTypedObjects.push(sceneElement);
				//放入缓存池并冻结对象
			}
			
			if(categoryTypedObjects.indexOf(sceneElement) == -1)
			{
				//直接销毁
				disposeObject(sceneElement);
			}
		}
		
		//打印当前缓存对象的信息
		public function printPoolInfo():void
		{
			for(var category:String in _sceneElementsPool)
			{
				var categoryGroups:Object = _sceneElementsPool[category];
				for(var typeId:String in categoryGroups)
				{
					var objects:Array = categoryGroups[typeId];
					var n:uint = objects != null && objects.length > 0 ? objects.length : 0;
					trace(category + "->" + "typeId->" + typeId + ": " + n);
				}
			}
		}
		
		private function disposeObject(object:Object):void
		{
			if(object is IDisposeObject)
			{
				IDisposeObject(object).dispose();
			}
			else if(object is Vector.<BitmapFrameInfo>)
			{
				for each(var bitmapFrameInfo:BitmapFrameInfo in object)
				{
					if(bitmapFrameInfo != null)
					{
						if(bitmapFrameInfo.bitmapData)
							bitmapFrameInfo.bitmapData.dispose();
						bitmapFrameInfo.bitmapData = null;
					}
				}
			}
		}
		
		private function isAllowRecycleObject(category:String, elementTypeId:int, curentCachedCount:int):Boolean
		{
			var limitCategoryChars:String = category.toUpperCase() + "_CACHE_MAX_COUNT";
			if(ObjectPoolManager[limitCategoryChars] == undefined) return true;
			
			var limitCategoryCount:uint = ObjectPoolManager[limitCategoryChars];
			return curentCachedCount < limitCategoryCount;
		}

		private function getCategoryTypedSceneElementObjectsPool(category:String, elementTypeId:int):Array
		{
			elementTypeId = adjustSceneElementObjectTypeIdByCategory(category, elementTypeId);

			var subCategory:Array = _sceneElementsPool[category];
			if(!subCategory)
			{
				subCategory = [];
				_sceneElementsPool[category] = subCategory;
			}
			
			var typedObjects:Array = subCategory[elementTypeId];
			if(!typedObjects)
			{
				typedObjects = [];
				subCategory[elementTypeId] = typedObjects;
			}

			return typedObjects;
		}
		
		private function adjustSceneElementObjectTypeIdByCategory(category:String, objectTypeId:int):int
		{
			switch(category)
			{
				/*case GameObjectCategoryType.TOFT:
					objectTypeId = 1;
					break;*/
				
				case GameObjectCategoryType.MONSTER:
					switch(objectTypeId)
					{
						//case 141019://寒冰之心
						//case 141028://灾难领主
						//case 142037://不朽巨龙
						//case 142046://沼泽之王
						//case 142047://元素分身
							//objectTypeId = 141001;
							//break;
					}
					break;
				
				case GameObjectCategoryType.BULLET:
					switch(objectTypeId)
					{
						case 20036://粉色光波，女巫塔的魅惑子弹
							objectTypeId = 20030;
							break;
						/*case 20024://女巫塔的子弹
							objectTypeId = 20025;
							break;*/
					}
					break;
				
//				case GameObjectCategoryType.SOLDIER:
//					objectTypeId = 12114;
//					break;
			}

			return objectTypeId;
		}

		//--Inner Impl Infact
		public function createNewMonster(elementTypeId:int):BasicMonsterElement
		{
			var monster:BasicMonsterElement;
			switch(elementTypeId)
			{
				case MonsterID.OrcOnWolf:
					monster = new OrcOnWolfMonster(elementTypeId);
					break;
				case MonsterID.Behemoth:
				case MonsterID.WhiteBehemoth:
					monster = new Behemoth(elementTypeId);
					break;
				case MonsterID.DemonSnowman:
					monster = new DemonSnowman(elementTypeId);
					break;
				case MonsterID.WolfPioneer:
					monster = new WolfPioneer(elementTypeId);
					break;
				case MonsterID.IceElement:
					monster = new IceElement(elementTypeId);
					break;
				case MonsterID.HeartOfIce:
					monster = new HeartOfIce(elementTypeId);
					break;
				case MonsterID.DisasterLord:
					monster = new DisasterLord(elementTypeId);
					break;
				case MonsterID.ImmortalDragon:
					monster = new ImmortalDragon(elementTypeId);
					break;
				case MonsterID.Skeletons:
					monster = new Skeletons(elementTypeId);
					break;
				case MonsterID.KingOfSwamp:
					monster = new KingOfSwamp(elementTypeId);
					break;
				case MonsterID.IcePhoenix:
					monster = new IcePhoenix(elementTypeId);
					break;
				default:
					monster = new BasicMonsterElement(elementTypeId);
					break;
			}
			injector.injectInto(monster);
			return monster;
		}
		
		public function createNewToft(elementTypeId:int):ToftElement
		{
			var toftElement:ToftElement = injector.instantiateUnmapped(ToftElement);
			return toftElement;
		}

		public function createNewTower(elementTypeId:int):BasicTowerElement
		{
			var basicTowerElement:BasicTowerElement = null;
			switch(elementTypeId)
			{
				case 111001://兵营1
				case 111002:
				case 111003:
				case 111004:
				case 111005:
				case 111006:
					basicTowerElement = new BarrackTowerElement(elementTypeId);
				break;
				
				case 113013://法师塔1
				case 113014:
				case 113015:
					basicTowerElement = new MagicTowerElement(elementTypeId);
					break;
				case 113017:
					basicTowerElement = new WitchTowerElement(elementTypeId);
					break;
				case 113018:
					basicTowerElement = new WizardTowerElement(elementTypeId);
					break;
				case 113016:
					basicTowerElement = new MysteryMagicTowerElement(elementTypeId);
					break;
				
				case 112007://箭塔1
				case 112008:
				case 112009:
				case 112010:
				case 112011:
				case 112012:
					basicTowerElement = new ArrowTowerElement(elementTypeId);
					break;
				
				
				case 114019://炮塔1
				case 114020:
				case 114021:
				case 114022:
				case 114024:
					basicTowerElement = new CannonTowerElement(elementTypeId);
					break;
				case 114023:
					basicTowerElement = new LongXiTowerElement(elementTypeId);
					break;
			}
			injector.injectInto(basicTowerElement);
			return basicTowerElement;
		}
		
		public function createNewHero(elementTypeId:int):HeroElement
		{
			var heroElement:HeroElement = null;
			switch(elementTypeId)
			{
				case 180001:
				case 180007:
					heroElement = new SilverHero(elementTypeId);
					break;
				case 180006:
					heroElement = new ShadowWarrior(elementTypeId);
					break;
				case 180003:
				case 180009:
					heroElement = new MagicMan(elementTypeId);
					break;
				case 180004:
				case 180010:
					heroElement = new Bomber(elementTypeId);
					break;
				case 180005:
					heroElement = new PowerOfNatural(elementTypeId);
					break;
				default:
					heroElement = new HeroElement(elementTypeId);
			}	
			injector.injectInto(heroElement);
			return heroElement;
		}
		
		public function createNewSoldier(elementTypeId:int):BarrackSoldierElement
		{
			var soldierElement:BarrackSoldierElement = null;
			soldierElement = new BarrackSoldierElement(elementTypeId);
			injector.injectInto(soldierElement);
			return soldierElement;
		}
		
		public function createNewCondottiereSoldier(elementTypeId:int):CondottiereSoldier
		{
			var soldierElement:CondottiereSoldier = null;
			soldierElement = new CondottiereSoldier(elementTypeId);
			injector.injectInto(soldierElement);
			return soldierElement;
		}
		
		public function createNewSupportSoldier(elementTypeId:int):SupportSoldier
		{
			var soldierElement:SupportSoldier = null;
			soldierElement = new SupportSoldier(elementTypeId);
			injector.injectInto(soldierElement);
			return soldierElement;
		}
		
		public function createNewSummonByOrganism(elementTypeId:int):SummonByOrganisms
		{
			var soldierElement:SummonByOrganisms = null;
			switch(elementTypeId)
			{
				default:
					soldierElement = new SummonByOrganisms(elementTypeId);
					break;
			}
			injector.injectInto(soldierElement);
			return soldierElement;
		}
		
		public function createNewSummonByTower(elementTypeId:int):SummonByTower
		{
			var soldierElement:SummonByTower = null;
			switch(elementTypeId)
			{
				default:
					soldierElement = new SummonByTower(elementTypeId);
					break;
			}
			injector.injectInto(soldierElement);
			return soldierElement;
		}
		
		public function createNewBullet(elementTypeId:int):BasicBulletEffect
		{
			var bulletEffect:BasicBulletEffect = null;
			switch(elementTypeId)
			{
				case BulletID.Shell1:
				case BulletID.Shell2:
				case BulletID.Shell3:
					bulletEffect = new ShellBulletEffect(elementTypeId);
					break;
				case BulletID.ZiMuBullet://子母弹
					bulletEffect = new ZiMuBulletEffect(elementTypeId);
					break;
				case BulletID.Arrow:
					bulletEffect = new ArrowBulletEffect(elementTypeId);
					break;
				case BulletID.DeadlyShuriken:
					bulletEffect = new DeadlyShurikenBullet(elementTypeId);
					break;
				
				case BulletID.Aerolite://普通陨石
				case BulletID.BigAerolite://流星陨石
					bulletEffect = new AeroliteBulletEffect(elementTypeId);
					break;

				case BulletID.Blaze:
					bulletEffect = new BlazeBulletEffect(elementTypeId);
					break;
				
				case BulletID.WitchRay:
					bulletEffect = new WitchRayEffect(elementTypeId);
					break;
				
				case BulletID.TrackMissile:
					bulletEffect = new TrackMissile(elementTypeId);
					break;
				
				case BulletID.FlyBullet:
					bulletEffect = new LetBulletFlyBulletEffect(elementTypeId);
					break;
				case BulletID.ArcaneBombBullet:
					bulletEffect = new ArcaneBombBulletEffect(elementTypeId);
					break;
				default:
					bulletEffect = new BasicBulletEffect(elementTypeId);
					break
			}
			injector.injectInto(bulletEffect);
			return bulletEffect;
		}
		
		public function createNewExplosion(elementTypeId:int):ExplosionEffect
		{
			var sceneExplosionEffect:ExplosionEffect = null;
			switch(elementTypeId)
			{
				case ExplosionID.Mire:
					sceneExplosionEffect = new MireEffect(elementTypeId);
					break;
				default:
					sceneExplosionEffect = new ExplosionEffect(elementTypeId);
					break;
			}
			injector.injectInto(sceneExplosionEffect);
			return sceneExplosionEffect;
		}
		
		public function createNewSkillRes(elementTypeId:int):BasicSkillEffectRes
		{
			var res:BasicSkillEffectRes = null;
			switch(elementTypeId)
			{
				case SkillID.SafeLaunch:
					res = new SafeLaunchSkillRes(elementTypeId);
					break;
				case SkillID.ColdStorm:
					res = new ColdStormSkillRes(elementTypeId);
					break;
				case SkillID.FlameRain:
					res = new FlameRainSkillRes(elementTypeId);
					break;
				case SkillID.SummonDemon:
					res = new SummonDemonDoorSkillRes(elementTypeId);
					break;
				case SkillID.BlackWind:
					res = new BlackWindSkillRes(elementTypeId);
					break;
				case ExplosionID.NeclareWeapon:
					res = new NuclareWeaponEff(elementTypeId);
					break;
				default:
					res = new BasicSkillEffectRes(elementTypeId);
					break;
			}
			injector.injectInto(res);
			return res;
		}
		
		public function createNewGroundEffect(elementTypeId:int):BasicGroundEffect
		{
			var res:BasicGroundEffect = null;
			switch(elementTypeId)
			{
				case GroundEffectID.IceMagicWandBig:
				case GroundEffectID.IceMagicWandSmall:
					res = new IceMagicWandGroundEff(elementTypeId);
					break;
				default:
					res = new BasicGroundEffect(elementTypeId);
					break;
			}
			injector.injectInto(res);
			return res;
		}
		
		public function createNewDieEffect(elementTypeId:int):BasicDieEffect
		{
			var res:BasicDieEffect = null;
			switch(elementTypeId)
			{
				default:
					res = new BasicDieEffect(elementTypeId);
					break;
			}
			injector.injectInto(res);
			return res;
		}
		
		public function createNewGroundItem(elementTypeId:int):BasicGroundItem
		{
			var item:BasicGroundItem = null;
			switch(elementTypeId)
			{
				default:
					item = new BasicGroundItem(elementTypeId);
					break;
			}
			injector.injectInto(item);
			return item;
		}

		public function createNewSceneTip(elementTypeId:int):SceneTipEffect
		{
			var sceneTipEffect:SceneTipEffect = null;
			sceneTipEffect = new SceneTipEffect(elementTypeId);
			injector.injectInto(sceneTipEffect);
			return sceneTipEffect;
		}
		
		public function createNewOrganismSkillBuffer(elementTypeId:int):BasicBufferResource
		{
			var organismSkillBufferEffect:BasicBufferResource = null;
			switch(elementTypeId)
			{
				case BufferID.Vampire:
				case BufferID.LetBulletFly:
					organismSkillBufferEffect = new SpecialBufferRes(elementTypeId);
					break;
				default:
					organismSkillBufferEffect = new BasicBufferResource(elementTypeId); 
					break;
			}	
			injector.injectInto(organismSkillBufferEffect);
			return organismSkillBufferEffect;
		}	
		
		public function createNewMagicSkill(elementTypeId:int):BasicMagicSkillEffect
		{
			var magicSkillEffect:BasicMagicSkillEffect = null;
			var parseId:int = elementTypeId*0.01;
			switch(parseId)
			{
				case int(MagicID.NaturalAngry*0.01):
					magicSkillEffect = new ZiRanZhiRuMagicSkill(elementTypeId);
					break;
				
				case int(MagicID.LightShines*0.01):
					magicSkillEffect = new ShengGuangPuZhaoMagicSkill(elementTypeId);
					break;
				
				case int(MagicID.DoorOfDimensional*0.01):
					magicSkillEffect = new YiCiYuanZhiMenMagicSkill(elementTypeId);
					break;
				
				case int(MagicID.Earthquake*0.01):
					magicSkillEffect = new DaDiZhenchanMagicSkill(elementTypeId);
					break;
				
				case int(MagicID.Blizzard*0.01):
				case int(MagicID.Blizzard1*0.01):
				case int(MagicID.Blizzard2*0.01):
					magicSkillEffect = new BaoFengXueMagicSkill(elementTypeId);
					break;
				
				case int(MagicID.PlagueSpread*0.01):
					magicSkillEffect = new WenYiManYanMagicSkill(elementTypeId);
					break;
				
				case int(MagicID.FlameCurse*0.01):
					magicSkillEffect = new HuoYanZuZhouMagicSkill(elementTypeId);
					break;
				
				case int(MagicID.QingQiuZhiYuan*0.01):
				case int(MagicID.QingQiuZhiYuan1*0.01):
				case int(MagicID.QingQiuZhiYuan2*0.01):
					magicSkillEffect = new QingQiuZhiYuanMagicSkill(elementTypeId);
					break;
				
				case int(MagicID.GoblinBomb*0.01):
					magicSkillEffect = new GoblinBombMagicSkill(elementTypeId);
					break;
				case int(MagicID.MarmotWhistle*0.01):	
					magicSkillEffect = new MarmotWhistleMagicSkill(elementTypeId);
					break;
				case int(MagicID.GoblinThunder*0.01):	
				case int(MagicID.GoblinThunder1*0.01):
				case int(MagicID.GoblinThunder2*0.01):
					magicSkillEffect = new GoblinThunderMagicSkill(elementTypeId);
					break;
				case int(MagicID.WorkerRope*0.01):		
					magicSkillEffect = new WorkerRopeMagicSkill(elementTypeId);
					break;
				case int(MagicID.FreshApple*0.01):
					magicSkillEffect = new FreshAppleMagicSkill(elementTypeId);
					break;
				case int(MagicID.NuclearWeapon*0.01):
					magicSkillEffect = new FullScreenKillMonster(elementTypeId);
					break;
				case int(MagicID.IceMagicWand*0.01):
					magicSkillEffect = new FullScreenFreezeEnemy(elementTypeId);
					break;
			}
			injector.injectInto(magicSkillEffect);
			return magicSkillEffect;
		}
	}
}