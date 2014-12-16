package core 
{
	import core.ResourceLoader;
	import enums.ResourceType;
	import events.UMIBEvent;
	import events.UMIBEventManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.PsychoUtils;
	
	/**
	 * ...
	 * @author Psycho
	 */
	public class RecLoader extends Sprite
	{
		
		
		private var _passBack:Main;
		private var _preloader:ResourceLoader;
		private var _resources:Object = { };
		private var _textDataList:Array;
		private var _textDataNameList:Array;
		private var _resourceList:Array;
		private var _resourceNameList:Array;
		
		public function RecLoader()
		{
			super();
		}
		
		public function addResource(res:Object, type:String):void
		{
			if (type == ResourceType.DISPLAY_OBJECT)
			{
				if (!_resourceList) _resourceList = [];
				if (!_resourceNameList) _resourceNameList = [];
				_resourceList.push(res.url);
				_resourceNameList.push(res.name);
			}
			else if (type == ResourceType.PLAIN_TEXT)
			{
				if (!_textDataList) _textDataList = [];
				if (!_textDataNameList) _textDataNameList = [];
				_textDataList.push(res.url);
				_textDataNameList.push(res.name);
			}
		}
		
		public function loadResources():void
		{
			if (_resourceList) loadVisuals();
			else if (!_resourceList && _textDataList) loadData();
		}
		
		private function loadVisuals():void 
		{
			_preloader = new ResourceLoader(_resourceList);
			_preloader.addEventListener("preloadProgress", onPreloadProgress);
			_preloader.addEventListener("preloadComplete", onPreloadComplete);
		}
		
		private function onPreloadProgress(e:Event):void 
		{
		}
		
		private function onPreloadComplete(e:Event):void 
		{
			_preloader.removeEventListener("preloadProgress", onPreloadProgress);
			_preloader.removeEventListener("preloadComplete", onPreloadComplete);
			
			for (var i:int = 0; i < _preloader.objects.length; i++)
			{
				_resources[_resourceNameList[i]] = _preloader.objects[i];
			}
			if (_textDataList) loadData();
			else UMIBEventManager.dispatchEvent(new UMIBEvent(UMIBEvent.LOAD_COMPLETE, _resources ));
		}
		
		private function loadData():void 
		{
			PsychoUtils.loadResource(_textDataList);
			UMIBEventManager.addEventListener(UMIBEvent.TEXT_LOAD_COMPLETE, onTextDataLoaded );
			
		}
		
		private function onTextDataLoaded(e:UMIBEvent):void 
		{
			for (var i:int = 0; i < e.data.length; i++)
			{
				_resources[_textDataNameList[i]] = e.data[i];
			}
			UMIBEventManager.dispatchEvent(new UMIBEvent(UMIBEvent.LOAD_COMPLETE, _resources ));
		}
	}

}