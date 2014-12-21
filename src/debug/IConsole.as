package debug 
{
	import com.greensock.TweenLite;
	import debug.printf;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import input.Key;
	import utils.VirtualCamera;
	/**
	 * ...
	 * @author Psycho
	 */
	public class IConsole extends Console
	{
		private var _consoleVisible:Boolean;
		private var _outputPane:TextField;
		private var _mouseXY:TextField;
		private var _cameraXY:TextField;
		private var _selection:*;
		private var _selectionName:TextField;
		private var _selectionX:TextField;
		private var _selectionY:TextField;
		private var _vCam:VirtualCamera;
		private var _totalChildren:uint;
		private var _frames:uint;
		private var _FPS:uint;
		private var _FPSPrev:uint;
		private var _FPSVec:Vector.<int>;
		private var _tDelay:uint;
		
		
		public function IConsole() 
		{
			_outputPane = outputPane;
			_mouseXY = mouseTXT;
			_cameraXY = camTXT;
			_selectionName = currentSelectionName;
			_selectionX = selectionX;
			_selectionY = selectionY;
			_totalChildren = 0;
			_FPS = 0;
			_FPSPrev = 0;
			_FPSVec = new Vector.<int>();
			_tDelay = 20;
		}
		
		public function show(e:MouseEvent = null):void
		{
			if (toggleVisuals.hasEventListener(MouseEvent.CLICK)) 
			{
				toggleVisuals.removeEventListener(MouseEvent.CLICK, show);
				printf("removed listener");
				toggleVisuals.addEventListener(MouseEvent.CLICK, hide);
			}
			
			if (!_consoleVisible)
			{
				this.alpha = 1;
				_consoleVisible = true;
			}
		}
		
		public function hide(e:MouseEvent = null):void
		{
			if (toggleVisuals.hasEventListener(MouseEvent.CLICK)) 
			{
				toggleVisuals.removeEventListener(MouseEvent.CLICK, hide);
				printf("removed listener");
			}
			
			if (_consoleVisible)
			{
				this.alpha = 0;
				_consoleVisible = false;
			}
		}
		
		public function appendOutput(output:String = ""):void
		{
			_outputPane.appendText(output+"\n");
			_outputPane.scrollV = _outputPane.numLines - 3;
		}
		
		public function setSelection(e:MouseEvent):void
		{
			_selection = e.target;
		}
		
		public function update():void
		{
			_mouseXY.text = "X: " + mouseX + ", Y: " + mouseY;
			incrementFPS();
			performanceTest();
			if (_vCam) _cameraXY.text = _vCam.x + ", " + _vCam.y;
			if (_selection) 
			{
				_selectionName.text = String(_selection).substring(8, String(_selection).length - 1);
				_selectionX.text = _selection.x.toString();
				_selectionY.text = _selection.y.toString();
			}
			if (!_tDelay)
			{
				if (Key.isDown(Key.T))
				{
					if (_consoleVisible) hide();
					else show();
					_tDelay = 20;
				}
			}
			else --_tDelay;
			
		}
		
		public function init(location:DisplayObjectContainer):void 
		{
			_consoleVisible = true;
			
			resData.text = "Initiating performance test...";
			_selectionName.text = "Current Selection: Stage";
			printf("console initated.");
			
			_selectionX.text = "" + stage.x;
			_selectionY.text = "" + stage.y;
			displayObjNum.text = addDebugMouseListeners(location).toString();
			
			toggleVisuals.addEventListener(MouseEvent.CLICK, hide);
		}
		
		private function incrementFPS():void 
		{
			_frames++;
		}
		
		private function performanceTest():void 
		{
			_FPS = getTimer();
			
			if (_FPSVec.length > 4)
			{
				_FPSVec[0] = _FPSVec[_FPSVec.length - 1];
				_FPSVec.pop();
			}
			
			if (_FPS - _FPSPrev >= 1000) 
			{
				var avgFPS:uint = 0;
				var vecLength:uint = _FPSVec.length;
				for (var i:uint = 0; i < vecLength; i++) avgFPS += _FPSVec[i];
				avgFPS = avgFPS / vecLength;
				
				_FPSVec.push(Math.floor(_frames * 1000 / (_FPS - _FPSPrev)));
				resData.text = "FPS: " + _FPSVec[vecLength] + " || AVG_FPS: " + avgFPS +" || MEM: " + Math.round(System.privateMemory / 1024 / 1024).toString() + " MB";
				
				_FPSPrev = _FPS;
				_frames = 0;
				
			}
		}
		
		public function addDebugMouseListeners(dOC:DisplayObjectContainer):uint
		{
			var numCh:int = dOC.numChildren;
			
			for (var i:int = 0; i < numCh; i++)
			{
				var child:* = dOC.getChildAt(i);
				child.addEventListener(MouseEvent.CLICK, setSelection);
				++_totalChildren;
				
				if (child is DisplayObjectContainer && child.numChildren > 0)
				{
					addDebugMouseListeners(child);
				}
			}
			return _totalChildren;
		}
		
		public function setCamera(vCam:VirtualCamera):void 
		{
			_vCam = vCam;
		}
	}
}