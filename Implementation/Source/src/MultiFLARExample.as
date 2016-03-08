package {
	//import stuff
	import flash.events.Event;
	import com.greensock.*;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.materials.ColorMaterial;
	import flash.geom.ColorTransform;
	import flash.filters.*;
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import org.papervision3d.objects.parsers.Collada;
	
	import com.squidder.flar.FLARMarkerObj;
	import com.squidder.flar.PVFLARBaseApplication;
	import com.squidder.flar.events.FLARDetectorEvent;		

	
	public class MultiFLARExample extends PVFLARBaseApplication {
		// variables that work throughout the code
		private var _cubes : Array;
		private var _lightPoint : PointLight3D;
		private var _green:Cube;
		private var drama:dramatic = new dramatic();
		private var dramaChnl:SoundChannel = new SoundChannel();
		private var cowSkin: BitmapFileMaterial;
		private var cowMat: MaterialsList;
		private var cow: Collada;
		private var moo:mooSnd = new mooSnd();
		private var mooChnl:SoundChannel = new SoundChannel();

		public function MultiFLARExample() {
			
			_cubes = new Array();
			
		// import the marker pattern
			_markers = new Array();
			_markers.push( new FLARMarkerObj( "assets/flar/kmarker.pat" , 16 , 50 , 80 ) );
			_markers.push( new FLARMarkerObj( "assets/flar/kickdrum.pat" , 16 , 50 , 80 ) );
			_markers.push( new FLARMarkerObj( "assets/flar/ride.pat" , 16 , 50 , 80 ) );
			_markers.push( new FLARMarkerObj( "assets/flar/snare.pat" , 16 , 50 , 80 ) );
			
			super( );
		}
		
		override protected function _init( event : Event ) : void {

			super._init( event );	
			
			_lightPoint = new PointLight3D( );
			_lightPoint.y = 1000;
			_lightPoint.z = -1000;
			
		}
		//detecting the marker
		override protected function _detectMarkers() : void {
			
			_resultsArray = _flarDetector.updateMarkerPosition( _flarRaster , 80 , .5 );
			
			for ( var i : int = 0 ; i < _resultsArray.length ; i ++ ) {
				
				var subResults : Array = _resultsArray[ i ];
				
				for ( var j : * in subResults ) {
					
					_flarDetector.getTransmationMatrix( subResults[ j ], _resultMat );
					if ( _cubes[ i ][ j ] != null ) transformMatrix( _cubes[ i ][ j ] , _resultMat );
				}
				
			}
				
			
		}		
		
		override protected function _handleMarkerAdded( event : FLARDetectorEvent ) : void {
			
			_addCube( event.codeId , event.codeIndex );
		}

		override protected function _handleMarkerRemove( event : FLARDetectorEvent ) : void {
	
			_removeCube( event.codeId , event.codeIndex );
	
		}
		
		//adding your objects
		
		private function _addCube( id:int , index:int ) : void {
		//make the cow moo
			if(id==1){
				mooChnl = moo.play(0, 1);
			}
			
			if ( _cubes[ id ] == null ) _cubes[ id ] = new Array();
			
			if ( _cubes[ id ][ index ] == null ) {

		//material set up
				var fmat : FlatShadeMaterial = new FlatShadeMaterial( _lightPoint , 0xff22aa , 0x75104e );
				var fmat2 : FlatShadeMaterial = new FlatShadeMaterial( _lightPoint , 0x00ff00 , 0x113311 );
				var fmat3 : FlatShadeMaterial = new FlatShadeMaterial( _lightPoint , 0x0000ff , 0x111133 ); 
				var fmat4 : FlatShadeMaterial = new FlatShadeMaterial( _lightPoint , 0x777777 , 0x111111 ); 
				var earth : BitmapFileMaterial = new BitmapFileMaterial("assets/map.jpg");
				var dispObj : DisplayObject3D = new DisplayObject3D();
				var star : ColorMaterial = new ColorMaterial(0xFFFFFF);
				var Top : BitmapFileMaterial = new BitmapFileMaterial("assets/top.png");
				var Bottom : BitmapFileMaterial = new BitmapFileMaterial("assets/bottom.png");
				var Left : BitmapFileMaterial = new BitmapFileMaterial("assets/left.png");
				var Right : BitmapFileMaterial = new BitmapFileMaterial("assets/right.png");
				
		//the "green screen" effect, masks out the colour green
				this.viewport.filters = [
                new ColorMatrixFilter([
                    1, 0, 0, 0, 0,
                   0, 1, 0, 0, 0,
                    0, 0, 1, 0, 0,
                    1, -1, 1, 1, 0
                ])
            ];
				
				if (id==0){
		//creating the inner cube
					var hole:Cube = dispObj.addChild(new Cube(new MaterialsList({all:new  BitmapFileMaterial( "assets/hole.jpg" ), bottom: new  BitmapFileMaterial( "assets/k.jpg" )}), 80, 80,80,1,1,1, Cube.ALL,Cube.TOP)) as Cube;
					
		//creating the green cube or outer cube
           			 this._green = dispObj.addChild(new Cube(new MaterialsList({all: new ColorMaterial(0x00ff00)}), 80, 80,80, 1, 1, 1, Cube.TOP)) as Cube;
            		hole.rotationX = this._green.rotationX =90;
					hole.z = this._green.z = -40;
		
		//create the earth
					var Earth:Sphere = new Sphere(earth, 1);
					Earth.z=-40;
					TweenMax.to(Earth, 4,{scaleX:40, scaleY:40, scaleZ:40, z:"200", delay:4});
					dispObj.addChild(Earth);
				
		//create the stars
					var star1:Sphere = new Sphere(star, 1);
					star1.z=-40;
					TweenMax.to(star1, 4,{scaleX:1, scaleY:1, scaleZ:1, x:"84", y:"164", z:"65", delay:4});
					dispObj.addChild(star1);
					
					var star2:Sphere = new Sphere(star, 1);
					star2.z=-40;
					TweenMax.to(star2, 4,{scaleX:3, scaleY:3, scaleZ:3, x:"32", y:"64", z:"246", delay:4});
					dispObj.addChild(star2);
					
					var star3:Sphere = new Sphere(star, 1);
					star3.z=-40;
					TweenMax.to(star3, 4,{scaleX:2, scaleY:2, scaleZ:2, x:"78", y:"98", z:"163", delay:4});
					dispObj.addChild(star3);
					
					var star4:Sphere = new Sphere(star, 1);
					star4.z=-40;
					TweenMax.to(star4, 4,{scaleX:4, scaleY:4, scaleZ:4, x:"164", y:"157", z:"120", delay:4});
					dispObj.addChild(star4);
					
					var star5:Sphere = new Sphere(star, 1);
					star5.z=-40;
					TweenMax.to(star5, 4,{scaleX:2, scaleY:2, scaleZ:2, x:"-164", y:"-157", z:"148", delay:4});
					dispObj.addChild(star5);
					
					var star6:Sphere = new Sphere(star, 1);
					star6.z=-40;
					TweenMax.to(star6, 4,{scaleX:3, scaleY:3, scaleZ:3, x:"-36", y:"-156", z:"46", delay:4});
					dispObj.addChild(star6);
					
					var star7:Sphere = new Sphere(star, 1);
					star7.z=-40;
					TweenMax.to(star7, 4,{scaleX:5, scaleY:5, scaleZ:5, x:"-16", y:"-84", z:"40", delay:4});
					dispObj.addChild(star7);
					
					var star8:Sphere = new Sphere(star, 1);
					star8.z=-40;
					TweenMax.to(star8, 4,{scaleX:5, scaleY:5, scaleZ:5, x:"-84", y:"30", z:"59", delay:4});
					dispObj.addChild(star8);
					
					var star9:Sphere = new Sphere(star, 1);
					star9.z=-40;
					TweenMax.to(star9, 4,{scaleX:4, scaleY:4, scaleZ:4, x:"-134", y:"84", z:"87", delay:4});
					dispObj.addChild(star9);
					
					var star10:Sphere = new Sphere(star, 1);
					star10.z=-40;
					TweenMax.to(star10, 4,{scaleX:2, scaleY:2, scaleZ:2, x:"10", y:"18", z:"49", delay:4});
					dispObj.addChild(star10);
					
					var star11:Sphere = new Sphere(star, 1);
					star11.z=-40;
					TweenMax.to(star11, 4,{scaleX:5, scaleY:5, scaleZ:5, x:"-84", y:"41", z:"94", delay:4});
					dispObj.addChild(star11);
					
					var star12:Sphere = new Sphere(star, 1);
					star12.z=-40;
					TweenMax.to(star12, 4,{scaleX:3, scaleY:3, scaleZ:3, x:"91", y:"-46", z:"54", delay:4});
					dispObj.addChild(star12);
					
					var star13:Sphere = new Sphere(star, 1);
					star13.z=-40;
					TweenMax.to(star13, 4,{scaleX:2, scaleY:2, scaleZ:2, x:"88", y:"-130", z:"180", delay:4});
					dispObj.addChild(star13);
					
					var star14:Sphere = new Sphere(star, 1);
					star14.z=-40;
					TweenMax.to(star14, 4,{scaleX:4, scaleY:4, scaleZ:4, x:"134", y:"-13", z:"102", delay:4});
					dispObj.addChild(star14);
					
					var star15:Sphere = new Sphere(star, 1);
					star15.z=-40;
					TweenMax.to(star15, 4,{scaleX:1, scaleY:1, scaleZ:1, x:"-35", y:"145", z:"61", delay:4});
					dispObj.addChild(star15);
					
					
			//Create the box lid
					var top:Cube = new Cube( new MaterialsList( {all: Top} ) , 80 , 0 , 80 ); 
					top.z=0;
					top.y=40;
					 TweenMax.to(top, 2,{rotationX:-180, delay:2});
					  dispObj.addChild(top);
					 
					var bottom:Cube = new Cube( new MaterialsList( {all: Bottom} ) , 80 , 0 , 80 ); 
					bottom.z=0;
					bottom.y=-40;
					 TweenMax.to(bottom, 2,{rotationX:180, delay:2}); 
					 dispObj.addChild(bottom);
					 
					var left:Cube = new Cube( new MaterialsList( {all: Left} ) , 80 , 0 , 80 ); 
					left.z=0;
					left.rotationZ=90;
					left.x=-40;
					 TweenMax.to(left, 2,{rotationX:180, delay:2}); 
					 dispObj.addChild(left);
					 
					var right:Cube = new Cube( new MaterialsList( {all: Right} ) , 80 , 0 , 80 ); 
					right.z=0;
					right.x=40;
					right.rotationZ=90;
					 TweenMax.to(right, 2,{rotationX:-180, delay:2}); 
					  dispObj.addChild(right);	
					  
			//Play a really dramatic sound
					dramaChnl = drama.play(0,1);
					
					
				} else if(id==1){
			//set up the cow's materials						
					cowMat       = new MaterialsList();
           			cowSkin  = new BitmapFileMaterial("assets/Cow.png");
            		cowMat.addMaterial(cowSkin,"all");
           
            //Create the new Collada Object with materialList
           			cow = new Collada("assets/cow.dae",cowMat);
				 	cow.rotationX = 90;
					cow.scale = 0.5;
					dispObj.addChild(cow);
				
				} 
				_baseNode.addChild( dispObj );
				
				_cubes[ id ][ index ] = dispObj;
				
			} 
				
			_baseNode.addChild( _cubes[ id ][ index ] );
			
		}
		
		//The remove cube function. Gets activated once a marker is removed
		private function _removeCube( id:int , index:int ) : void {

			if ( _cubes[ id ] == null ) _cubes[ id ] = new Array();

			if ( _cubes[ id ][ index ] != null ) {
				
				_baseNode.removeChild( _cubes[ id ][ index ] );
			}
		}		

		
	}
}
