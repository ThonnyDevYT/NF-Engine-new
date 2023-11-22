package states.editors;

import openfl.utils.Timer;
import flixel.ui.FlxBar;
import flixel.FlxSprite;
import flixel.text.FlxText;

import flixel.util.FlxTimer;

class UpdatingState extends MusicBeatState
{

    inline static var MIN_TIME = 1.0;

    var Waiting:FlxTimer;
    var Waiting2:FlxTimer;

    public static var progressEC:Float = 0; 
    //public static var progressBarEC:FlxBar;
    //static var ECBarrita:FlxBar = new FlxBar(0, -20, LEFT_TO_RIGHT, 20, 3, progressEC, "ECBarrita", 0, 100);
    //Dio muchos poblemas
    static var Page:String = "";
    var Loaded:Float = 0;
    var ProgressEC:FlxSprite;
    var BG:FlxSprite;
    var porcent:FlxText;
    var loadingBar:FlxSprite;
    var Warn:FlxText;
   // var Porcent:String = "%" + Loaded + "Complete";
    var pesoMbs:FlxText;
    var FileSpace:String = Page + "Mbs";
	//var onComplete(default, null):Null<FlxTimer -> Void>;


    override function create() {

    FlxG.sound.music.fadeOut(7, 0.3);

    if (ClientPrefs.data.Update_Support = true) {
        trace('checking Mbs');
        var htps = new haxe.Http("https://raw.githubusercontent.com/ThonnyDev-Developer/Corruption_Version_Actual/main/Peso_Update");

        htps.onData = function (data:String)
        {
            Page = data.split('\n')[0].trim();
            var curVersionEC2:String = MainMenuState.endingcorruptionVersion.trim();
            trace('version online: ' + Page + ', your version: ' + curVersionEC2);
            if(Page != curVersionEC2) {
                trace('versions arebt matching!');
                //mustUpdateEC2 = true;
            }
        }

        htps.onError = function (error) {
            trace('error: $error');
        }

        htps.request();
    }

    var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x000000);
    bg.antialiasing = ClientPrefs.data.antialiasing;
    add(bg);
    if (ClientPrefs.data.Update_Support = true) {

    BG = new FlxSprite(0, 0).loadGraphic(Paths.getPath('images/Updating_bg', IMAGE));
    BG.setGraphicSize(0, FlxG.height);
    BG.updateHitbox();
    add(BG);
    BG.antialiasing = ClientPrefs.data.antialiasing;
    BG.scrollFactor.set();
    BG.screenCenter();
    
    }

    function onloading(Timer:FlxTimer):Void {
        FlxG.sound.play(Paths.sound('LoadMenu'));
        Loaded += 20;
    }

    function onTimerComplete(Timer:FlxTimer):Void {
        FlxG.sound.play(Paths.sound('ConfirmMenu'));
        Warn = new FlxText(0, 0, FlxG.width,
            "Descarga Completa!!!", 32);
        Warn.setFormat('VCR OSD Mono', 32, FlxColor.GREEN, CENTER);
        FlxTween.tween(loadingBar, {alpha: 0}, 3, {
            onComplete: function (twn:FlxTween) {
               // MusicBeatState.switchState(new MainMenuState());
            }
        });
        FlxTween.tween(pesoMbs, {alpha: 0}, 1, {
            onComplete: function (twn:FlxTween) {
                MusicBeatState.switchState(new MainMenuState());
                FlxG.sound.music.fadeIn(1, 0.3, 0.5);
            }
        });
    }
    if(ClientPrefs.data.language == "Spanish") {
        Warn = new FlxText(0, 0, FlxG.width,
            "Actualmente estamos instalando todo lo necesario\n
            Este proceso es interno y no afectara a ningun otro Elemento del Juego\n
            Y Esto no va a durar nada archivos adicionales se instalaran\n
            En segundo Plano...", 32);
        porcent = new FlxText(-50, 0, FlxG.width,
            "Se le Redireccionara al Main Menu Al terminar", 28);
        pesoMbs = new FlxText(0, 75, FlxG.width, "Se estan Descargando un total de: " + Page + "Mbs", 8, true);
    }
    if(ClientPrefs.data.language == "Inglish") {
        Warn = new FlxText(0, 0, FlxG.width,
            "We are currently installing everything necessary\n
            This process is internal and will not affect any other Game Element\n
            And This will not last any additional files will be installed\n
            In background...", 32);
        porcent = new FlxText(-50, 0, FlxG.width,
            "You will be redirected to the Main Menu when finished", 28);
        pesoMbs = new FlxText(0, 75, FlxG.width, "A total of: " + "are being downloaded" + Page + "Mbs", 8, true);
    }
    if(ClientPrefs.data.language == "Portuguese") {
        Warn = new FlxText(0, 0, FlxG.width,
            "No momento estamos instalando tudo o que e necessario\n
            Este processo e interno e nao afetara nenhum outro elemento do jogo\n
            E isso nao durara, nenhum arquivo adicional sera instalado\n
            No fundo...", 32);
        porcent = new FlxText(-50, 0, FlxG.width,
            "Voce sera redirecionado para o Menu Principal quando terminar", 28);
        pesoMbs = new FlxText(0, 75, FlxG.width, "Um total de:" + "estao sendo baixados" + Page + "Mbs", 8, true);
    }
    if(ClientPrefs.data.language == "Mandarin") {
        Warn = new FlxText(0, 0, FlxG.width,
            "我们目前正在安装所有必要的东西\n
            此过程是内部过程，不会影响任何其他游戏元素\n
            并且这不会持续任何其他文件将被安装\n
            在背景中...", 32);
        porcent = new FlxText(-50, 0, FlxG.width,
            "完成后您将被重定向到主菜单", 28);
        pesoMbs = new FlxText(0, 75, FlxG.width, "总共："+"正在下载" + Page + "Mbs", 8, true);
    }
    pesoMbs.setFormat('VCR OSD Mono', 23, FlxColor.GRAY, CENTER);
    pesoMbs.screenCenter(X);
    pesoMbs.visible = false;
    add(pesoMbs);

    loadingBar = new FlxSprite(-65, 0).makeGraphic(FlxG.width, 10, 0xFFFFFF);
    loadingBar.screenCenter(X);
    add(loadingBar);

    Warn.setFormat('VCR OSD Mono', 32, FlxColor.WHITE, CENTER);
    Warn.screenCenter();
    add(Warn);

    porcent.setFormat('VCR OSD Mono', 28, FlxColor.RED, CENTER);
    //porcent.screenCenter(Y);
    add(porcent);

    /*var fadeTime = 0.5;
    FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
    new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());*/
    Waiting = new FlxTimer();
    Waiting2 = new FlxTimer();

    Waiting.start(14, onTimerComplete);
    //Waiting.start(2, onloading, 5);
    }

    override function update(elapsed:Float) {
     
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER) {
            FlxG.sound.play(Paths.sound('CancelMenu'));
            pesoMbs.visible = true;
            FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.RED : 0x4CFF0000, 1);
        }

        /*progressEC += 0.1;

        progressEC = Math.max(0, Math.min(1, progressEC));
    
        ECBarrita.value = progressEC;*/
    }
}