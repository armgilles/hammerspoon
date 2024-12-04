-----------------------------------------------
-- Naviguer entre les fenêtres avec alt + hjkl

-----------------------------------------------
hs.hotkey.bind({"alt"}, "h", function()
    hs.window.focusedWindow():focusWindowWest()
end)

hs.hotkey.bind({"alt"}, "j", function()
    hs.window.focusedWindow():focusWindowSouth()
end)

hs.hotkey.bind({"alt"}, "k", function()
    hs.window.focusedWindow():focusWindowNorth()
end)

hs.hotkey.bind({"alt"}, "l", function()
    hs.window.focusedWindow():focusWindowEast()
end)

-- Configuration de hs.window.highlight
hs.window.highlight.ui.overlay = true -- Affiche un surlignage autour de la fenêtre
hs.window.highlight.ui.frameWidth = 5 -- Largeur de la bordure
hs.window.highlight.ui.frameColor = {1, 0.29, 0.25, 1} -- Couleur de la bordure (rouge-orangé)
hs.window.highlight.ui.overlayColor = {0, 0, 0, 0.01} -- Couleur transparente (désactive l'overlay)

-- Activer le surlignage des fenêtres actives
hs.window.highlight.start()

----------------------------------------------------
-- Resize windows --

-- alt+shift+H : Réduire la largeur de la fenêtre
-- alt+shift+L : Augmenter la largeur de la fenêtre
-- alt+shift+K : Réduire la hauteur de la fenêtre
-- alt+shift+J : Augmenter la hauteur de la fenêtre
----------------------------------------------------
local grid = require "hs.grid"

grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDHEIGHT = 7
grid.GRIDWIDTH = 7

-- hjkl
hs.hotkey.bind({"alt", "shift"}, "H", grid.resizeWindowThinner)
hs.hotkey.bind({"alt", "shift"}, "J",grid.resizeWindowTaller)
hs.hotkey.bind({"alt", "shift"}, "K", grid.resizeWindowShorter)
hs.hotkey.bind({"alt", "shift"}, "L", grid.resizeWindowWider)

--------------------------------------------------------
-- Déplacement des fenêtres avec répétition de touche --

-- alt+cmd+shift+H : Déplacer la fenêtre vers la gauche
-- alt+cmd+shift+L : Déplacer la fenêtre vers la droite
-- alt+cmd+shift+K : Déplacer la fenêtre vers le haut
-- alt+cmd+shift+J : Déplacer la fenêtre vers le bas
--------------------------------------------------------

local moveStep = 50
local repeatTimer = nil

-- Fonction pour déplacer la fenêtre
local function moveWindow(direction)
    local win = hs.window.focusedWindow()
    if not win then return end -- Si aucune fenêtre n'est focus, ne rien faire

    local frame = win:frame() -- Cadre de la fenêtre actuelle

    -- Ajuster la position selon la direction
    if direction == "left" then
        frame.x = frame.x - moveStep
    elseif direction == "right" then
        frame.x = frame.x + moveStep
    elseif direction == "up" then
        frame.y = frame.y - moveStep
    elseif direction == "down" then
        frame.y = frame.y + moveStep
    end

    -- Appliquer les nouvelles positions
    win:setFrame(frame)
end

-- Fonction pour configurer les raccourcis avec répétition
local function bindMoveWithRepeat(mods, key, direction)
    hs.hotkey.bind(mods, key, function()
        if repeatTimer then repeatTimer:stop() end
        repeatTimer = hs.timer.doEvery(0.1, function() moveWindow(direction) end) -- Répète toutes les 100ms
        moveWindow(direction) -- Exécute immédiatement
    end, function()
        if repeatTimer then repeatTimer:stop() end
        repeatTimer = nil
    end)
end

-- Raccourcis clavier pour le déplacement avec répétition
bindMoveWithRepeat({"alt", "cmd", "shift"}, "H", "left")  -- Alt + Cmd + Shift + H : Gauche
bindMoveWithRepeat({"alt", "cmd", "shift"}, "L", "right") -- Alt + Cmd + Shift + L : Droite
bindMoveWithRepeat({"alt", "cmd", "shift"}, "K", "up")    -- Alt + Cmd + Shift + K : Haut
bindMoveWithRepeat({"alt", "cmd", "shift"}, "J", "down")  -- Alt + Cmd + Shift + J : Bas


--------------------------------------------------------------
-- Déplacer les fenêtres entre les écrans --

-- alt+shift+O : Déplacer la fenêtre vers l'écran suivant
-- alt+shift+I : Déplacer la fenêtre vers l'écran précédent
--------------------------------------------------------------

-- Déplacer la fenêtre vers l'écran suivant
hs.hotkey.bind({"alt", "shift"}, "O", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():next()) -- Déplacer vers l'écran suivant
    end
end)

-- Déplacer la fenêtre vers l'écran précédent
hs.hotkey.bind({"alt", "shift"}, "I", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():previous()) -- Déplacer vers l'écran précédent
    end
end)