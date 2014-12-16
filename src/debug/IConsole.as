package debug 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
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
		private var _FPS:uint;
		private var _FPSTimer:uint;
		private var _FPSVec:Vector.<uint>;
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
			_FPSTimer = 60;
			_FPSVec = new Vector.<uint>();
			_tDelay = 20;
		}
		
		public function show():void
		{
			if (!_consoleVisible)
			{
				this.alpha = 1;
				_consoleVisible = true;
			}
		}
		
		public function hide():void
		{
			if (_consoleVisible)
			{
				this.alpha = 0;
				_consoleVisible = false;
			}
		}
		
		public function appendOutput(...rest):void
		{
			for each(var item:* in rest) 
			{
				_outputPane.appendText(item);
				_outputPane.scrollV = _outputPane.numLines - 3;
			}
		}
		
		public function setSelection(e:MouseEvent):void
		{
			_selection = e.target;
		}
		
		public function update():void
		{
			_mouseXY.text = "X: " + mouseX + ", Y: " + mouseY;
			currentFPS();
			testMemory();
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
			println("[AE] :: DEBUG_MODE : TRUE CONSOLE\n[AE] :: Console mode changed.");
			_selectionName.text = "Current Selection: Stage";
			_selectionX.text = "" + stage.x;
			_selectionY.text = "" + stage.y;
			resData.text = "dix";
			displayObjNum.text = addDebugMouseListeners(location).toString();
		}
		
		private function currentFPS():void 
		{
			_FPS++;
		}
		
		private function testMemory():void 
		{
			if (!_FPSTimer)
			{
				_FPSVec.push(_FPS);
				
				if(_FPSVec.length == 4)
				{
					for (var i:int = 1; i < _FPSVec.length; i++)
					{	
						_FPSVec[0] += _FPSVec[i];
					}
					_FPSVec.splice(1, _FPSVec.length - 1);
					_FPSVec[0] /= 4;
				}
				
				resData.text = "FPS: " + _FPS + " || AVG_FPS: " + Math.round(_FPSVec[0]) + " || MEM: " + Math.round(System.privateMemory / 1024 / 1024).toString() + " MB";
				_FPS = 0;
				_FPSTimer = 60;
			}
			else --_FPSTimer;
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