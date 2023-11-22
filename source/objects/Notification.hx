package objects;

import cpp.Function;
import flixel.FlxG;

class Notification extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;

	//Files
	var achievementIcon:FlxSprite;
	var achievementBG:FlxSprite;
	var notiBG:FlxSprite;

	//Texts
	var notiName:FlxText;
	var notiText:FlxText;

	public function new(Title:String, description:String, ?type:Int, ?camera:FlxCamera, ?Duration:Float)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		achievementBG = new FlxSprite(-990, 0).makeGraphic(420, 120, FlxColor.BLACK);
		achievementBG.scrollFactor.set();

		notiBG = new FlxSprite(-1000, -20).loadGraphic(Paths.image('notification_box'));
		notiBG.setGraphicSize(420, 130);
		notiBG.scrollFactor.set();

		var Gx:Float = achievementBG.x + 10;
		var Gy:Float = achievementBG.y + 10;

		achievementIcon = new FlxSprite(Gx, Gy);
		achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 3)));
		achievementIcon.updateHitbox();

		notiName = new FlxText(achievementIcon.x + achievementIcon.width + 10, achievementIcon.y + 20, 280, Title + "", 10);
		notiName.setFormat(Paths.font("Paintlinear"), 10, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		notiName.scrollFactor.set();
		notiName.setGraphicSize(Std.int(notiBG.width * (2 / 3)));

		notiText = new FlxText(notiName.x, notiName.y + 32, 280, "" + description, 16);
		notiText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, OUTLINE);
		notiText.scrollFactor.set();
		notiText.setGraphicSize(Std.int(notiBG.width * (2 / 3)));

		add(achievementBG);
		add(notiBG);
		add(notiName);
		add(notiText);
		this.visible = ClientPrefs.data.notivisible;

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		this.cameras = cam;

		FlxTween.tween(notiName, {alpha: 1}, 0.1, {onComplete: function (twn:FlxTween) {
			FlxTween.tween(notiName, {x: 40, y: 30}, 1);
		}});
		FlxTween.tween(notiBG, {alpha: 1}, 0.1, {onComplete: function (twn:FlxTween) {
			FlxTween.tween(notiBG, {x: -50, y: -20}, 1);
		}});
		FlxTween.tween(achievementBG, {alpha: 1}, 0.1, {onComplete: function (twn:FlxTween) {
			FlxTween.tween(achievementBG, {x: -50, y: -210}, 1);
		}});

		FlxTween.tween(notiText, {alpha: 1}, 0.1, {onComplete: function (twn:FlxTween) {
			FlxG.sound.play(Paths.sound('notificacion-1'));
			FlxTween.tween(notiText, {x: 40, y: 50}, 1, {
				onComplete: function(twn:FlxTween) {
					new FlxTimer().start(3.5, function(tmr:FlxTimer) {
						fadeOut();
					});
				}
			});
		}});
	}

	public function fadeOut() {
		FlxTween.tween(notiName, {alpha: 0}, 1.4);
		FlxTween.tween(notiBG, {alpha: 0}, 1.4);
		FlxTween.tween(achievementBG, {alpha: 0}, 1.4);
		FlxTween.tween(notiText, {alpha: 0}, 1.5, {
			onComplete: function (twn:FlxTween) {
				this.destroy();
			}
		});
	}
}