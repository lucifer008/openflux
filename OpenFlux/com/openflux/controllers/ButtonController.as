package com.openflux.controllers
{
	import com.openflux.core.FluxController;
	import com.openflux.core.IEnabled;
	import com.openflux.core.IFluxController;
	import com.openflux.core.ISelectable;
	import com.openflux.constants.ButtonStates;
	
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	import mx.core.IStateClient;
	import mx.events.PropertyChangeEvent;
	
	[ViewHandler(event="rollOver", handler="rollOverHandler")]
	[ViewHandler(event="rollOut", handler="rollOutHandler")]
	[ViewHandler(event="mouseDown", handler="mouseDownHandler")]
	[ViewHandler(event="mouseUp", handler="mouseUpHandler")]
	[EventHandler(event="propertyChange", handler="propertyChangeHandler")]
	
	/**
	 * Default Button controller handling current state and selection
	 */
	public class ButtonController extends FluxController implements IFluxController
	{
		[StyleBinding] public var selectable:Boolean;
		[ModelAlias(required="false")] public var ec:IEnabled;
		[ModelAlias(required="false")] public var sc:ISelectable;
		
		/**
		 * Constructor
		 */
		public function ButtonController() {
			super();
		} 
		
		// ========================================
		// Event handlers
		// ========================================
		
		metadata function propertyChangeHandler(event:PropertyChangeEvent):void {
			switch(event.property) {
				case "selected": 
				case "enabled" :
					(component as IStateClient).currentState = resolveState(component.view.state);
			}
		}
		
		metadata function rollOverHandler(event:MouseEvent):void {
			(component as IStateClient).currentState = resolveState(ButtonStates.OVER);
		}
		
		metadata function rollOutHandler(event:MouseEvent):void {
			(component as IStateClient).currentState = resolveState(ButtonStates.UP);
		}
		
		metadata function mouseDownHandler(event:MouseEvent):void {
			(component as IStateClient).currentState = resolveState(ButtonStates.DOWN);
		}
		
		metadata function mouseUpHandler(event:MouseEvent):void {
			if(sc && selectable) { sc.selected = !sc.selected; }
			(component as IStateClient).currentState = resolveState(ButtonStates.OVER);
		}
		
		// ========================================
		// Private utility methods
		// ========================================
		
		private function resolveState(state:String):String {
			var selected:Boolean = (sc) ? sc.selected : false;
			if(!ec || ec.enabled) {
				switch(state) {
					case ButtonStates.OVER:
						return selected ? ButtonStates.SELECTED_OVER : ButtonStates.OVER;
						break;
					case ButtonStates.DOWN:
						return selected ? ButtonStates.SELECTED_DOWN : ButtonStates.DOWN;
						break;
					case ButtonStates.UP:
					default:
						return selected ? ButtonStates.SELECTED_UP : ButtonStates.UP;
						break;
				}
			} else {
				return ButtonStates.DISABLED;
			}
		}
	}
}