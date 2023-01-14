local IsMiraHQ=false
local MiraSpeed=1
local Credits=false
function onCreate()
    addLuaScript('data/CameraMove.lua')
    setGlobalFromScript('data/CameraMove','CamNoteMove',20)
    setGlobalFromScript('data/CameraMove','ForceCamPos',true)
    setGlobalFromScript('data/CameraMove','ManualPos',{950,700})
    addCharacterToList('monotone','dad')
    addCharacterToList('impostor','dad')
    addCharacterToList('blackdk','dad')
    addCharacterToList('parasite','dad')
    addCharacterToList('bfscary','dad')
    addCharacterToList('bf','boyfriend')
    addCharacterToList('bf-fall','boyfriend')
    precacheImage('speedLines')
    SetStage('Skeld','Blue')

    makeLuaSprite('CreditsBG',nil,-512,200)
    makeGraphic('CreditsBG',512,150,'FFFFFF')
    setProperty('CreditsBG.alpha',0.4)
    setObjectCamera('CreditsBG','other')
    addLuaSprite('CreditsBG')
    Text=getTextFromFile('data/'..'identity-crisis'..'/info.txt')
    makeLuaText('CreditsTxt',Text,0,getProperty('CreditsBG.x')+12,getProperty('CreditsBG.y')+12)
    setTextAlignment('CreditsTxt','left')
    setTextSize('CreditsTxt',24)
    setObjectCamera('CreditsTxt','other')
    addLuaText('CreditsTxt')

    makeLuaSprite('Bars','bars',0,0)
    setObjectCamera('Bars','hud')
    addLuaSprite('Bars')

    setProperty('camHUD.alpha', 0)

    setPropertyFromClass('GameOverSubstate', 'characterName', 'genericdeath')
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'playerdisconnect')
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameover_v4_LOOP')
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameover_v4_End')
end
function onGameOver()
    removeLuaScript('data/CameraMove.lua')
end
function onCountdownTick(swagCounter)
    setObjectCamera('countdownGo','other')
    setObjectCamera('countdownSet','other')
    setObjectCamera('countdownReady','other')
end
function onCreatePost()
    if not hideHud or not hideTime then
    makeLuaSprite('TimeBarBG','timeBar',defaultOpponentStrumX0,getProperty('timeBar.y'))
    setObjectCamera('TimeBarBG','hud')
    addLuaSprite('TimeBarBG')
    makeLuaSprite('TimeBar',nil,getProperty('TimeBarBG.x')+3.5,getProperty('TimeBarBG.y')+4)
    makeGraphic('TimeBar',getProperty('TimeBarBG.width')-8,getProperty('TimeBarBG.height')-8,'00EC00')
    setObjectCamera('TimeBar','hud')
    addLuaSprite('TimeBar')
    setProperty('TimeBar.visible',false)
    setProperty('timeTxt.visible',false)
    makeLuaText('TimeTxt',string.upper(songName),0,getProperty('TimeBarBG.x')+12,getProperty('TimeBarBG.y')+2)
    setTextBorder('TimeTxt',1,'000000')
    setTextSize('TimeTxt',12)
    addLuaText('TimeTxt')
    end
end
function onEvent(eventName, value1, value2)
    if eventName=='Identity Crisis Stage Change' then
        SetStage(value1,value2)
    end
end
function onBeatHit()
    if luaSpriteExists('DefeatBack') and curBeat%4==0 then
        playAnim('DefeatBack','Beat',true)
    end
end
function onUpdate(elapsed)
    if not Credits then
        setProperty('CreditsTxt.x',Lerp(getProperty('CreditsTxt.x'),12,0.1))
        setProperty('CreditsBG.x',Lerp(getProperty('CreditsBG.x'),0,0.1))
    else
        setProperty('CreditsTxt.x',Lerp(getProperty('CreditsTxt.x'),-512+12,0.1))
        setProperty('CreditsBG.x',Lerp(getProperty('CreditsBG.x'),-512,0.1))
    end

    ColorDad=getProperty('dad.healthColorArray')
    setTextColor('scoreTxt',getColorFromRGB(ColorDad[1],ColorDad[2],ColorDad[3]))
    ModChartEvents()

    setProperty('timeBar.alpha',0)
    if getProperty('timeBar.percent')>0 and  (not hideHud or not hideTime) then
        setProperty('TimeBar.visible',true)
    setGraphicSize('TimeBar',(getProperty('TimeBarBG.width')-8)*(getProperty('timeBar.percent')/100),getProperty('TimeBarBG.height')-8)
    end
    if IsMiraHQ then
        
        if not luaSpriteExists('Lines'..MiraSpeed) then
            makeLuaSprite('Lines'..MiraSpeed,'speedLines',-475+getRandomInt(-100,100),2170 )
            setProperty('Lines'..MiraSpeed..'.velocity.y',-100000)
            setProperty('Lines'..MiraSpeed..'.alpha',0.5)
            setObjectCamera('Lines'..MiraSpeed,'hud')
            addLuaSprite('Lines'..MiraSpeed)
            setObjectOrder('Lines'..MiraSpeed,getObjectOrder('Bars')-1)
        elseif getProperty('Lines'..MiraSpeed..'.y')< -2170 then
            if MiraSpeed==0 then
                setProperty('Lines'..MiraSpeed..'.velocity.y',0)
                setProperty('Lines'..MiraSpeed..'.x',-475+getRandomInt(-100,100))
                MiraSpeed=MiraSpeed+1
                setProperty('Lines'..MiraSpeed..'.y',2170)
                setProperty('Lines'..MiraSpeed..'.velocity.y',-100000)
            elseif MiraSpeed==1 then
                setProperty('Lines'..MiraSpeed..'.velocity.y',0)
                setProperty('Lines'..MiraSpeed..'.x',-475+getRandomInt(-100,100))
                MiraSpeed=MiraSpeed-1
                setProperty('Lines'..MiraSpeed..'.y',2170)
                setProperty('Lines'..MiraSpeed..'.velocity.y',-100000)
            end
        end
    else

    end
end
function getColorFromRGB(RR,GG,BB,PassFromHex)
    local FinalColor=''
    local RGBNum={"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
    if RR==nil then RR="00" end
    if GG==nil then GG="00" end
    if BB==nil then BB="00" end
    local RGB={RR,GG,BB}
    for i=1,#RGB do
        FinalColor=FinalColor..RGBNum[math.floor(RGB[i]/16)+1]..RGBNum[(RGB[i]%16)+1]
    end
    if PassFromHex then
        return getColorFromHex(FinalColor)
    else
        return FinalColor
    end
end
function ModChartEvents()
    if curBeat >= 5 then
        if getProperty('CreditsBG.x')>-0.9 then
            Credits=true
        end
    end
    if curBeat == 6 then
        doTweenZoom('defeated', 'camGame', 0.4, 20, 'linear')
    end
    if curBeat == 32 then
        setProperty('defaultCamZoom',0.4)
		followchars = true
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{950,700})
    end
    if curBeat == 81 then
        setProperty('defaultCamZoom',0.45)
        setGlobalFromScript('data/CameraMove','ManualCharacterPos',{dad={850,750},bf={1050,750}})
        setGlobalFromScript('data/CameraMove','ForceCamPos',false)
    end
    if curBeat == 88 then
        setProperty('defaultCamZoom',0.8)
		followchars = true
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{700,800})
    end
    if curBeat == 95 then
        setProperty('defaultCamZoom',0.5)
        setGlobalFromScript('data/CameraMove','ManualCharacterPos',{dad={850,750},bf={1050,750}})
        setGlobalFromScript('data/CameraMove','ForceCamPos',false)
    end
    if curBeat == 112 then
        setProperty('defaultCamZoom',0.5)

        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{950,700})
    end
    if curBeat == 128 then
        setProperty('defaultCamZoom',0.6)
        setGlobalFromScript('data/CameraMove','ManualCharacterPos',{dad={850,750},bf={1050,750}})
        setGlobalFromScript('data/CameraMove','ForceCamPos',false)
    end
    if curBeat == 192 then
        setProperty('defaultCamZoom',0.5)
		setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{950,700})
    end
    if curBeat == 208 then
        setProperty('defaultCamZoom',0.6)
		setGlobalFromScript('data/CameraMove','ManualCharacterPos',{dad={850,750},bf={1050,750}})
        setGlobalFromScript('data/CameraMove','ForceCamPos',false)
    end
    if curBeat == 224 then
        setProperty('defaultCamZoom',0.5)
		setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{950,700})
    end
    if curBeat == 254 then
        setProperty('defaultCamZoom',0.6)
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{1300,800})
    end
    if curBeat == 262 then
        setProperty('defaultCamZoom',0.7)
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{1400,800})
    end
    if curBeat == 270 then
        setProperty('defaultCamZoom',0.8)
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{1450,800})
    end
    if curBeat == 278 then
        setProperty('defaultCamZoom',0.9)
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{1500,800})
    end
    if curBeat == 294 then
        setProperty('defaultCamZoom',0.4)
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{850,700})
    end
    if curBeat == 312 then
        setProperty('defaultCamZoom',0.45)
        setGlobalFromScript('data/CameraMove','ManualCharacterPos',{dad={850,750},bf={1050,750}})
        setGlobalFromScript('data/CameraMove','ForceCamPos',false)
    end
    if curBeat == 328 then
        setProperty('defaultCamZoom',0.55)
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{650,750})
    end
    if curBeat == 334 then
        setProperty('defaultCamZoom',0.45)
    end
    if curBeat == 344 then
        setProperty('defaultCamZoom',0.7)
        setGlobalFromScript('data/CameraMove','ManualCharacterPos',{dad={1400,800},bf={1300,800}})
        setGlobalFromScript('data/CameraMove','ForceCamPos',false)
    end
    if curBeat == 360 then
        setProperty('defaultCamZoom',0.5)
        setGlobalFromScript('data/CameraMove','ForceCamPos',true)
        setGlobalFromScript('data/CameraMove','ManualPos',{950,700})
    end
    if curBeat == 456 then
        setProperty('defaultCamZoom',0.6)
		setGlobalFromScript('data/CameraMove','ManualCharacterPos',{dad={850,750},bf={1050,750}})
        setGlobalFromScript('data/CameraMove','ForceCamPos',false)
    end
end
function SetStage(StageName,Color)
    local ConsistentScale=2
    local ConsistentPos={-1000,-575}

    if not luaSpriteExists('Overlay1') then
        makeLuaSprite('Overlay1','overlay',ConsistentPos[1],ConsistentPos[2])
        scaleObject('Overlay1',ConsistentScale,ConsistentScale)
        addLuaSprite('Overlay1',true)

        makeLuaSprite('Shadow','scary ass shadow',ConsistentPos[1],ConsistentPos[2])
        scaleObject('Shadow',ConsistentScale,ConsistentScale)
        addLuaSprite('Shadow',true)

    end
    if not luaSpriteExists('BackSkeld') then
        makeLuaSprite('BackSkeld','SkeldBack',ConsistentPos[1],ConsistentPos[2])
        scaleObject('BackSkeld',ConsistentScale,ConsistentScale)
        addLuaSprite('BackSkeld')

        makeLuaSprite('BackBlue','BackThings',ConsistentPos[1],ConsistentPos[2])
        scaleObject('BackBlue',ConsistentScale,ConsistentScale)
        addLuaSprite('BackBlue')

        --makeLuaSprite('BackPurple','BackThingspurple',ConsistentPos[1],ConsistentPos[2])
        --scaleObject('BackPurple',ConsistentScale,ConsistentScale)
        --addLuaSprite('BackPurple')

        makeLuaSprite('BackRed','BackThingsred',ConsistentPos[1],ConsistentPos[2])
        scaleObject('BackRed',ConsistentScale,ConsistentScale)
        addLuaSprite('BackRed')

        makeLuaSprite('FloorSkeld','Floor',ConsistentPos[1],ConsistentPos[2])
        scaleObject('FloorSkeld',ConsistentScale,ConsistentScale)
        addLuaSprite('FloorSkeld')

        makeLuaSprite('ReactorBlue','Reactor',ConsistentPos[1],ConsistentPos[2])
        scaleObject('ReactorBlue',ConsistentScale,ConsistentScale)
        addLuaSprite('ReactorBlue')

        --makeLuaSprite('ReactorPurple','ReactorBlue',ConsistentPos[1],ConsistentPos[2])
        --scaleObject('ReactorPurple',ConsistentScale,ConsistentScale)
        --addLuaSprite('ReactorPurple')

        makeLuaSprite('ReactorRed','ReactorRed',ConsistentPos[1],ConsistentPos[2])
        scaleObject('ReactorRed',ConsistentScale,ConsistentScale)
        addLuaSprite('ReactorRed')

        
        makeLuaSprite('Overlay2','overlay2',ConsistentPos[1],ConsistentPos[2])
        scaleObject('Overlay2',ConsistentScale,ConsistentScale)
        addLuaSprite('Overlay2',true)
        setBlendMode('Overlay2','ADD')

        makeLuaSprite('LightBlue','Reactorlight',ConsistentPos[1],ConsistentPos[2])
        scaleObject('LightBlue',ConsistentScale,ConsistentScale)
        addLuaSprite('LightBlue')
        setBlendMode('LightBlue','add')

        --makeLuaSprite('LightPurple','ReactorLightPurple',ConsistentPos[1],ConsistentPos[2])
        --scaleObject('LightPurple',ConsistentScale,ConsistentScale)
        --addLuaSprite('LightPurple')
        --setBlendMode('LightPurple','add')

        makeLuaSprite('LightRed','ReactorLightRed',ConsistentPos[1],ConsistentPos[2])
        scaleObject('LightRed',ConsistentScale,ConsistentScale)
        addLuaSprite('LightRed')
        setBlendMode('LightRed','add')

        
    end

    if not luaSpriteExists('MiraHQEvil') then
        makeLuaSprite('BackEvil','evilejected',ConsistentPos[1]-ConsistentScale*100,ConsistentPos[2]-ConsistentScale*700)
        scaleObject('BackEvil',ConsistentScale*1.1,ConsistentScale*1.1)
        addLuaSprite('BackEvil')

        makeLuaSprite('MiraHQEvil','brombom',ConsistentPos[1],ConsistentPos[2]-ConsistentScale*600)
        scaleObject('MiraHQEvil',ConsistentScale,ConsistentScale)
        addLuaSprite('MiraHQEvil')

        
    end
    if not luaSpriteExists('DefeatBack') then
        makeAnimatedLuaSprite('DefeatBack','defeat',ConsistentPos[1]-ConsistentScale*100,ConsistentPos[2])
        scaleObject('DefeatBack',ConsistentScale,ConsistentScale)
        addAnimationByPrefix('DefeatBack','Beat','defeat',24,false)
        addLuaSprite('DefeatBack')
    end
    if StageName~='Skeld' then
        Skeld(false)
    else
        Skeld(true)
        SetSkeldColor(Color)
    end
    if StageName~='MiraHQ' then
        MiraHQ(false)
    else
        MiraHQ(true)
    end
    if StageName~='Defeat' then
        setProperty('DefeatBack.visible',false)
    else

        setProperty('DefeatBack.visible',true)
    end
    if not luaSpriteExists('Wire') then
        makeLuaSprite('Wire','wires1',0,ConsistentPos[2]+(ConsistentScale/2)*475)
        scaleObject('Wire',ConsistentScale/2,ConsistentScale/2)
        addLuaSprite('Wire')
    end
    if StageName=='Skeld' or StageName=='Defeat' then
        setProperty('Wire.visible',true)
        setProperty('Overlay2.visible',true)

    else
        setProperty('Overlay2.visible',true)
        setProperty('Wire.visible',false)
    end
end
function SetSkeldColor(color)
    setProperty('BackBlue.visible',false)
    --setProperty('BackPurple.visible',false)
    setProperty('BackRed.visible',false)
    setProperty('Back'..color..'.visible',true)

    setProperty('ReactorBlue.visible',false)
    --setProperty('ReactorPurple.visible',false)
    setProperty('ReactorRed.visible',false)
    setProperty('Reactor'..color..'.visible',true)

    setProperty('LightBlue.visible',false)
    --setProperty('LightPurple.visible',false)
    setProperty('LightRed.visible',false)
    setProperty('Light'..color..'.visible',true)
end
function Skeld(visible)
    setProperty('BackSkeld.visible',visible)
    setProperty('BackBlue.visible',visible)
    --setProperty('BackPurple.visible',visible)
    setProperty('BackRed.visible',visible)
    setProperty('FloorSkeld.visible',visible)

    setProperty('ReactorBlue.visible',visible)
    --setProperty('ReactorPurple.visible',visible)
    setProperty('ReactorRed.visible',visible)

    setProperty('LightBlue.visible',visible)
    --setProperty('LightPurple.visible',visible)
    setProperty('LightRed.visible',visible)
end
function MiraHQ(visible)
    setProperty('BackEvil.visible',visible)
    setProperty('MiraHQEvil.visible',visible)
    setProperty('Lines'..tostring(1)..'.visible',visible)
    setProperty('Lines'..tostring(0)..'.visible',visible)
    IsMiraHQ=visible
end
function Lerp(Min,Max,Ratio)
    return Min + Ratio * (Max - Min)
end
