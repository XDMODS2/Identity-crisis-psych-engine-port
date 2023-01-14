function onEvent(eventName, value1, value2)
    if eventName=='Identity Crisis line' then
        makeAnimatedLuaSprite('dialogue','dialogue',0,0)
        scaleObject('dialogue',0.5,0.5)
        addAnimationByPrefix('dialogue','idle','dialogue',24,false)
        setObjectCamera('dialogue','other')
        screenCenter('dialogue','xy')
        addLuaSprite('dialogue')
    end
    if eventName=='flash' and luaSpriteExists('dialogue') then
        setProperty('dialogue.visible',false)
        removeLuaSprite('dialogue',true)
    end
end
function onCreate()
    precacheImage('dialogue')
end
function onUpdate(elapsed)
    if getProperty('dialogue.animation.curAnim.finished') then
        setProperty('dialogue.visible',false)
    end
end