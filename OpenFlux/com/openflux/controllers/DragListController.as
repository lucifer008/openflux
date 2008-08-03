package com.openflux.controllers
{
	import com.openflux.core.IFluxController;
	import com.openflux.core.IFluxList;
	import com.openflux.core.MetaControllerBase;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.DragSource;
	import mx.core.IDataRenderer;
	import mx.core.IUIComponent;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	/*
	[Event("dragStart")]
	[Event("dragComplete")]
	*/
	
	[ViewHandler(event="childAdd", handler="childAddHandler")]
	[ViewHandler(event="childRemove", handler="childRemoveHandler")]
	[EventHandler(event="dragComplete", handler="dragCompleteHandler")]
	
	public class DragListController extends MetaControllerBase implements IFluxController
	{
		
		public var dragEnabled:Boolean = true;
		
		[ModelAlias] public var list:IFluxList;
		[ModelAlias] public var dispatcher:IEventDispatcher;
		
		public function DragListController()
		{
			super(function(t:*):*{return this[t]});
		}
		
		
		//***************************************************************
		// Event Listeners
		//***************************************************************
		
		private function childAddHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.addEventListener(MouseEvent.MOUSE_DOWN, child_mouseDownHandler, false, 0, true);
		}
		
		private function childRemoveHandler(event:ChildExistenceChangedEvent):void {
			var child:DisplayObject = event.relatedObject;
			child.removeEventListener(MouseEvent.MOUSE_DOWN, child_mouseDownHandler, false);
		}
		
		private function child_mouseDownHandler(event:MouseEvent):void {
			var instance:DisplayObject = event.currentTarget as DisplayObject;
			instance.addEventListener(MouseEvent.MOUSE_UP, child_mouseUpHandler, false, 0, true);
			instance.addEventListener(MouseEvent.MOUSE_MOVE, child_mouseMoveHandler, false, 0, true);
		}
		
		private function child_mouseUpHandler(event:MouseEvent):void {
			var instance:DisplayObject = event.currentTarget as DisplayObject;
			instance.removeEventListener(MouseEvent.MOUSE_UP, child_mouseUpHandler, false);
			instance.removeEventListener(MouseEvent.MOUSE_MOVE, child_mouseMoveHandler, false);
		}
		
		private function child_mouseMoveHandler(event:MouseEvent):void {
			var instance:DisplayObject = event.currentTarget as DisplayObject;
			instance.removeEventListener(MouseEvent.MOUSE_UP, child_mouseUpHandler, false);
			instance.removeEventListener(MouseEvent.MOUSE_MOVE, child_mouseMoveHandler, false);
			
			// add some data
			var source:DragSource = new DragSource();
			if(instance is IDataRenderer) { // need to cover multiple items
				source.addData((instance as IDataRenderer).data, "data");
			}
			
			// create image
			DragManager.doDrag(instance as IUIComponent, source, event);
			// does doDrag dispatch this for us?
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_START, false, true, instance as IUIComponent, source, null, event.ctrlKey, event.altKey, event.shiftKey);
			dispatcher.dispatchEvent(dragEvent);
		}
		
		private function dragCompleteHandler(event:DragEvent):void {
			// trace(event);
			var data:Object = event.dragSource.dataForFormat("data");
			var collection:IList = list.data as IList;
			var index:int = collection.getItemIndex(data);
			collection.removeItemAt(index);
		}
		
	}
}