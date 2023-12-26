package objects;

import cpp.Function;
import flixel.FlxG;

class Misiones extends FlxSpriteGroup {
    //Files
    var BG:FlxSprite;
    var Path:String = 'Misiones/';

    //Texts
    var titleText:FlxText;
    var misionsText:FlxText;

    public function new(misiones:String, duration:Float, ?camera:FlxCamera) {
        super(x, y);
        ClientPrefs.saveSettings();

        BG = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image(Path + 'bgMisions'));
        BG.antialiasing = ClientPrefs.data.antialiasing;
        BG.screenCenter(Y);
        BG.alpha = 0;

        titleText = new FlxText(BG.width / 2,BG.height - 7, 0, "misiones", 32);
        titleText.setFormat("miss.ttf", 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        titleText.antialiasing = ClientPrefs.data.antialiasing;
        titleText.alpha = 0;

        misionsText = new FlxText(BG.width / 2, 0, 0, misiones, 32);
        misionsText.setFormat("miss.ttf", 32, FlxColor.WHITE, CENTER, OUTLINE_FAST, FlxColor.BLACK);
        misionsText.screenCenter(Y);
        misionsText.antialiasing = ClientPrefs.data.antialiasing;
        misionsText.alpha = 0;

        add(BG);
        add(titleText);
        add(misionsText);

        var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
        if (cam != null) {
            cam = [camera];
        }

        this.cameras = cam;

        FlxTween.tween(this, {alpha: 1}, duration / 2, {
            onComplete: function(twn:FlxTween) {
                moveObjects(FlxG.width - BG.width, duration);
            }
        });
    }

    public function moveObjects(?x:Float, ?duration:Float) {
        FlxTween.tween(this, {x: x}, duration / 2, {
            onComplete: function(twn:FlxTween) {
                FlxTween.tween(this, {x: this.x - x}, duration / 2, {
                    onComplete: function(twn:FlxTween) {
                        FlxTween.tween(this, {alpha: 0}, 0.2, {
                            onComplete: function(twn:FlxTween) {
                                this.destroy();
                            }
                        });
                    }
                });
            }
        });
    }
}