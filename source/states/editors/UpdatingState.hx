package states.editors;

import openfl.utils.Timer;
import flixel.ui.FlxBar;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import objects.HealthBar;

class UpdatingState extends MusicBeatState
{

    var porcent:Float = 0;
    var porcentText:FlxText;
    var loadTimer:FlxTimer;
    var progressBar:HealthBar;

    public function onCarga(Timer:FlxTimer) {
        porcent += 10;
        trace('Ejecutando +=');
    }

    override function create() {
    FlxG.sound.music.fadeOut(4, 0.3);
    loadTimer = new FlxTimer();

    var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x000000);
    add(bg);

    porcentText = new FlxText(0, 0, 0, "", 26);
    porcentText.setFormat("", 26, FlxColor.BLACK, RIGHT, FlxColor.WHITE);
    add(porcentText);

    progressBar = new HealthBar(0, FlxG.height - 90, 'healthBar', porcent, 0, 100);
    progressBar.screenCenter();
    progressBar.width = FlxG.width;
    progressBar.setColors(FlxColor.WHITE, FlxColor.BLACK);
    add(progressBar);

    loadTimer.start(0.5, onCarga, 0);

    trace('Cargado!!');
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        porcentText.x = FlxG.width - porcentText.width;
        porcentText.text = porcent + "%";
        porcentText.y = FlxG.height - FlxG.height + 30;

        if (progressBar.percent == 100) {
            MusicBeatState.switchState(new states.MainMenuState());
        }
        if (progressBar.percent > 100) {
            progressBar.percent = 100;
            trace('Fixed!!\nPorcent: 100%');
        }

    }
}